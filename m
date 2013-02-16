Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-da0-f48.google.com ([209.85.210.48]:34823 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753965Ab3BPSmR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Feb 2013 13:42:17 -0500
Received: by mail-da0-f48.google.com with SMTP id v40so1857617dad.35
        for <linux-wireless@vger.kernel.org>; Sat, 16 Feb 2013 10:42:16 -0800 (PST)
From: Thomas Pedersen <thomas@cozybit.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH 1/3] mac80211: clean up mesh HT operation
Date: Sat, 16 Feb 2013 10:41:04 -0800
Message-Id: <1361040066-5771-1-git-send-email-thomas@cozybit.com> (sfid-20130216_194226_139310_2AC0F9F9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ieee80211_ht_cap_ie_to_sta_ht_cap() will clean up the
ht_supported flag and station bandwidth field for us
if the peer beacon doesn't have an HT capability element
(is operating as non-HT).

Also, we don't really need a special station ch_width
member to track the station operating mode any more so use
sta.bandwidth instead.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 net/mac80211/mesh_plink.c |   62 ++++++++++++++++++---------------------------
 net/mac80211/sta_info.h   |    2 --
 2 files changed, 24 insertions(+), 40 deletions(-)

diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 0b58e81..d74bdf9 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -129,7 +129,6 @@ static u32 mesh_set_ht_prot_mode(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct sta_info *sta;
-	u32 changed = 0;
 	u16 ht_opmode;
 	bool non_ht_sta = false, ht20_sta = false;
 
@@ -142,23 +141,19 @@ static u32 mesh_set_ht_prot_mode(struct ieee80211_sub_if_data *sdata)
 		    sta->plink_state != NL80211_PLINK_ESTAB)
 			continue;
 
-		switch (sta->ch_width) {
-		case NL80211_CHAN_WIDTH_20_NOHT:
-			mpl_dbg(sdata,
-				"mesh_plink %pM: nonHT sta (%pM) is present\n",
-				sdata->vif.addr, sta->sta.addr);
+		if (sta->sta.bandwidth > IEEE80211_STA_RX_BW_20)
+			continue;
+
+		if (!sta->sta.ht_cap.ht_supported) {
+			mpl_dbg(sdata, "nonHT sta (%pM) is present\n",
+				       sta->sta.addr);
 			non_ht_sta = true;
-			goto out;
-		case NL80211_CHAN_WIDTH_20:
-			mpl_dbg(sdata,
-				"mesh_plink %pM: HT20 sta (%pM) is present\n",
-				sdata->vif.addr, sta->sta.addr);
-			ht20_sta = true;
-		default:
 			break;
 		}
+
+		mpl_dbg(sdata, "HT20 sta (%pM) is present\n", sta->sta.addr);
+		ht20_sta = true;
 	}
-out:
 	rcu_read_unlock();
 
 	if (non_ht_sta)
@@ -169,16 +164,13 @@ out:
 	else
 		ht_opmode = IEEE80211_HT_OP_MODE_PROTECTION_NONE;
 
-	if (sdata->vif.bss_conf.ht_operation_mode != ht_opmode) {
-		sdata->vif.bss_conf.ht_operation_mode = ht_opmode;
-		sdata->u.mesh.mshcfg.ht_opmode = ht_opmode;
-		changed = BSS_CHANGED_HT;
-		mpl_dbg(sdata,
-			"mesh_plink %pM: protection mode changed to %d\n",
-			sdata->vif.addr, ht_opmode);
-	}
+	if (sdata->vif.bss_conf.ht_operation_mode == ht_opmode)
+		return 0;
 
-	return changed;
+	sdata->vif.bss_conf.ht_operation_mode = ht_opmode;
+	sdata->u.mesh.mshcfg.ht_opmode = ht_opmode;
+	mpl_dbg(sdata, "selected new HT protection mode %d\n", ht_opmode);
+	return BSS_CHANGED_HT;
 }
 
 /**
@@ -371,24 +363,18 @@ static void mesh_sta_info_init(struct ieee80211_sub_if_data *sdata,
 	if (sta->sta.supp_rates[band] != rates)
 		changed |= IEEE80211_RC_SUPP_RATES_CHANGED;
 	sta->sta.supp_rates[band] = rates;
-	if (elems->ht_cap_elem &&
-	    sdata->vif.bss_conf.chandef.width != NL80211_CHAN_WIDTH_20_NOHT)
-		ieee80211_ht_cap_ie_to_sta_ht_cap(sdata, sband,
-						  elems->ht_cap_elem, sta);
-	else
-		memset(&sta->sta.ht_cap, 0, sizeof(sta->sta.ht_cap));
 
-	if (elems->ht_operation) {
-		struct cfg80211_chan_def chandef;
+	if (ieee80211_ht_cap_ie_to_sta_ht_cap(sdata, sband,
+					      elems->ht_cap_elem, sta))
+		changed |= IEEE80211_RC_BW_CHANGED;
 
-		if (!(elems->ht_operation->ht_param &
-		      IEEE80211_HT_PARAM_CHAN_WIDTH_ANY))
-			sta->sta.bandwidth = IEEE80211_STA_RX_BW_20;
-		ieee80211_ht_oper_to_chandef(sdata->vif.bss_conf.chandef.chan,
-					     elems->ht_operation, &chandef);
-		if (sta->ch_width != chandef.width)
+	/* HT peer is operating 20MHz-only */
+	if (elems->ht_operation &&
+	    !(elems->ht_operation->ht_param &
+	      IEEE80211_HT_PARAM_CHAN_WIDTH_ANY)) {
+		if (sta->sta.bandwidth != IEEE80211_STA_RX_BW_20)
 			changed |= IEEE80211_RC_BW_CHANGED;
-		sta->ch_width = chandef.width;
+		sta->sta.bandwidth = IEEE80211_STA_RX_BW_20;
 	}
 
 	if (insert)
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 63dfdb5..4947341 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -285,7 +285,6 @@ struct sta_ampdu_mlme {
  * @t_offset: timing offset relative to this host
  * @t_offset_setpoint: reference timing offset of this sta to be used when
  * 	calculating clockdrift
- * @ch_width: peer's channel width
  * @local_pm: local link-specific power save mode
  * @peer_pm: peer-specific power save mode towards local STA
  * @nonpeer_pm: STA power save mode towards non-peer neighbors
@@ -386,7 +385,6 @@ struct sta_info {
 	struct timer_list plink_timer;
 	s64 t_offset;
 	s64 t_offset_setpoint;
-	enum nl80211_chan_width ch_width;
 	/* mesh power save */
 	enum nl80211_mesh_power_mode local_pm;
 	enum nl80211_mesh_power_mode peer_pm;
-- 
1.7.10.4

