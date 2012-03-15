Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:21182 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161453Ab2COU2H (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Mar 2012 16:28:07 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 17/26] iwlwifi: move ucode_type from shared to op_mode
Date: Thu, 15 Mar 2012 13:26:57 -0700
Message-Id: <1331843226-29860-18-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120315_212829_202891_A14B6DB9)
In-Reply-To: <1331843226-29860-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1331843226-29860-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>

This variable holds the ucode currently
running on the device; which is determined by
op_mode, so move this parameter there.

Also, the name of the variable is a bit
misleading, so rename it to cur_ucode.

Signed-off-by: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   10 +++++-----
 drivers/net/wireless/iwlwifi/iwl-debugfs.c  |    2 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    3 +++
 drivers/net/wireless/iwlwifi/iwl-shared.h   |    4 ----
 drivers/net/wireless/iwlwifi/iwl-testmode.c |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-ucode.c    |   14 +++++++-------
 6 files changed, 18 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index ce41437..3476130 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1632,7 +1632,7 @@ static void iwl_dump_nic_error_log(struct iwl_priv *priv)
 	struct iwl_error_event_table table;
 
 	base = priv->device_pointers.error_event_table;
-	if (priv->shrd->ucode_type == IWL_UCODE_INIT) {
+	if (priv->cur_ucode == IWL_UCODE_INIT) {
 		if (!base)
 			base = priv->shrd->fw->init_errlog_ptr;
 	} else {
@@ -1644,7 +1644,7 @@ static void iwl_dump_nic_error_log(struct iwl_priv *priv)
 		IWL_ERR(priv,
 			"Not valid error log pointer 0x%08X for %s uCode\n",
 			base,
-			(priv->shrd->ucode_type == IWL_UCODE_INIT)
+			(priv->cur_ucode == IWL_UCODE_INIT)
 					? "Init" : "RT");
 		return;
 	}
@@ -1723,7 +1723,7 @@ static int iwl_print_event_log(struct iwl_priv *priv, u32 start_idx,
 		return pos;
 
 	base = priv->device_pointers.log_event_table;
-	if (priv->shrd->ucode_type == IWL_UCODE_INIT) {
+	if (priv->cur_ucode == IWL_UCODE_INIT) {
 		if (!base)
 			base = priv->shrd->fw->init_evtlog_ptr;
 	} else {
@@ -1838,7 +1838,7 @@ int iwl_dump_nic_event_log(struct iwl_priv *priv, bool full_log,
 	struct iwl_trans *trans = trans(priv);
 
 	base = priv->device_pointers.log_event_table;
-	if (priv->shrd->ucode_type == IWL_UCODE_INIT) {
+	if (priv->cur_ucode == IWL_UCODE_INIT) {
 		logsize = priv->shrd->fw->init_evtlog_size;
 		if (!base)
 			base = priv->shrd->fw->init_evtlog_ptr;
@@ -1852,7 +1852,7 @@ int iwl_dump_nic_event_log(struct iwl_priv *priv, bool full_log,
 		IWL_ERR(priv,
 			"Invalid event log pointer 0x%08X for %s uCode\n",
 			base,
-			(priv->shrd->ucode_type == IWL_UCODE_INIT)
+			(priv->cur_ucode == IWL_UCODE_INIT)
 					? "Init" : "RT");
 		return -EINVAL;
 	}
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index d4b51a5..a2baf17 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -240,7 +240,7 @@ static ssize_t iwl_dbgfs_sram_read(struct file *file,
 			IWL_ERR(priv, "No uCode has been loadded.\n");
 			return -EINVAL;
 		}
-		img = &priv->fw->img[priv->shrd->ucode_type];
+		img = &priv->fw->img[priv->cur_ucode];
 		priv->dbgfs_sram_len = img->sec[IWL_UCODE_SECTION_DATA].len;
 	}
 	len = priv->dbgfs_sram_len;
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 2f54c9b..99be589 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -997,6 +997,9 @@ struct iwl_priv {
 		u32 error_event_table;
 		u32 log_event_table;
 	} device_pointers;
+
+	/* indicator of loaded ucode image */
+	enum iwl_ucode_type cur_ucode;
 }; /*iwl_priv */
 
 extern struct kmem_cache *iwl_tx_cmd_pool;
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index ef3f0b9..90f464e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -346,7 +346,6 @@ struct iwl_cfg {
  * @hw_params: see struct iwl_hw_params
  * @lock: protect general shared data
  * @eeprom: pointer to the eeprom/OTP image
- * @ucode_type: indicator of loaded ucode image
  */
 struct iwl_shared {
 	unsigned long status;
@@ -360,9 +359,6 @@ struct iwl_shared {
 	/* eeprom -- this is in the card's little endian byte order */
 	u8 *eeprom;
 
-	/* ucode related variables */
-	enum iwl_ucode_type ucode_type;
-
 };
 
 /*Whatever _m is (iwl_trans, iwl_priv, these macros will work */
diff --git a/drivers/net/wireless/iwlwifi/iwl-testmode.c b/drivers/net/wireless/iwlwifi/iwl-testmode.c
index 645b850..d65dac8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-testmode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-testmode.c
@@ -601,11 +601,11 @@ static int iwl_testmode_driver(struct ieee80211_hw *hw, struct nlattr **tb)
 			IWL_ERR(priv, "No uCode has not been loaded\n");
 			return -EINVAL;
 		} else {
-			img = &priv->fw->img[priv->shrd->ucode_type];
+			img = &priv->fw->img[priv->cur_ucode];
 			inst_size = img->sec[IWL_UCODE_SECTION_INST].len;
 			data_size = img->sec[IWL_UCODE_SECTION_DATA].len;
 		}
-		NLA_PUT_U32(skb, IWL_TM_ATTR_FW_TYPE, priv->shrd->ucode_type);
+		NLA_PUT_U32(skb, IWL_TM_ATTR_FW_TYPE, priv->cur_ucode);
 		NLA_PUT_U32(skb, IWL_TM_ATTR_FW_INST_SIZE, inst_size);
 		NLA_PUT_U32(skb, IWL_TM_ATTR_FW_DATA_SIZE, data_size);
 		status = cfg80211_testmode_reply(skb);
diff --git a/drivers/net/wireless/iwlwifi/iwl-ucode.c b/drivers/net/wireless/iwlwifi/iwl-ucode.c
index 993f1a3..ba7c9f8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-ucode.c
@@ -391,8 +391,8 @@ int iwl_load_ucode_wait_alive(struct iwl_priv *priv,
 	enum iwl_ucode_type old_type;
 	static const u8 alive_cmd[] = { REPLY_ALIVE };
 
-	old_type = priv->shrd->ucode_type;
-	priv->shrd->ucode_type = ucode_type;
+	old_type = priv->cur_ucode;
+	priv->cur_ucode = ucode_type;
 	fw = iwl_get_ucode_image(priv, ucode_type);
 
 	priv->ucode_loaded = false;
@@ -406,7 +406,7 @@ int iwl_load_ucode_wait_alive(struct iwl_priv *priv,
 
 	ret = iwl_trans_start_fw(trans(priv), fw);
 	if (ret) {
-		priv->shrd->ucode_type = old_type;
+		priv->cur_ucode = old_type;
 		iwl_remove_notification(&priv->notif_wait, &alive_wait);
 		return ret;
 	}
@@ -418,13 +418,13 @@ int iwl_load_ucode_wait_alive(struct iwl_priv *priv,
 	ret = iwl_wait_notification(&priv->notif_wait, &alive_wait,
 					UCODE_ALIVE_TIMEOUT);
 	if (ret) {
-		priv->shrd->ucode_type = old_type;
+		priv->cur_ucode = old_type;
 		return ret;
 	}
 
 	if (!alive_data.valid) {
 		IWL_ERR(priv, "Loaded ucode is not valid!\n");
-		priv->shrd->ucode_type = old_type;
+		priv->cur_ucode = old_type;
 		return -EIO;
 	}
 
@@ -436,7 +436,7 @@ int iwl_load_ucode_wait_alive(struct iwl_priv *priv,
 	if (ucode_type != IWL_UCODE_WOWLAN) {
 		ret = iwl_verify_ucode(priv, ucode_type);
 		if (ret) {
-			priv->shrd->ucode_type = old_type;
+			priv->cur_ucode = old_type;
 			return ret;
 		}
 
@@ -448,7 +448,7 @@ int iwl_load_ucode_wait_alive(struct iwl_priv *priv,
 	if (ret) {
 		IWL_WARN(priv,
 			"Could not complete ALIVE transition: %d\n", ret);
-		priv->shrd->ucode_type = old_type;
+		priv->cur_ucode = old_type;
 		return ret;
 	}
 
-- 
1.7.0.4

