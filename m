Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:42747 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756125AbXKNPgG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Nov 2007 10:36:06 -0500
From: Ron Rindjunsky <ron.rindjunsky@intel.com>
To: linville@tuxdriver.com
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: [PATCH 07/15] mac80211: adding 802.11n configuration flows
Date: Wed, 14 Nov 2007 17:29:43 +0200
Message-Id: <11950542011413-git-send-email-ron.rindjunsky@intel.com> (sfid-20071114_153620_840496_E99105DD)
In-Reply-To: <11950541913679-git-send-email-ron.rindjunsky@intel.com>
References: <11950541913679-git-send-email-ron.rindjunsky@intel.com>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch configures the 802.11n mode of operation
internally in ieee80211_conf structure and in the low-level
driver as well (through op conf_ht).
It does not include AP configuration flows.

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
---
 include/net/mac80211.h       |    3 ++
 net/mac80211/ieee80211.c     |   51 ++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/ieee80211_i.h   |    3 ++
 net/mac80211/ieee80211_sta.c |   32 ++++++++++++++++++++++++++
 4 files changed, 89 insertions(+), 0 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 862431a..2fcf9f3 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1040,6 +1040,8 @@ enum ieee80211_erp_change_flags {
  * @tx_last_beacon: Determine whether the last IBSS beacon was sent by us.
  *	This is needed only for IBSS mode and the result of this function is
  *	used to determine whether to reply to Probe Requests.
+ *
+ * @conf_ht: Configures low level driver with 802.11n HT data. Must be atomic.
  */
 struct ieee80211_ops {
 	int (*tx)(struct ieee80211_hw *hw, struct sk_buff *skb,
@@ -1085,6 +1087,7 @@ struct ieee80211_ops {
 			     struct sk_buff *skb,
 			     struct ieee80211_tx_control *control);
 	int (*tx_last_beacon)(struct ieee80211_hw *hw);
+	int (*conf_ht)(struct ieee80211_hw *hw, struct ieee80211_conf *conf);
 };
 
 /**
diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
index e0ee65a..bcfc771 100644
--- a/net/mac80211/ieee80211.c
+++ b/net/mac80211/ieee80211.c
@@ -34,6 +34,8 @@
 #include "debugfs.h"
 #include "debugfs_netdev.h"
 
+#define SUPP_MCS_SET_LEN 16
+
 /*
  * For seeing transmitted packets on monitor interfaces
  * we have a radiotap header too.
@@ -534,6 +536,55 @@ int ieee80211_hw_config(struct ieee80211_local *local)
 	return ret;
 }
 
+/**
+ * ieee80211_hw_config_ht should be used only after legacy configuration
+ * has been determined, as ht configuration depends upon the hardware's
+ * HT abilities for a _specific_ band.
+ */
+int ieee80211_hw_config_ht(struct ieee80211_local *local, int enable_ht,
+			   struct ieee80211_ht_info *req_ht_cap,
+			   struct ieee80211_ht_bss_info *req_bss_cap)
+{
+	struct ieee80211_conf *conf = &local->hw.conf;
+	struct ieee80211_hw_mode *mode = conf->mode;
+	int i;
+
+	/* HT is not supported */
+	if (!mode->ht_info.ht_supported) {
+		conf->flags &= ~IEEE80211_CONF_SUPPORT_HT_MODE;
+		return -EOPNOTSUPP;
+	}
+
+	/* disable HT */
+	if (!enable_ht) {
+		conf->flags &= ~IEEE80211_CONF_SUPPORT_HT_MODE;
+	} else {
+		conf->flags |= IEEE80211_CONF_SUPPORT_HT_MODE;
+		conf->ht_conf.cap = req_ht_cap->cap & mode->ht_info.cap;
+		conf->ht_conf.cap &= ~(IEEE80211_HT_CAP_MIMO_PS);
+		conf->ht_conf.cap |=
+			mode->ht_info.cap & IEEE80211_HT_CAP_MIMO_PS;
+		conf->ht_bss_conf.primary_channel =
+			req_bss_cap->primary_channel;
+		conf->ht_bss_conf.bss_cap = req_bss_cap->bss_cap;
+		conf->ht_bss_conf.bss_op_mode = req_bss_cap->bss_op_mode;
+		for (i = 0; i < SUPP_MCS_SET_LEN; i++)
+			conf->ht_conf.supp_mcs_set[i] =
+				mode->ht_info.supp_mcs_set[i] &
+				  req_ht_cap->supp_mcs_set[i];
+
+		/* In STA mode, this gives us indication
+		 * to the AP's mode of operation */
+		conf->ht_conf.ht_supported = 1;
+		conf->ht_conf.ampdu_factor = req_ht_cap->ampdu_factor;
+		conf->ht_conf.ampdu_density = req_ht_cap->ampdu_density;
+	}
+
+	local->ops->conf_ht(local_to_hw(local), &local->hw.conf);
+
+	return 0;
+}
+
 void ieee80211_erp_info_change_notify(struct net_device *dev, u8 changes)
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 5175054..b5cd899 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -709,6 +709,9 @@ int ieee80211_if_update_wds(struct net_device *dev, u8 *remote_addr);
 void ieee80211_if_setup(struct net_device *dev);
 struct ieee80211_rate *ieee80211_get_rate(struct ieee80211_local *local,
 					  int phymode, int hwrate);
+int ieee80211_hw_config_ht(struct ieee80211_local *local, int enable_ht,
+			   struct ieee80211_ht_info *req_ht_cap,
+			   struct ieee80211_ht_bss_info *req_bss_cap);
 
 /* ieee80211_ioctl.c */
 extern const struct iw_handler_def ieee80211_iw_handler_def;
diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
index e02a908..863957c 100644
--- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -1441,6 +1441,19 @@ static void ieee80211_rx_mgmt_assoc_resp(struct net_device *dev,
 	}
 	sta->supp_rates = rates;
 
+	if (elems.ht_cap_elem && elems.ht_info_elem && elems.wmm_param &&
+	    local->ops->conf_ht) {
+		struct ieee80211_ht_bss_info bss_info;
+
+		ieee80211_ht_cap_ie_to_ht_info(
+				(struct ieee80211_ht_cap *)
+				elems.ht_cap_elem, &sta->ht_info);
+		ieee80211_ht_addt_info_ie_to_ht_bss_info(
+				(struct ieee80211_ht_addt_info *)
+				elems.ht_info_elem, &bss_info);
+		ieee80211_hw_config_ht(local, 1, &sta->ht_info, &bss_info);
+	}
+
 	rate_control_rate_init(sta, local);
 
 	if (elems.wmm_param && (ifsta->flags & IEEE80211_STA_WMM_ENABLED)) {
@@ -1853,6 +1866,8 @@ static void ieee80211_rx_mgmt_beacon(struct net_device *dev,
 	struct ieee80211_if_sta *ifsta;
 	size_t baselen;
 	struct ieee802_11_elems elems;
+	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_conf *conf = &local->hw.conf;
 
 	ieee80211_rx_bss_info(dev, mgmt, len, rx_status, 1);
 
@@ -1875,6 +1890,23 @@ static void ieee80211_rx_mgmt_beacon(struct net_device *dev,
 	if (elems.erp_info && elems.erp_info_len >= 1)
 		ieee80211_handle_erp_ie(dev, elems.erp_info[0]);
 
+	if (elems.ht_cap_elem && elems.ht_info_elem &&
+	    elems.wmm_param && local->ops->conf_ht &&
+	    conf->flags & IEEE80211_CONF_SUPPORT_HT_MODE) {
+		struct ieee80211_ht_bss_info bss_info;
+
+		ieee80211_ht_addt_info_ie_to_ht_bss_info(
+				(struct ieee80211_ht_addt_info *)
+				elems.ht_info_elem, &bss_info);
+		/* check if AP changed bss inforamation */
+		if ((conf->ht_bss_conf.primary_channel !=
+		     bss_info.primary_channel) ||
+		    (conf->ht_bss_conf.bss_cap != bss_info.bss_cap) ||
+		    (conf->ht_bss_conf.bss_op_mode != bss_info.bss_op_mode))
+			ieee80211_hw_config_ht(local, 1, &conf->ht_conf,
+						&bss_info);
+	}
+
 	if (elems.wmm_param && (ifsta->flags & IEEE80211_STA_WMM_ENABLED)) {
 		ieee80211_sta_wmm_params(dev, ifsta, elems.wmm_param,
 					 elems.wmm_param_len);
-- 
1.5.3.3
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
