Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:45464 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758572Ab1FKOzl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Jun 2011 10:55:41 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 06/18] iwlagn: don't check ucode subtype
Date: Sat, 11 Jun 2011 07:25:40 -0700
Message-Id: <1307802352-16398-7-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110611_165608_710414_6CCFDB9C)
In-Reply-To: <1307802352-16398-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1307802352-16398-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The ucode subtypes keep changing, and there's no
particular reason to be checking them (other than
a paranoid sanity check). Since the numbers are
also in conflict between different ucode images
now, simply don't check them any more and rely on
the images being built correctly.

Also, to indicate that, rename the constants and
the enum, moving it to a different file.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c |   19 +++++--------------
 drivers/net/wireless/iwlwifi/iwl-agn.c       |   15 ++++++---------
 drivers/net/wireless/iwlwifi/iwl-agn.h       |    2 +-
 drivers/net/wireless/iwlwifi/iwl-commands.h  |   12 ------------
 drivers/net/wireless/iwlwifi/iwl-debugfs.c   |    2 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h       |    9 ++++++++-
 drivers/net/wireless/iwlwifi/iwl-sv-open.c   |    5 ++---
 7 files changed, 23 insertions(+), 41 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
index 97de5d9..a5cb1f6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
@@ -602,12 +602,12 @@ static void iwlagn_alive_fn(struct iwl_priv *priv,
 
 int iwlagn_load_ucode_wait_alive(struct iwl_priv *priv,
 				 struct fw_img *image,
-				 int subtype, int alternate_subtype)
+				 enum iwlagn_ucode_type ucode_type)
 {
 	struct iwl_notification_wait alive_wait;
 	struct iwlagn_alive_data alive_data;
 	int ret;
-	enum iwlagn_ucode_subtype old_type;
+	enum iwlagn_ucode_type old_type;
 
 	ret = iwlagn_start_device(priv);
 	if (ret)
@@ -617,7 +617,7 @@ int iwlagn_load_ucode_wait_alive(struct iwl_priv *priv,
 				      iwlagn_alive_fn, &alive_data);
 
 	old_type = priv->ucode_type;
-	priv->ucode_type = subtype;
+	priv->ucode_type = ucode_type;
 
 	ret = iwlagn_load_given_ucode(priv, image);
 	if (ret) {
@@ -645,15 +645,6 @@ int iwlagn_load_ucode_wait_alive(struct iwl_priv *priv,
 		return -EIO;
 	}
 
-	if (alive_data.subtype != subtype &&
-	    alive_data.subtype != alternate_subtype) {
-		IWL_ERR(priv,
-			"Loaded ucode is not expected type (got %d, expected %d)!\n",
-			alive_data.subtype, subtype);
-		priv->ucode_type = old_type;
-		return -EIO;
-	}
-
 	ret = iwl_verify_ucode(priv, image);
 	if (ret) {
 		priv->ucode_type = old_type;
@@ -685,7 +676,7 @@ int iwlagn_run_init_ucode(struct iwl_priv *priv)
 	if (!priv->ucode_init.code.len)
 		return 0;
 
-	if (priv->ucode_type != UCODE_SUBTYPE_NONE_LOADED)
+	if (priv->ucode_type != IWL_UCODE_NONE)
 		return 0;
 
 	iwlagn_init_notification_wait(priv, &calib_wait,
@@ -694,7 +685,7 @@ int iwlagn_run_init_ucode(struct iwl_priv *priv)
 
 	/* Will also start the device */
 	ret = iwlagn_load_ucode_wait_alive(priv, &priv->ucode_init,
-					   UCODE_SUBTYPE_INIT, -1);
+					   IWL_UCODE_INIT);
 	if (ret)
 		goto error;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 8bed315..3cd42a5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1626,7 +1626,7 @@ void iwl_dump_nic_error_log(struct iwl_priv *priv)
 	struct iwl_error_event_table table;
 
 	base = priv->device_pointers.error_event_table;
-	if (priv->ucode_type == UCODE_SUBTYPE_INIT) {
+	if (priv->ucode_type == IWL_UCODE_INIT) {
 		if (!base)
 			base = priv->_agn.init_errlog_ptr;
 	} else {
@@ -1638,7 +1638,7 @@ void iwl_dump_nic_error_log(struct iwl_priv *priv)
 		IWL_ERR(priv,
 			"Not valid error log pointer 0x%08X for %s uCode\n",
 			base,
-			(priv->ucode_type == UCODE_SUBTYPE_INIT)
+			(priv->ucode_type == IWL_UCODE_INIT)
 					? "Init" : "RT");
 		return;
 	}
@@ -1702,7 +1702,7 @@ static int iwl_print_event_log(struct iwl_priv *priv, u32 start_idx,
 		return pos;
 
 	base = priv->device_pointers.log_event_table;
-	if (priv->ucode_type == UCODE_SUBTYPE_INIT) {
+	if (priv->ucode_type == IWL_UCODE_INIT) {
 		if (!base)
 			base = priv->_agn.init_evtlog_ptr;
 	} else {
@@ -1815,7 +1815,7 @@ int iwl_dump_nic_event_log(struct iwl_priv *priv, bool full_log,
 	size_t bufsz = 0;
 
 	base = priv->device_pointers.log_event_table;
-	if (priv->ucode_type == UCODE_SUBTYPE_INIT) {
+	if (priv->ucode_type == IWL_UCODE_INIT) {
 		logsize = priv->_agn.init_evtlog_size;
 		if (!base)
 			base = priv->_agn.init_evtlog_ptr;
@@ -1829,7 +1829,7 @@ int iwl_dump_nic_event_log(struct iwl_priv *priv, bool full_log,
 		IWL_ERR(priv,
 			"Invalid event log pointer 0x%08X for %s uCode\n",
 			base,
-			(priv->ucode_type == UCODE_SUBTYPE_INIT)
+			(priv->ucode_type == IWL_UCODE_INIT)
 					? "Init" : "RT");
 		return -EINVAL;
 	}
@@ -2210,8 +2210,7 @@ static int __iwl_up(struct iwl_priv *priv)
 
 	ret = iwlagn_load_ucode_wait_alive(priv,
 					   &priv->ucode_rt,
-					   UCODE_SUBTYPE_REGULAR,
-					   UCODE_SUBTYPE_REGULAR_NEW);
+					   IWL_UCODE_REGULAR);
 	if (ret) {
 		IWL_ERR(priv, "Failed to start RT ucode: %d\n", ret);
 		goto error;
@@ -3448,8 +3447,6 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	priv = hw->priv;
 	/* At this point both hw and priv are allocated. */
 
-	priv->ucode_type = UCODE_SUBTYPE_NONE_LOADED;
-
 	/*
 	 * The default context is always valid,
 	 * more may be discovered when firmware
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index d074e6c..94ee141 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -161,7 +161,7 @@ void iwlagn_send_prio_tbl(struct iwl_priv *priv);
 int iwlagn_run_init_ucode(struct iwl_priv *priv);
 int iwlagn_load_ucode_wait_alive(struct iwl_priv *priv,
 				 struct fw_img *image,
-				 int subtype, int alternate_subtype);
+				 enum iwlagn_ucode_type ucode_type);
 
 /* lib */
 void iwl_check_abort_status(struct iwl_priv *priv,
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 6ee5f1a..8dcb210 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -384,18 +384,6 @@ struct iwl_tx_ant_config_cmd {
 
 #define UCODE_VALID_OK	cpu_to_le32(0x1)
 
-enum iwlagn_ucode_subtype {
-	UCODE_SUBTYPE_REGULAR	= 0,
-	UCODE_SUBTYPE_REGULAR_NEW = 1,
-	UCODE_SUBTYPE_INIT	= 9,
-
-	/*
-	 * Not a valid subtype, the ucode has just a u8, so
-	 * we can use something > 0xff for this value.
-	 */
-	UCODE_SUBTYPE_NONE_LOADED = 0x100,
-};
-
 /**
  * REPLY_ALIVE = 0x1 (response only, not a command)
  *
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index 0e6a04b..5f335c7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -227,7 +227,7 @@ static ssize_t iwl_dbgfs_sram_read(struct file *file,
 	/* default is to dump the entire data segment */
 	if (!priv->dbgfs_sram_offset && !priv->dbgfs_sram_len) {
 		priv->dbgfs_sram_offset = 0x800000;
-		if (priv->ucode_type == UCODE_SUBTYPE_INIT)
+		if (priv->ucode_type == IWL_UCODE_INIT)
 			priv->dbgfs_sram_len = priv->ucode_init.data.len;
 		else
 			priv->dbgfs_sram_len = priv->ucode_rt.data.len;
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index d23430e..ffed302 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1168,6 +1168,13 @@ enum iwl_scan_type {
 	IWL_SCAN_OFFCH_TX,
 };
 
+enum iwlagn_ucode_type {
+	IWL_UCODE_NONE,
+	IWL_UCODE_REGULAR,
+	IWL_UCODE_INIT,
+	IWL_UCODE_WOWLAN,
+};
+
 #ifdef CONFIG_IWLWIFI_DEVICE_SVTOOL
 struct iwl_testmode_trace {
 	u32 buff_size;
@@ -1273,7 +1280,7 @@ struct iwl_priv {
 	struct fw_img ucode_rt;
 	struct fw_img ucode_init;
 
-	enum iwlagn_ucode_subtype ucode_type;
+	enum iwlagn_ucode_type ucode_type;
 	u8 ucode_write_complete;	/* the image write is complete */
 	char firmware_name[25];
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-sv-open.c b/drivers/net/wireless/iwlwifi/iwl-sv-open.c
index 038c696..6f62642 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sv-open.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sv-open.c
@@ -397,7 +397,7 @@ static int iwl_testmode_driver(struct ieee80211_hw *hw, struct nlattr **tb)
 
 	case IWL_TM_CMD_APP2DEV_LOAD_INIT_FW:
 		status = iwlagn_load_ucode_wait_alive(priv, &priv->ucode_init,
-					   UCODE_SUBTYPE_INIT, -1);
+						      IWL_UCODE_INIT);
 		if (status)
 			IWL_DEBUG_INFO(priv,
 				"Error loading init ucode: %d\n", status);
@@ -411,8 +411,7 @@ static int iwl_testmode_driver(struct ieee80211_hw *hw, struct nlattr **tb)
 	case IWL_TM_CMD_APP2DEV_LOAD_RUNTIME_FW:
 		status = iwlagn_load_ucode_wait_alive(priv,
 					   &priv->ucode_rt,
-					   UCODE_SUBTYPE_REGULAR,
-					   UCODE_SUBTYPE_REGULAR_NEW);
+					   IWL_UCODE_REGULAR);
 		if (status) {
 			IWL_DEBUG_INFO(priv,
 				"Error loading runtime ucode: %d\n", status);
-- 
1.7.0.4

