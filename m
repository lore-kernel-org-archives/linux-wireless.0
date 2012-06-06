Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:20470 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752772Ab2FFKHL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 06:07:11 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	linux-nfc@lists.01.org, Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 10/29] NFC: Set the NFC device RF mode appropriately
Date: Wed,  6 Jun 2012 12:16:27 +0200
Message-Id: <1338977806-30279-11-git-send-email-sameo@linux.intel.com> (sfid-20120606_120720_172765_7E80864B)
In-Reply-To: <1338977806-30279-1-git-send-email-sameo@linux.intel.com>
References: <1338977806-30279-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 include/linux/nfc.h   |    1 +
 include/net/nfc/nfc.h |    2 +-
 net/nfc/core.c        |   14 ++++++++++----
 3 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/include/linux/nfc.h b/include/linux/nfc.h
index d124e92..f4e6dd9 100644
--- a/include/linux/nfc.h
+++ b/include/linux/nfc.h
@@ -146,6 +146,7 @@ enum nfc_attrs {
 /* NFC RF modes */
 #define NFC_RF_INITIATOR 0
 #define NFC_RF_TARGET    1
+#define NFC_RF_NONE      2
 
 /* NFC protocols masks used in bitsets */
 #define NFC_PROTO_JEWEL_MASK	(1 << NFC_PROTO_JEWEL)
diff --git a/include/net/nfc/nfc.h b/include/net/nfc/nfc.h
index 41573b4b..a6a7b49 100644
--- a/include/net/nfc/nfc.h
+++ b/include/net/nfc/nfc.h
@@ -100,10 +100,10 @@ struct nfc_dev {
 	int targets_generation;
 	struct device dev;
 	bool dev_up;
+	u8 rf_mode;
 	bool polling;
 	struct nfc_target *active_target;
 	bool dep_link_up;
-	u32 dep_rf_mode;
 	struct nfc_genl_data genl_data;
 	u32 supported_protocols;
 
diff --git a/net/nfc/core.c b/net/nfc/core.c
index 17f1474..722a0c7 100644
--- a/net/nfc/core.c
+++ b/net/nfc/core.c
@@ -144,8 +144,10 @@ int nfc_start_poll(struct nfc_dev *dev, u32 im_protocols, u32 tm_protocols)
 	}
 
 	rc = dev->ops->start_poll(dev, im_protocols, tm_protocols);
-	if (!rc)
+	if (!rc) {
 		dev->polling = true;
+		dev->rf_mode = NFC_RF_NONE;
+	}
 
 error:
 	device_unlock(&dev->dev);
@@ -235,8 +237,10 @@ int nfc_dep_link_up(struct nfc_dev *dev, int target_index, u8 comm_mode)
 	}
 
 	rc = dev->ops->dep_link_up(dev, target, comm_mode, gb, gb_len);
-	if (!rc)
+	if (!rc) {
 		dev->active_target = target;
+		dev->rf_mode = NFC_RF_INITIATOR;
+	}
 
 error:
 	device_unlock(&dev->dev);
@@ -264,7 +268,7 @@ int nfc_dep_link_down(struct nfc_dev *dev)
 		goto error;
 	}
 
-	if (dev->dep_rf_mode == NFC_RF_TARGET) {
+	if (dev->rf_mode == NFC_RF_TARGET) {
 		rc = -EOPNOTSUPP;
 		goto error;
 	}
@@ -286,7 +290,6 @@ int nfc_dep_link_is_up(struct nfc_dev *dev, u32 target_idx,
 		       u8 comm_mode, u8 rf_mode)
 {
 	dev->dep_link_up = true;
-	dev->dep_rf_mode = rf_mode;
 
 	nfc_llcp_mac_is_up(dev, target_idx, comm_mode, rf_mode);
 
@@ -330,6 +333,7 @@ int nfc_activate_target(struct nfc_dev *dev, u32 target_idx, u32 protocol)
 	rc = dev->ops->activate_target(dev, target, protocol);
 	if (!rc) {
 		dev->active_target = target;
+		dev->rf_mode = NFC_RF_INITIATOR;
 
 		if (dev->ops->check_presence)
 			mod_timer(&dev->check_pres_timer, jiffies +
@@ -470,6 +474,8 @@ int nfc_tm_activated(struct nfc_dev *dev, u32 protocol, u8 comm_mode,
 			goto out;
 	}
 
+	dev->rf_mode = NFC_RF_TARGET;
+
 	if (protocol == NFC_PROTO_NFC_DEP_MASK)
 		nfc_dep_link_is_up(dev, 0, comm_mode, NFC_RF_TARGET);
 
-- 
1.7.9.1

