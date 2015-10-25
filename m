Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:7815 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752814AbbJYJAF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Oct 2015 05:00:05 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 05/10] mac80211: make enable_qos parameter to ieee80211_set_wmm_default()
Date: Sun, 25 Oct 2015 10:59:37 +0200
Message-Id: <1445763582-11421-5-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151025_100014_851327_B36F8524)
In-Reply-To: <1445763582-11421-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1445763582-11421-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The function currently determines this value, for use in bss_info.qos,
based on the interface type itself. Make it a parameter instead and
set it with the same logic for now.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ibss.c        |  2 +-
 net/mac80211/ieee80211_i.h |  2 +-
 net/mac80211/iface.c       |  8 +++++---
 net/mac80211/mlme.c        |  4 ++--
 net/mac80211/util.c        | 11 ++---------
 5 files changed, 11 insertions(+), 16 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 3b5874e..337bb5d 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -356,7 +356,7 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 	else
 		sdata->flags &= ~IEEE80211_SDATA_OPERATING_GMODE;
 
-	ieee80211_set_wmm_default(sdata, true);
+	ieee80211_set_wmm_default(sdata, true, false);
 
 	sdata->vif.bss_conf.ibss_joined = true;
 	sdata->vif.bss_conf.ibss_creator = creator;
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 5c76ba7..d832bd5 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1769,7 +1769,7 @@ int ieee80211_frame_duration(enum ieee80211_band band, size_t len,
 			     int rate, int erp, int short_preamble,
 			     int shift);
 void ieee80211_set_wmm_default(struct ieee80211_sub_if_data *sdata,
-			       bool bss_notify);
+			       bool bss_notify, bool enable_qos);
 void ieee80211_xmit(struct ieee80211_sub_if_data *sdata,
 		    struct sta_info *sta, struct sk_buff *skb);
 
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index f848c75..d0dc1bf 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -661,11 +661,13 @@ int ieee80211_do_open(struct wireless_dev *wdev, bool coming_up)
 		}
 
 		/*
-		 * set default queue parameters so drivers don't
+		 * Set default queue parameters so drivers don't
 		 * need to initialise the hardware if the hardware
-		 * doesn't start up with sane defaults
+		 * doesn't start up with sane defaults.
+		 * Enable QoS for anything but station interfaces.
 		 */
-		ieee80211_set_wmm_default(sdata, true);
+		ieee80211_set_wmm_default(sdata, true,
+			sdata->vif.type != NL80211_IFTYPE_STATION);
 	}
 
 	set_bit(SDATA_STATE_RUNNING, &sdata->state);
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index ded4b97..0d0ce5c 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2077,7 +2077,7 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
 	ieee80211_bss_info_change_notify(sdata, changed);
 
 	/* disassociated - set to defaults now */
-	ieee80211_set_wmm_default(sdata, false);
+	ieee80211_set_wmm_default(sdata, false, false);
 
 	del_timer_sync(&sdata->u.mgd.conn_mon_timer);
 	del_timer_sync(&sdata->u.mgd.bcn_mon_timer);
@@ -3048,7 +3048,7 @@ static bool ieee80211_assoc_success(struct ieee80211_sub_if_data *sdata,
 		ieee80211_sta_wmm_params(local, sdata, elems.wmm_param,
 					 elems.wmm_param_len);
 	else
-		ieee80211_set_wmm_default(sdata, false);
+		ieee80211_set_wmm_default(sdata, false, false);
 	changed |= BSS_CHANGED_QOS;
 
 	/* set AID and assoc capability,
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index c51ff91..29c55ce 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1105,13 +1105,13 @@ u32 ieee802_11_parse_elems_crc(const u8 *start, size_t len, bool action,
 }
 
 void ieee80211_set_wmm_default(struct ieee80211_sub_if_data *sdata,
-			       bool bss_notify)
+			       bool bss_notify, bool enable_qos)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_tx_queue_params qparam;
 	struct ieee80211_chanctx_conf *chanctx_conf;
 	int ac;
-	bool use_11b, enable_qos;
+	bool use_11b;
 	bool is_ocb; /* Use another EDCA parameters if dot11OCBActivated=true */
 	int aCWmin, aCWmax;
 
@@ -1130,13 +1130,6 @@ void ieee80211_set_wmm_default(struct ieee80211_sub_if_data *sdata,
 		 !(sdata->flags & IEEE80211_SDATA_OPERATING_GMODE);
 	rcu_read_unlock();
 
-	/*
-	 * By default disable QoS in STA mode for old access points, which do
-	 * not support 802.11e. New APs will provide proper queue parameters,
-	 * that we will configure later.
-	 */
-	enable_qos = (sdata->vif.type != NL80211_IFTYPE_STATION);
-
 	is_ocb = (sdata->vif.type == NL80211_IFTYPE_OCB);
 
 	/* Set defaults according to 802.11-2007 Table 7-37 */
-- 
2.1.4

