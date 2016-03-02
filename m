Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:30993 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751624AbcCBV2r (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Mar 2016 16:28:47 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Arik Nemtsov <arik@wizery.com>,
	Arik Nemtsov <arikx.nemtsov@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 2/3] mac80211: TDLS: change BW calculation for WIDER_BW peers
Date: Wed,  2 Mar 2016 23:28:32 +0200
Message-Id: <1456954113-4682-2-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160302_222850_672768_F8AD4A3E)
In-Reply-To: <1456954113-4682-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1456954113-4682-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

The previous approach simply ignored chandef restrictions when calculating
the appropriate peer BW for a WIDER_BW peer. This could result in a
regulatory violation if both peers indicated 80MHz support, but the
regdomain forbade it.

Change the approach to setting a WIDER_BW peer's BW. Don't exempt it from
the chandef width at first. If during TDLS negotiation the chandef width
is upgraded, update the peer's BW to match.

Fixes: dde4002 ("mac80211: upgrade BW of TDLS peers when possible")
Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/ieee80211_i.h |  4 ++++
 net/mac80211/tdls.c        | 38 ++++++++++++++++++++++++++++++++------
 net/mac80211/vht.c         | 30 +++++++++++++++++++++++++-----
 3 files changed, 61 insertions(+), 11 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 1630975..a602a2a 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1719,6 +1719,10 @@ ieee80211_vht_cap_ie_to_sta_vht_cap(struct ieee80211_sub_if_data *sdata,
 enum ieee80211_sta_rx_bandwidth ieee80211_sta_cap_rx_bw(struct sta_info *sta);
 enum ieee80211_sta_rx_bandwidth ieee80211_sta_cur_vht_bw(struct sta_info *sta);
 void ieee80211_sta_set_rx_nss(struct sta_info *sta);
+enum ieee80211_sta_rx_bandwidth
+ieee80211_chan_width_to_rx_bw(enum nl80211_chan_width width);
+enum nl80211_chan_width ieee80211_sta_cap_chan_bw(struct sta_info *sta);
+void ieee80211_sta_set_rx_nss(struct sta_info *sta);
 void ieee80211_process_mu_groups(struct ieee80211_sub_if_data *sdata,
 				 struct ieee80211_mgmt *mgmt);
 u32 __ieee80211_vht_handle_opmode(struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/tdls.c b/net/mac80211/tdls.c
index 43f13abe..eed1152 100644
--- a/net/mac80211/tdls.c
+++ b/net/mac80211/tdls.c
@@ -4,7 +4,7 @@
  * Copyright 2006-2010	Johannes Berg <johannes@sipsolutions.net>
  * Copyright 2014, Intel Corporation
  * Copyright 2014  Intel Mobile Communications GmbH
- * Copyright 2015  Intel Deutschland GmbH
+ * Copyright 2015 - 2016 Intel Deutschland GmbH
  *
  * This file is GPLv2 as found in COPYING.
  */
@@ -15,6 +15,7 @@
 #include <linux/rtnetlink.h>
 #include "ieee80211_i.h"
 #include "driver-ops.h"
+#include "rate.h"
 
 /* give usermode some time for retries in setting up the TDLS session */
 #define TDLS_PEER_SETUP_TIMEOUT	(15 * HZ)
@@ -302,7 +303,7 @@ ieee80211_tdls_chandef_vht_upgrade(struct ieee80211_sub_if_data *sdata,
 	/* IEEE802.11ac-2013 Table E-4 */
 	u16 centers_80mhz[] = { 5210, 5290, 5530, 5610, 5690, 5775 };
 	struct cfg80211_chan_def uc = sta->tdls_chandef;
-	enum nl80211_chan_width max_width = ieee80211_get_sta_bw(&sta->sta);
+	enum nl80211_chan_width max_width = ieee80211_sta_cap_chan_bw(sta);
 	int i;
 
 	/* only support upgrading non-narrow channels up to 80Mhz */
@@ -1242,18 +1243,44 @@ int ieee80211_tdls_mgmt(struct wiphy *wiphy, struct net_device *dev,
 	return ret;
 }
 
-static void iee80211_tdls_recalc_chanctx(struct ieee80211_sub_if_data *sdata)
+static void iee80211_tdls_recalc_chanctx(struct ieee80211_sub_if_data *sdata,
+					 struct sta_info *sta)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_chanctx_conf *conf;
 	struct ieee80211_chanctx *ctx;
+	enum nl80211_chan_width width;
+	struct ieee80211_supported_band *sband;
 
 	mutex_lock(&local->chanctx_mtx);
 	conf = rcu_dereference_protected(sdata->vif.chanctx_conf,
 					 lockdep_is_held(&local->chanctx_mtx));
 	if (conf) {
+		width = conf->def.width;
+		sband = local->hw.wiphy->bands[conf->def.chan->band];
 		ctx = container_of(conf, struct ieee80211_chanctx, conf);
 		ieee80211_recalc_chanctx_chantype(local, ctx);
+
+		/* if width changed and a peer is given, update its BW */
+		if (width != conf->def.width && sta &&
+		    test_sta_flag(sta, WLAN_STA_TDLS_WIDER_BW)) {
+			enum ieee80211_sta_rx_bandwidth bw;
+
+			bw = ieee80211_chan_width_to_rx_bw(conf->def.width);
+			bw = min(bw, ieee80211_sta_cap_rx_bw(sta));
+			if (bw != sta->sta.bandwidth) {
+				sta->sta.bandwidth = bw;
+				rate_control_rate_update(local, sband, sta,
+							 IEEE80211_RC_BW_CHANGED);
+				/*
+				 * if a TDLS peer BW was updated, we need to
+				 * recalc the chandef width again, to get the
+				 * correct chanctx min_def
+				 */
+				ieee80211_recalc_chanctx_chantype(local, ctx);
+			}
+		}
+
 	}
 	mutex_unlock(&local->chanctx_mtx);
 }
@@ -1350,8 +1377,6 @@ int ieee80211_tdls_oper(struct wiphy *wiphy, struct net_device *dev,
 			break;
 		}
 
-		iee80211_tdls_recalc_chanctx(sdata);
-
 		mutex_lock(&local->sta_mtx);
 		sta = sta_info_get(sdata, peer);
 		if (!sta) {
@@ -1360,6 +1385,7 @@ int ieee80211_tdls_oper(struct wiphy *wiphy, struct net_device *dev,
 			break;
 		}
 
+		iee80211_tdls_recalc_chanctx(sdata, sta);
 		iee80211_tdls_recalc_ht_protection(sdata, sta);
 
 		set_sta_flag(sta, WLAN_STA_TDLS_PEER_AUTH);
@@ -1390,7 +1416,7 @@ int ieee80211_tdls_oper(struct wiphy *wiphy, struct net_device *dev,
 		iee80211_tdls_recalc_ht_protection(sdata, NULL);
 		mutex_unlock(&local->sta_mtx);
 
-		iee80211_tdls_recalc_chanctx(sdata);
+		iee80211_tdls_recalc_chanctx(sdata, NULL);
 		break;
 	default:
 		ret = -ENOTSUPP;
diff --git a/net/mac80211/vht.c b/net/mac80211/vht.c
index 89e04d5..e590e2e 100644
--- a/net/mac80211/vht.c
+++ b/net/mac80211/vht.c
@@ -319,7 +319,30 @@ enum ieee80211_sta_rx_bandwidth ieee80211_sta_cap_rx_bw(struct sta_info *sta)
 	return IEEE80211_STA_RX_BW_80;
 }
 
-static enum ieee80211_sta_rx_bandwidth
+enum nl80211_chan_width ieee80211_sta_cap_chan_bw(struct sta_info *sta)
+{
+	struct ieee80211_sta_vht_cap *vht_cap = &sta->sta.vht_cap;
+	u32 cap_width;
+
+	if (!vht_cap->vht_supported) {
+		if (!sta->sta.ht_cap.ht_supported)
+			return NL80211_CHAN_WIDTH_20_NOHT;
+
+		return sta->sta.ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40 ?
+				NL80211_CHAN_WIDTH_40 : NL80211_CHAN_WIDTH_20;
+	}
+
+	cap_width = vht_cap->cap & IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_MASK;
+
+	if (cap_width == IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160MHZ)
+		return NL80211_CHAN_WIDTH_160;
+	else if (cap_width == IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160_80PLUS80MHZ)
+		return NL80211_CHAN_WIDTH_80P80;
+
+	return NL80211_CHAN_WIDTH_80;
+}
+
+enum ieee80211_sta_rx_bandwidth
 ieee80211_chan_width_to_rx_bw(enum nl80211_chan_width width)
 {
 	switch (width) {
@@ -347,10 +370,7 @@ enum ieee80211_sta_rx_bandwidth ieee80211_sta_cur_vht_bw(struct sta_info *sta)
 
 	bw = ieee80211_sta_cap_rx_bw(sta);
 	bw = min(bw, sta->cur_max_bandwidth);
-
-	/* do not cap the BW of TDLS WIDER_BW peers by the bss */
-	if (!test_sta_flag(sta, WLAN_STA_TDLS_WIDER_BW))
-		bw = min(bw, ieee80211_chan_width_to_rx_bw(bss_width));
+	bw = min(bw, ieee80211_chan_width_to_rx_bw(bss_width));
 
 	return bw;
 }
-- 
2.5.0

