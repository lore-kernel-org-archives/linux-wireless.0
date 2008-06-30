Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:24090 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754280AbYF3J0V (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jun 2008 05:26:21 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 03/33] iwlwifi: better station table maintenance
Date: Mon, 30 Jun 2008 17:23:03 +0800
Message-Id: <1214817813-17639-4-git-send-email-yi.zhu@intel.com> (sfid-20080630_112624_926765_D20C9460)
In-Reply-To: <1214817813-17639-3-git-send-email-yi.zhu@intel.com>
References: <1214817813-17639-1-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-2-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-3-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This patch makes the station table maintenance safer. Two flags are
maintained:

1) if station is present in driver
2) if station is present in uCode

This will allow us in the future to deal with more stations than the
firmware allows.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c     |    4 +
 drivers/net/wireless/iwlwifi/iwl-sta.c      |  146 +++++++++++++++++---------
 drivers/net/wireless/iwlwifi/iwl-sta.h      |    2 +-
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    1 -
 4 files changed, 100 insertions(+), 53 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index eb74a40..1c0670b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -284,6 +284,10 @@ void iwlcore_clear_stations_table(struct iwl_priv *priv)
 	spin_lock_irqsave(&priv->sta_lock, flags);
 
 	priv->num_stations = 0;
+	if (iwl_is_alive(priv) &&
+	    iwl_send_cmd_pdu_async(priv, REPLY_REMOVE_ALL_STA, 0, NULL, NULL))
+		IWL_ERROR("Couldn't clear the station table\n");
+
 	memset(priv->stations, 0, sizeof(priv->stations));
 
 	spin_unlock_irqrestore(&priv->sta_lock, flags);
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index f874e7d..c81ab5f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -36,8 +36,8 @@
 #include "iwl-helpers.h"
 
 
-#define IWL_STA_DRIVER_ACTIVE		0x1     /* ucode entry is active */
-#define IWL_STA_UCODE_ACTIVE		0x2     /* ucode entry is active */
+#define IWL_STA_DRIVER_ACTIVE BIT(0) /* driver entry is active */
+#define IWL_STA_UCODE_ACTIVE  BIT(1) /* ucode entry is active */
 
 u8 iwl_find_station(struct iwl_priv *priv, const u8 *addr)
 {
@@ -83,10 +83,28 @@ int iwl_get_ra_sta_id(struct iwl_priv *priv, struct ieee80211_hdr *hdr)
 }
 EXPORT_SYMBOL(iwl_get_ra_sta_id);
 
+static void iwl_sta_ucode_activate(struct iwl_priv *priv, u8 sta_id)
+{
+	unsigned long flags;
+	DECLARE_MAC_BUF(mac);
+
+	spin_lock_irqsave(&priv->sta_lock, flags);
+
+	if (!(priv->stations[sta_id].used & IWL_STA_DRIVER_ACTIVE))
+		IWL_ERROR("ACTIVATE a non DRIVER active station %d\n", sta_id);
+
+	priv->stations[sta_id].used |= IWL_STA_UCODE_ACTIVE;
+	IWL_DEBUG_ASSOC("Added STA to Ucode: %s\n",
+			print_mac(mac, priv->stations[sta_id].sta.sta.addr));
+
+	spin_unlock_irqrestore(&priv->sta_lock, flags);
+}
+
 static int iwl_add_sta_callback(struct iwl_priv *priv,
 				   struct iwl_cmd *cmd, struct sk_buff *skb)
 {
 	struct iwl_rx_packet *res = NULL;
+	u8 sta_id = cmd->cmd.addsta.sta.sta_id;
 
 	if (!skb) {
 		IWL_ERROR("Error: Response NULL in REPLY_ADD_STA.\n");
@@ -102,8 +120,8 @@ static int iwl_add_sta_callback(struct iwl_priv *priv,
 
 	switch (res->u.add_sta.status) {
 	case ADD_STA_SUCCESS_MSK:
-		/* FIXME: implement iwl_sta_ucode_activate(priv, addr); */
-		/* fail through */
+		iwl_sta_ucode_activate(priv, sta_id);
+		 /* fall through */
 	default:
 		IWL_DEBUG_HC("Received REPLY_ADD_STA:(0x%08X)\n",
 			     res->u.add_sta.status);
@@ -147,6 +165,7 @@ int iwl_send_add_sta(struct iwl_priv *priv,
 	if (ret == 0) {
 		switch (res->u.add_sta.status) {
 		case ADD_STA_SUCCESS_MSK:
+			iwl_sta_ucode_activate(priv, sta->sta.sta_id);
 			IWL_DEBUG_INFO("REPLY_ADD_STA PASSED\n");
 			break;
 		default:
@@ -215,88 +234,92 @@ u8 iwl_add_station_flags(struct iwl_priv *priv, const u8 *addr, int is_ap,
 			 u8 flags, struct ieee80211_ht_info *ht_info)
 {
 	int i;
-	int index = IWL_INVALID_STATION;
+	int sta_id = IWL_INVALID_STATION;
 	struct iwl_station_entry *station;
 	unsigned long flags_spin;
 	DECLARE_MAC_BUF(mac);
 
 	spin_lock_irqsave(&priv->sta_lock, flags_spin);
 	if (is_ap)
-		index = IWL_AP_ID;
+		sta_id = IWL_AP_ID;
 	else if (is_broadcast_ether_addr(addr))
-		index = priv->hw_params.bcast_sta_id;
+		sta_id = priv->hw_params.bcast_sta_id;
 	else
 		for (i = IWL_STA_ID; i < priv->hw_params.max_stations; i++) {
 			if (!compare_ether_addr(priv->stations[i].sta.sta.addr,
 						addr)) {
-				index = i;
+				sta_id = i;
 				break;
 			}
 
 			if (!priv->stations[i].used &&
-			    index == IWL_INVALID_STATION)
-				index = i;
+			    sta_id == IWL_INVALID_STATION)
+				sta_id = i;
 		}
 
-
 	/* These two conditions have the same outcome, but keep them separate
-	  since they have different meanings */
-	if (unlikely(index == IWL_INVALID_STATION)) {
+	   since they have different meanings */
+	if (unlikely(sta_id == IWL_INVALID_STATION)) {
 		spin_unlock_irqrestore(&priv->sta_lock, flags_spin);
-		return index;
+		return sta_id;
 	}
 
-	if (priv->stations[index].used &&
-	    !compare_ether_addr(priv->stations[index].sta.sta.addr, addr)) {
+	if (priv->stations[sta_id].used &&
+	    !compare_ether_addr(priv->stations[sta_id].sta.sta.addr, addr)) {
 		spin_unlock_irqrestore(&priv->sta_lock, flags_spin);
-		return index;
+		return sta_id;
 	}
 
 
-	IWL_DEBUG_ASSOC("Add STA ID %d: %s\n", index, print_mac(mac, addr));
-	station = &priv->stations[index];
-	station->used = 1;
+	station = &priv->stations[sta_id];
+	station->used = IWL_STA_DRIVER_ACTIVE;
+	IWL_DEBUG_ASSOC("Add STA to driver ID %d: %s\n",
+			sta_id, print_mac(mac, addr));
 	priv->num_stations++;
 
 	/* Set up the REPLY_ADD_STA command to send to device */
 	memset(&station->sta, 0, sizeof(struct iwl_addsta_cmd));
 	memcpy(station->sta.sta.addr, addr, ETH_ALEN);
 	station->sta.mode = 0;
-	station->sta.sta.sta_id = index;
+	station->sta.sta.sta_id = sta_id;
 	station->sta.station_flags = 0;
 
 	/* BCAST station and IBSS stations do not work in HT mode */
-	if (index != priv->hw_params.bcast_sta_id &&
+	if (sta_id != priv->hw_params.bcast_sta_id &&
 	    priv->iw_mode != IEEE80211_IF_TYPE_IBSS)
-		iwl_set_ht_add_station(priv, index, ht_info);
+		iwl_set_ht_add_station(priv, sta_id, ht_info);
 
 	spin_unlock_irqrestore(&priv->sta_lock, flags_spin);
 
 	/* Add station to device's station table */
 	iwl_send_add_sta(priv, &station->sta, flags);
-	return index;
+	return sta_id;
 
 }
 EXPORT_SYMBOL(iwl_add_station_flags);
 
-static int iwl_sta_ucode_deactivate(struct iwl_priv *priv, const char *addr)
+static void iwl_sta_ucode_deactivate(struct iwl_priv *priv, const char *addr)
 {
 	unsigned long flags;
-	u8 sta_id;
 	DECLARE_MAC_BUF(mac);
 
-	sta_id = iwl_find_station(priv, addr);
-	if (sta_id != IWL_INVALID_STATION) {
-		IWL_DEBUG_ASSOC("Removed STA from Ucode: %s\n",
-				print_mac(mac, addr));
-		spin_lock_irqsave(&priv->sta_lock, flags);
-		priv->stations[sta_id].used &= ~IWL_STA_UCODE_ACTIVE;
-		memset(&priv->stations[sta_id], 0,
-			sizeof(struct iwl_station_entry));
-		spin_unlock_irqrestore(&priv->sta_lock, flags);
-		return 0;
-	}
-	return -EINVAL;
+	u8 sta_id = iwl_find_station(priv, addr);
+
+	BUG_ON(sta_id == IWL_INVALID_STATION);
+
+	IWL_DEBUG_ASSOC("Removed STA from Ucode: %s\n",
+			print_mac(mac, addr));
+
+	spin_lock_irqsave(&priv->sta_lock, flags);
+
+	/* Ucode must be active and driver must be non active */
+	if (priv->stations[sta_id].used != IWL_STA_UCODE_ACTIVE)
+		IWL_ERROR("removed non active STA %d\n", sta_id);
+
+	priv->stations[sta_id].used &= ~IWL_STA_UCODE_ACTIVE;
+
+	memset(&priv->stations[sta_id], 0, sizeof(struct iwl_station_entry));
+	spin_unlock_irqrestore(&priv->sta_lock, flags);
 }
 
 static int iwl_remove_sta_callback(struct iwl_priv *priv,
@@ -322,6 +345,7 @@ static int iwl_remove_sta_callback(struct iwl_priv *priv,
 		iwl_sta_ucode_deactivate(priv, addr);
 		break;
 	default:
+		IWL_ERROR("REPLY_REMOVE_STA failed\n");
 		break;
 	}
 
@@ -386,44 +410,63 @@ static int iwl_send_remove_station(struct iwl_priv *priv, const u8 *addr,
 /**
  * iwl_remove_station - Remove driver's knowledge of station.
  */
-u8 iwl_remove_station(struct iwl_priv *priv, const u8 *addr, int is_ap)
+int iwl_remove_station(struct iwl_priv *priv, const u8 *addr, int is_ap)
 {
-	int index = IWL_INVALID_STATION;
-	int i;
+	int sta_id = IWL_INVALID_STATION;
+	int i, ret = -EINVAL;
 	unsigned long flags;
+	DECLARE_MAC_BUF(mac);
 
 	spin_lock_irqsave(&priv->sta_lock, flags);
 
 	if (is_ap)
-		index = IWL_AP_ID;
+		sta_id = IWL_AP_ID;
 	else if (is_broadcast_ether_addr(addr))
-		index = priv->hw_params.bcast_sta_id;
+		sta_id = priv->hw_params.bcast_sta_id;
 	else
 		for (i = IWL_STA_ID; i < priv->hw_params.max_stations; i++)
 			if (priv->stations[i].used &&
 			    !compare_ether_addr(priv->stations[i].sta.sta.addr,
 						addr)) {
-				index = i;
+				sta_id = i;
 				break;
 			}
 
-	if (unlikely(index == IWL_INVALID_STATION))
+	if (unlikely(sta_id == IWL_INVALID_STATION))
 		goto out;
 
-	if (priv->stations[index].used) {
-		priv->stations[index].used = 0;
-		priv->num_stations--;
+	IWL_DEBUG_ASSOC("Removing STA from driver:%d  %s\n",
+		sta_id, print_mac(mac, addr));
+
+	if (!(priv->stations[sta_id].used & IWL_STA_DRIVER_ACTIVE)) {
+		IWL_ERROR("Removing %s but non DRIVER active\n",
+				print_mac(mac, addr));
+		goto out;
+	}
+
+	if (!(priv->stations[sta_id].used & IWL_STA_UCODE_ACTIVE)) {
+		IWL_ERROR("Removing %s but non UCODE active\n",
+				print_mac(mac, addr));
+		goto out;
 	}
 
+
+	priv->stations[sta_id].used &= ~IWL_STA_DRIVER_ACTIVE;
+
+	priv->num_stations--;
+
 	BUG_ON(priv->num_stations < 0);
+
 	spin_unlock_irqrestore(&priv->sta_lock, flags);
-	iwl_send_remove_station(priv, addr, CMD_ASYNC);
-	return index;
+
+	ret = iwl_send_remove_station(priv, addr, CMD_ASYNC);
+	return ret;
 out:
 	spin_unlock_irqrestore(&priv->sta_lock, flags);
-	return 0;
+	return ret;
 }
 EXPORT_SYMBOL(iwl_remove_station);
+
 static int iwl_get_free_ucode_key_index(struct iwl_priv *priv)
 {
 	int i;
@@ -845,6 +888,7 @@ static void iwl_sta_init_lq(struct iwl_priv *priv, const u8 *addr, int is_ap)
 	iwl_send_cmd_pdu_async(priv, REPLY_TX_LINK_QUALITY_CMD,
 			       sizeof(link_cmd), &link_cmd, NULL);
 }
+
 /**
  * iwl_rxon_add_station - add station into station table.
  *
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.h b/drivers/net/wireless/iwlwifi/iwl-sta.h
index b6bb209..221b93e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.h
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.h
@@ -48,7 +48,7 @@ int iwl_set_dynamic_key(struct iwl_priv *priv,
 int iwl_remove_dynamic_key(struct iwl_priv *priv,
 			   struct ieee80211_key_conf *key, u8 sta_id);
 int iwl_rxon_add_station(struct iwl_priv *priv, const u8 *addr, int is_ap);
-u8 iwl_remove_station(struct iwl_priv *priv, const u8 *addr, int is_ap);
+int iwl_remove_station(struct iwl_priv *priv, const u8 *addr, int is_ap);
 int iwl_get_sta_id(struct iwl_priv *priv, struct ieee80211_hdr *hdr);
 void iwl_sta_modify_enable_tid_tx(struct iwl_priv *priv, int sta_id, int tid);
 int iwl_get_ra_sta_id(struct iwl_priv *priv, struct ieee80211_hdr *hdr);
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 6eee28d..1558b9a 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -315,7 +315,6 @@ static int iwl4965_commit_rxon(struct iwl_priv *priv)
 		return rc;
 	}
 
-	iwl_remove_station(priv, iwl_bcast_addr, 0);
 	iwlcore_clear_stations_table(priv);
 
 	if (!priv->error_recovering)
-- 
1.5.3.6

