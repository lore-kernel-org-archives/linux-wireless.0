Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:52708 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752295AbYE2Iha (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 May 2008 04:37:30 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 17/43] iwlwifi: add remove station functionality
Date: Thu, 29 May 2008 16:35:02 +0800
Message-Id: <1212050128-17132-18-git-send-email-yi.zhu@intel.com> (sfid-20080529_110547_621951_7A7DB449)
In-Reply-To: <1212050128-17132-17-git-send-email-yi.zhu@intel.com>
References: <1212050128-17132-1-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-2-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-3-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-4-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-5-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-6-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-7-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-8-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-9-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-10-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-11-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-12-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-13-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-14-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-15-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-16-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-17-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch adds remove station functionality, which is required for
5000 and AP mode.

There are still some gaps in managment that need to be closed but it
provides sufficient functionality for 5000 HW.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-commands.h |   23 ++++-
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    1 +
 drivers/net/wireless/iwlwifi/iwl-sta.c      |  150 +++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-sta.h      |    1 +
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   44 +--------
 5 files changed, 174 insertions(+), 45 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index afd0f7d..a637abe 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -928,10 +928,28 @@ struct iwl_addsta_cmd {
 /*
  * REPLY_ADD_STA = 0x18 (response)
  */
-struct iwl4965_add_sta_resp {
+struct iwl_add_sta_resp {
 	u8 status;	/* ADD_STA_* */
 } __attribute__ ((packed));
 
+#define REM_STA_SUCCESS_MSK              0x1
+/*
+ *  REPLY_REM_STA = 0x19 (response)
+ */
+struct iwl_rem_sta_resp {
+	u8 status;
+} __attribute__ ((packed));
+
+/*
+ *  REPLY_REM_STA = 0x19 (command)
+ */
+struct iwl_rem_sta_cmd {
+	u8 num_sta;     /* number of removed stations */
+	u8 reserved[3];
+	u8 addr[ETH_ALEN]; /* MAC addr of the first station */
+	u8 reserved2[2];
+} __attribute__ ((packed));
+
 /*
  * REPLY_WEP_KEY = 0x20
  */
@@ -2869,7 +2887,8 @@ struct iwl_rx_packet {
 		struct iwl_error_resp err_resp;
 		struct iwl4965_card_state_notif card_state_notif;
 		struct iwl4965_beacon_notif beacon_status;
-		struct iwl4965_add_sta_resp add_sta;
+		struct iwl_add_sta_resp add_sta;
+		struct iwl_rem_sta_resp rem_sta;
 		struct iwl4965_sleep_notification sleep_notif;
 		struct iwl4965_spectrum_resp spectrum;
 		struct iwl4965_notif_statistics stats;
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 5291f1a..2c92e55 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -333,6 +333,7 @@ struct iwl_cmd {
 		struct iwl_tx_cmd tx;
 		struct iwl4965_tx_beacon_cmd tx_beacon;
 		struct iwl4965_rxon_assoc_cmd rxon_assoc;
+		struct iwl_rem_sta_cmd rm_sta;
 		u8 *indirect;
 		u8 payload[IWL_CMD_MAX_PAYLOAD];
 	} __attribute__ ((packed)) cmd;
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index 99ee1e1..11ec408 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -37,6 +37,10 @@
 #include "iwl-io.h"
 #include "iwl-helpers.h"
 
+
+#define IWL_STA_DRIVER_ACTIVE		0x1     /* ucode entry is active */
+#define IWL_STA_UCODE_ACTIVE		0x2     /* ucode entry is active */
+
 u8 iwl_find_station(struct iwl_priv *priv, const u8 *addr)
 {
 	int i;
@@ -241,6 +245,152 @@ u8 iwl_add_station_flags(struct iwl_priv *priv, const u8 *addr, int is_ap,
 }
 EXPORT_SYMBOL(iwl_add_station_flags);
 
+
+static int iwl_sta_ucode_deactivate(struct iwl_priv *priv, const char *addr)
+{
+	unsigned long flags;
+	u8 sta_id;
+	DECLARE_MAC_BUF(mac);
+
+	sta_id = iwl_find_station(priv, addr);
+	if (sta_id != IWL_INVALID_STATION) {
+		IWL_DEBUG_ASSOC("Removed STA from Ucode: %s\n",
+				print_mac(mac, addr));
+		spin_lock_irqsave(&priv->sta_lock, flags);
+		priv->stations[sta_id].used &= ~IWL_STA_UCODE_ACTIVE;
+		memset(&priv->stations[sta_id], 0,
+			sizeof(struct iwl_station_entry));
+		spin_unlock_irqrestore(&priv->sta_lock, flags);
+		return 0;
+	}
+	return -EINVAL;
+}
+
+static int iwl_remove_sta_callback(struct iwl_priv *priv,
+				   struct iwl_cmd *cmd, struct sk_buff *skb)
+{
+	struct iwl_rx_packet *res = NULL;
+	const char *addr = cmd->cmd.rm_sta.addr;
+
+	if (!skb) {
+		IWL_ERROR("Error: Response NULL in REPLY_REMOVE_STA.\n");
+		return 1;
+	}
+
+	res = (struct iwl_rx_packet *)skb->data;
+	if (res->hdr.flags & IWL_CMD_FAILED_MSK) {
+		IWL_ERROR("Bad return from REPLY_REMOVE_STA (0x%08X)\n",
+		res->hdr.flags);
+		return 1;
+	}
+
+	switch (res->u.rem_sta.status) {
+	case REM_STA_SUCCESS_MSK:
+		iwl_sta_ucode_deactivate(priv, addr);
+		break;
+	default:
+		break;
+	}
+
+	/* We didn't cache the SKB; let the caller free it */
+	return 1;
+}
+
+static int iwl_send_remove_station(struct iwl_priv *priv, const u8 *addr,
+				   u8 flags)
+{
+	struct iwl_rx_packet *res = NULL;
+	int ret;
+
+	struct iwl_rem_sta_cmd rm_sta_cmd;
+
+	struct iwl_host_cmd cmd = {
+		.id = REPLY_REMOVE_STA,
+		.len = sizeof(struct iwl_rem_sta_cmd),
+		.meta.flags = flags,
+		.data = &rm_sta_cmd,
+	};
+
+	memset(&rm_sta_cmd, 0, sizeof(rm_sta_cmd));
+	rm_sta_cmd.num_sta = 1;
+	memcpy(&rm_sta_cmd.addr, addr , ETH_ALEN);
+
+	if (flags & CMD_ASYNC)
+		cmd.meta.u.callback = iwl_remove_sta_callback;
+	else
+		cmd.meta.flags |= CMD_WANT_SKB;
+	ret = iwl_send_cmd(priv, &cmd);
+
+	if (ret || (flags & CMD_ASYNC))
+		return ret;
+
+	res = (struct iwl_rx_packet *)cmd.meta.u.skb->data;
+	if (res->hdr.flags & IWL_CMD_FAILED_MSK) {
+		IWL_ERROR("Bad return from REPLY_REMOVE_STA (0x%08X)\n",
+			  res->hdr.flags);
+		ret = -EIO;
+	}
+
+	if (!ret) {
+		switch (res->u.rem_sta.status) {
+		case REM_STA_SUCCESS_MSK:
+			iwl_sta_ucode_deactivate(priv, addr);
+			IWL_DEBUG_ASSOC("REPLY_REMOVE_STA PASSED\n");
+			break;
+		default:
+			ret = -EIO;
+			IWL_ERROR("REPLY_REMOVE_STA failed\n");
+			break;
+		}
+	}
+
+	priv->alloc_rxb_skb--;
+	dev_kfree_skb_any(cmd.meta.u.skb);
+
+	return ret;
+}
+/**
+ * iwl_remove_station - Remove driver's knowledge of station.
+ *
+ */
+u8 iwl_remove_station(struct iwl_priv *priv, const u8 *addr, int is_ap)
+{
+	int index = IWL_INVALID_STATION;
+	int i;
+	unsigned long flags;
+
+	spin_lock_irqsave(&priv->sta_lock, flags);
+
+	if (is_ap)
+		index = IWL_AP_ID;
+	else if (is_broadcast_ether_addr(addr))
+		index = priv->hw_params.bcast_sta_id;
+	else
+		for (i = IWL_STA_ID; i < priv->hw_params.max_stations; i++)
+			if (priv->stations[i].used &&
+			    !compare_ether_addr(priv->stations[i].sta.sta.addr,
+						addr)) {
+				index = i;
+				break;
+			}
+
+	if (unlikely(index == IWL_INVALID_STATION))
+		goto out;
+
+	if (priv->stations[index].used) {
+		priv->stations[index].used = 0;
+		priv->num_stations--;
+	}
+
+	BUG_ON(priv->num_stations < 0);
+	spin_unlock_irqrestore(&priv->sta_lock, flags);
+	iwl_send_remove_station(priv, addr, CMD_ASYNC);
+	return index;
+out:
+	spin_unlock_irqrestore(&priv->sta_lock, flags);
+	return 0;
+}
+EXPORT_SYMBOL(iwl_remove_station);
 int iwl_get_free_ucode_key_index(struct iwl_priv *priv)
 {
 	int i;
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.h b/drivers/net/wireless/iwlwifi/iwl-sta.h
index b643546..500e1df 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.h
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.h
@@ -43,5 +43,6 @@ int iwl_set_dynamic_key(struct iwl_priv *priv,
 int iwl_remove_dynamic_key(struct iwl_priv *priv,
 				struct ieee80211_key_conf *key, u8 sta_id);
 int iwl_rxon_add_station(struct iwl_priv *priv, const u8 *addr, int is_ap);
+u8 iwl_remove_station(struct iwl_priv *priv, const u8 *addr, int is_ap);
 int iwl_get_sta_id(struct iwl_priv *priv, struct ieee80211_hdr *hdr);
 #endif /* __iwl_sta_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 985876b..185d667 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -140,49 +140,6 @@ static const char *iwl4965_escape_essid(const char *essid, u8 essid_len)
 
 /**************************************************************/
 
-#if 0 /* temporary disable till we add real remove station */
-/**
- * iwl4965_remove_station - Remove driver's knowledge of station.
- *
- * NOTE:  This does not remove station from device's station table.
- */
-static u8 iwl4965_remove_station(struct iwl_priv *priv, const u8 *addr, int is_ap)
-{
-	int index = IWL_INVALID_STATION;
-	int i;
-	unsigned long flags;
-
-	spin_lock_irqsave(&priv->sta_lock, flags);
-
-	if (is_ap)
-		index = IWL_AP_ID;
-	else if (is_broadcast_ether_addr(addr))
-		index = priv->hw_params.bcast_sta_id;
-	else
-		for (i = IWL_STA_ID; i < priv->hw_params.max_stations; i++)
-			if (priv->stations[i].used &&
-			    !compare_ether_addr(priv->stations[i].sta.sta.addr,
-						addr)) {
-				index = i;
-				break;
-			}
-
-	if (unlikely(index == IWL_INVALID_STATION))
-		goto out;
-
-	if (priv->stations[index].used) {
-		priv->stations[index].used = 0;
-		priv->num_stations--;
-	}
-
-	BUG_ON(priv->num_stations < 0);
-
-out:
-	spin_unlock_irqrestore(&priv->sta_lock, flags);
-	return 0;
-}
-#endif
-
 
 
 static void iwl4965_set_rxon_hwcrypto(struct iwl_priv *priv, int hw_decrypt)
@@ -404,6 +361,7 @@ static int iwl4965_commit_rxon(struct iwl_priv *priv)
 		return rc;
 	}
 
+	iwl_remove_station(priv, iwl_bcast_addr, 0);
 	iwlcore_clear_stations_table(priv);
 
 	if (!priv->error_recovering)
-- 
1.5.3.6

