Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:15212 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756190AbYC1Xdz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Mar 2008 19:33:55 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: [PATCH 1/4] mac80211: eliminate conf_ht
Date: Fri, 28 Mar 2008 16:33:32 -0700
Message-Id: <1206747215-10640-2-git-send-email-reinette.chatre@intel.com> (sfid-20080328_233359_228283_D5A88965)
In-Reply-To: <1206747215-10640-1-git-send-email-reinette.chatre@intel.com>
References: <1206747215-10640-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch eliminates the use of conf_ht, replacing it with
bss_info_changed.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
---
 include/net/mac80211.h       |   10 +++++-
 net/mac80211/ieee80211.c     |   73 +++++++++++++++++++++++++----------------
 net/mac80211/ieee80211_i.h   |    6 ++--
 net/mac80211/ieee80211_sta.c |   33 +++++++++++--------
 4 files changed, 75 insertions(+), 47 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 0679adc..dddc69b 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -192,11 +192,13 @@ struct ieee80211_low_level_stats {
  *	also implies a change in the AID.
  * @BSS_CHANGED_ERP_CTS_PROT: CTS protection changed
  * @BSS_CHANGED_ERP_PREAMBLE: preamble changed
+ * @BSS_CHANGED_HT: 802.11n parameters changed
  */
 enum ieee80211_bss_change {
 	BSS_CHANGED_ASSOC		= 1<<0,
 	BSS_CHANGED_ERP_CTS_PROT	= 1<<1,
 	BSS_CHANGED_ERP_PREAMBLE	= 1<<2,
+	BSS_CHANGED_HT                  = 1<<4,
 };
 
 /**
@@ -209,6 +211,9 @@ enum ieee80211_bss_change {
  * @aid: association ID number, valid only when @assoc is true
  * @use_cts_prot: use CTS protection
  * @use_short_preamble: use 802.11b short preamble
+ * @assoc_ht: association in HT mode
+ * @ht_conf: ht capabilities
+ * @ht_bss_conf: ht extended capabilities
  */
 struct ieee80211_bss_conf {
 	/* association related data */
@@ -217,6 +222,10 @@ struct ieee80211_bss_conf {
 	/* erp related data */
 	bool use_cts_prot;
 	bool use_short_preamble;
+	/* ht related data */
+	bool assoc_ht;
+	struct ieee80211_ht_info *ht_conf;
+	struct ieee80211_ht_bss_info *ht_bss_conf;
 };
 
 /**
@@ -1146,7 +1155,6 @@ struct ieee80211_ops {
 			     struct sk_buff *skb,
 			     struct ieee80211_tx_control *control);
 	int (*tx_last_beacon)(struct ieee80211_hw *hw);
-	int (*conf_ht)(struct ieee80211_hw *hw, struct ieee80211_conf *conf);
 	int (*ampdu_action)(struct ieee80211_hw *hw,
 			    enum ieee80211_ampdu_mlme_action action,
 			    const u8 *addr, u16 tid, u16 *ssn);
diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
index 8c0f782..1b953d9 100644
--- a/net/mac80211/ieee80211.c
+++ b/net/mac80211/ieee80211.c
@@ -1034,54 +1034,69 @@ int ieee80211_hw_config(struct ieee80211_local *local)
 }
 
 /**
- * ieee80211_hw_config_ht should be used only after legacy configuration
- * has been determined, as ht configuration depends upon the hardware's
- * HT abilities for a _specific_ band.
+ * ieee80211_handle_ht should be used only after legacy configuration
+ * has been determined namely band, as ht configuration depends upon
+ * the hardware's HT abilities for a _specific_ band.
  */
-int ieee80211_hw_config_ht(struct ieee80211_local *local, int enable_ht,
+u32 ieee80211_handle_ht(struct ieee80211_local *local, int enable_ht,
 			   struct ieee80211_ht_info *req_ht_cap,
 			   struct ieee80211_ht_bss_info *req_bss_cap)
 {
 	struct ieee80211_conf *conf = &local->hw.conf;
 	struct ieee80211_supported_band *sband;
+	struct ieee80211_ht_info ht_conf;
+	struct ieee80211_ht_bss_info ht_bss_conf;
 	int i;
+	u32 changed = 0;
 
 	sband = local->hw.wiphy->bands[conf->channel->band];
 
 	/* HT is not supported */
 	if (!sband->ht_info.ht_supported) {
 		conf->flags &= ~IEEE80211_CONF_SUPPORT_HT_MODE;
-		return -EOPNOTSUPP;
+		return 0;
 	}
 
-	/* disable HT */
-	if (!enable_ht) {
-		conf->flags &= ~IEEE80211_CONF_SUPPORT_HT_MODE;
-	} else {
+	memset(&ht_conf, 0, sizeof(struct ieee80211_ht_info));
+	memset(&ht_bss_conf, 0, sizeof(struct ieee80211_ht_bss_info));
+
+	if (enable_ht) {
+		if (!(conf->flags & IEEE80211_CONF_SUPPORT_HT_MODE))
+			changed |= BSS_CHANGED_HT;
+
 		conf->flags |= IEEE80211_CONF_SUPPORT_HT_MODE;
-		conf->ht_conf.cap = req_ht_cap->cap & sband->ht_info.cap;
-		conf->ht_conf.cap &= ~(IEEE80211_HT_CAP_MIMO_PS);
-		conf->ht_conf.cap |=
-			sband->ht_info.cap & IEEE80211_HT_CAP_MIMO_PS;
-		conf->ht_bss_conf.primary_channel =
-			req_bss_cap->primary_channel;
-		conf->ht_bss_conf.bss_cap = req_bss_cap->bss_cap;
-		conf->ht_bss_conf.bss_op_mode = req_bss_cap->bss_op_mode;
+		ht_conf.ht_supported = 1;
+
+		ht_conf.cap = req_ht_cap->cap & sband->ht_info.cap;
+		ht_conf.cap &= ~(IEEE80211_HT_CAP_MIMO_PS);
+		ht_conf.cap |= sband->ht_info.cap & IEEE80211_HT_CAP_MIMO_PS;
+
 		for (i = 0; i < SUPP_MCS_SET_LEN; i++)
-			conf->ht_conf.supp_mcs_set[i] =
-				sband->ht_info.supp_mcs_set[i] &
-				  req_ht_cap->supp_mcs_set[i];
-
-		/* In STA mode, this gives us indication
-		 * to the AP's mode of operation */
-		conf->ht_conf.ht_supported = 1;
-		conf->ht_conf.ampdu_factor = req_ht_cap->ampdu_factor;
-		conf->ht_conf.ampdu_density = req_ht_cap->ampdu_density;
+			ht_conf.supp_mcs_set[i] =
+					sband->ht_info.supp_mcs_set[i] &
+					req_ht_cap->supp_mcs_set[i];
+
+		ht_bss_conf.primary_channel = req_bss_cap->primary_channel;
+		ht_bss_conf.bss_cap = req_bss_cap->bss_cap;
+		ht_bss_conf.bss_op_mode = req_bss_cap->bss_op_mode;
+
+		ht_conf.ampdu_factor = req_ht_cap->ampdu_factor;
+		ht_conf.ampdu_density = req_ht_cap->ampdu_density;
+
+		/* if bss configuration changed store the new one */
+		if (memcmp(&conf->ht_conf, &ht_conf, sizeof(ht_conf)) ||
+		    memcmp(&conf->ht_bss_conf, &ht_bss_conf, sizeof(ht_bss_conf))) {
+			changed |= BSS_CHANGED_HT;
+			memcpy(&conf->ht_conf, &ht_conf, sizeof(ht_conf));
+			memcpy(&conf->ht_bss_conf, &ht_bss_conf, sizeof(ht_bss_conf));
+		}
+	} else {
+		if (conf->flags & IEEE80211_CONF_SUPPORT_HT_MODE)
+			changed |= BSS_CHANGED_HT;
+		conf->flags &= ~IEEE80211_CONF_SUPPORT_HT_MODE;
 	}
 
-	local->ops->conf_ht(local_to_hw(local), &local->hw.conf);
-
-	return 0;
+	return changed;
 }
 
 void ieee80211_bss_info_change_notify(struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 7ab8066..4637115 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -863,9 +863,9 @@ int ieee80211_if_config(struct net_device *dev);
 int ieee80211_if_config_beacon(struct net_device *dev);
 void ieee80211_tx_set_protected(struct ieee80211_tx_data *tx);
 void ieee80211_if_setup(struct net_device *dev);
-int ieee80211_hw_config_ht(struct ieee80211_local *local, int enable_ht,
-			   struct ieee80211_ht_info *req_ht_cap,
-			   struct ieee80211_ht_bss_info *req_bss_cap);
+u32 ieee80211_handle_ht(struct ieee80211_local *local, int enable_ht,
+			struct ieee80211_ht_info *req_ht_cap,
+			struct ieee80211_ht_bss_info *req_bss_cap);
 
 /* ieee80211_ioctl.c */
 extern const struct iw_handler_def ieee80211_iw_handler_def;
diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
index b1c9a5a..59d1060 100644
--- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -495,6 +495,7 @@ static void ieee80211_set_associated(struct net_device *dev,
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_conf *conf = &local_to_hw(local)->conf;
 	union iwreq_data wrqu;
 	u32 changed = BSS_CHANGED_ASSOC;
 
@@ -507,7 +508,7 @@ static void ieee80211_set_associated(struct net_device *dev,
 			return;
 
 		bss = ieee80211_rx_bss_get(dev, ifsta->bssid,
-					   local->hw.conf.channel->center_freq,
+					   conf->channel->center_freq,
 					   ifsta->ssid, ifsta->ssid_len);
 		if (bss) {
 			if (bss->has_erp_value)
@@ -516,6 +517,13 @@ static void ieee80211_set_associated(struct net_device *dev,
 			ieee80211_rx_bss_put(dev, bss);
 		}
 
+		if (conf->flags & IEEE80211_CONF_SUPPORT_HT_MODE) {
+			changed |= BSS_CHANGED_HT;
+			sdata->bss_conf.assoc_ht = 1;
+			sdata->bss_conf.ht_conf = &conf->ht_conf;
+			sdata->bss_conf.ht_bss_conf = &conf->ht_bss_conf;
+		}
+
 		netif_carrier_on(dev);
 		ifsta->flags |= IEEE80211_STA_PREV_BSSID_SET;
 		memcpy(ifsta->prev_bssid, sdata->u.sta.bssid, ETH_ALEN);
@@ -526,6 +534,11 @@ static void ieee80211_set_associated(struct net_device *dev,
 		ifsta->flags &= ~IEEE80211_STA_ASSOCIATED;
 		netif_carrier_off(dev);
 		ieee80211_reset_erp_info(dev);
+
+		sdata->bss_conf.assoc_ht = 0;
+		sdata->bss_conf.ht_conf = NULL;
+		sdata->bss_conf.ht_bss_conf = NULL;
+
 		memset(wrqu.ap_addr.sa_data, 0, ETH_ALEN);
 	}
 	wrqu.ap_addr.sa_family = ARPHRD_ETHER;
@@ -2003,17 +2016,15 @@ static void ieee80211_rx_mgmt_assoc_resp(struct ieee80211_sub_if_data *sdata,
 	else
 		sdata->flags &= ~IEEE80211_SDATA_OPERATING_GMODE;
 
-	if (elems.ht_cap_elem && elems.ht_info_elem && elems.wmm_param &&
-	    local->ops->conf_ht) {
+	if (elems.ht_cap_elem && elems.ht_info_elem && elems.wmm_param) {
 		struct ieee80211_ht_bss_info bss_info;
-
 		ieee80211_ht_cap_ie_to_ht_info(
 				(struct ieee80211_ht_cap *)
 				elems.ht_cap_elem, &sta->ht_info);
 		ieee80211_ht_addt_info_ie_to_ht_bss_info(
 				(struct ieee80211_ht_addt_info *)
 				elems.ht_info_elem, &bss_info);
-		ieee80211_hw_config_ht(local, 1, &sta->ht_info, &bss_info);
+		ieee80211_handle_ht(local, 1, &sta->ht_info, &bss_info);
 	}
 
 	rate_control_rate_init(sta, local);
@@ -2759,20 +2770,14 @@ static void ieee80211_rx_mgmt_beacon(struct net_device *dev,
 		changed |= ieee80211_handle_erp_ie(sdata, elems.erp_info[0]);
 
 	if (elems.ht_cap_elem && elems.ht_info_elem &&
-	    elems.wmm_param && local->ops->conf_ht &&
-	    conf->flags & IEEE80211_CONF_SUPPORT_HT_MODE) {
+	    elems.wmm_param && conf->flags & IEEE80211_CONF_SUPPORT_HT_MODE) {
 		struct ieee80211_ht_bss_info bss_info;
 
 		ieee80211_ht_addt_info_ie_to_ht_bss_info(
 				(struct ieee80211_ht_addt_info *)
 				elems.ht_info_elem, &bss_info);
-		/* check if AP changed bss inforamation */
-		if ((conf->ht_bss_conf.primary_channel !=
-		     bss_info.primary_channel) ||
-		    (conf->ht_bss_conf.bss_cap != bss_info.bss_cap) ||
-		    (conf->ht_bss_conf.bss_op_mode != bss_info.bss_op_mode))
-			ieee80211_hw_config_ht(local, 1, &conf->ht_conf,
-						&bss_info);
+		changed |= ieee80211_handle_ht(local, 1, &conf->ht_conf,
+					       &bss_info);
 	}
 
 	if (elems.wmm_param && (ifsta->flags & IEEE80211_STA_WMM_ENABLED)) {
-- 
1.5.3.4

