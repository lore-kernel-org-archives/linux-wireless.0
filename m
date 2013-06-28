Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:45837 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755354Ab3F1Ike (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Jun 2013 04:40:34 -0400
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCH 2/2] mac80211: enable HT overrides for ibss
Date: Fri, 28 Jun 2013 10:39:59 +0200
Message-Id: <1372408799-25651-2-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130628_104123_505507_29BCC1C7)
In-Reply-To: <1372408799-25651-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1372408799-25651-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
---
 net/mac80211/ht.c          |   53 +++++++++++++++++++++++++++++++-------------
 net/mac80211/ibss.c        |   18 +++++++++++++--
 net/mac80211/ieee80211_i.h |    3 +++
 3 files changed, 57 insertions(+), 17 deletions(-)

diff --git a/net/mac80211/ht.c b/net/mac80211/ht.c
index f83534f..529bf58 100644
--- a/net/mac80211/ht.c
+++ b/net/mac80211/ht.c
@@ -19,13 +19,14 @@
 #include "ieee80211_i.h"
 #include "rate.h"
 
-static void __check_htcap_disable(struct ieee80211_sub_if_data *sdata,
+static void __check_htcap_disable(struct ieee80211_ht_cap *ht_capa,
+				  struct ieee80211_ht_cap *ht_capa_mask,
 				  struct ieee80211_sta_ht_cap *ht_cap,
 				  u16 flag)
 {
 	__le16 le_flag = cpu_to_le16(flag);
-	if (sdata->u.mgd.ht_capa_mask.cap_info & le_flag) {
-		if (!(sdata->u.mgd.ht_capa.cap_info & le_flag))
+	if (ht_capa_mask->cap_info & le_flag) {
+		if (!(ht_capa->cap_info & le_flag))
 			ht_cap->cap &= ~flag;
 	}
 }
@@ -33,13 +34,30 @@ static void __check_htcap_disable(struct ieee80211_sub_if_data *sdata,
 void ieee80211_apply_htcap_overrides(struct ieee80211_sub_if_data *sdata,
 				     struct ieee80211_sta_ht_cap *ht_cap)
 {
-	u8 *scaps = (u8 *)(&sdata->u.mgd.ht_capa.mcs.rx_mask);
-	u8 *smask = (u8 *)(&sdata->u.mgd.ht_capa_mask.mcs.rx_mask);
+	struct ieee80211_ht_cap *ht_capa, *ht_capa_mask;
+	u8 *scaps, *smask;
 	int i;
 
 	if (!ht_cap->ht_supported)
 		return;
 
+	switch (sdata->vif.type) {
+	case NL80211_IFTYPE_STATION:
+		ht_capa = &sdata->u.mgd.ht_capa;
+		ht_capa_mask = &sdata->u.mgd.ht_capa_mask;
+		break;
+	case NL80211_IFTYPE_ADHOC:
+		ht_capa = &sdata->u.ibss.ht_capa;
+		ht_capa_mask = &sdata->u.ibss.ht_capa_mask;
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		return;
+	}
+
+	scaps = (u8 *)(&ht_capa->mcs.rx_mask);
+	smask = (u8 *)(&ht_capa_mask->mcs.rx_mask);
+
 	/* NOTE:  If you add more over-rides here, update register_hw
 	 * ht_capa_mod_msk logic in main.c as well.
 	 * And, if this method can ever change ht_cap.ht_supported, fix
@@ -55,28 +73,32 @@ void ieee80211_apply_htcap_overrides(struct ieee80211_sub_if_data *sdata,
 	}
 
 	/* Force removal of HT-40 capabilities? */
-	__check_htcap_disable(sdata, ht_cap, IEEE80211_HT_CAP_SUP_WIDTH_20_40);
-	__check_htcap_disable(sdata, ht_cap, IEEE80211_HT_CAP_SGI_40);
+	__check_htcap_disable(ht_capa, ht_capa_mask, ht_cap,
+			      IEEE80211_HT_CAP_SUP_WIDTH_20_40);
+	__check_htcap_disable(ht_capa, ht_capa_mask, ht_cap,
+			      IEEE80211_HT_CAP_SGI_40);
 
 	/* Allow user to disable SGI-20 (SGI-40 is handled above) */
-	__check_htcap_disable(sdata, ht_cap, IEEE80211_HT_CAP_SGI_20);
+	__check_htcap_disable(ht_capa, ht_capa_mask, ht_cap,
+			      IEEE80211_HT_CAP_SGI_20);
 
 	/* Allow user to disable the max-AMSDU bit. */
-	__check_htcap_disable(sdata, ht_cap, IEEE80211_HT_CAP_MAX_AMSDU);
+	__check_htcap_disable(ht_capa, ht_capa_mask, ht_cap,
+			      IEEE80211_HT_CAP_MAX_AMSDU);
 
 	/* Allow user to decrease AMPDU factor */
-	if (sdata->u.mgd.ht_capa_mask.ampdu_params_info &
+	if (ht_capa_mask->ampdu_params_info &
 	    IEEE80211_HT_AMPDU_PARM_FACTOR) {
-		u8 n = sdata->u.mgd.ht_capa.ampdu_params_info
-			& IEEE80211_HT_AMPDU_PARM_FACTOR;
+		u8 n = ht_capa->ampdu_params_info &
+		       IEEE80211_HT_AMPDU_PARM_FACTOR;
 		if (n < ht_cap->ampdu_factor)
 			ht_cap->ampdu_factor = n;
 	}
 
 	/* Allow the user to increase AMPDU density. */
-	if (sdata->u.mgd.ht_capa_mask.ampdu_params_info &
+	if (ht_capa_mask->ampdu_params_info &
 	    IEEE80211_HT_AMPDU_PARM_DENSITY) {
-		u8 n = (sdata->u.mgd.ht_capa.ampdu_params_info &
+		u8 n = (ht_capa->ampdu_params_info &
 			IEEE80211_HT_AMPDU_PARM_DENSITY)
 			>> IEEE80211_HT_AMPDU_PARM_DENSITY_SHIFT;
 		if (n > ht_cap->ampdu_density)
@@ -112,7 +134,8 @@ bool ieee80211_ht_cap_ie_to_sta_ht_cap(struct ieee80211_sub_if_data *sdata,
 	 * we advertised a restricted capability set to. Override
 	 * our own capabilities and then use those below.
 	 */
-	if (sdata->vif.type == NL80211_IFTYPE_STATION &&
+	if ((sdata->vif.type == NL80211_IFTYPE_STATION ||
+	     sdata->vif.type == NL80211_IFTYPE_ADHOC) &&
 	    !test_sta_flag(sta, WLAN_STA_TDLS_PEER))
 		ieee80211_apply_htcap_overrides(sdata, &own_cap);
 
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index ea7b9c2..25e6998 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -179,8 +179,12 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 	    chandef.width != NL80211_CHAN_WIDTH_5 &&
 	    chandef.width != NL80211_CHAN_WIDTH_10 &&
 	    sband->ht_cap.ht_supported) {
-		pos = ieee80211_ie_build_ht_cap(pos, &sband->ht_cap,
-						sband->ht_cap.cap);
+		struct ieee80211_sta_ht_cap ht_cap;
+
+		memcpy(&ht_cap, &sband->ht_cap, sizeof(ht_cap));
+		ieee80211_apply_htcap_overrides(sdata, &ht_cap);
+
+		pos = ieee80211_ie_build_ht_cap(pos, &ht_cap, ht_cap.cap);
 		/*
 		 * Note: According to 802.11n-2009 9.13.3.1, HT Protection
 		 * field and RIFS Mode are reserved in IBSS mode, therefore
@@ -1051,6 +1055,11 @@ int ieee80211_ibss_join(struct ieee80211_sub_if_data *sdata,
 	memcpy(sdata->u.ibss.ssid, params->ssid, params->ssid_len);
 	sdata->u.ibss.ssid_len = params->ssid_len;
 
+	memcpy(&sdata->u.ibss.ht_capa, &params->ht_capa,
+	       sizeof(sdata->u.ibss.ht_capa));
+	memcpy(&sdata->u.ibss.ht_capa_mask, &params->ht_capa_mask,
+	       sizeof(sdata->u.ibss.ht_capa_mask));
+
 	/*
 	 * 802.11n-2009 9.13.3.1: In an IBSS, the HT Protection field is
 	 * reserved, but an HT STA shall protect HT transmissions as though
@@ -1131,6 +1140,11 @@ int ieee80211_ibss_leave(struct ieee80211_sub_if_data *sdata)
 	presp = rcu_dereference_protected(ifibss->presp,
 					  lockdep_is_held(&sdata->wdev.mtx));
 	RCU_INIT_POINTER(sdata->u.ibss.presp, NULL);
+
+	/* on the next assoc, re-program HT parameters */
+	memset(&ifibss->ht_capa, 0, sizeof(ifibss->ht_capa));
+	memset(&ifibss->ht_capa_mask, 0, sizeof(ifibss->ht_capa_mask));
+
 	sdata->vif.bss_conf.ibss_joined = false;
 	sdata->vif.bss_conf.ibss_creator = false;
 	sdata->vif.bss_conf.enable_beacon = false;
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 8412a30..683751a 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -509,6 +509,9 @@ struct ieee80211_if_ibss {
 	/* probe response/beacon for IBSS */
 	struct beacon_data __rcu *presp;
 
+	struct ieee80211_ht_cap ht_capa; /* configured ht-cap over-rides */
+	struct ieee80211_ht_cap ht_capa_mask; /* Valid parts of ht_capa */
+
 	spinlock_t incomplete_lock;
 	struct list_head incomplete_stations;
 
-- 
1.7.10.4

