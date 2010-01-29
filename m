Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:62928 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754036Ab0A2Ty7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jan 2010 14:54:59 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes@sipsolutions.net>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH] iwlwifi: load firmware asynchronously before mac80211 registration
Date: Fri, 29 Jan 2010 11:54:56 -0800
Message-Id: <1264794896-8112-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>

At the wireless summit in Portland we discussed a way of
loading firmware asynchronously from ->probe() before
registration to mac80211, in order to register with the
wireless subsystems with complete information in cases
where firmware is required to know parameters.

This is not yet the case in iwlwifi, but for some new
features we're working on it will be the case since
those will only be supported by new firmware images.

Hence, to start with, convert iwlwifi to load firmware
asynchronously from probe, unbinding the device when
firmware loading fails, and only registering with the
wireless subsystems after firmware has been loaded
successfully.

Future patches will hook into this to register the
new firmware capabilities, depending on the firmware
API version.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
This patch depends on the new request_firmware_nowait() that has not yet
been merged into wireless-next-2.6. We thus send this patch based on
wireless-testing, which has the correct function.

Even though we do not base it on wireles-next-2.6 please do take this patch
for 2.6.34 to be included during the merge window.

Thank you very much


 drivers/net/wireless/iwlwifi/iwl-agn.c |  157 ++++++++++++++++----------------
 drivers/net/wireless/iwlwifi/iwl-dev.h |    2 +
 2 files changed, 81 insertions(+), 78 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 4a26892..3bb3a89 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1463,59 +1463,66 @@ static void iwl_nic_start(struct iwl_priv *priv)
 }
 
 
+static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context);
+static int iwl_mac_setup_register(struct iwl_priv *priv);
+
+static int __must_check iwl_request_firmware(struct iwl_priv *priv, bool first)
+{
+	const char *name_pre = priv->cfg->fw_name_pre;
+
+	if (first)
+		priv->fw_index = priv->cfg->ucode_api_max;
+	else
+		priv->fw_index--;
+
+	if (priv->fw_index < priv->cfg->ucode_api_min) {
+		IWL_ERR(priv, "no suitable firmware found!\n");
+		return -ENOENT;
+	}
+
+	sprintf(priv->firmware_name, "%s%d%s",
+		name_pre, priv->fw_index, ".ucode");
+
+	IWL_DEBUG_INFO(priv, "attempting to load firmware '%s'\n",
+		       priv->firmware_name);
+
+	return request_firmware_nowait(THIS_MODULE, 1, priv->firmware_name,
+				       &priv->pci_dev->dev, GFP_KERNEL, priv,
+				       iwl_ucode_callback);
+}
+
 /**
- * iwl_read_ucode - Read uCode images from disk file.
+ * iwl_ucode_callback - callback when firmware was loaded
  *
- * Copy into buffers for card to fetch via bus-mastering
+ * If loaded successfully, copies the firmware into buffers
+ * for the card to fetch (via DMA).
  */
-static int iwl_read_ucode(struct iwl_priv *priv)
+static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 {
+	struct iwl_priv *priv = context;
 	struct iwl_ucode_header *ucode;
-	int ret = -EINVAL, index;
-	const struct firmware *ucode_raw;
-	const char *name_pre = priv->cfg->fw_name_pre;
 	const unsigned int api_max = priv->cfg->ucode_api_max;
 	const unsigned int api_min = priv->cfg->ucode_api_min;
-	char buf[25];
 	u8 *src;
 	size_t len;
 	u32 api_ver, build;
 	u32 inst_size, data_size, init_size, init_data_size, boot_size;
+	int err;
 	u16 eeprom_ver;
 
-	/* Ask kernel firmware_class module to get the boot firmware off disk.
-	 * request_firmware() is synchronous, file is in memory on return. */
-	for (index = api_max; index >= api_min; index--) {
-		sprintf(buf, "%s%d%s", name_pre, index, ".ucode");
-		ret = request_firmware(&ucode_raw, buf, &priv->pci_dev->dev);
-		if (ret < 0) {
-			IWL_ERR(priv, "%s firmware file req failed: %d\n",
-				  buf, ret);
-			if (ret == -ENOENT)
-				continue;
-			else
-				goto error;
-		} else {
-			if (index < api_max)
-				IWL_ERR(priv, "Loaded firmware %s, "
-					"which is deprecated. "
-					"Please use API v%u instead.\n",
-					  buf, api_max);
-
-			IWL_DEBUG_INFO(priv, "Got firmware '%s' file (%zd bytes) from disk\n",
-				       buf, ucode_raw->size);
-			break;
-		}
+	if (!ucode_raw) {
+		IWL_ERR(priv, "request for firmware file '%s' failed.\n",
+			priv->firmware_name);
+		goto try_again;
 	}
 
-	if (ret < 0)
-		goto error;
+	IWL_DEBUG_INFO(priv, "Loaded firmware file '%s' (%zd bytes).\n",
+		       priv->firmware_name, ucode_raw->size);
 
 	/* Make sure that we got at least the v1 header! */
 	if (ucode_raw->size < priv->cfg->ops->ucode->get_header_size(1)) {
 		IWL_ERR(priv, "File size way too small!\n");
-		ret = -EINVAL;
-		goto err_release;
+		goto try_again;
 	}
 
 	/* Data from ucode file:  header followed by uCode images */
@@ -1540,10 +1547,9 @@ static int iwl_read_ucode(struct iwl_priv *priv)
 		IWL_ERR(priv, "Driver unable to support your firmware API. "
 			  "Driver supports v%u, firmware is v%u.\n",
 			  api_max, api_ver);
-		priv->ucode_ver = 0;
-		ret = -EINVAL;
-		goto err_release;
+		goto try_again;
 	}
+
 	if (api_ver != api_max)
 		IWL_ERR(priv, "Firmware has old API version. Expected v%u, "
 			  "got v%u. New firmware can be obtained "
@@ -1585,6 +1591,12 @@ static int iwl_read_ucode(struct iwl_priv *priv)
 	IWL_DEBUG_INFO(priv, "f/w package hdr boot inst size = %u\n",
 		       boot_size);
 
+	/*
+	 * For any of the failures below (before allocating pci memory)
+	 * we will try to load a version with a smaller API -- maybe the
+	 * user just got a corrupted version of the latest API.
+	 */
+
 	/* Verify size of file vs. image size info in file's header */
 	if (ucode_raw->size !=
 		priv->cfg->ops->ucode->get_header_size(api_ver) +
@@ -1594,41 +1606,35 @@ static int iwl_read_ucode(struct iwl_priv *priv)
 		IWL_DEBUG_INFO(priv,
 			"uCode file size %d does not match expected size\n",
 			(int)ucode_raw->size);
-		ret = -EINVAL;
-		goto err_release;
+		goto try_again;
 	}
 
 	/* Verify that uCode images will fit in card's SRAM */
 	if (inst_size > priv->hw_params.max_inst_size) {
 		IWL_DEBUG_INFO(priv, "uCode instr len %d too large to fit in\n",
 			       inst_size);
-		ret = -EINVAL;
-		goto err_release;
+		goto try_again;
 	}
 
 	if (data_size > priv->hw_params.max_data_size) {
 		IWL_DEBUG_INFO(priv, "uCode data len %d too large to fit in\n",
 				data_size);
-		ret = -EINVAL;
-		goto err_release;
+		goto try_again;
 	}
 	if (init_size > priv->hw_params.max_inst_size) {
 		IWL_INFO(priv, "uCode init instr len %d too large to fit in\n",
 			init_size);
-		ret = -EINVAL;
-		goto err_release;
+		goto try_again;
 	}
 	if (init_data_size > priv->hw_params.max_data_size) {
 		IWL_INFO(priv, "uCode init data len %d too large to fit in\n",
 		      init_data_size);
-		ret = -EINVAL;
-		goto err_release;
+		goto try_again;
 	}
 	if (boot_size > priv->hw_params.max_bsm_size) {
 		IWL_INFO(priv, "uCode boot instr len %d too large to fit in\n",
 			boot_size);
-		ret = -EINVAL;
-		goto err_release;
+		goto try_again;
 	}
 
 	/* Allocate ucode buffers for card's bus-master loading ... */
@@ -1712,20 +1718,36 @@ static int iwl_read_ucode(struct iwl_priv *priv)
 	IWL_DEBUG_INFO(priv, "Copying (but not loading) boot instr len %Zd\n", len);
 	memcpy(priv->ucode_boot.v_addr, src, len);
 
+	/**************************************************
+	 * This is still part of probe() in a sense...
+	 *
+	 * 9. Setup and register with mac80211 and debugfs
+	 **************************************************/
+	err = iwl_mac_setup_register(priv);
+	if (err)
+		goto out_unbind;
+
+	err = iwl_dbgfs_register(priv, DRV_NAME);
+	if (err)
+		IWL_ERR(priv, "failed to create debugfs files. Ignoring error: %d\n", err);
+
 	/* We have our copies now, allow OS release its copies */
 	release_firmware(ucode_raw);
-	return 0;
+	return;
+
+ try_again:
+	/* try next, if any */
+	if (iwl_request_firmware(priv, false))
+		goto out_unbind;
+	release_firmware(ucode_raw);
+	return;
 
  err_pci_alloc:
 	IWL_ERR(priv, "failed to allocate pci memory\n");
-	ret = -ENOMEM;
 	iwl_dealloc_ucode_pci(priv);
-
- err_release:
+ out_unbind:
+	device_release_driver(&priv->pci_dev->dev);
 	release_firmware(ucode_raw);
-
- error:
-	return ret;
 }
 
 static const char *desc_lookup_text[] = {
@@ -2673,21 +2695,7 @@ static int iwl_mac_start(struct ieee80211_hw *hw)
 
 	/* we should be verifying the device is ready to be opened */
 	mutex_lock(&priv->mutex);
-
-	/* fetch ucode file from disk, alloc and copy to bus-master buffers ...
-	 * ucode filename and max sizes are card-specific. */
-
-	if (!priv->ucode_code.len) {
-		ret = iwl_read_ucode(priv);
-		if (ret) {
-			IWL_ERR(priv, "Could not read microcode: %d\n", ret);
-			mutex_unlock(&priv->mutex);
-			return ret;
-		}
-	}
-
 	ret = __iwl_up(priv);
-
 	mutex_unlock(&priv->mutex);
 
 	if (ret)
@@ -3645,17 +3653,10 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	iwl_power_initialize(priv);
 	iwl_tt_initialize(priv);
 
-	/**************************************************
-	 * 9. Setup and register with mac80211 and debugfs
-	 **************************************************/
-	err = iwl_mac_setup_register(priv);
+	err = iwl_request_firmware(priv, true);
 	if (err)
 		goto out_remove_sysfs;
 
-	err = iwl_dbgfs_register(priv, DRV_NAME);
-	if (err)
-		IWL_ERR(priv, "failed to create debugfs files. Ignoring error: %d\n", err);
-
 	return 0;
 
  out_remove_sysfs:
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 9b0a5cb..78106cc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1111,6 +1111,7 @@ struct iwl_priv {
 	u8   rev_id;
 
 	/* uCode images, save to reload in case of failure */
+	int fw_index;			/* firmware we're trying to load */
 	u32 ucode_ver;			/* version of ucode, copy of
 					   iwl_ucode.ver */
 	struct fw_desc ucode_code;	/* runtime inst */
@@ -1121,6 +1122,7 @@ struct iwl_priv {
 	struct fw_desc ucode_boot;	/* bootstrap inst */
 	enum ucode_type ucode_type;
 	u8 ucode_write_complete;	/* the image write is complete */
+	char firmware_name[25];
 
 
 	struct iwl_rxon_time_cmd rxon_timing;
-- 
1.6.3.3

