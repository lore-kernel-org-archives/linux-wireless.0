Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:61819 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753937AbXJXKWV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Oct 2007 06:22:21 -0400
From: Ron Rindjunsky <ron.rindjunsky@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, tomas.winkler@intel.com,
	flamingice@sourmilk.net, Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: [PATCH 1/2] mac80211: [RFC] adding bss_config to low level driver ops
Date: Wed, 24 Oct 2007 12:22:11 +0200
Message-Id: <11932213374183-git-send-email-ron.rindjunsky@intel.com> (sfid-20071024_112245_044620_861DF153)
In-Reply-To: <11932213323451-git-send-email-ron.rindjunsky@intel.com>
References: <11932213323451-git-send-email-ron.rindjunsky@intel.com>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch gives a framwork that will enable the mac80211 to inform to
low level driver about association status + the bss status due to changes
in BSS capabilities advertised by AP or in AP mode changes to be advertised
and configured to.
This will also obselete current ops for each BSS change such as erp or wmm.
In legacy networks the B G coexistence is handeled by ERP while in HT there
are many more issues such as 20/40Mhz, GF etc. It will be counterproductive
to implement handlers for each parameter, it is simpler to consolidate all
in one handler under common structure

1 - struct ieee80211_bss_data will be used to transfer data to low-level
driver
2 - bss_info_change will triger the change in low-level driver

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
---
 include/net/mac80211.h       |   43 +++++++++++++++++++
 net/mac80211/ieee80211_i.h   |    1 +
 net/mac80211/ieee80211_sta.c |   92 +++++++++++++++++++++++++-----------------
 3 files changed, 99 insertions(+), 37 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 2b1bffb..2c908ae 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -237,6 +237,41 @@ struct ieee80211_low_level_stats {
 	unsigned int dot11RTSSuccessCount;
 };
 
+#define BSS_VERIFY_STATE_ASSOC		(1<<0)
+#define BSS_VERIFY_STATE_AID		(1<<1)
+#define BSS_VERIFY_STATE_ERP_CTS_PROT	(1<<2)
+#define BSS_VERIFY_STATE_ERP_PREAMBLE	(1<<3)
+#define BSS_VERIFY_STATE_WMM		(1<<4)
+
+/**
+ * struct ieee80211_bss_data - holds the BSS's changing parameters
+ *
+ * enables the mac80211 to send association status notification to
+ * low-level driver, as well as data that may be changed through the
+ * lifetime of the BSS, after it was parsed to meaningful parameters
+ *
+ * @verify_map: use BSS_VERIFY_STATE.. to indicates the desired element
+ * @assoc: association status, 0: not associated, 1: associated
+ * @aid: association ID number, valid only when assoc is 1
+ * @use_cts_prot: use CTS protection, 0: off, 1: activate
+ * @preamble_length: 802.11b preamble leangth, 0: short, 1: long
+ * @queue: relevant queue id for the below wmm params
+ * @params: queue needed configuration
+ *
+ */
+struct ieee80211_bss_data {
+	u8 verify_map;
+	/* association related data */
+	u8 assoc;
+	u16 aid;
+	/* erp related data */
+	u8 use_cts_prot;
+	u8 preamble_length;
+	/* wmm related data */
+	u8 queue;
+	struct ieee80211_tx_queue_params *params;
+};
+
 /* Transmit control fields. This data structure is passed to low-level driver
  * with each TX frame. The low-level driver is responsible for configuring
  * the hardware to use given values (depending on what is supported). */
@@ -922,6 +957,12 @@ enum ieee80211_erp_change_flags {
  * @config_interface: Handler for configuration requests related to interfaces
  *	(e.g. BSSID changes.)
  *
+ * @bss_info_changed: Handler for configuration requests related to BSS
+ * 	parameters that may vary during BSS's lifespan, and may affect low
+ * 	level driver (e.g. assoc/disassoc status, erp parameters).
+ * 	This function should not be used if no BSS has been set, unless
+ * 	for association indication. Must be atomic.
+ *
  * @configure_filter: Configure the device's RX filter.
  *	See the section "Frame filtering" for more information.
  *	This callback must be implemented and atomic.
@@ -1021,6 +1062,8 @@ struct ieee80211_ops {
 	int (*config)(struct ieee80211_hw *hw, struct ieee80211_conf *conf);
 	int (*config_interface)(struct ieee80211_hw *hw,
 				int if_id, struct ieee80211_if_conf *conf);
+	void (*bss_info_changed)(struct ieee80211_hw *hw,
+				 struct ieee80211_bss_data *bss_data);
 	void (*configure_filter)(struct ieee80211_hw *hw,
 				 unsigned int changed_flags,
 				 unsigned int *total_flags,
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index d34a9de..5755c1e 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -276,6 +276,7 @@ struct ieee80211_if_sta {
 	u32 supp_rates_bits;
 
 	int wmm_last_param_set;
+	struct ieee80211_bss_data bss_data;
 };
 
 
diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
index d50f857..3ccb9aa 100644
--- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -384,59 +384,70 @@ static void ieee80211_sta_send_associnfo(struct net_device *dev,
 
 
 static void ieee80211_set_associated(struct net_device *dev,
-				     struct ieee80211_if_sta *ifsta,
-				     bool assoc)
+				     struct ieee80211_if_sta *ifsta)
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	union iwreq_data wrqu;
+	struct ieee80211_bss_data *bss_data = &ifsta->bss_data;
 
-	if (!!(ifsta->flags & IEEE80211_STA_ASSOCIATED) == assoc)
+	if (!bss_data->verify_map)
 		return;
+
+	if (bss_data->verify_map & BSS_VERIFY_STATE_ASSOC) {
+		if (bss_data->assoc) {
+			struct ieee80211_sub_if_data *sdata;
+			struct ieee80211_sta_bss *bss;
+
+			ifsta->flags |= IEEE80211_STA_ASSOCIATED;
+
+			sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+			if (sdata->type != IEEE80211_IF_TYPE_STA)
+				return;
+
+			bss = ieee80211_rx_bss_get(dev, ifsta->bssid,
+						local->hw.conf.channel,
+						ifsta->ssid, ifsta->ssid_len);
+			if (bss) {
+				if (bss->has_erp_value)
+				    ieee80211_handle_erp_ie(dev,
+							    bss->erp_value);
+				ieee80211_rx_bss_put(dev, bss);
+			}
 
-	if (assoc) {
-		struct ieee80211_sub_if_data *sdata;
-		struct ieee80211_sta_bss *bss;
-
-		ifsta->flags |= IEEE80211_STA_ASSOCIATED;
-
-		sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-		if (sdata->type != IEEE80211_IF_TYPE_STA)
-			return;
+			netif_carrier_on(dev);
+			ifsta->flags |= IEEE80211_STA_PREV_BSSID_SET;
+			memcpy(ifsta->prev_bssid,
+				sdata->u.sta.bssid, ETH_ALEN);
+			memcpy(wrqu.ap_addr.sa_data,
+				sdata->u.sta.bssid, ETH_ALEN);
+			ieee80211_sta_send_associnfo(dev, ifsta);
+		} else {
+			ifsta->flags &= ~IEEE80211_STA_ASSOCIATED;
 
-		bss = ieee80211_rx_bss_get(dev, ifsta->bssid,
-					   local->hw.conf.channel,
-					   ifsta->ssid, ifsta->ssid_len);
-		if (bss) {
-			if (bss->has_erp_value)
-				ieee80211_handle_erp_ie(dev, bss->erp_value);
-			ieee80211_rx_bss_put(dev, bss);
+			netif_carrier_off(dev);
+			ieee80211_reset_erp_info(dev);
+			memset(wrqu.ap_addr.sa_data, 0, ETH_ALEN);
 		}
-
-		netif_carrier_on(dev);
-		ifsta->flags |= IEEE80211_STA_PREV_BSSID_SET;
-		memcpy(ifsta->prev_bssid, sdata->u.sta.bssid, ETH_ALEN);
-		memcpy(wrqu.ap_addr.sa_data, sdata->u.sta.bssid, ETH_ALEN);
-		ieee80211_sta_send_associnfo(dev, ifsta);
-	} else {
-		ifsta->flags &= ~IEEE80211_STA_ASSOCIATED;
-
-		netif_carrier_off(dev);
-		ieee80211_reset_erp_info(dev);
-		memset(wrqu.ap_addr.sa_data, 0, ETH_ALEN);
+		wrqu.ap_addr.sa_family = ARPHRD_ETHER;
+		wireless_send_event(dev, SIOCGIWAP, &wrqu, NULL);
+		ifsta->last_probe = jiffies;
+		ieee80211_led_assoc(local, bss_data->assoc);
 	}
-	wrqu.ap_addr.sa_family = ARPHRD_ETHER;
-	wireless_send_event(dev, SIOCGIWAP, &wrqu, NULL);
-	ifsta->last_probe = jiffies;
-	ieee80211_led_assoc(local, assoc);
+	if (local->ops->bss_info_changed)
+		local->ops->bss_info_changed(local_to_hw(local), bss_data);
 }
 
 static void ieee80211_set_disassoc(struct net_device *dev,
 				   struct ieee80211_if_sta *ifsta, int deauth)
 {
+	struct ieee80211_bss_data *bss_data = &ifsta->bss_data;
+
 	if (deauth)
 		ifsta->auth_tries = 0;
 	ifsta->assoc_tries = 0;
-	ieee80211_set_associated(dev, ifsta, 0);
+	bss_data->assoc = 0;
+	bss_data->verify_map = BSS_VERIFY_STATE_ASSOC;
+	ieee80211_set_associated(dev, ifsta);
 }
 
 static void ieee80211_sta_tx(struct net_device *dev, struct sk_buff *skb,
@@ -1139,6 +1150,7 @@ static void ieee80211_rx_mgmt_assoc_resp(struct net_device *dev,
 	u32 rates;
 	u16 capab_info, status_code, aid;
 	struct ieee802_11_elems elems;
+	struct ieee80211_bss_data *bss_data = &ifsta->bss_data;
 	u8 *pos;
 	int i, j;
 
@@ -1200,6 +1212,8 @@ static void ieee80211_rx_mgmt_assoc_resp(struct net_device *dev,
 		return;
 	}
 
+	bss_data->verify_map = 0;
+
 	/* it probably doesn't, but if the frame includes an ERP value then
 	 * update our stored copy */
 	if (elems.erp_info && elems.erp_info_len >= 1) {
@@ -1224,7 +1238,11 @@ static void ieee80211_rx_mgmt_assoc_resp(struct net_device *dev,
 	if (ifsta->assocresp_ies)
 		memcpy(ifsta->assocresp_ies, pos, ifsta->assocresp_ies_len);
 
-	ieee80211_set_associated(dev, ifsta, 1);
+	bss_data->assoc = 1;
+	bss_data->verify_map |= BSS_VERIFY_STATE_ASSOC;
+	bss_data->aid = aid;
+	bss_data->verify_map |= BSS_VERIFY_STATE_AID;
+	ieee80211_set_associated(dev, ifsta);
 
 	/* Add STA entry for the AP */
 	sta = sta_info_get(local, ifsta->bssid);
-- 
1.5.2.4
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
