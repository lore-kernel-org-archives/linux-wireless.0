Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:48472 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137Ab0KBA4d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Nov 2010 20:56:33 -0400
Received: by pxi15 with SMTP id 15so630739pxi.19
        for <linux-wireless@vger.kernel.org>; Mon, 01 Nov 2010 17:56:32 -0700 (PDT)
From: Brian Cavagnolo <brian@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: buytenh@wantstofly.org, Brian Cavagnolo <brian@cozybit.com>
Subject: [PATCH 6/7] mwl8k: choose proper firmware image as directed by user
Date: Mon,  1 Nov 2010 17:55:50 -0700
Message-Id: <1288659351-22313-6-git-send-email-brian@cozybit.com>
In-Reply-To: <1288659351-22313-1-git-send-email-brian@cozybit.com>
References: <1288659351-22313-1-git-send-email-brian@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The mwl8k can operate in AP or STA mode, depending on the
firmware image that is loaded.  Allow the user to specify
the desired firmware image at module load time.

Also, the firmware image can be swapped to meet the user's
add_interface request.  For example, suppose the STA
firmware is loaded, no STA interface has been added, and the
user adds an AP interface.  In this case, the AP firmware
will be loaded to meet the request.

Based on a patch from Pradeep Nemavat <pnemavat@marvell.com>

Signed-off-by: Brian Cavagnolo <brian@cozybit.com>
---
 drivers/net/wireless/mwl8k.c |  127 ++++++++++++++++++++++++++++++++++++++----
 1 files changed, 115 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index bbf8222..1368e5c 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -29,6 +29,11 @@
 #define MWL8K_NAME	KBUILD_MODNAME
 #define MWL8K_VERSION	"0.12"
 
+/* Module parameters */
+static unsigned want_ap_fw;
+module_param(want_ap_fw, bool, 0);
+MODULE_PARM_DESC(want_ap_fw, "Set to 1 to default to ap fw instead of sta fw");
+
 /* Register definitions */
 #define MWL8K_HIU_GEN_PTR			0x00000c10
 #define  MWL8K_MODE_STA				 0x0000005a
@@ -92,7 +97,8 @@ struct rxd_ops {
 struct mwl8k_device_info {
 	char *part_name;
 	char *helper_image;
-	char *fw_image;
+	char *fw_image_sta;
+	char *fw_image_ap;
 	struct rxd_ops *ap_rxd_ops;
 };
 
@@ -214,6 +220,12 @@ struct mwl8k_priv {
 
 	/* Size of the tx descriptor for the currently loaded firmware */
 	unsigned short txd_size;
+
+	/*
+	 * preserve the queue configurations so they can be restored if/when
+	 * the firmware image is swapped.
+	 */
+	struct ieee80211_tx_queue_params wmm_params[MWL8K_TX_QUEUES];
 };
 
 /* Per interface specific private data */
@@ -405,7 +417,7 @@ static int mwl8k_request_fw(struct mwl8k_priv *priv,
 				fname, &priv->pdev->dev);
 }
 
-static int mwl8k_request_firmware(struct mwl8k_priv *priv)
+static int mwl8k_request_firmware(struct mwl8k_priv *priv, char *fw_image)
 {
 	struct mwl8k_device_info *di = priv->device_info;
 	int rc;
@@ -420,10 +432,10 @@ static int mwl8k_request_firmware(struct mwl8k_priv *priv)
 		}
 	}
 
-	rc = mwl8k_request_fw(priv, di->fw_image, &priv->fw_ucode);
+	rc = mwl8k_request_fw(priv, fw_image, &priv->fw_ucode);
 	if (rc) {
 		printk(KERN_ERR "%s: Error requesting firmware file %s\n",
-		       pci_name(priv->pdev), di->fw_image);
+		       pci_name(priv->pdev), fw_image);
 		mwl8k_release_fw(&priv->fw_helper);
 		return rc;
 	}
@@ -3364,13 +3376,16 @@ static void mwl8k_stop(struct ieee80211_hw *hw)
 		mwl8k_txq_reclaim(hw, i, INT_MAX, 1);
 }
 
+static int mwl8k_reload_firmware(struct ieee80211_hw *hw, char *fw_image);
+
 static int mwl8k_add_interface(struct ieee80211_hw *hw,
 			       struct ieee80211_vif *vif)
 {
 	struct mwl8k_priv *priv = hw->priv;
 	struct mwl8k_vif *mwl8k_vif;
 	u32 macids_supported;
-	int macid;
+	int macid, rc;
+	struct mwl8k_device_info *di;
 
 	/*
 	 * Reject interface creation if sniffer mode is active, as
@@ -3383,12 +3398,28 @@ static int mwl8k_add_interface(struct ieee80211_hw *hw,
 		return -EINVAL;
 	}
 
-
+	di = priv->device_info;
 	switch (vif->type) {
 	case NL80211_IFTYPE_AP:
+		if (!priv->ap_fw && di->fw_image_ap) {
+			/* we must load the ap fw to meet this request */
+			if (!list_empty(&priv->vif_list))
+				return -EBUSY;
+			rc = mwl8k_reload_firmware(hw, di->fw_image_ap);
+			if (rc)
+				return rc;
+		}
 		macids_supported = priv->ap_macids_supported;
 		break;
 	case NL80211_IFTYPE_STATION:
+		if (priv->ap_fw && di->fw_image_sta) {
+			/* we must load the sta fw to meet this request */
+			if (!list_empty(&priv->vif_list))
+				return -EBUSY;
+			rc = mwl8k_reload_firmware(hw, di->fw_image_sta);
+			if (rc)
+				return rc;
+		}
 		macids_supported = priv->sta_macids_supported;
 		break;
 	default:
@@ -3824,6 +3855,9 @@ static int mwl8k_conf_tx(struct ieee80211_hw *hw, u16 queue,
 
 	rc = mwl8k_fw_lock(hw);
 	if (!rc) {
+		BUG_ON(queue > MWL8K_TX_QUEUES - 1);
+		memcpy(&priv->wmm_params[queue], params, sizeof(*params));
+
 		if (!priv->wmm_enabled)
 			rc = mwl8k_cmd_set_wmm_mode(hw, 1);
 
@@ -3927,17 +3961,18 @@ static struct mwl8k_device_info mwl8k_info_tbl[] __devinitdata = {
 	[MWL8363] = {
 		.part_name	= "88w8363",
 		.helper_image	= "mwl8k/helper_8363.fw",
-		.fw_image	= "mwl8k/fmimage_8363.fw",
+		.fw_image_sta	= "mwl8k/fmimage_8363.fw",
 	},
 	[MWL8687] = {
 		.part_name	= "88w8687",
 		.helper_image	= "mwl8k/helper_8687.fw",
-		.fw_image	= "mwl8k/fmimage_8687.fw",
+		.fw_image_sta	= "mwl8k/fmimage_8687.fw",
 	},
 	[MWL8366] = {
 		.part_name	= "88w8366",
 		.helper_image	= "mwl8k/helper_8366.fw",
-		.fw_image	= "mwl8k/fmimage_8366.fw",
+		.fw_image_sta	= "mwl8k/fmimage_8366.fw",
+		.fw_image_ap	= "mwl8k/fmimage_8366_ap.fw",
 		.ap_rxd_ops	= &rxd_8366_ap_ops,
 	},
 };
@@ -3961,7 +3996,7 @@ static DEFINE_PCI_DEVICE_TABLE(mwl8k_pci_id_table) = {
 };
 MODULE_DEVICE_TABLE(pci, mwl8k_pci_id_table);
 
-static int mwl8k_init_firmware(struct ieee80211_hw *hw)
+static int mwl8k_init_firmware(struct ieee80211_hw *hw, char *fw_image)
 {
 	struct mwl8k_priv *priv = hw->priv;
 	int rc;
@@ -3970,7 +4005,7 @@ static int mwl8k_init_firmware(struct ieee80211_hw *hw)
 	mwl8k_hw_reset(priv);
 
 	/* Ask userland hotplug daemon for the device firmware */
-	rc = mwl8k_request_firmware(priv);
+	rc = mwl8k_request_firmware(priv, fw_image);
 	if (rc) {
 		wiphy_err(hw->wiphy, "Firmware files not found\n");
 		return rc;
@@ -4097,12 +4132,64 @@ err_stop_firmware:
 	return rc;
 }
 
+/*
+ * invoke mwl8k_reload_firmware to change the firmware image after the device
+ * has already been registered
+ */
+static int mwl8k_reload_firmware(struct ieee80211_hw *hw, char *fw_image)
+{
+	int i, rc = 0;
+	struct mwl8k_priv *priv = hw->priv;
+
+	mwl8k_stop(hw);
+	mwl8k_rxq_deinit(hw, 0);
+
+	for (i = 0; i < MWL8K_TX_QUEUES; i++)
+		mwl8k_txq_deinit(hw, i);
+
+	rc = mwl8k_init_firmware(hw, fw_image);
+	if (rc)
+		goto fail;
+
+	rc = mwl8k_probe_hw(hw);
+	if (rc)
+		goto fail;
+
+	rc = mwl8k_start(hw);
+	if (rc)
+		goto fail;
+
+	rc = mwl8k_config(hw, ~0);
+	if (rc)
+		goto fail;
+
+	for (i = 0; i < MWL8K_TX_QUEUES; i++) {
+		rc = mwl8k_conf_tx(hw, i, &priv->wmm_params[i]);
+		if (rc)
+			goto fail;
+	}
+
+	printk(KERN_INFO "%s: %s v%d, %pM, %s firmware %u.%u.%u.%u\n",
+	       wiphy_name(hw->wiphy), priv->device_info->part_name,
+	       priv->hw_rev, hw->wiphy->perm_addr,
+	       priv->ap_fw ? "AP" : "STA",
+	       (priv->fw_rev >> 24) & 0xff, (priv->fw_rev >> 16) & 0xff,
+	       (priv->fw_rev >> 8) & 0xff, priv->fw_rev & 0xff);
+
+	return rc;
+
+fail:
+	printk(KERN_WARNING "mwl8k: Failed to reload firmware image.\n");
+	return rc;
+}
+
 static int __devinit mwl8k_probe(struct pci_dev *pdev,
 				 const struct pci_device_id *id)
 {
 	static int printed_version = 0;
 	struct ieee80211_hw *hw;
 	struct mwl8k_priv *priv;
+	struct mwl8k_device_info *di;
 	int rc;
 	int i;
 
@@ -4164,7 +4251,23 @@ static int __devinit mwl8k_probe(struct pci_dev *pdev,
 		}
 	}
 
-	rc = mwl8k_init_firmware(hw);
+	/*
+	 * Choose the initial fw image depending on user input and availability
+	 * of images.
+	 */
+	di = priv->device_info;
+	if (want_ap_fw && di->fw_image_ap)
+		rc = mwl8k_init_firmware(hw, di->fw_image_ap);
+	else if (!want_ap_fw && di->fw_image_sta)
+		rc = mwl8k_init_firmware(hw, di->fw_image_sta);
+	else if (want_ap_fw && !di->fw_image_ap && di->fw_image_sta) {
+		printk(KERN_WARNING "AP fw is unavailable.  Using STA fw.");
+		rc = mwl8k_init_firmware(hw, di->fw_image_sta);
+	} else if (!want_ap_fw && !di->fw_image_sta && di->fw_image_ap) {
+		printk(KERN_WARNING "STA fw is unavailable.  Using AP fw.");
+		rc = mwl8k_init_firmware(hw, di->fw_image_ap);
+	} else
+		rc = mwl8k_init_firmware(hw, di->fw_image_sta);
 	if (rc)
 		goto err_stop_firmware;
 
-- 
1.7.1.1

