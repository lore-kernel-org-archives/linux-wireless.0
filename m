Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:48251 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933216Ab0KMBYZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Nov 2010 20:24:25 -0500
Received: by mail-gx0-f174.google.com with SMTP id 23so2185256gxk.19
        for <linux-wireless@vger.kernel.org>; Fri, 12 Nov 2010 17:24:25 -0800 (PST)
From: Brian Cavagnolo <brian@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: buytenh@wantstofly.org, Brian Cavagnolo <brian@cozybit.com>
Subject: [PATCH V2 6/7] mwl8k: make initial firmware load asynchronous
Date: Fri, 12 Nov 2010 17:23:52 -0800
Message-Id: <1289611433-5119-7-git-send-email-brian@cozybit.com>
In-Reply-To: <1288659351-22313-1-git-send-email-brian@cozybit.com>
References: <1288659351-22313-1-git-send-email-brian@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Introduce a firmware loading state machine to manage the process
of loading firmware asynchronously and completing initialization
upon success.  The state machine attempts to load the preferred
firmware image.  If that fails, and if an alternative firmware
image is available, it will attempt to load that one.

Signed-off-by: Brian Cavagnolo <brian@cozybit.com>
---
 drivers/net/wireless/mwl8k.c |  207 ++++++++++++++++++++++++++++++++++++------
 1 files changed, 178 insertions(+), 29 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index e5b062c..081bb6c 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -224,6 +224,12 @@ struct mwl8k_priv {
 	 * the firmware image is swapped.
 	 */
 	struct ieee80211_tx_queue_params wmm_params[MWL8K_TX_QUEUES];
+
+	/* async firmware loading state */
+	unsigned fw_state;
+	char *fw_pref;
+	char *fw_alt;
+	struct completion firmware_loading_complete;
 };
 
 /* Per interface specific private data */
@@ -403,34 +409,66 @@ static void mwl8k_release_firmware(struct mwl8k_priv *priv)
 	mwl8k_release_fw(&priv->fw_helper);
 }
 
+/* states for asynchronous f/w loading */
+static void mwl8k_fw_state_machine(const struct firmware *fw, void *context);
+enum {
+	FW_STATE_INIT = 0,
+	FW_STATE_LOADING_PREF,
+	FW_STATE_LOADING_ALT,
+	FW_STATE_ERROR,
+};
+
 /* Request fw image */
 static int mwl8k_request_fw(struct mwl8k_priv *priv,
-			    const char *fname, struct firmware **fw)
+			    const char *fname, struct firmware **fw,
+			    bool nowait)
 {
 	/* release current image */
 	if (*fw != NULL)
 		mwl8k_release_fw(fw);
 
-	return request_firmware((const struct firmware **)fw,
-				fname, &priv->pdev->dev);
+	if (nowait)
+		return request_firmware_nowait(THIS_MODULE, 1, fname,
+					       &priv->pdev->dev, GFP_KERNEL,
+					       priv, mwl8k_fw_state_machine);
+	else
+		return request_firmware((const struct firmware **)fw,
+					fname, &priv->pdev->dev);
 }
 
-static int mwl8k_request_firmware(struct mwl8k_priv *priv, char *fw_image)
+static int mwl8k_request_firmware(struct mwl8k_priv *priv, char *fw_image,
+				  bool nowait)
 {
 	struct mwl8k_device_info *di = priv->device_info;
 	int rc;
 
 	if (di->helper_image != NULL) {
-		rc = mwl8k_request_fw(priv, di->helper_image, &priv->fw_helper);
-		if (rc) {
-			printk(KERN_ERR "%s: Error requesting helper "
-			       "firmware file %s\n", pci_name(priv->pdev),
-			       di->helper_image);
+		if (nowait)
+			rc = mwl8k_request_fw(priv, di->helper_image,
+					      &priv->fw_helper, true);
+		else
+			rc = mwl8k_request_fw(priv, di->helper_image,
+					      &priv->fw_helper, false);
+		if (rc)
+			printk(KERN_ERR "%s: Error requesting helper fw %s\n",
+			       pci_name(priv->pdev), di->helper_image);
+
+		if (rc || nowait)
 			return rc;
-		}
 	}
 
-	rc = mwl8k_request_fw(priv, fw_image, &priv->fw_ucode);
+	if (nowait) {
+		/*
+		 * if we get here, no helper image is needed.  Skip the
+		 * FW_STATE_INIT state.
+		 */
+		priv->fw_state = FW_STATE_LOADING_PREF;
+		rc = mwl8k_request_fw(priv, fw_image,
+				      &priv->fw_ucode,
+				      true);
+	} else
+		rc = mwl8k_request_fw(priv, fw_image,
+				      &priv->fw_ucode, false);
 	if (rc) {
 		printk(KERN_ERR "%s: Error requesting firmware file %s\n",
 		       pci_name(priv->pdev), fw_image);
@@ -3998,7 +4036,99 @@ static DEFINE_PCI_DEVICE_TABLE(mwl8k_pci_id_table) = {
 };
 MODULE_DEVICE_TABLE(pci, mwl8k_pci_id_table);
 
-static int mwl8k_init_firmware(struct ieee80211_hw *hw, char *fw_image)
+static int mwl8k_request_alt_fw(struct mwl8k_priv *priv)
+{
+	int rc;
+	printk(KERN_ERR "%s: Error requesting preferred fw %s.\n"
+	       "Trying alternative firmware %s\n", pci_name(priv->pdev),
+	       priv->fw_pref, priv->fw_alt);
+	rc = mwl8k_request_fw(priv, priv->fw_alt, &priv->fw_ucode, true);
+	if (rc) {
+		printk(KERN_ERR "%s: Error requesting alt fw %s\n",
+		       pci_name(priv->pdev), priv->fw_alt);
+		return rc;
+	}
+	return 0;
+}
+
+static int mwl8k_firmware_load_success(struct mwl8k_priv *priv);
+static void mwl8k_fw_state_machine(const struct firmware *fw, void *context)
+{
+	struct mwl8k_priv *priv = context;
+	struct mwl8k_device_info *di = priv->device_info;
+	int rc;
+
+	switch (priv->fw_state) {
+	case FW_STATE_INIT:
+		if (!fw) {
+			printk(KERN_ERR "%s: Error requesting helper fw %s\n",
+			       pci_name(priv->pdev), di->helper_image);
+			goto fail;
+		}
+		priv->fw_helper = fw;
+		rc = mwl8k_request_fw(priv, priv->fw_pref, &priv->fw_ucode,
+				      true);
+		if (rc && priv->fw_alt) {
+			rc = mwl8k_request_alt_fw(priv);
+			if (rc)
+				goto fail;
+			priv->fw_state = FW_STATE_LOADING_ALT;
+		} else if (rc)
+			goto fail;
+		else
+			priv->fw_state = FW_STATE_LOADING_PREF;
+		break;
+
+	case FW_STATE_LOADING_PREF:
+		if (!fw) {
+			if (priv->fw_alt) {
+				rc = mwl8k_request_alt_fw(priv);
+				if (rc)
+					goto fail;
+				priv->fw_state = FW_STATE_LOADING_ALT;
+			} else
+				goto fail;
+		} else {
+			priv->fw_ucode = fw;
+			rc = mwl8k_firmware_load_success(priv);
+			if (rc)
+				goto fail;
+			else
+				complete(&priv->firmware_loading_complete);
+		}
+		break;
+
+	case FW_STATE_LOADING_ALT:
+		if (!fw) {
+			printk(KERN_ERR "%s: Error requesting alt fw %s\n",
+			       pci_name(priv->pdev), di->helper_image);
+			goto fail;
+		}
+		priv->fw_ucode = fw;
+		rc = mwl8k_firmware_load_success(priv);
+		if (rc)
+			goto fail;
+		else
+			complete(&priv->firmware_loading_complete);
+		break;
+
+	default:
+		printk(KERN_ERR "%s: Unexpected firmware loading state: %d\n",
+		       MWL8K_NAME, priv->fw_state);
+		BUG_ON(1);
+	}
+
+	return;
+
+fail:
+	priv->fw_state = FW_STATE_ERROR;
+	complete(&priv->firmware_loading_complete);
+	device_release_driver(&priv->pdev->dev);
+	mwl8k_release_firmware(priv);
+}
+
+static int mwl8k_init_firmware(struct ieee80211_hw *hw, char *fw_image,
+			       bool nowait)
 {
 	struct mwl8k_priv *priv = hw->priv;
 	int rc;
@@ -4007,12 +4137,15 @@ static int mwl8k_init_firmware(struct ieee80211_hw *hw, char *fw_image)
 	mwl8k_hw_reset(priv);
 
 	/* Ask userland hotplug daemon for the device firmware */
-	rc = mwl8k_request_firmware(priv, fw_image);
+	rc = mwl8k_request_firmware(priv, fw_image, nowait);
 	if (rc) {
 		wiphy_err(hw->wiphy, "Firmware files not found\n");
 		return rc;
 	}
 
+	if (nowait)
+		return rc;
+
 	/* Load firmware into hardware */
 	rc = mwl8k_load_firmware(hw);
 	if (rc)
@@ -4147,7 +4280,7 @@ static int mwl8k_reload_firmware(struct ieee80211_hw *hw, char *fw_image)
 	for (i = 0; i < MWL8K_TX_QUEUES; i++)
 		mwl8k_txq_deinit(hw, i);
 
-	rc = mwl8k_init_firmware(hw, fw_image);
+	rc = mwl8k_init_firmware(hw, fw_image, false);
 	if (rc)
 		goto fail;
 
@@ -4181,6 +4314,13 @@ static int mwl8k_firmware_load_success(struct mwl8k_priv *priv)
 	struct ieee80211_hw *hw = priv->hw;
 	int i, rc;
 
+	rc = mwl8k_load_firmware(hw);
+	mwl8k_release_firmware(priv);
+	if (rc) {
+		wiphy_err(hw->wiphy, "Cannot start firmware\n");
+		return rc;
+	}
+
 	/*
 	 * Extra headroom is the size of the required DMA header
 	 * minus the size of the smallest 802.11 frame (CTS frame).
@@ -4325,28 +4465,29 @@ static int __devinit mwl8k_probe(struct pci_dev *pdev,
 	}
 
 	/*
-	 * Choose the initial fw image depending on user input and availability
-	 * of images.
+	 * Choose the initial fw image depending on user input.  If a second
+	 * image is available, make it the alternative image that will be
+	 * loaded if the first one fails.
 	 */
+	init_completion(&priv->firmware_loading_complete);
 	di = priv->device_info;
-	if (ap_mode_default && di->fw_image_ap)
-		rc = mwl8k_init_firmware(hw, di->fw_image_ap);
-	else if (!ap_mode_default && di->fw_image_sta)
-		rc = mwl8k_init_firmware(hw, di->fw_image_sta);
-	else if (ap_mode_default && !di->fw_image_ap && di->fw_image_sta) {
+	if (ap_mode_default && di->fw_image_ap) {
+		priv->fw_pref = di->fw_image_ap;
+		priv->fw_alt = di->fw_image_sta;
+	} else if (!ap_mode_default && di->fw_image_sta) {
+		priv->fw_pref = di->fw_image_sta;
+		priv->fw_alt = di->fw_image_ap;
+	} else if (ap_mode_default && !di->fw_image_ap && di->fw_image_sta) {
 		printk(KERN_WARNING "AP fw is unavailable.  Using STA fw.");
-		rc = mwl8k_init_firmware(hw, di->fw_image_sta);
+		priv->fw_pref = di->fw_image_sta;
 	} else if (!ap_mode_default && !di->fw_image_sta && di->fw_image_ap) {
 		printk(KERN_WARNING "STA fw is unavailable.  Using AP fw.");
-		rc = mwl8k_init_firmware(hw, di->fw_image_ap);
-	} else
-		rc = mwl8k_init_firmware(hw, di->fw_image_sta);
+		priv->fw_pref = di->fw_image_ap;
+	}
+	rc = mwl8k_init_firmware(hw, priv->fw_pref, true);
 	if (rc)
 		goto err_stop_firmware;
-
-	rc = mwl8k_firmware_load_success(priv);
-	if (!rc)
-		return rc;
+	return rc;
 
 err_stop_firmware:
 	mwl8k_hw_reset(priv);
@@ -4385,6 +4526,13 @@ static void __devexit mwl8k_remove(struct pci_dev *pdev)
 		return;
 	priv = hw->priv;
 
+	wait_for_completion(&priv->firmware_loading_complete);
+
+	if (priv->fw_state == FW_STATE_ERROR) {
+		mwl8k_hw_reset(priv);
+		goto unmap;
+	}
+
 	ieee80211_stop_queues(hw);
 
 	ieee80211_unregister_hw(hw);
@@ -4407,6 +4555,7 @@ static void __devexit mwl8k_remove(struct pci_dev *pdev)
 
 	pci_free_consistent(priv->pdev, 4, priv->cookie, priv->cookie_dma);
 
+unmap:
 	pci_iounmap(pdev, priv->regs);
 	pci_iounmap(pdev, priv->sram);
 	pci_set_drvdata(pdev, NULL);
-- 
1.7.1.1

