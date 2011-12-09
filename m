Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:1214 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753966Ab1LIBZD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Dec 2011 20:25:03 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Don Fry <donald.h.fry@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 11/15] iwlwifi: move device_pointers from iwl_priv to iwl_shared
Date: Thu,  8 Dec 2011 16:26:18 -0800
Message-Id: <1323390382-1678-12-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111209_022512_304717_75788209)
In-Reply-To: <1323390382-1678-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1323390382-1678-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Don Fry <donald.h.fry@intel.com>

Move the low level ucode device_pointers structure to iwl_shared.

Signed-off-by: Don Fry <donald.h.fry@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rx.c        |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c           |    2 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h           |    5 -----
 drivers/net/wireless/iwlwifi/iwl-mac80211.c      |    2 +-
 drivers/net/wireless/iwlwifi/iwl-shared.h        |   12 ++++++++++--
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c |    6 +++---
 drivers/net/wireless/iwlwifi/iwl-ucode.c         |   10 +++++-----
 7 files changed, 21 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rx.c b/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
index 90c55ea..9001c23 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
@@ -1165,7 +1165,7 @@ int iwl_rx_dispatch(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb,
 				pkt->hdr.cmd);
 			w->triggered = true;
 			if (w->fn)
-				w->fn(priv, pkt, w->fn_data);
+				w->fn(trans(priv), pkt, w->fn_data);
 		}
 		spin_unlock(&priv->shrd->notif_wait_lock);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 6b99448..02927fa 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -366,7 +366,7 @@ static void iwl_continuous_event_trace(struct iwl_priv *priv)
 	u32 num_wraps;  /* # times uCode wrapped to top of log */
 	u32 next_entry; /* index of next entry to be written by uCode */
 
-	base = priv->device_pointers.error_event_table;
+	base = priv->shrd->device_pointers.error_event_table;
 	if (iwlagn_hw_valid_rtc_data_addr(base)) {
 		capacity = iwl_read_targ_mem(bus(priv), base);
 		num_wraps = iwl_read_targ_mem(bus(priv),
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 68f9dc5..aa225be 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -865,11 +865,6 @@ struct iwl_priv {
 
 	__le16 switch_channel;
 
-	struct {
-		u32 error_event_table;
-		u32 log_event_table;
-	} device_pointers;
-
 	u16 active_rate;
 
 	u8 start_calib;
diff --git a/drivers/net/wireless/iwlwifi/iwl-mac80211.c b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
index 2dd536c..b3886d2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-mac80211.c
+++ b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
@@ -427,7 +427,7 @@ static int iwlagn_mac_resume(struct ieee80211_hw *hw)
 	iwl_write32(bus(priv), CSR_UCODE_DRV_GP1_CLR,
 			  CSR_UCODE_DRV_GP1_BIT_D3_CFG_COMPLETE);
 
-	base = priv->device_pointers.error_event_table;
+	base = priv->shrd->device_pointers.error_event_table;
 	if (iwlagn_hw_valid_rtc_data_addr(base)) {
 		spin_lock_irqsave(&bus(priv)->reg_lock, flags);
 		ret = iwl_grab_nic_access_silent(bus(priv));
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index 53cddd3..29a7284 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -97,6 +97,7 @@
 struct iwl_cfg;
 struct iwl_bus;
 struct iwl_priv;
+struct iwl_trans;
 struct iwl_sensitivity_ranges;
 struct iwl_trans_ops;
 
@@ -294,7 +295,7 @@ enum iwl_ucode_type {
 struct iwl_notification_wait {
 	struct list_head list;
 
-	void (*fn)(struct iwl_priv *priv, struct iwl_rx_packet *pkt,
+	void (*fn)(struct iwl_trans *trans, struct iwl_rx_packet *pkt,
 		   void *data);
 	void *fn_data;
 
@@ -323,6 +324,7 @@ struct iwl_notification_wait {
  * @notif_waits: things waiting for notification
  * @notif_wait_lock: lock protecting notification
  * @notif_waitq: head of notification wait queue
+ * @device_pointers: pointers to ucode event tables
  */
 struct iwl_shared {
 #ifdef CONFIG_IWLWIFI_DEBUG
@@ -361,6 +363,12 @@ struct iwl_shared {
 	struct list_head notif_waits;
 	spinlock_t notif_wait_lock;
 	wait_queue_head_t notif_waitq;
+
+	struct {
+		u32 error_event_table;
+		u32 log_event_table;
+	} device_pointers;
+
 };
 
 /*Whatever _m is (iwl_trans, iwl_priv, iwl_bus, these macros will work */
@@ -510,7 +518,7 @@ void __acquires(wait_entry)
 iwl_init_notification_wait(struct iwl_shared *shrd,
 			      struct iwl_notification_wait *wait_entry,
 			      u8 cmd,
-			      void (*fn)(struct iwl_priv *priv,
+			      void (*fn)(struct iwl_trans *trans,
 					 struct iwl_rx_packet *pkt,
 					 void *data),
 			      void *fn_data);
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
index a0d43d6..2ee00e0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
@@ -594,7 +594,7 @@ static void iwl_dump_nic_error_log(struct iwl_trans *trans)
 	struct iwl_trans_pcie *trans_pcie =
 		IWL_TRANS_GET_PCIE_TRANS(trans);
 
-	base = priv->device_pointers.error_event_table;
+	base = trans->shrd->device_pointers.error_event_table;
 	if (trans->shrd->ucode_type == IWL_UCODE_INIT) {
 		if (!base)
 			base = priv->init_errlog_ptr;
@@ -724,7 +724,7 @@ static int iwl_print_event_log(struct iwl_trans *trans, u32 start_idx,
 	if (num_events == 0)
 		return pos;
 
-	base = priv->device_pointers.log_event_table;
+	base = trans->shrd->device_pointers.log_event_table;
 	if (trans->shrd->ucode_type == IWL_UCODE_INIT) {
 		if (!base)
 			base = priv->init_evtlog_ptr;
@@ -838,7 +838,7 @@ int iwl_dump_nic_event_log(struct iwl_trans *trans, bool full_log,
 	size_t bufsz = 0;
 	struct iwl_priv *priv = priv(trans);
 
-	base = priv->device_pointers.log_event_table;
+	base = trans->shrd->device_pointers.log_event_table;
 	if (trans->shrd->ucode_type == IWL_UCODE_INIT) {
 		logsize = priv->init_evtlog_size;
 		if (!base)
diff --git a/drivers/net/wireless/iwlwifi/iwl-ucode.c b/drivers/net/wireless/iwlwifi/iwl-ucode.c
index f560669..256f647 100644
--- a/drivers/net/wireless/iwlwifi/iwl-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-ucode.c
@@ -550,7 +550,7 @@ struct iwlagn_alive_data {
 	u8 subtype;
 };
 
-static void iwl_alive_fn(struct iwl_priv *priv,
+static void iwl_alive_fn(struct iwl_trans *trans,
 			    struct iwl_rx_packet *pkt,
 			    void *data)
 {
@@ -559,14 +559,14 @@ static void iwl_alive_fn(struct iwl_priv *priv,
 
 	palive = &pkt->u.alive_frame;
 
-	IWL_DEBUG_FW(priv, "Alive ucode status 0x%08X revision "
+	IWL_DEBUG_FW(trans, "Alive ucode status 0x%08X revision "
 		       "0x%01X 0x%01X\n",
 		       palive->is_valid, palive->ver_type,
 		       palive->ver_subtype);
 
-	priv->device_pointers.error_event_table =
+	trans->shrd->device_pointers.error_event_table =
 		le32_to_cpu(palive->error_event_table_ptr);
-	priv->device_pointers.log_event_table =
+	trans->shrd->device_pointers.log_event_table =
 		le32_to_cpu(palive->log_event_table_ptr);
 
 	alive_data->subtype = palive->ver_subtype;
@@ -577,7 +577,7 @@ static void iwl_alive_fn(struct iwl_priv *priv,
 void iwl_init_notification_wait(struct iwl_shared *shrd,
 				   struct iwl_notification_wait *wait_entry,
 				   u8 cmd,
-				   void (*fn)(struct iwl_priv *priv,
+				   void (*fn)(struct iwl_trans *trans,
 					      struct iwl_rx_packet *pkt,
 					      void *data),
 				   void *fn_data)
-- 
1.7.0.4

