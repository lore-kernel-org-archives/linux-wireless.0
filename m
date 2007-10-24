Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:61819 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751226AbXJXKWW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Oct 2007 06:22:22 -0400
From: Ron Rindjunsky <ron.rindjunsky@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, tomas.winkler@intel.com,
	flamingice@sourmilk.net, Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: [PATCH 2/2] mac80211: [RFC] eliminating erp_ie_changed from low level driver ops
Date: Wed, 24 Oct 2007 12:22:12 +0200
Message-Id: <1193221337148-git-send-email-ron.rindjunsky@intel.com> (sfid-20071024_112246_884857_3EE1A5DC)
In-Reply-To: <11932213374183-git-send-email-ron.rindjunsky@intel.com>
References: <11932213323451-git-send-email-ron.rindjunsky@intel.com>
 <11932213374183-git-send-email-ron.rindjunsky@intel.com>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch demonstrates how erp_ie_changed can be replaced by
the new bss_info_change call. it also saves one low level ops call during
association flow, as data of erp is sent during the association flow,
not after association has been completed.
As more IE will be incorporate inside this framework, it will save low
level driver ops call. note for example that ieee80211_rx_mgmt_beacon will
be able to send all IE changes at once, instead of current serial ops calls

NOTE - This patch breaks current drivers realizing erp_ie_changed, current
patch is for RFC purposes.

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
---
 include/net/mac80211.h       |    4 ----
 net/mac80211/ieee80211.c     |   25 ++++++++++++++++---------
 net/mac80211/ieee80211_i.h   |    3 ++-
 net/mac80211/ieee80211_sta.c |   28 +++++++++-------------------
 4 files changed, 27 insertions(+), 33 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 2c908ae..51fec24 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1013,8 +1013,6 @@ enum ieee80211_erp_change_flags {
  * @sta_notify: Notifies low level driver about addition or removal
  *	of assocaited station or AP.
  *
- * @erp_ie_changed: Handle ERP IE change notifications. Must be atomic.
- *
  * @conf_tx: Configure TX queue parameters (EDCF (aifs, cw_min, cw_max),
  *	bursting) for a hardware TX queue. The @queue parameter uses the
  *	%IEEE80211_TX_QUEUE_* constants. Must be atomic.
@@ -1089,8 +1087,6 @@ struct ieee80211_ops {
 			       u32 short_retry, u32 long_retr);
 	void (*sta_notify)(struct ieee80211_hw *hw, int if_id,
 			enum sta_notify_cmd, const u8 *addr);
-	void (*erp_ie_changed)(struct ieee80211_hw *hw, u8 changes,
-			       int cts_protection, int preamble);
 	int (*conf_tx)(struct ieee80211_hw *hw, int queue,
 		       const struct ieee80211_tx_queue_params *params);
 	int (*get_tx_stats)(struct ieee80211_hw *hw,
diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
index 64fa720..5e4f4c4 100644
--- a/net/mac80211/ieee80211.c
+++ b/net/mac80211/ieee80211.c
@@ -523,25 +523,32 @@ int ieee80211_hw_config(struct ieee80211_local *local)
 	return ret;
 }
 
-void ieee80211_erp_info_change_notify(struct net_device *dev, u8 changes)
+void ieee80211_bss_info_change_notify(struct net_device *dev,
+				    struct ieee80211_bss_data *bss_data)
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	if (local->ops->erp_ie_changed)
-		local->ops->erp_ie_changed(local_to_hw(local), changes,
-			!!(sdata->flags & IEEE80211_SDATA_USE_PROTECTION),
-			!(sdata->flags & IEEE80211_SDATA_SHORT_PREAMBLE));
+
+	if (!bss_data->verify_map)
+		return;
+
+	if (local->ops->bss_info_changed)
+		local->ops->bss_info_changed(local_to_hw(local), bss_data);
+
+	bss_data->verify_map = 0;
 }
 
 void ieee80211_reset_erp_info(struct net_device *dev)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_if_sta *ifsta = &sdata->u.sta;
 
 	sdata->flags &= ~(IEEE80211_SDATA_USE_PROTECTION |
 			IEEE80211_SDATA_SHORT_PREAMBLE);
-	ieee80211_erp_info_change_notify(dev,
-					 IEEE80211_ERP_CHANGE_PROTECTION |
-					 IEEE80211_ERP_CHANGE_PREAMBLE);
+	ifsta->bss_data.verify_map = (BSS_VERIFY_STATE_ERP_CTS_PROT &
+					BSS_VERIFY_STATE_ERP_PREAMBLE);
+	ifsta->bss_data.use_cts_prot = 0;
+	ifsta->bss_data.preamble_length = WLAN_ERP_PREAMBLE_LONG;
+	ieee80211_bss_info_change_notify(dev, &ifsta->bss_data);
 }
 
 void ieee80211_tx_status_irqsafe(struct ieee80211_hw *hw,
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 5755c1e..db78ee7 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -760,7 +760,8 @@ struct sta_info * ieee80211_ibss_add_sta(struct net_device *dev,
 					 u8 *addr);
 int ieee80211_sta_deauthenticate(struct net_device *dev, u16 reason);
 int ieee80211_sta_disassociate(struct net_device *dev, u16 reason);
-void ieee80211_erp_info_change_notify(struct net_device *dev, u8 changes);
+void ieee80211_bss_info_change_notify(struct net_device *dev,
+				      struct ieee80211_bss_data *bss_data);
 void ieee80211_reset_erp_info(struct net_device *dev);
 
 /* ieee80211_iface.c */
diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
index 3ccb9aa..bf9f920 100644
--- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -292,9 +292,9 @@ static void ieee80211_handle_erp_ie(struct net_device *dev, u8 erp_value)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_if_sta *ifsta = &sdata->u.sta;
+	struct ieee80211_bss_data *bss_data = &ifsta->bss_data;
 	int use_protection = (erp_value & WLAN_ERP_USE_PROTECTION) != 0;
 	int preamble_mode = (erp_value & WLAN_ERP_BARKER_PREAMBLE) != 0;
-	u8 changes = 0;
 
 	if (use_protection != !!(sdata->flags & IEEE80211_SDATA_USE_PROTECTION)) {
 		if (net_ratelimit()) {
@@ -308,7 +308,8 @@ static void ieee80211_handle_erp_ie(struct net_device *dev, u8 erp_value)
 			sdata->flags |= IEEE80211_SDATA_USE_PROTECTION;
 		else
 			sdata->flags &= ~IEEE80211_SDATA_USE_PROTECTION;
-		changes |= IEEE80211_ERP_CHANGE_PROTECTION;
+		bss_data->verify_map |= BSS_VERIFY_STATE_ERP_CTS_PROT;
+		bss_data->use_cts_prot = use_protection;
 	}
 
 	if (preamble_mode != !(sdata->flags & IEEE80211_SDATA_SHORT_PREAMBLE)) {
@@ -324,11 +325,9 @@ static void ieee80211_handle_erp_ie(struct net_device *dev, u8 erp_value)
 			sdata->flags &= ~IEEE80211_SDATA_SHORT_PREAMBLE;
 		else
 			sdata->flags |= IEEE80211_SDATA_SHORT_PREAMBLE;
-		changes |= IEEE80211_ERP_CHANGE_PREAMBLE;
+		bss_data->verify_map |= BSS_VERIFY_STATE_ERP_PREAMBLE;
+		bss_data->preamble_length = preamble_mode;
 	}
-
-	if (changes)
-		ieee80211_erp_info_change_notify(dev, changes);
 }
 
 
@@ -396,7 +395,6 @@ static void ieee80211_set_associated(struct net_device *dev,
 	if (bss_data->verify_map & BSS_VERIFY_STATE_ASSOC) {
 		if (bss_data->assoc) {
 			struct ieee80211_sub_if_data *sdata;
-			struct ieee80211_sta_bss *bss;
 
 			ifsta->flags |= IEEE80211_STA_ASSOCIATED;
 
@@ -404,16 +402,6 @@ static void ieee80211_set_associated(struct net_device *dev,
 			if (sdata->type != IEEE80211_IF_TYPE_STA)
 				return;
 
-			bss = ieee80211_rx_bss_get(dev, ifsta->bssid,
-						local->hw.conf.channel,
-						ifsta->ssid, ifsta->ssid_len);
-			if (bss) {
-				if (bss->has_erp_value)
-				    ieee80211_handle_erp_ie(dev,
-							    bss->erp_value);
-				ieee80211_rx_bss_put(dev, bss);
-			}
-
 			netif_carrier_on(dev);
 			ifsta->flags |= IEEE80211_STA_PREV_BSSID_SET;
 			memcpy(ifsta->prev_bssid,
@@ -433,8 +421,7 @@ static void ieee80211_set_associated(struct net_device *dev,
 		ifsta->last_probe = jiffies;
 		ieee80211_led_assoc(local, bss_data->assoc);
 	}
-	if (local->ops->bss_info_changed)
-		local->ops->bss_info_changed(local_to_hw(local), bss_data);
+	ieee80211_bss_info_change_notify(dev, bss_data);
 }
 
 static void ieee80211_set_disassoc(struct net_device *dev,
@@ -1224,6 +1211,7 @@ static void ieee80211_rx_mgmt_assoc_resp(struct net_device *dev,
 		if (bss) {
 			bss->erp_value = elems.erp_info[0];
 			bss->has_erp_value = 1;
+			ieee80211_handle_erp_ie(dev, bss->erp_value);
 			ieee80211_rx_bss_put(dev, bss);
 		}
 	}
@@ -1704,6 +1692,8 @@ static void ieee80211_rx_mgmt_beacon(struct net_device *dev,
 		ieee80211_sta_wmm_params(dev, ifsta, elems.wmm_param,
 					 elems.wmm_param_len);
 	}
+
+	ieee80211_bss_info_change_notify(dev, &ifsta->bss_data);
 }
 
 
-- 
1.5.2.4
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
