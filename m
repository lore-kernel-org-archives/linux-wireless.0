Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:47198 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753446AbbGBOZA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jul 2015 10:25:00 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	Krishna Chaitanya <chaitanya.mgit@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 2/4] mac80211: make enable_qos parameter to ieee80211_set_wmm_default()
Date: Thu,  2 Jul 2015 16:24:54 +0200
Message-Id: <1435847096-5750-2-git-send-email-johannes@sipsolutions.net> (sfid-20150702_162507_669925_6C0A1C7F)
In-Reply-To: <1435847096-5750-1-git-send-email-johannes@sipsolutions.net>
References: <1435847096-5750-1-git-send-email-johannes@sipsolutions.net>
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
index 7f72bc9bae2e..281bd747e72f 100644
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
index b12f61507f9f..e54dfebe27fe 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1772,7 +1772,7 @@ void mac80211_ev_michael_mic_failure(struct ieee80211_sub_if_data *sdata, int ke
 				     struct ieee80211_hdr *hdr, const u8 *tsc,
 				     gfp_t gfp);
 void ieee80211_set_wmm_default(struct ieee80211_sub_if_data *sdata,
-			       bool bss_notify);
+			       bool bss_notify, bool enable_qos);
 void ieee80211_xmit(struct ieee80211_sub_if_data *sdata,
 		    struct sta_info *sta, struct sk_buff *skb);
 
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index ed1edac14372..f7e62cebc63d 100644
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
index 7d195fc47675..9c7ed4b38c83 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2101,7 +2101,7 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
 	ieee80211_bss_info_change_notify(sdata, changed);
 
 	/* disassociated - set to defaults now */
-	ieee80211_set_wmm_default(sdata, false);
+	ieee80211_set_wmm_default(sdata, false, false);
 
 	del_timer_sync(&sdata->u.mgd.conn_mon_timer);
 	del_timer_sync(&sdata->u.mgd.bcn_mon_timer);
@@ -3077,7 +3077,7 @@ static bool ieee80211_assoc_success(struct ieee80211_sub_if_data *sdata,
 		ieee80211_sta_wmm_params(local, sdata, elems.wmm_param,
 					 elems.wmm_param_len);
 	else
-		ieee80211_set_wmm_default(sdata, false);
+		ieee80211_set_wmm_default(sdata, false, false);
 	changed |= BSS_CHANGED_QOS;
 
 	/* set AID and assoc capability,
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 43e5aadd7a89..a83cbd5b0a3b 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1148,13 +1148,13 @@ u32 ieee802_11_parse_elems_crc(const u8 *start, size_t len, bool action,
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
 
@@ -1173,13 +1173,6 @@ void ieee80211_set_wmm_default(struct ieee80211_sub_if_data *sdata,
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

