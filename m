Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:20170 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755977Ab2EGKcK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 May 2012 06:32:10 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	Eric Lapuyade <eric.lapuyade@intel.com>,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 05/20] NFC: Add HCI/SHDLC support to let driver check for tag presence
Date: Mon,  7 May 2012 12:31:16 +0200
Message-Id: <1336386691-24840-6-git-send-email-sameo@linux.intel.com> (sfid-20120507_123214_370379_CE520E33)
In-Reply-To: <1336386691-24840-1-git-send-email-sameo@linux.intel.com>
References: <1336386691-24840-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eric Lapuyade <eric.lapuyade@intel.com>

Signed-off-by: Eric Lapuyade <eric.lapuyade@intel.com>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 include/net/nfc/hci.h   |    2 ++
 include/net/nfc/shdlc.h |    2 ++
 net/nfc/hci/core.c      |   12 ++++++++++++
 net/nfc/hci/shdlc.c     |   12 ++++++++++++
 4 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/include/net/nfc/hci.h b/include/net/nfc/hci.h
index 95fc0c2..ae04200 100644
--- a/include/net/nfc/hci.h
+++ b/include/net/nfc/hci.h
@@ -39,6 +39,8 @@ struct nfc_hci_ops {
 	int (*data_exchange) (struct nfc_hci_dev *hdev,
 			      struct nfc_target *target,
 			      struct sk_buff *skb, struct sk_buff **res_skb);
+	int (*check_presence)(struct nfc_hci_dev *hdev,
+			      struct nfc_target *target);
 };
 
 #define NFC_HCI_MAX_CUSTOM_GATES	15
diff --git a/include/net/nfc/shdlc.h b/include/net/nfc/shdlc.h
index 1071987..ab06afd 100644
--- a/include/net/nfc/shdlc.h
+++ b/include/net/nfc/shdlc.h
@@ -35,6 +35,8 @@ struct nfc_shdlc_ops {
 	int (*data_exchange) (struct nfc_shdlc *shdlc,
 			      struct nfc_target *target,
 			      struct sk_buff *skb, struct sk_buff **res_skb);
+	int (*check_presence)(struct nfc_shdlc *shdlc,
+			      struct nfc_target *target);
 };
 
 enum shdlc_state {
diff --git a/net/nfc/hci/core.c b/net/nfc/hci/core.c
index ef5cd5c9..f7e4f5a 100644
--- a/net/nfc/hci/core.c
+++ b/net/nfc/hci/core.c
@@ -574,6 +574,17 @@ static int hci_data_exchange(struct nfc_dev *nfc_dev, struct nfc_target *target,
 	return 0;
 }
 
+static int hci_check_presence(struct nfc_dev *nfc_dev,
+			      struct nfc_target *target)
+{
+	struct nfc_hci_dev *hdev = nfc_get_drvdata(nfc_dev);
+
+	if (hdev->ops->check_presence)
+		return hdev->ops->check_presence(hdev, target);
+
+	return 0;
+}
+
 struct nfc_ops hci_nfc_ops = {
 	.dev_up = hci_dev_up,
 	.dev_down = hci_dev_down,
@@ -582,6 +593,7 @@ struct nfc_ops hci_nfc_ops = {
 	.activate_target = hci_activate_target,
 	.deactivate_target = hci_deactivate_target,
 	.data_exchange = hci_data_exchange,
+	.check_presence = hci_check_presence,
 };
 
 struct nfc_hci_dev *nfc_hci_allocate_device(struct nfc_hci_ops *ops,
diff --git a/net/nfc/hci/shdlc.c b/net/nfc/hci/shdlc.c
index 923bdf7..5665dc6 100644
--- a/net/nfc/hci/shdlc.c
+++ b/net/nfc/hci/shdlc.c
@@ -816,6 +816,17 @@ static int nfc_shdlc_data_exchange(struct nfc_hci_dev *hdev,
 	return -EPERM;
 }
 
+static int nfc_shdlc_check_presence(struct nfc_hci_dev *hdev,
+				    struct nfc_target *target)
+{
+	struct nfc_shdlc *shdlc = nfc_hci_get_clientdata(hdev);
+
+	if (shdlc->ops->check_presence)
+		return shdlc->ops->check_presence(shdlc, target);
+
+	return 0;
+}
+
 static struct nfc_hci_ops shdlc_ops = {
 	.open = nfc_shdlc_open,
 	.close = nfc_shdlc_close,
@@ -825,6 +836,7 @@ static struct nfc_hci_ops shdlc_ops = {
 	.target_from_gate = nfc_shdlc_target_from_gate,
 	.complete_target_discovered = nfc_shdlc_complete_target_discovered,
 	.data_exchange = nfc_shdlc_data_exchange,
+	.check_presence = nfc_shdlc_check_presence,
 };
 
 struct nfc_shdlc *nfc_shdlc_allocate(struct nfc_shdlc_ops *ops,
-- 
1.7.9.1

