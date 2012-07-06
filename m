Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:23801 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751196Ab2GFUAh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jul 2012 16:00:37 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	linux-nfc@lists.01.org, Samuel Ortiz <sameo@linux.intel.com>,
	Eric Lapuyade <eric.lapuyade@intel.com>
Subject: [PATCH 32/33] NFC: Add ISO 14443 type B protocol
Date: Fri,  6 Jul 2012 22:09:52 +0200
Message-Id: <1341605393-32056-33-git-send-email-sameo@linux.intel.com> (sfid-20120706_220533_671078_46A91E0D)
In-Reply-To: <1341605393-32056-1-git-send-email-sameo@linux.intel.com>
References: <1341605393-32056-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some devices (e.g. Sony's PaSoRi) can not do type B polling, so we have
to make a distinction between ISO14443 type A and B poll modes.

Cc: Eric Lapuyade <eric.lapuyade@intel.com>
Cc: Ilan Elias <ilane@ti.com>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/nfc/nfcwilink.c |    7 ++++---
 drivers/nfc/pn533.c     |   12 +++++++-----
 drivers/nfc/pn544_hci.c |    1 +
 include/linux/nfc.h     |   14 ++++++++------
 net/nfc/hci/core.c      |    2 +-
 net/nfc/nci/core.c      |    5 +++--
 net/nfc/nci/ntf.c       |    5 ++++-
 7 files changed, 28 insertions(+), 18 deletions(-)

diff --git a/drivers/nfc/nfcwilink.c b/drivers/nfc/nfcwilink.c
index 1f74a77..e7fd493 100644
--- a/drivers/nfc/nfcwilink.c
+++ b/drivers/nfc/nfcwilink.c
@@ -535,9 +535,10 @@ static int nfcwilink_probe(struct platform_device *pdev)
 	drv->pdev = pdev;
 
 	protocols = NFC_PROTO_JEWEL_MASK
-			| NFC_PROTO_MIFARE_MASK | NFC_PROTO_FELICA_MASK
-			| NFC_PROTO_ISO14443_MASK
-			| NFC_PROTO_NFC_DEP_MASK;
+		| NFC_PROTO_MIFARE_MASK | NFC_PROTO_FELICA_MASK
+		| NFC_PROTO_ISO14443_MASK
+		| NFC_PROTO_ISO14443_B_MASK
+		| NFC_PROTO_NFC_DEP_MASK;
 
 	drv->ndev = nci_allocate_device(&nfcwilink_ops,
 					protocols,
diff --git a/drivers/nfc/pn533.c b/drivers/nfc/pn533.c
index 84d8175..d606f52 100644
--- a/drivers/nfc/pn533.c
+++ b/drivers/nfc/pn533.c
@@ -49,13 +49,15 @@
 #define PN533_DEVICE_STD    0x1
 #define PN533_DEVICE_PASORI 0x2
 
-#define PN533_ALL_PROTOCOLS (NFC_PROTO_JEWEL_MASK | NFC_PROTO_MIFARE_MASK \
-			     | NFC_PROTO_FELICA_MASK | NFC_PROTO_ISO14443_MASK \
-			     | NFC_PROTO_NFC_DEP_MASK)
+#define PN533_ALL_PROTOCOLS (NFC_PROTO_JEWEL_MASK | NFC_PROTO_MIFARE_MASK |\
+			     NFC_PROTO_FELICA_MASK | NFC_PROTO_ISO14443_MASK |\
+			     NFC_PROTO_NFC_DEP_MASK |\
+			     NFC_PROTO_ISO14443_B_MASK)
 
 #define PN533_NO_TYPE_B_PROTOCOLS (NFC_PROTO_JEWEL_MASK | \
 				   NFC_PROTO_MIFARE_MASK | \
 				   NFC_PROTO_FELICA_MASK | \
+				   NFC_PROTO_ISO14443_MASK | \
 				   NFC_PROTO_NFC_DEP_MASK)
 
 static const struct usb_device_id pn533_table[] = {
@@ -987,7 +989,7 @@ static int pn533_target_found_type_b(struct nfc_target *nfc_tgt, u8 *tgt_data,
 	if (!pn533_target_type_b_is_valid(tgt_type_b, tgt_data_len))
 		return -EPROTO;
 
-	nfc_tgt->supported_protocols = NFC_PROTO_ISO14443_MASK;
+	nfc_tgt->supported_protocols = NFC_PROTO_ISO14443_B_MASK;
 
 	return 0;
 }
@@ -1094,7 +1096,7 @@ static void pn533_poll_create_mod_list(struct pn533 *dev,
 	if (im_protocols & NFC_PROTO_JEWEL_MASK)
 		pn533_poll_add_mod(dev, PN533_POLL_MOD_106KBPS_JEWEL);
 
-	if (im_protocols & NFC_PROTO_ISO14443_MASK)
+	if (im_protocols & NFC_PROTO_ISO14443_B_MASK)
 		pn533_poll_add_mod(dev, PN533_POLL_MOD_847KBPS_B);
 
 	if (tm_protocols)
diff --git a/drivers/nfc/pn544_hci.c b/drivers/nfc/pn544_hci.c
index c67b55e..aa71807 100644
--- a/drivers/nfc/pn544_hci.c
+++ b/drivers/nfc/pn544_hci.c
@@ -869,6 +869,7 @@ static int __devinit pn544_hci_probe(struct i2c_client *client,
 		    NFC_PROTO_MIFARE_MASK |
 		    NFC_PROTO_FELICA_MASK |
 		    NFC_PROTO_ISO14443_MASK |
+		    NFC_PROTO_ISO14443_B_MASK |
 		    NFC_PROTO_NFC_DEP_MASK;
 
 	info->shdlc = nfc_shdlc_allocate(&pn544_shdlc_ops,
diff --git a/include/linux/nfc.h b/include/linux/nfc.h
index f4e6dd9..6189f27 100644
--- a/include/linux/nfc.h
+++ b/include/linux/nfc.h
@@ -136,8 +136,9 @@ enum nfc_attrs {
 #define NFC_PROTO_FELICA	3
 #define NFC_PROTO_ISO14443	4
 #define NFC_PROTO_NFC_DEP	5
+#define NFC_PROTO_ISO14443_B	6
 
-#define NFC_PROTO_MAX		6
+#define NFC_PROTO_MAX		7
 
 /* NFC communication modes */
 #define NFC_COMM_ACTIVE  0
@@ -149,11 +150,12 @@ enum nfc_attrs {
 #define NFC_RF_NONE      2
 
 /* NFC protocols masks used in bitsets */
-#define NFC_PROTO_JEWEL_MASK	(1 << NFC_PROTO_JEWEL)
-#define NFC_PROTO_MIFARE_MASK	(1 << NFC_PROTO_MIFARE)
-#define NFC_PROTO_FELICA_MASK	(1 << NFC_PROTO_FELICA)
-#define NFC_PROTO_ISO14443_MASK	(1 << NFC_PROTO_ISO14443)
-#define NFC_PROTO_NFC_DEP_MASK	(1 << NFC_PROTO_NFC_DEP)
+#define NFC_PROTO_JEWEL_MASK      (1 << NFC_PROTO_JEWEL)
+#define NFC_PROTO_MIFARE_MASK     (1 << NFC_PROTO_MIFARE)
+#define NFC_PROTO_FELICA_MASK	  (1 << NFC_PROTO_FELICA)
+#define NFC_PROTO_ISO14443_MASK	  (1 << NFC_PROTO_ISO14443)
+#define NFC_PROTO_NFC_DEP_MASK	  (1 << NFC_PROTO_NFC_DEP)
+#define NFC_PROTO_ISO14443_B_MASK (1 << NFC_PROTO_ISO14443_B)
 
 struct sockaddr_nfc {
 	sa_family_t sa_family;
diff --git a/net/nfc/hci/core.c b/net/nfc/hci/core.c
index 4ccc518..36717ce 100644
--- a/net/nfc/hci/core.c
+++ b/net/nfc/hci/core.c
@@ -230,7 +230,7 @@ static int nfc_hci_target_discovered(struct nfc_hci_dev *hdev, u8 gate)
 		}
 		break;
 	case NFC_HCI_RF_READER_B_GATE:
-		targets->supported_protocols = NFC_PROTO_ISO14443_MASK;
+		targets->supported_protocols = NFC_PROTO_ISO14443_B_MASK;
 		break;
 	default:
 		if (hdev->ops->target_from_gate)
diff --git a/net/nfc/nci/core.c b/net/nfc/nci/core.c
index 766a02b..5bb4da6 100644
--- a/net/nfc/nci/core.c
+++ b/net/nfc/nci/core.c
@@ -194,7 +194,7 @@ static void nci_rf_discover_req(struct nci_dev *ndev, unsigned long opt)
 	}
 
 	if ((cmd.num_disc_configs < NCI_MAX_NUM_RF_CONFIGS) &&
-	    (protocols & NFC_PROTO_ISO14443_MASK)) {
+	    (protocols & NFC_PROTO_ISO14443_B_MASK)) {
 		cmd.disc_configs[cmd.num_disc_configs].rf_tech_and_mode =
 			NCI_NFC_B_PASSIVE_POLL_MODE;
 		cmd.disc_configs[cmd.num_disc_configs].frequency = 1;
@@ -486,7 +486,8 @@ static int nci_activate_target(struct nfc_dev *nfc_dev,
 			param.rf_protocol = NCI_RF_PROTOCOL_T2T;
 		else if (protocol == NFC_PROTO_FELICA)
 			param.rf_protocol = NCI_RF_PROTOCOL_T3T;
-		else if (protocol == NFC_PROTO_ISO14443)
+		else if (protocol == NFC_PROTO_ISO14443 ||
+			 protocol == NFC_PROTO_ISO14443_B)
 			param.rf_protocol = NCI_RF_PROTOCOL_ISO_DEP;
 		else
 			param.rf_protocol = NCI_RF_PROTOCOL_NFC_DEP;
diff --git a/net/nfc/nci/ntf.c b/net/nfc/nci/ntf.c
index 2ab196a..af7a93b 100644
--- a/net/nfc/nci/ntf.c
+++ b/net/nfc/nci/ntf.c
@@ -170,7 +170,10 @@ static int nci_add_new_protocol(struct nci_dev *ndev,
 	if (rf_protocol == NCI_RF_PROTOCOL_T2T)
 		protocol = NFC_PROTO_MIFARE_MASK;
 	else if (rf_protocol == NCI_RF_PROTOCOL_ISO_DEP)
-		protocol = NFC_PROTO_ISO14443_MASK;
+		if (rf_tech_and_mode == NCI_NFC_A_PASSIVE_POLL_MODE)
+			protocol = NFC_PROTO_ISO14443_MASK;
+		else
+			protocol = NFC_PROTO_ISO14443_B_MASK;
 	else if (rf_protocol == NCI_RF_PROTOCOL_T3T)
 		protocol = NFC_PROTO_FELICA_MASK;
 	else
-- 
1.7.10

