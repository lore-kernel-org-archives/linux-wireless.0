Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f170.google.com ([209.85.223.170]:62393 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933266Ab3CTTNp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Mar 2013 15:13:45 -0400
Received: by mail-ie0-f170.google.com with SMTP id c11so2553564ieb.15
        for <linux-wireless@vger.kernel.org>; Wed, 20 Mar 2013 12:13:45 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 20 Mar 2013 20:13:45 +0100
Message-ID: <CAFED-j=tNHkbwt9R6qSBNtZ2pTFvtt5pzOaLOOPTf8Sxg5nvVQ@mail.gmail.com> (sfid-20130320_201354_988083_95B199CF)
Subject: [PATCH 3/4] mac80211: P2P add NOA settings
From: Janusz Dziedzic <janusz.dziedzic@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add P2P NOA settings for STA mode.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 include/net/mac80211.h     |    3 +--
 net/mac80211/cfg.c         |   21 ++++++++++++++++-----
 net/mac80211/ieee80211_i.h |    2 +-
 net/mac80211/mlme.c        |   45 ++++++++++++++++++++++++--------------------
 net/mac80211/trace.h       |    6 ++----
 5 files changed, 45 insertions(+), 32 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index cdd7cea..582e743 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -363,8 +363,7 @@ struct ieee80211_bss_conf {
 	size_t ssid_len;
 	bool hidden_ssid;
 	int txpower;
-	u8 p2p_ctwindow;
-	bool p2p_oppps;
+	struct ieee80211_p2p_noa_attr p2p_noa_attr;
 };

 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 1d1ddab..e9cf6c2 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -960,8 +960,11 @@ static int ieee80211_start_ap(struct wiphy
*wiphy, struct net_device *dev,
 	sdata->vif.bss_conf.hidden_ssid =
 		(params->hidden_ssid != NL80211_HIDDEN_SSID_NOT_IN_USE);

-	sdata->vif.bss_conf.p2p_ctwindow = params->p2p_ctwindow;
-	sdata->vif.bss_conf.p2p_oppps = params->p2p_opp_ps;
+	sdata->vif.bss_conf.p2p_noa_attr.oppps_ctwindow =
+		params->p2p_ctwindow & IEEE80211_P2P_OPPPS_CTWINDOW_MASK;
+	if (params->p2p_opp_ps)
+		sdata->vif.bss_conf.p2p_noa_attr.oppps_ctwindow |=
+					IEEE80211_P2P_OPPPS_ENABLE_BIT;

 	err = ieee80211_assign_beacon(sdata, &params->beacon);
 	if (err < 0)
@@ -1956,12 +1959,20 @@ static int ieee80211_change_bss(struct wiphy *wiphy,
 	}

 	if (params->p2p_ctwindow >= 0) {
-		sdata->vif.bss_conf.p2p_ctwindow = params->p2p_ctwindow;
+		sdata->vif.bss_conf.p2p_noa_attr.oppps_ctwindow &=
+					~IEEE80211_P2P_OPPPS_CTWINDOW_MASK;
+		sdata->vif.bss_conf.p2p_noa_attr.oppps_ctwindow |=
+			params->p2p_ctwindow & IEEE80211_P2P_OPPPS_CTWINDOW_MASK;
 		changed |= BSS_CHANGED_P2P_PS;
 	}

-	if (params->p2p_opp_ps >= 0) {
-		sdata->vif.bss_conf.p2p_oppps = params->p2p_opp_ps;
+	if (params->p2p_opp_ps > 0) {
+		sdata->vif.bss_conf.p2p_noa_attr.oppps_ctwindow |=
+					IEEE80211_P2P_OPPPS_ENABLE_BIT;
+		changed |= BSS_CHANGED_P2P_PS;
+	} else if (params->p2p_opp_ps == 0) {
+		sdata->vif.bss_conf.p2p_noa_attr.oppps_ctwindow &=
+					~IEEE80211_P2P_OPPPS_ENABLE_BIT;
 		changed |= BSS_CHANGED_P2P_PS;
 	}

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index f4433f0..11451ee 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -442,7 +442,7 @@ struct ieee80211_if_managed {

 	u8 use_4addr;

-	u8 p2p_noa_index;
+	s16 p2p_noa_index;

 	/* Signal strength from the last Beacon frame in the current BSS. */
 	int last_beacon_signal;
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 14612cd..54d0338 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1655,20 +1655,17 @@ static void ieee80211_set_associated(struct
ieee80211_sub_if_data *sdata,
 		rcu_read_lock();
 		ies = rcu_dereference(cbss->ies);
 		if (ies) {
-			struct ieee80211_p2p_noa_attr noa;
 			int ret;

 			ret = cfg80211_get_p2p_attr(
 					ies->data, ies->len,
 					IEEE80211_P2P_ATTR_ABSENCE_NOTICE,
-					(u8 *) &noa, sizeof(noa));
+					(u8 *) &bss_conf->p2p_noa_attr,
+					sizeof(bss_conf->p2p_noa_attr));
 			if (ret >= 2) {
-				bss_conf->p2p_oppps = noa.oppps_ctwindow &
-						IEEE80211_P2P_OPPPS_ENABLE_BIT;
-				bss_conf->p2p_ctwindow = noa.oppps_ctwindow &
-						IEEE80211_P2P_OPPPS_CTWINDOW_MASK;
+				sdata->u.mgd.p2p_noa_index =
+					bss_conf->p2p_noa_attr.index;
 				bss_info_changed |= BSS_CHANGED_P2P_PS;
-				sdata->u.mgd.p2p_noa_index = noa.index;
 			}
 		}
 		rcu_read_unlock();
@@ -1793,8 +1790,9 @@ static void ieee80211_set_disassoc(struct
ieee80211_sub_if_data *sdata,
 	changed |= BSS_CHANGED_ASSOC;
 	sdata->vif.bss_conf.assoc = false;

-	sdata->vif.bss_conf.p2p_ctwindow = 0;
-	sdata->vif.bss_conf.p2p_oppps = false;
+	ifmgd->p2p_noa_index = -1;
+	memset(&sdata->vif.bss_conf.p2p_noa_attr, 0,
+	       sizeof(sdata->vif.bss_conf.p2p_noa_attr));

 	/* on the next assoc, re-program HT/VHT parameters */
 	memset(&ifmgd->ht_capa, 0, sizeof(ifmgd->ht_capa));
@@ -2955,24 +2953,30 @@ ieee80211_rx_mgmt_beacon(struct
ieee80211_sub_if_data *sdata,
 	}

 	if (sdata->vif.p2p) {
-		struct ieee80211_p2p_noa_attr noa;
+		struct ieee80211_p2p_noa_attr noa = {};
 		int ret;

 		ret = cfg80211_get_p2p_attr(mgmt->u.beacon.variable,
 					    len - baselen,
 					    IEEE80211_P2P_ATTR_ABSENCE_NOTICE,
 					    (u8 *) &noa, sizeof(noa));
-		if (ret >= 2 && sdata->u.mgd.p2p_noa_index != noa.index) {
-			bss_conf->p2p_oppps = noa.oppps_ctwindow &
-						IEEE80211_P2P_OPPPS_ENABLE_BIT;
-			bss_conf->p2p_ctwindow = noa.oppps_ctwindow &
-						IEEE80211_P2P_OPPPS_CTWINDOW_MASK;
+		if (ret >= 2) {
+			if (sdata->u.mgd.p2p_noa_index != noa.index) {
+				/* valid noa_attr and index changed */
+				sdata->u.mgd.p2p_noa_index = noa.index;
+				memcpy(&bss_conf->p2p_noa_attr, &noa, sizeof(noa));
+				changed |= BSS_CHANGED_P2P_PS;
+				/*
+				 * make sure we update all information, the CRC
+				 * mechanism doesn't look at P2P attributes.
+				 */
+				ifmgd->beacon_crc_valid = false;
+			}
+		} else if (sdata->u.mgd.p2p_noa_index != -1) {
+			/* noa_attr not found and we had valid noa_attr before */
+			sdata->u.mgd.p2p_noa_index = -1;
+			memset(&bss_conf->p2p_noa_attr, 0, sizeof(bss_conf->p2p_noa_attr));
 			changed |= BSS_CHANGED_P2P_PS;
-			sdata->u.mgd.p2p_noa_index = noa.index;
-			/*
-			 * make sure we update all information, the CRC
-			 * mechanism doesn't look at P2P attributes.
-			 */
 			ifmgd->beacon_crc_valid = false;
 		}
 	}
@@ -3515,6 +3519,7 @@ void ieee80211_sta_setup_sdata(struct
ieee80211_sub_if_data *sdata)
 	ifmgd->powersave = sdata->wdev.ps;
 	ifmgd->uapsd_queues = IEEE80211_DEFAULT_UAPSD_QUEUES;
 	ifmgd->uapsd_max_sp_len = IEEE80211_DEFAULT_MAX_SP_LEN;
+	ifmgd->p2p_noa_index = -1;

 	mutex_init(&ifmgd->mtx);

diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index e7db2b8..b9322b5 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -359,8 +359,7 @@ TRACE_EVENT(drv_bss_info_changed,
 		__dynamic_array(u8, ssid, info->ssid_len);
 		__field(bool, hidden_ssid);
 		__field(int, txpower)
-		__field(u8, p2p_ctwindow)
-		__field(bool, p2p_oppps)
+		__field(u8, p2p_oppps_ctwindow)
 	),

 	TP_fast_assign(
@@ -400,8 +399,7 @@ TRACE_EVENT(drv_bss_info_changed,
 		memcpy(__get_dynamic_array(ssid), info->ssid, info->ssid_len);
 		__entry->hidden_ssid = info->hidden_ssid;
 		__entry->txpower = info->txpower;
-		__entry->p2p_ctwindow = info->p2p_ctwindow;
-		__entry->p2p_oppps = info->p2p_oppps;
+		__entry->p2p_oppps_ctwindow = info->p2p_noa_attr.oppps_ctwindow;
 	),

 	TP_printk(
-- 
1.7.9.5
