Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:11497 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752696AbYDPXex (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Apr 2008 19:34:53 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 2/3] iwlwifi: move find station to iwl-sta.c
Date: Wed, 16 Apr 2008 16:34:48 -0700
Message-Id: <1208388889-32131-3-git-send-email-reinette.chatre@intel.com> (sfid-20080417_003500_015415_D0CDE332)
In-Reply-To: <1208388889-32131-2-git-send-email-reinette.chatre@intel.com>
References: <1208388889-32131-1-git-send-email-reinette.chatre@intel.com>
 <1208388889-32131-2-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch move iwl_find_station into iwl-sta.c file

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965-rs.c  |    4 +-
 drivers/net/wireless/iwlwifi/iwl-4965.c     |   40 +++------------------------
 drivers/net/wireless/iwlwifi/iwl-4965.h     |    4 +-
 drivers/net/wireless/iwlwifi/iwl-sta.c      |   35 +++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   10 +++---
 5 files changed, 48 insertions(+), 45 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
index b608e1c..557912a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
@@ -2190,7 +2190,7 @@ static void rs_get_rate(void *priv_rate, struct net_device *dev,
 
 	if ((priv->iw_mode == IEEE80211_IF_TYPE_IBSS) &&
 	    !lq_sta->ibss_sta_added) {
-		u8 sta_id = iwl4965_hw_find_station(priv, hdr->addr1);
+		u8 sta_id = iwl_find_station(priv, hdr->addr1);
 		DECLARE_MAC_BUF(mac);
 
 		if (sta_id == IWL_INVALID_STATION) {
@@ -2268,7 +2268,7 @@ static void rs_rate_init(void *priv_rate, void *priv_sta,
 
 	lq_sta->ibss_sta_added = 0;
 	if (priv->iw_mode == IEEE80211_IF_TYPE_AP) {
-		u8 sta_id = iwl4965_hw_find_station(priv, sta->addr);
+		u8 sta_id = iwl_find_station(priv, sta->addr);
 		DECLARE_MAC_BUF(mac);
 
 		/* for IBSS the call are from tasklet */
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index be4cc5f..f318c50 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -492,38 +492,6 @@ int iwl4965_hw_rxq_stop(struct iwl_priv *priv)
 	return 0;
 }
 
-u8 iwl4965_hw_find_station(struct iwl_priv *priv, const u8 *addr)
-{
-	int i;
-	int start = 0;
-	int ret = IWL_INVALID_STATION;
-	unsigned long flags;
-	DECLARE_MAC_BUF(mac);
-
-	if ((priv->iw_mode == IEEE80211_IF_TYPE_IBSS) ||
-	    (priv->iw_mode == IEEE80211_IF_TYPE_AP))
-		start = IWL_STA_ID;
-
-	if (is_broadcast_ether_addr(addr))
-		return priv->hw_params.bcast_sta_id;
-
-	spin_lock_irqsave(&priv->sta_lock, flags);
-	for (i = start; i < priv->hw_params.max_stations; i++)
-		if ((priv->stations[i].used) &&
-		    (!compare_ether_addr
-		     (priv->stations[i].sta.sta.addr, addr))) {
-			ret = i;
-			goto out;
-		}
-
-	IWL_DEBUG_ASSOC_LIMIT("can not find STA %s total %d\n",
-			print_mac(mac, addr), priv->num_stations);
-
- out:
-	spin_unlock_irqrestore(&priv->sta_lock, flags);
-	return ret;
-}
-
 static int iwl4965_nic_set_pwr_src(struct iwl_priv *priv, int pwr_max)
 {
 	int ret;
@@ -3125,7 +3093,7 @@ static void iwl4965_sta_modify_ps_wake(struct iwl_priv *priv, int sta_id)
 static void iwl4965_update_ps_mode(struct iwl_priv *priv, u16 ps_bit, u8 *addr)
 {
 	/* FIXME: need locking over ps_status ??? */
-	u8 sta_id = iwl4965_hw_find_station(priv, addr);
+	u8 sta_id = iwl_find_station(priv, addr);
 
 	if (sta_id != IWL_INVALID_STATION) {
 		u8 sta_awake = priv->stations[sta_id].
@@ -4112,7 +4080,7 @@ static int iwl4965_mac_ht_tx_agg_start(struct ieee80211_hw *hw, const u8 *da,
 	IWL_WARNING("%s on da = %s tid = %d\n",
 			__func__, print_mac(mac, da), tid);
 
-	sta_id = iwl4965_hw_find_station(priv, da);
+	sta_id = iwl_find_station(priv, da);
 	if (sta_id == IWL_INVALID_STATION)
 		return -ENXIO;
 
@@ -4171,7 +4139,7 @@ static int iwl4965_mac_ht_tx_agg_stop(struct ieee80211_hw *hw, const u8 *da,
 	else
 		return -EINVAL;
 
-	sta_id = iwl4965_hw_find_station(priv, da);
+	sta_id = iwl_find_station(priv, da);
 
 	if (sta_id == IWL_INVALID_STATION)
 		return -ENXIO;
@@ -4221,7 +4189,7 @@ int iwl4965_mac_ampdu_action(struct ieee80211_hw *hw,
 
 	IWL_DEBUG_HT("A-MPDU action on da=%s tid=%d ",
 			print_mac(mac, addr), tid);
-	sta_id = iwl4965_hw_find_station(priv, addr);
+	sta_id = iwl_find_station(priv, addr);
 	switch (action) {
 	case IEEE80211_AMPDU_RX_START:
 		IWL_DEBUG_HT("start Rx\n");
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.h b/drivers/net/wireless/iwlwifi/iwl-4965.h
index 9835aff..e4674c2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.h
@@ -733,14 +733,14 @@ extern void iwl4965_disable_events(struct iwl_priv *priv);
 extern int iwl4965_get_temperature(const struct iwl_priv *priv);
 
 /**
- * iwl4965_hw_find_station - Find station id for a given BSSID
+ * iwl_find_station - Find station id for a given BSSID
  * @bssid: MAC address of station ID to find
  *
  * NOTE:  This should not be hardware specific but the code has
  * not yet been merged into a single common layer for managing the
  * station tables.
  */
-extern u8 iwl4965_hw_find_station(struct iwl_priv *priv, const u8 *bssid);
+extern u8 iwl_find_station(struct iwl_priv *priv, const u8 *bssid);
 
 extern int iwl4965_hw_channel_switch(struct iwl_priv *priv, u16 channel);
 extern int iwl4965_tx_queue_reclaim(struct iwl_priv *priv, int txq_id, int index);
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index e4fdfaa..fa463ce 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -28,6 +28,7 @@
  *****************************************************************************/
 
 #include <net/mac80211.h>
+#include <linux/etherdevice.h>
 
 #include "iwl-eeprom.h"
 #include "iwl-4965.h"
@@ -38,6 +39,40 @@
 #include "iwl-4965.h"
 #include "iwl-sta.h"
 
+u8 iwl_find_station(struct iwl_priv *priv, const u8 *addr)
+{
+	int i;
+	int start = 0;
+	int ret = IWL_INVALID_STATION;
+	unsigned long flags;
+	DECLARE_MAC_BUF(mac);
+
+	if ((priv->iw_mode == IEEE80211_IF_TYPE_IBSS) ||
+	    (priv->iw_mode == IEEE80211_IF_TYPE_AP))
+		start = IWL_STA_ID;
+
+	if (is_broadcast_ether_addr(addr))
+		return priv->hw_params.bcast_sta_id;
+
+	spin_lock_irqsave(&priv->sta_lock, flags);
+	for (i = start; i < priv->hw_params.max_stations; i++)
+		if (priv->stations[i].used &&
+		    (!compare_ether_addr(priv->stations[i].sta.sta.addr,
+					 addr))) {
+			ret = i;
+			goto out;
+		}
+
+	IWL_DEBUG_ASSOC_LIMIT("can not find STA %s total %d\n",
+			      print_mac(mac, addr), priv->num_stations);
+
+ out:
+	spin_unlock_irqrestore(&priv->sta_lock, flags);
+	return ret;
+}
+EXPORT_SYMBOL(iwl_find_station);
+
+
 int iwl_get_free_ucode_key_index(struct iwl_priv *priv)
 {
 	int i;
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index e177b6d..2dc4960 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -2076,7 +2076,7 @@ static int iwl4965_get_sta_id(struct iwl_priv *priv,
 
 	/* If we are an AP, then find the station, or use BCAST */
 	case IEEE80211_IF_TYPE_AP:
-		sta_id = iwl4965_hw_find_station(priv, hdr->addr1);
+		sta_id = iwl_find_station(priv, hdr->addr1);
 		if (sta_id != IWL_INVALID_STATION)
 			return sta_id;
 		return priv->hw_params.bcast_sta_id;
@@ -2084,7 +2084,7 @@ static int iwl4965_get_sta_id(struct iwl_priv *priv,
 	/* If this frame is going out to an IBSS network, find the station,
 	 * or create a new station table entry */
 	case IEEE80211_IF_TYPE_IBSS:
-		sta_id = iwl4965_hw_find_station(priv, hdr->addr1);
+		sta_id = iwl_find_station(priv, hdr->addr1);
 		if (sta_id != IWL_INVALID_STATION)
 			return sta_id;
 
@@ -2778,7 +2778,7 @@ static inline int iwl4965_get_ra_sta_id(struct iwl_priv *priv,
 		return IWL_AP_ID;
 	else {
 		u8 *da = ieee80211_get_DA(hdr);
-		return iwl4965_hw_find_station(priv, da);
+		return iwl_find_station(priv, da);
 	}
 }
 
@@ -6781,7 +6781,7 @@ static void iwl4965_mac_update_tkip_key(struct ieee80211_hw *hw,
 
 	IWL_DEBUG_MAC80211("enter\n");
 
-	sta_id = iwl4965_hw_find_station(priv, addr);
+	sta_id = iwl_find_station(priv, addr);
 	if (sta_id == IWL_INVALID_STATION) {
 		IWL_DEBUG_MAC80211("leave - %s not in station map.\n",
 				   print_mac(mac, addr));
@@ -6837,7 +6837,7 @@ static int iwl4965_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		/* only support pairwise keys */
 		return -EOPNOTSUPP;
 
-	sta_id = iwl4965_hw_find_station(priv, addr);
+	sta_id = iwl_find_station(priv, addr);
 	if (sta_id == IWL_INVALID_STATION) {
 		IWL_DEBUG_MAC80211("leave - %s not in station map.\n",
 				   print_mac(mac, addr));
-- 
1.5.3.4

