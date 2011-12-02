Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:13138 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757270Ab1LBRqS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Dec 2011 12:46:18 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Don Fry <donald.h.fry@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 15/16] iwlwifi: move ucode_type from iwl_priv to iwl_shared
Date: Fri,  2 Dec 2011 08:48:39 -0800
Message-Id: <1322844520-21149-16-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111202_184639_006649_C25F0B73)
In-Reply-To: <1322844520-21149-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1322844520-21149-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Don Fry <donald.h.fry@intel.com>

Move the ucode_type variable from the iwl_priv to the iwl_shared
structure with associated code changes.

Signed-off-by: Don Fry <donald.h.fry@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-debugfs.c       |    7 +++--
 drivers/net/wireless/iwlwifi/iwl-dev.h           |    1 -
 drivers/net/wireless/iwlwifi/iwl-shared.h        |   20 +++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-testmode.c      |    2 +-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c |   10 ++++----
 drivers/net/wireless/iwlwifi/iwl-trans.h         |    7 ------
 drivers/net/wireless/iwlwifi/iwl-ucode.c         |   25 +++++++++++----------
 7 files changed, 43 insertions(+), 29 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index 68b04f5..ccbcab4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -234,11 +234,12 @@ static ssize_t iwl_dbgfs_sram_read(struct file *file,
 
 	/* default is to dump the entire data segment */
 	if (!priv->dbgfs_sram_offset && !priv->dbgfs_sram_len) {
+		struct iwl_trans *trans = trans(priv);
 		priv->dbgfs_sram_offset = 0x800000;
-		if (priv->ucode_type == IWL_UCODE_INIT)
-			priv->dbgfs_sram_len = trans(priv)->ucode_init.data.len;
+		if (trans->shrd->ucode_type == IWL_UCODE_INIT)
+			priv->dbgfs_sram_len = trans->ucode_init.data.len;
 		else
-			priv->dbgfs_sram_len = trans(priv)->ucode_rt.data.len;
+			priv->dbgfs_sram_len = trans->ucode_rt.data.len;
 	}
 	len = priv->dbgfs_sram_len;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index cb24adb..0019a23 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -889,7 +889,6 @@ struct iwl_priv {
 	u32 ucode_ver;			/* version of ucode, copy of
 					   iwl_ucode.ver */
 
-	enum iwl_ucode_type ucode_type;
 	char firmware_name[25];
 
 	struct iwl_rxon_context contexts[NUM_IWL_RXON_CTX];
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index 47be77a..70bb9b8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -257,6 +257,23 @@ struct iwl_tid_data {
 };
 
 /**
+ * enum iwl_ucode_type
+ *
+ * The type of ucode currently loaded on the hardware.
+ *
+ * @IWL_UCODE_NONE: No ucode loaded
+ * @IWL_UCODE_REGULAR: Normal runtime ucode
+ * @IWL_UCODE_INIT: Initial ucode
+ * @IWL_UCODE_WOWLAN: Wake on Wireless enabled ucode
+ */
+enum iwl_ucode_type {
+	IWL_UCODE_NONE,
+	IWL_UCODE_REGULAR,
+	IWL_UCODE_INIT,
+	IWL_UCODE_WOWLAN,
+};
+
+/**
  * struct iwl_shared - shared fields for all the layers of the driver
  *
  * @dbg_level_dev: dbg level set per device. Prevails on
@@ -300,6 +317,9 @@ struct iwl_shared {
 	struct iwl_tid_data tid_data[IWLAGN_STATION_COUNT][IWL_MAX_TID_COUNT];
 
 	wait_queue_head_t wait_command_queue;
+
+	/* ucode related variables */
+	enum iwl_ucode_type ucode_type;
 };
 
 /*Whatever _m is (iwl_trans, iwl_priv, iwl_bus, these macros will work */
diff --git a/drivers/net/wireless/iwlwifi/iwl-testmode.c b/drivers/net/wireless/iwlwifi/iwl-testmode.c
index 3c97626..ed2a3d7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-testmode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-testmode.c
@@ -710,7 +710,7 @@ static int iwl_testmode_sram(struct ieee80211_hw *hw, struct nlattr **tb)
 		return -ENOMSG;
 	}
 	size = nla_get_u32(tb[IWL_TM_ATTR_SRAM_SIZE]);
-	switch (priv->ucode_type) {
+	switch (priv->shrd->ucode_type) {
 	case IWL_UCODE_REGULAR:
 		maxsize = trans(priv)->ucode_rt.data.len;
 		break;
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
index ee126f8..becd921 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
@@ -595,7 +595,7 @@ static void iwl_dump_nic_error_log(struct iwl_trans *trans)
 		IWL_TRANS_GET_PCIE_TRANS(trans);
 
 	base = priv->device_pointers.error_event_table;
-	if (priv->ucode_type == IWL_UCODE_INIT) {
+	if (trans->shrd->ucode_type == IWL_UCODE_INIT) {
 		if (!base)
 			base = priv->init_errlog_ptr;
 	} else {
@@ -607,7 +607,7 @@ static void iwl_dump_nic_error_log(struct iwl_trans *trans)
 		IWL_ERR(trans,
 			"Not valid error log pointer 0x%08X for %s uCode\n",
 			base,
-			(priv->ucode_type == IWL_UCODE_INIT)
+			(trans->shrd->ucode_type == IWL_UCODE_INIT)
 					? "Init" : "RT");
 		return;
 	}
@@ -710,7 +710,7 @@ static int iwl_print_event_log(struct iwl_trans *trans, u32 start_idx,
 		return pos;
 
 	base = priv->device_pointers.log_event_table;
-	if (priv->ucode_type == IWL_UCODE_INIT) {
+	if (trans->shrd->ucode_type == IWL_UCODE_INIT) {
 		if (!base)
 			base = priv->init_evtlog_ptr;
 	} else {
@@ -824,7 +824,7 @@ int iwl_dump_nic_event_log(struct iwl_trans *trans, bool full_log,
 	struct iwl_priv *priv = priv(trans);
 
 	base = priv->device_pointers.log_event_table;
-	if (priv->ucode_type == IWL_UCODE_INIT) {
+	if (trans->shrd->ucode_type == IWL_UCODE_INIT) {
 		logsize = priv->init_evtlog_size;
 		if (!base)
 			base = priv->init_evtlog_ptr;
@@ -838,7 +838,7 @@ int iwl_dump_nic_event_log(struct iwl_trans *trans, bool full_log,
 		IWL_ERR(trans,
 			"Invalid event log pointer 0x%08X for %s uCode\n",
 			base,
-			(priv->ucode_type == IWL_UCODE_INIT)
+			(trans->shrd->ucode_type == IWL_UCODE_INIT)
 					? "Init" : "RT");
 		return -EINVAL;
 	}
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 50227eb..4a29b8a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -220,13 +220,6 @@ struct fw_img {
 	struct fw_desc data;	/* firmware data image */
 };
 
-enum iwl_ucode_type {
-	IWL_UCODE_NONE,
-	IWL_UCODE_REGULAR,
-	IWL_UCODE_INIT,
-	IWL_UCODE_WOWLAN,
-};
-
 /**
  * struct iwl_trans - transport common data
  * @ops - pointer to iwl_trans_ops
diff --git a/drivers/net/wireless/iwlwifi/iwl-ucode.c b/drivers/net/wireless/iwlwifi/iwl-ucode.c
index 0da4b8e..1b23b99 100644
--- a/drivers/net/wireless/iwlwifi/iwl-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-ucode.c
@@ -579,27 +579,28 @@ int iwlagn_load_ucode_wait_alive(struct iwl_priv *priv,
 {
 	struct iwl_notification_wait alive_wait;
 	struct iwlagn_alive_data alive_data;
+	struct iwl_trans *trans = trans(priv);
 	int ret;
 	enum iwl_ucode_type old_type;
 
-	ret = iwl_trans_start_device(trans(priv));
+	ret = iwl_trans_start_device(trans);
 	if (ret)
 		return ret;
 
 	iwlagn_init_notification_wait(priv, &alive_wait, REPLY_ALIVE,
 				      iwl_alive_fn, &alive_data);
 
-	old_type = priv->ucode_type;
-	priv->ucode_type = ucode_type;
+	old_type = trans->shrd->ucode_type;
+	trans->shrd->ucode_type = ucode_type;
 
-	ret = iwl_load_given_ucode(trans(priv), ucode_type);
+	ret = iwl_load_given_ucode(trans, ucode_type);
 	if (ret) {
-		priv->ucode_type = old_type;
+		trans->shrd->ucode_type = old_type;
 		iwlagn_remove_notification(priv, &alive_wait);
 		return ret;
 	}
 
-	iwl_trans_kick_nic(trans(priv));
+	iwl_trans_kick_nic(trans);
 
 	/*
 	 * Some things may run in the background now, but we
@@ -607,13 +608,13 @@ int iwlagn_load_ucode_wait_alive(struct iwl_priv *priv,
 	 */
 	ret = iwlagn_wait_notification(priv, &alive_wait, UCODE_ALIVE_TIMEOUT);
 	if (ret) {
-		priv->ucode_type = old_type;
+		trans->shrd->ucode_type = old_type;
 		return ret;
 	}
 
 	if (!alive_data.valid) {
 		IWL_ERR(priv, "Loaded ucode is not valid!\n");
-		priv->ucode_type = old_type;
+		trans->shrd->ucode_type = old_type;
 		return -EIO;
 	}
 
@@ -623,9 +624,9 @@ int iwlagn_load_ucode_wait_alive(struct iwl_priv *priv,
 	 * skip it for WoWLAN.
 	 */
 	if (ucode_type != IWL_UCODE_WOWLAN) {
-		ret = iwl_verify_ucode(trans(priv), ucode_type);
+		ret = iwl_verify_ucode(trans, ucode_type);
 		if (ret) {
-			priv->ucode_type = old_type;
+			trans->shrd->ucode_type = old_type;
 			return ret;
 		}
 
@@ -637,7 +638,7 @@ int iwlagn_load_ucode_wait_alive(struct iwl_priv *priv,
 	if (ret) {
 		IWL_WARN(priv,
 			"Could not complete ALIVE transition: %d\n", ret);
-		priv->ucode_type = old_type;
+		trans->shrd->ucode_type = old_type;
 		return ret;
 	}
 
@@ -655,7 +656,7 @@ int iwlagn_run_init_ucode(struct iwl_priv *priv)
 	if (!trans(priv)->ucode_init.code.len)
 		return 0;
 
-	if (priv->ucode_type != IWL_UCODE_NONE)
+	if (priv->shrd->ucode_type != IWL_UCODE_NONE)
 		return 0;
 
 	iwlagn_init_notification_wait(priv, &calib_wait,
-- 
1.7.0.4

