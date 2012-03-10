Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:15620 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752099Ab2CJU72 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Mar 2012 15:59:28 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	David Spinadel <david.spinadel@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 05/10] iwlwifi: avoid some operations if no uCode loaded
Date: Sat, 10 Mar 2012 13:00:10 -0800
Message-Id: <1331413215-10027-6-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120310_215959_998787_FC84D9B6)
In-Reply-To: <1331413215-10027-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1331413215-10027-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Spinadel <david.spinadel@intel.com>

Printing the SRAM and similar testmode operations could
be triggered when no uCode is loaded; prevent those
invalid operations by tracking whether uCode is loaded.

Signed-off-by: David Spinadel <david.spinadel@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c  |    1 +
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    2 +
 drivers/net/wireless/iwlwifi/iwl-core.c     |    3 ++
 drivers/net/wireless/iwlwifi/iwl-debugfs.c  |   15 +++++++++-
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    1 +
 drivers/net/wireless/iwlwifi/iwl-testmode.c |   40 +++++++++++++++------------
 drivers/net/wireless/iwlwifi/iwl-ucode.c    |    6 ++++
 7 files changed, 48 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 915183a..3e1698d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -1189,6 +1189,7 @@ int iwlagn_suspend(struct iwl_priv *priv, struct cfg80211_wowlan *wowlan)
 
 	memcpy(&rxon, &ctx->active, sizeof(rxon));
 
+	priv->ucode_loaded = false;
 	iwl_trans_stop_device(trans(priv));
 
 	priv->wowlan = true;
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 66d7446..f1226db 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -816,6 +816,7 @@ void iwl_down(struct iwl_priv *priv)
 	if (priv->mac80211_registered)
 		ieee80211_stop_queues(priv->hw);
 
+	priv->ucode_loaded = false;
 	iwl_trans_stop_device(trans(priv));
 
 	/* Clear out all status bits but a few that are stable across reset */
@@ -1406,6 +1407,7 @@ static void iwl_op_mode_dvm_stop(struct iwl_op_mode *op_mode)
 	iwl_tt_exit(priv);
 
 	/*This will stop the queues, move the device to low power state */
+	priv->ucode_loaded = false;
 	iwl_trans_stop_device(trans(priv));
 
 	iwl_eeprom_free(priv->shrd);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index e3eda50..46490d3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -838,6 +838,9 @@ static void iwlagn_fw_error(struct iwl_priv *priv, bool ondemand)
 		iwl_print_rx_config_cmd(priv, IWL_RXON_CTX_BSS);
 #endif
 
+	/* uCode is no longer loaded. */
+	priv->ucode_loaded = false;
+
 	/* Set the FW error flag -- cleared on iwl_down */
 	set_bit(STATUS_FW_ERROR, &priv->shrd->status);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index 9b71c87..89cb9a7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -235,10 +235,21 @@ static ssize_t iwl_dbgfs_sram_read(struct file *file,
 	/* default is to dump the entire data segment */
 	if (!priv->dbgfs_sram_offset && !priv->dbgfs_sram_len) {
 		priv->dbgfs_sram_offset = 0x800000;
-		if (priv->shrd->ucode_type == IWL_UCODE_INIT)
+		if (!priv->ucode_loaded) {
+			IWL_ERR(priv, "No uCode has been loadded.\n");
+			return -EINVAL;
+		}
+		if (priv->shrd->ucode_type == IWL_UCODE_INIT) {
 			priv->dbgfs_sram_len = priv->fw->ucode_init.data.len;
-		else
+		} else if (priv->shrd->ucode_type == IWL_UCODE_REGULAR) {
 			priv->dbgfs_sram_len = priv->fw->ucode_rt.data.len;
+		} else if (priv->shrd->ucode_type == IWL_UCODE_WOWLAN) {
+			priv->dbgfs_sram_len = priv->fw->ucode_wowlan.data.len;
+		} else {
+			IWL_ERR(priv, "Unsupported type of uCode loaded?"
+					" that shouldn't happen.\n");
+			return -EINVAL;
+		}
 	}
 	len = priv->dbgfs_sram_len;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index aa4b3b1..01dbe11 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -769,6 +769,7 @@ struct iwl_priv {
 	/* firmware reload counter and timestamp */
 	unsigned long reload_jiffies;
 	int reload_count;
+	bool ucode_loaded;
 
 	/* we allocate array of iwl_channel_info for NIC's valid channels.
 	 *    Access via channel # using indirect index array */
diff --git a/drivers/net/wireless/iwlwifi/iwl-testmode.c b/drivers/net/wireless/iwlwifi/iwl-testmode.c
index b06c676..c6c084f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-testmode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-testmode.c
@@ -494,6 +494,7 @@ static int iwl_testmode_driver(struct ieee80211_hw *hw, struct nlattr **tb)
 
 	case IWL_TM_CMD_APP2DEV_CFG_INIT_CALIB:
 		iwl_testmode_cfg_init_calib(priv);
+		priv->ucode_loaded = false;
 		iwl_trans_stop_device(trans);
 		break;
 
@@ -512,6 +513,7 @@ static int iwl_testmode_driver(struct ieee80211_hw *hw, struct nlattr **tb)
 
 	case IWL_TM_CMD_APP2DEV_LOAD_WOWLAN_FW:
 		iwl_scan_cancel_timeout(priv, 200);
+		priv->ucode_loaded = false;
 		iwl_trans_stop_device(trans);
 		status = iwl_load_ucode_wait_alive(priv, IWL_UCODE_WOWLAN);
 		if (status) {
@@ -591,25 +593,27 @@ static int iwl_testmode_driver(struct ieee80211_hw *hw, struct nlattr **tb)
 			IWL_ERR(priv, "Memory allocation fail\n");
 			return -ENOMEM;
 		}
-		switch (priv->shrd->ucode_type) {
-		case IWL_UCODE_REGULAR:
-			inst_size = priv->fw->ucode_rt.code.len;
-			data_size = priv->fw->ucode_rt.data.len;
-			break;
-		case IWL_UCODE_INIT:
-			inst_size = priv->fw->ucode_init.code.len;
-			data_size = priv->fw->ucode_init.data.len;
-			break;
-		case IWL_UCODE_WOWLAN:
-			inst_size = priv->fw->ucode_wowlan.code.len;
-			data_size = priv->fw->ucode_wowlan.data.len;
-			break;
-		case IWL_UCODE_NONE:
+		if (!priv->ucode_loaded) {
 			IWL_ERR(priv, "No uCode has not been loaded\n");
-			break;
-		default:
-			IWL_ERR(priv, "Unsupported uCode type\n");
-			break;
+			return -EINVAL;
+		} else {
+			switch (priv->shrd->ucode_type) {
+			case IWL_UCODE_REGULAR:
+				inst_size = priv->fw->ucode_rt.code.len;
+				data_size = priv->fw->ucode_rt.data.len;
+				break;
+			case IWL_UCODE_INIT:
+				inst_size = priv->fw->ucode_init.code.len;
+				data_size = priv->fw->ucode_init.data.len;
+				break;
+			case IWL_UCODE_WOWLAN:
+				inst_size = priv->fw->ucode_wowlan.code.len;
+				data_size = priv->fw->ucode_wowlan.data.len;
+				break;
+			default:
+				IWL_ERR(priv, "Unsupported uCode type\n");
+				break;
+			}
 		}
 		NLA_PUT_U32(skb, IWL_TM_ATTR_FW_TYPE, priv->shrd->ucode_type);
 		NLA_PUT_U32(skb, IWL_TM_ATTR_FW_INST_SIZE, inst_size);
diff --git a/drivers/net/wireless/iwlwifi/iwl-ucode.c b/drivers/net/wireless/iwlwifi/iwl-ucode.c
index d97cf44..ae935c0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-ucode.c
@@ -465,6 +465,8 @@ int iwl_load_ucode_wait_alive(struct iwl_priv *priv,
 	priv->shrd->ucode_type = ucode_type;
 	fw = iwl_get_ucode_image(priv, ucode_type);
 
+	priv->ucode_loaded = false;
+
 	if (!fw)
 		return -EINVAL;
 
@@ -519,6 +521,8 @@ int iwl_load_ucode_wait_alive(struct iwl_priv *priv,
 		return ret;
 	}
 
+	priv->ucode_loaded = true;
+
 	return 0;
 }
 
@@ -563,5 +567,7 @@ int iwl_run_init_ucode(struct iwl_priv *priv)
  out:
 	/* Whatever happened, stop the device */
 	iwl_trans_stop_device(trans(priv));
+	priv->ucode_loaded = false;
+
 	return ret;
 }
-- 
1.7.0.4

