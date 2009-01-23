Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:34241 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756095AbZAWVm4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 16:42:56 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Samuel Ortiz <samuel.ortiz@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 12/15] iwl3945: Remaining host command cleanups
Date: Fri, 23 Jan 2009 13:45:20 -0800
Message-Id: <1232747123-7261-13-git-send-email-reinette.chatre@intel.com> (sfid-20090123_230907_296528_BE2E8B6C)
In-Reply-To: <1232747123-7261-12-git-send-email-reinette.chatre@intel.com>
References: <>
 <1232747123-7261-1-git-send-email-reinette.chatre@intel.com>
 <1232747123-7261-2-git-send-email-reinette.chatre@intel.com>
 <1232747123-7261-3-git-send-email-reinette.chatre@intel.com>
 <1232747123-7261-4-git-send-email-reinette.chatre@intel.com>
 <1232747123-7261-5-git-send-email-reinette.chatre@intel.com>
 <1232747123-7261-6-git-send-email-reinette.chatre@intel.com>
 <1232747123-7261-7-git-send-email-reinette.chatre@intel.com>
 <1232747123-7261-8-git-send-email-reinette.chatre@intel.com>
 <1232747123-7261-9-git-send-email-reinette.chatre@intel.com>
 <1232747123-7261-10-git-send-email-reinette.chatre@intel.com>
 <1232747123-7261-11-git-send-email-reinette.chatre@intel.com>
 <1232747123-7261-12-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Samuel Ortiz <samuel.ortiz@intel.com>

With the recent host command routines merge, we can now look at the various
host command helpers and get rid of the duplicated ones.

Signed-off-by: Samuel Ortiz <samuel.ortiz@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c     |   12 +++-
 drivers/net/wireless/iwlwifi/iwl-3945.h     |    1 -
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   14 ---
 drivers/net/wireless/iwlwifi/iwl-core.c     |   15 ++++
 drivers/net/wireless/iwlwifi/iwl-core.h     |    2 +
 drivers/net/wireless/iwlwifi/iwl-scan.c     |    4 +-
 drivers/net/wireless/iwlwifi/iwl-sta.c      |    6 +-
 drivers/net/wireless/iwlwifi/iwl-sta.h      |    2 +
 drivers/net/wireless/iwlwifi/iwl3945-base.c |  116 ++------------------------
 9 files changed, 45 insertions(+), 127 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 7f1e042..12f93b6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -41,6 +41,7 @@
 #include "iwl-fh.h"
 #include "iwl-3945-fh.h"
 #include "iwl-commands.h"
+#include "iwl-sta.h"
 #include "iwl-3945.h"
 #include "iwl-eeprom.h"
 #include "iwl-helpers.h"
@@ -895,7 +896,8 @@ u8 iwl3945_sync_sta(struct iwl_priv *priv, int sta_id, u16 tx_rate, u8 flags)
 
 	spin_unlock_irqrestore(&priv->sta_lock, flags_spin);
 
-	iwl3945_send_add_station(priv, &station->sta, flags);
+	iwl_send_add_sta(priv,
+			 (struct iwl_addsta_cmd *)&station->sta, flags);
 	IWL_DEBUG_RATE("SCALE sync station %d to rate %d\n",
 			sta_id, tx_rate);
 	return sta_id;
@@ -2376,6 +2378,13 @@ static u16 iwl3945_get_hcmd_size(u8 cmd_id, u16 len)
 	}
 }
 
+static u16 iwl3945_build_addsta_hcmd(const struct iwl_addsta_cmd *cmd, u8 *data)
+{
+	u16 size = (u16)sizeof(struct iwl3945_addsta_cmd);
+	memcpy(data, cmd, size);
+	return size;
+}
+
 /**
  * iwl3945_init_hw_rate_table - Initialize the hardware rate fallback table
  */
@@ -2743,6 +2752,7 @@ static struct iwl_lib_ops iwl3945_lib = {
 
 static struct iwl_hcmd_utils_ops iwl3945_hcmd_utils = {
 	.get_hcmd_size = iwl3945_get_hcmd_size,
+	.build_addsta_hcmd = iwl3945_build_addsta_hcmd,
 };
 
 static struct iwl_ops iwl3945_ops = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index 77e97ea..fef54e9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -222,7 +222,6 @@ extern int __must_check iwl3945_send_cmd(struct iwl_priv *priv,
 					 struct iwl_host_cmd *cmd);
 extern unsigned int iwl3945_fill_beacon_frame(struct iwl_priv *priv,
 					struct ieee80211_hdr *hdr,int left);
-extern int iwl3945_send_statistics_request(struct iwl_priv *priv);
 extern void iwl3945_set_decrypted_flag(struct iwl_priv *priv, struct sk_buff *skb,
 				   u32 decrypt_res,
 				   struct ieee80211_rx_status *stats);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 5c6b3fe..757a9bd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -310,20 +310,6 @@ void iwl_update_chain_flags(struct iwl_priv *priv)
 	iwl_commit_rxon(priv);
 }
 
-static int iwl_send_bt_config(struct iwl_priv *priv)
-{
-	struct iwl_bt_cmd bt_cmd = {
-		.flags = 3,
-		.lead_time = 0xAA,
-		.max_kill = 1,
-		.kill_ack_mask = 0,
-		.kill_cts_mask = 0,
-	};
-
-	return iwl_send_cmd_pdu(priv, REPLY_BT_CONFIG,
-				sizeof(struct iwl_bt_cmd), &bt_cmd);
-}
-
 static void iwl_clear_free_frames(struct iwl_priv *priv)
 {
 	struct list_head *element;
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 902b75f..21f3865 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1007,6 +1007,21 @@ void iwl_enable_interrupts(struct iwl_priv *priv)
 }
 EXPORT_SYMBOL(iwl_enable_interrupts);
 
+int iwl_send_bt_config(struct iwl_priv *priv)
+{
+	struct iwl_bt_cmd bt_cmd = {
+		.flags = 3,
+		.lead_time = 0xAA,
+		.max_kill = 1,
+		.kill_ack_mask = 0,
+		.kill_cts_mask = 0,
+	};
+
+	return iwl_send_cmd_pdu(priv, REPLY_BT_CONFIG,
+				sizeof(struct iwl_bt_cmd), &bt_cmd);
+}
+EXPORT_SYMBOL(iwl_send_bt_config);
+
 int iwl_send_statistics_request(struct iwl_priv *priv, u8 flags)
 {
 	u32 stat_flags = 0;
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 0c6250c..c8e1dad 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -335,6 +335,7 @@ void iwl_bg_scan_check(struct work_struct *data);
 void iwl_bg_abort_scan(struct work_struct *work);
 void iwl_bg_scan_completed(struct work_struct *work);
 void iwl_setup_scan_deferred_work(struct iwl_priv *priv);
+int iwl_send_scan_abort(struct iwl_priv *priv);
 
 /* For faster active scanning, scan will move to the next channel if fewer than
  * PLCP_QUIET_THRESH packets are heard on this channel within
@@ -468,6 +469,7 @@ static inline int iwl_is_ready_rf(struct iwl_priv *priv)
 }
 
 extern void iwl_rf_kill_ct_config(struct iwl_priv *priv);
+extern int iwl_send_bt_config(struct iwl_priv *priv);
 extern int iwl_send_statistics_request(struct iwl_priv *priv, u8 flags);
 extern int iwl_verify_ucode(struct iwl_priv *priv);
 extern int iwl_send_lq_cmd(struct iwl_priv *priv,
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index 0ce122a..c282d1d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -109,7 +109,7 @@ int iwl_scan_cancel_timeout(struct iwl_priv *priv, unsigned long ms)
 }
 EXPORT_SYMBOL(iwl_scan_cancel_timeout);
 
-static int iwl_send_scan_abort(struct iwl_priv *priv)
+int iwl_send_scan_abort(struct iwl_priv *priv)
 {
 	int ret = 0;
 	struct iwl_rx_packet *res;
@@ -150,7 +150,7 @@ static int iwl_send_scan_abort(struct iwl_priv *priv)
 
 	return ret;
 }
-
+EXPORT_SYMBOL(iwl_send_scan_abort);
 
 /* Service response to REPLY_SCAN_CMD (0x80) */
 static void iwl_rx_reply_scan(struct iwl_priv *priv,
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index 0cbb449..9bba98e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -86,7 +86,8 @@ static void iwl_sta_ucode_activate(struct iwl_priv *priv, u8 sta_id)
 
 	spin_lock_irqsave(&priv->sta_lock, flags);
 
-	if (!(priv->stations[sta_id].used & IWL_STA_DRIVER_ACTIVE))
+	if (!(priv->stations[sta_id].used & IWL_STA_DRIVER_ACTIVE) &&
+	    !(priv->stations_39[sta_id].used & IWL_STA_DRIVER_ACTIVE))
 		IWL_ERR(priv, "ACTIVATE a non DRIVER active station %d\n",
 			sta_id);
 
@@ -131,7 +132,7 @@ static int iwl_add_sta_callback(struct iwl_priv *priv,
 	return 1;
 }
 
-static int iwl_send_add_sta(struct iwl_priv *priv,
+int iwl_send_add_sta(struct iwl_priv *priv,
 		     struct iwl_addsta_cmd *sta, u8 flags)
 {
 	struct iwl_rx_packet *res = NULL;
@@ -179,6 +180,7 @@ static int iwl_send_add_sta(struct iwl_priv *priv,
 
 	return ret;
 }
+EXPORT_SYMBOL(iwl_send_add_sta);
 
 static void iwl_set_ht_add_station(struct iwl_priv *priv, u8 index,
 				   struct ieee80211_sta_ht_cap *sta_ht_inf)
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.h b/drivers/net/wireless/iwlwifi/iwl-sta.h
index 3fe7cc5..97f6169 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.h
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.h
@@ -56,6 +56,8 @@ int iwl_remove_station(struct iwl_priv *priv, const u8 *addr, int is_ap);
 void iwl_clear_stations_table(struct iwl_priv *priv);
 int iwl_get_sta_id(struct iwl_priv *priv, struct ieee80211_hdr *hdr);
 int iwl_get_ra_sta_id(struct iwl_priv *priv, struct ieee80211_hdr *hdr);
+int iwl_send_add_sta(struct iwl_priv *priv,
+		     struct iwl_addsta_cmd *sta, u8 flags);
 u8 iwl_add_station_flags(struct iwl_priv *priv, const u8 *addr,
 			int is_ap, u8 flags,
 			struct ieee80211_sta_ht_cap *ht_info);
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 13fb618..d093255 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -51,6 +51,7 @@
 #include "iwl-fh.h"
 #include "iwl-3945-fh.h"
 #include "iwl-commands.h"
+#include "iwl-sta.h"
 #include "iwl-3945.h"
 #include "iwl-helpers.h"
 #include "iwl-core.h"
@@ -226,24 +227,12 @@ u8 iwl3945_add_station(struct iwl_priv *priv, const u8 *addr, int is_ap, u8 flag
 	spin_unlock_irqrestore(&priv->sta_lock, flags_spin);
 
 	/* Add station to device's station table */
-	iwl3945_send_add_station(priv, &station->sta, flags);
+	iwl_send_add_sta(priv,
+			 (struct iwl_addsta_cmd *)&station->sta, flags);
 	return index;
 
 }
 
-int iwl3945_send_statistics_request(struct iwl_priv *priv)
-{
-	u32 val = 0;
-
-	struct iwl_host_cmd cmd = {
-		.id = REPLY_STATISTICS_CMD,
-		.len = sizeof(val),
-		.data = &val,
-	};
-
-	return iwl_send_cmd_sync(priv, &cmd);
-}
-
 /**
  * iwl3945_set_rxon_channel - Set the phymode and channel values in staging RXON
  * @band: 2.4 or 5 GHz band
@@ -611,95 +600,6 @@ static int iwl3945_commit_rxon(struct iwl_priv *priv)
 	return 0;
 }
 
-static int iwl3945_send_bt_config(struct iwl_priv *priv)
-{
-	struct iwl_bt_cmd bt_cmd = {
-		.flags = 3,
-		.lead_time = 0xAA,
-		.max_kill = 1,
-		.kill_ack_mask = 0,
-		.kill_cts_mask = 0,
-	};
-
-	return iwl_send_cmd_pdu(priv, REPLY_BT_CONFIG,
-					sizeof(bt_cmd), &bt_cmd);
-}
-
-static int iwl3945_add_sta_sync_callback(struct iwl_priv *priv,
-				     struct iwl_cmd *cmd, struct sk_buff *skb)
-{
-	struct iwl_rx_packet *res = NULL;
-
-	if (!skb) {
-		IWL_ERR(priv, "Error: Response NULL in REPLY_ADD_STA.\n");
-		return 1;
-	}
-
-	res = (struct iwl_rx_packet *)skb->data;
-	if (res->hdr.flags & IWL_CMD_FAILED_MSK) {
-		IWL_ERR(priv, "Bad return from REPLY_ADD_STA (0x%08X)\n",
-			  res->hdr.flags);
-		return 1;
-	}
-
-	switch (res->u.add_sta.status) {
-	case ADD_STA_SUCCESS_MSK:
-		break;
-	default:
-		break;
-	}
-
-	/* We didn't cache the SKB; let the caller free it */
-	return 1;
-}
-
-int iwl3945_send_add_station(struct iwl_priv *priv,
-			 struct iwl3945_addsta_cmd *sta, u8 flags)
-{
-	struct iwl_rx_packet *res = NULL;
-	int rc = 0;
-	struct iwl_host_cmd cmd = {
-		.id = REPLY_ADD_STA,
-		.len = sizeof(struct iwl3945_addsta_cmd),
-		.meta.flags = flags,
-		.data = sta,
-	};
-
-	if (flags & CMD_ASYNC)
-		cmd.meta.u.callback = iwl3945_add_sta_sync_callback;
-	else
-		cmd.meta.flags |= CMD_WANT_SKB;
-
-	rc = iwl_send_cmd(priv, &cmd);
-
-	if (rc || (flags & CMD_ASYNC))
-		return rc;
-
-	res = (struct iwl_rx_packet *)cmd.meta.u.skb->data;
-	if (res->hdr.flags & IWL_CMD_FAILED_MSK) {
-		IWL_ERR(priv, "Bad return from REPLY_ADD_STA (0x%08X)\n",
-			  res->hdr.flags);
-		rc = -EIO;
-	}
-
-	if (rc == 0) {
-		switch (res->u.add_sta.status) {
-		case ADD_STA_SUCCESS_MSK:
-			IWL_DEBUG_INFO("REPLY_ADD_STA PASSED\n");
-			break;
-		default:
-			rc = -EIO;
-			IWL_WARN(priv, "REPLY_ADD_STA failed\n");
-			break;
-		}
-	}
-
-	priv->alloc_rxb_skb--;
-	dev_kfree_skb_any(cmd.meta.u.skb);
-
-	return rc;
-}
-
 static int iwl3945_update_sta_key_info(struct iwl_priv *priv,
 				   struct ieee80211_key_conf *keyconf,
 				   u8 sta_id)
@@ -734,7 +634,8 @@ static int iwl3945_update_sta_key_info(struct iwl_priv *priv,
 	spin_unlock_irqrestore(&priv->sta_lock, flags);
 
 	IWL_DEBUG_INFO("hwcrypto: modify ucode station key info\n");
-	iwl3945_send_add_station(priv, &priv->stations_39[sta_id].sta, 0);
+	iwl_send_add_sta(priv,
+		(struct iwl_addsta_cmd *)&priv->stations_39[sta_id].sta, 0);
 	return 0;
 }
 
@@ -752,7 +653,8 @@ static int iwl3945_clear_sta_key_info(struct iwl_priv *priv, u8 sta_id)
 	spin_unlock_irqrestore(&priv->sta_lock, flags);
 
 	IWL_DEBUG_INFO("hwcrypto: clear ucode station key info\n");
-	iwl3945_send_add_station(priv, &priv->stations_39[sta_id].sta, 0);
+	iwl_send_add_sta(priv,
+		(struct iwl_addsta_cmd *)&priv->stations_39[sta_id].sta, 0);
 	return 0;
 }
 
@@ -4005,7 +3907,7 @@ static void iwl3945_alive_start(struct iwl_priv *priv)
 	}
 
 	/* Configure Bluetooth device coexistence support */
-	iwl3945_send_bt_config(priv);
+	iwl_send_bt_config(priv);
 
 	/* Configure the adapter for unassociated operation */
 	iwl3945_commit_rxon(priv);
@@ -5810,7 +5712,7 @@ static ssize_t show_statistics(struct device *d,
 		return -EAGAIN;
 
 	mutex_lock(&priv->mutex);
-	rc = iwl3945_send_statistics_request(priv);
+	rc = iwl_send_statistics_request(priv, 0);
 	mutex_unlock(&priv->mutex);
 
 	if (rc) {
-- 
1.5.4.3

