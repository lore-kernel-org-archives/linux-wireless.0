Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:40536 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519Ab2ARLOE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jan 2012 06:14:04 -0500
Received: by ggnb1 with SMTP id b1so92350ggn.19
        for <linux-wireless@vger.kernel.org>; Wed, 18 Jan 2012 03:14:03 -0800 (PST)
From: ilanelias78@gmail.com
To: samuel@sortiz.org, lauro.venancio@openbossa.org,
	aloisio.almeida@openbossa.org, linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Ilan Elias <ilane@ti.com>
Subject: [PATCH 1/3] NFC: Clearly separate NCI states from flags
Date: Wed, 18 Jan 2012 13:16:12 +0200
Message-Id: <1326885374-13318-2-git-send-email-ilane@ti.com> (sfid-20120118_121407_630939_A6C4251D)
In-Reply-To: <1326885374-13318-1-git-send-email-ilane@ti.com>
References: <1326885374-13318-1-git-send-email-ilane@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ilan Elias <ilane@ti.com>

Make a clear separation between NCI states and flags.
This is required in order to support more NCI states (e.g.
for multiple targets support).

Signed-off-by: Ilan Elias <ilane@ti.com>
---
 include/net/nfc/nci_core.h |   14 ++++++++++----
 net/nfc/nci/core.c         |   11 ++++++-----
 net/nfc/nci/ntf.c          |    5 ++---
 net/nfc/nci/rsp.c          |    8 ++++----
 4 files changed, 22 insertions(+), 16 deletions(-)

diff --git a/include/net/nfc/nci_core.h b/include/net/nfc/nci_core.h
index 9154663..b9c3f8d 100644
--- a/include/net/nfc/nci_core.h
+++ b/include/net/nfc/nci_core.h
@@ -34,16 +34,21 @@
 #include <net/nfc/nfc.h>
 #include <net/nfc/nci.h>
 
-/* NCI device state */
-enum {
+/* NCI device flags */
+enum nci_flag {
 	NCI_INIT,
 	NCI_UP,
-	NCI_DISCOVERY,
-	NCI_POLL_ACTIVE,
 	NCI_DATA_EXCHANGE,
 	NCI_DATA_EXCHANGE_TO,
 };
 
+/* NCI device states */
+enum nci_state {
+	NCI_IDLE,
+	NCI_DISCOVERY,
+	NCI_POLL_ACTIVE,
+};
+
 /* NCI timeouts */
 #define NCI_RESET_TIMEOUT			5000
 #define NCI_INIT_TIMEOUT			5000
@@ -70,6 +75,7 @@ struct nci_dev {
 	int			tx_headroom;
 	int			tx_tailroom;
 
+	atomic_t		state;
 	unsigned long		flags;
 
 	atomic_t		cmd_cnt;
diff --git a/net/nfc/nci/core.c b/net/nfc/nci/core.c
index 815d28a..629b768 100644
--- a/net/nfc/nci/core.c
+++ b/net/nfc/nci/core.c
@@ -264,6 +264,7 @@ static int nci_open_device(struct nci_dev *ndev)
 
 	if (!rc) {
 		set_bit(NCI_UP, &ndev->flags);
+		atomic_set(&ndev->state, NCI_IDLE);
 	} else {
 		/* Init failed, cleanup */
 		skb_queue_purge(&ndev->cmd_q);
@@ -360,7 +361,7 @@ static int nci_start_poll(struct nfc_dev *nfc_dev, __u32 protocols)
 	struct nci_dev *ndev = nfc_get_drvdata(nfc_dev);
 	int rc;
 
-	if (test_bit(NCI_DISCOVERY, &ndev->flags)) {
+	if (atomic_read(&ndev->state) == NCI_DISCOVERY) {
 		pr_err("unable to start poll, since poll is already active\n");
 		return -EBUSY;
 	}
@@ -370,7 +371,7 @@ static int nci_start_poll(struct nfc_dev *nfc_dev, __u32 protocols)
 		return -EBUSY;
 	}
 
-	if (test_bit(NCI_POLL_ACTIVE, &ndev->flags)) {
+	if (atomic_read(&ndev->state) == NCI_POLL_ACTIVE) {
 		pr_debug("target is active, implicitly deactivate...\n");
 
 		rc = nci_request(ndev, nci_rf_deactivate_req, 0,
@@ -392,7 +393,7 @@ static void nci_stop_poll(struct nfc_dev *nfc_dev)
 {
 	struct nci_dev *ndev = nfc_get_drvdata(nfc_dev);
 
-	if (!test_bit(NCI_DISCOVERY, &ndev->flags)) {
+	if (atomic_read(&ndev->state) != NCI_DISCOVERY) {
 		pr_err("unable to stop poll, since poll is not active\n");
 		return;
 	}
@@ -408,7 +409,7 @@ static int nci_activate_target(struct nfc_dev *nfc_dev, __u32 target_idx,
 
 	pr_debug("target_idx %d, protocol 0x%x\n", target_idx, protocol);
 
-	if (!test_bit(NCI_POLL_ACTIVE, &ndev->flags)) {
+	if (atomic_read(&ndev->state) != NCI_POLL_ACTIVE) {
 		pr_err("there is no available target to activate\n");
 		return -EINVAL;
 	}
@@ -443,7 +444,7 @@ static void nci_deactivate_target(struct nfc_dev *nfc_dev, __u32 target_idx)
 
 	ndev->target_active_prot = 0;
 
-	if (test_bit(NCI_POLL_ACTIVE, &ndev->flags)) {
+	if (atomic_read(&ndev->state) == NCI_POLL_ACTIVE) {
 		nci_request(ndev, nci_rf_deactivate_req, 0,
 			msecs_to_jiffies(NCI_RF_DEACTIVATE_TIMEOUT));
 	}
diff --git a/net/nfc/nci/ntf.c b/net/nfc/nci/ntf.c
index a88be91..8ec3946 100644
--- a/net/nfc/nci/ntf.c
+++ b/net/nfc/nci/ntf.c
@@ -261,8 +261,7 @@ static void nci_rf_intf_activated_ntf_packet(struct nci_dev *ndev,
 	__u8 *data = skb->data;
 	int err = 0;
 
-	clear_bit(NCI_DISCOVERY, &ndev->flags);
-	set_bit(NCI_POLL_ACTIVE, &ndev->flags);
+	atomic_set(&ndev->state, NCI_POLL_ACTIVE);
 
 	ntf.rf_discovery_id = *data++;
 	ntf.rf_interface = *data++;
@@ -350,7 +349,7 @@ static void nci_rf_deactivate_ntf_packet(struct nci_dev *ndev,
 
 	pr_debug("entry, type 0x%x, reason 0x%x\n", ntf->type, ntf->reason);
 
-	clear_bit(NCI_POLL_ACTIVE, &ndev->flags);
+	atomic_set(&ndev->state, NCI_IDLE);
 	ndev->target_active_prot = 0;
 
 	/* drop tx data queue */
diff --git a/net/nfc/nci/rsp.c b/net/nfc/nci/rsp.c
index 3c73e92..cb8bce6 100644
--- a/net/nfc/nci/rsp.c
+++ b/net/nfc/nci/rsp.c
@@ -137,7 +137,7 @@ static void nci_rf_disc_rsp_packet(struct nci_dev *ndev, struct sk_buff *skb)
 	pr_debug("status 0x%x\n", status);
 
 	if (status == NCI_STATUS_OK)
-		set_bit(NCI_DISCOVERY, &ndev->flags);
+		atomic_set(&ndev->state, NCI_DISCOVERY);
 
 	nci_req_complete(ndev, status);
 }
@@ -149,12 +149,12 @@ static void nci_rf_deactivate_rsp_packet(struct nci_dev *ndev,
 
 	pr_debug("status 0x%x\n", status);
 
-	clear_bit(NCI_DISCOVERY, &ndev->flags);
-
 	/* If target was active, complete the request only in deactivate_ntf */
 	if ((status != NCI_STATUS_OK) ||
-		(!test_bit(NCI_POLL_ACTIVE, &ndev->flags)))
+		(atomic_read(&ndev->state) != NCI_POLL_ACTIVE)) {
+		atomic_set(&ndev->state, NCI_IDLE);
 		nci_req_complete(ndev, status);
+	}
 }
 
 void nci_rsp_packet(struct nci_dev *ndev, struct sk_buff *skb)
-- 
1.7.0.4

