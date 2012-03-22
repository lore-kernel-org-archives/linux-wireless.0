Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:51845 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755664Ab2CVAo6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Mar 2012 20:44:58 -0400
Date: Thu, 22 Mar 2012 01:53:05 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Ilan Elias <ilane@ti.com>
Cc: "Lapuyade, Eric" <eric.lapuyade@intel.com>,
	Linux Wireless <linux-wireless@vger.kernel.org>
Subject: [RFC] [PATCH] NFC: The core part should generate the target index
Message-ID: <20120322005305.GD3875@sortiz-mobl> (sfid-20120322_014502_746982_DB7377D3)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


The target index can be used by userspace to uniquely identify a target
and thus should be kept unique, per NFC adapter. Moreover, some protocols
do not provide a logical index when discovering new targets, so we have to
generate one for them.
For NCI or pn533 to fetch their logical index, we added a logical_idx field
to the target structure.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---

Ilan, could you please comment on this patch and also make sure that it
doesn't break multiple targets support for NCI ?

---

 include/net/nfc/nfc.h |    2 ++
 net/nfc/core.c        |    5 +++++
 net/nfc/nci/core.c    |    2 +-
 net/nfc/nci/ntf.c     |   11 ++++++-----
 net/nfc/rawsock.c     |   12 ++++++++++++
 5 files changed, 26 insertions(+), 6 deletions(-)

diff --git a/include/net/nfc/nfc.h b/include/net/nfc/nfc.h
index 57ea095..9097093 100644
--- a/include/net/nfc/nfc.h
+++ b/include/net/nfc/nfc.h
@@ -78,6 +78,7 @@ struct nfc_target {
 	u8 sensb_res[NFC_SENSB_RES_MAXSIZE];
 	u8 sensf_res_len;
 	u8 sensf_res[NFC_SENSF_RES_MAXSIZE];
+	u8 logical_idx;
 };
 
 struct nfc_genl_data {
@@ -87,6 +88,7 @@ struct nfc_genl_data {
 
 struct nfc_dev {
 	unsigned idx;
+	unsigned target_idx;
 	struct nfc_target *targets;
 	int n_targets;
 	int targets_generation;
diff --git a/net/nfc/core.c b/net/nfc/core.c
index 376f9ac..2818582 100644
--- a/net/nfc/core.c
+++ b/net/nfc/core.c
@@ -428,10 +428,15 @@ EXPORT_SYMBOL(nfc_alloc_recv_skb);
 int nfc_targets_found(struct nfc_dev *dev,
 		      struct nfc_target *targets, int n_targets)
 {
+	int i;
+
 	pr_debug("dev_name=%s n_targets=%d\n", dev_name(&dev->dev), n_targets);
 
 	dev->polling = false;
 
+	for (i = 0; i < n_targets; i++)
+		targets[i].idx = dev->target_idx++;
+
 	spin_lock_bh(&dev->targets_lock);
 
 	dev->targets_generation++;
diff --git a/net/nfc/nci/core.c b/net/nfc/nci/core.c
index 9ec065b..8737c20 100644
--- a/net/nfc/nci/core.c
+++ b/net/nfc/nci/core.c
@@ -477,7 +477,7 @@ static int nci_activate_target(struct nfc_dev *nfc_dev, __u32 target_idx,
 	}
 
 	if (atomic_read(&ndev->state) == NCI_W4_HOST_SELECT) {
-		param.rf_discovery_id = target->idx;
+		param.rf_discovery_id = target->logical_idx;
 
 		if (protocol == NFC_PROTO_JEWEL)
 			param.rf_protocol = NCI_RF_PROTOCOL_T1T;
diff --git a/net/nfc/nci/ntf.c b/net/nfc/nci/ntf.c
index 2e3dee4..99e1632 100644
--- a/net/nfc/nci/ntf.c
+++ b/net/nfc/nci/ntf.c
@@ -227,7 +227,7 @@ static void nci_add_new_target(struct nci_dev *ndev,
 
 	for (i = 0; i < ndev->n_targets; i++) {
 		target = &ndev->targets[i];
-		if (target->idx == ntf->rf_discovery_id) {
+		if (target->logical_idx == ntf->rf_discovery_id) {
 			/* This target already exists, add the new protocol */
 			nci_add_new_protocol(ndev, target, ntf->rf_protocol,
 					     ntf->rf_tech_and_mode,
@@ -248,10 +248,10 @@ static void nci_add_new_target(struct nci_dev *ndev,
 				  ntf->rf_tech_and_mode,
 				  &ntf->rf_tech_specific_params);
 	if (!rc) {
-		target->idx = ntf->rf_discovery_id;
+		target->logical_idx = ntf->rf_discovery_id;
 		ndev->n_targets++;
 
-		pr_debug("target_idx %d, n_targets %d\n", target->idx,
+		pr_debug("logical idx %d, n_targets %d\n", target->logical_idx,
 			 ndev->n_targets);
 	}
 }
@@ -372,10 +372,11 @@ static void nci_target_auto_activated(struct nci_dev *ndev,
 	if (rc)
 		return;
 
-	target->idx = ntf->rf_discovery_id;
+	target->logical_idx = ntf->rf_discovery_id;
 	ndev->n_targets++;
 
-	pr_debug("target_idx %d, n_targets %d\n", target->idx, ndev->n_targets);
+	pr_debug("logical idx %d, n_targets %d\n",
+		 target->logical_idx, ndev->n_targets);
 
 	nfc_targets_found(ndev->nfc_dev, ndev->targets, ndev->n_targets);
 }
diff --git a/net/nfc/rawsock.c b/net/nfc/rawsock.c
index 5a839ce..47fcf0d 100644
--- a/net/nfc/rawsock.c
+++ b/net/nfc/rawsock.c
@@ -92,6 +92,18 @@ static int rawsock_connect(struct socket *sock, struct sockaddr *_addr,
 		goto error;
 	}
 
+	if (addr->target_idx > dev->target_idx - 1 ||
+	    addr->target_idx < dev->target_idx - dev->n_targets) {
+		rc = -EINVAL;
+		goto error;
+	}
+
+	if (addr->target_idx > dev->target_idx - 1 ||
+	    addr->target_idx < dev->target_idx - dev->n_targets) {
+		rc = -EINVAL;
+		goto error;
+	}
+
 	rc = nfc_activate_target(dev, addr->target_idx, addr->nfc_protocol);
 	if (rc)
 		goto put_dev;
-- 
1.7.9.1

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
