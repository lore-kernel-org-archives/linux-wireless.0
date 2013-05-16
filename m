Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:49747 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752213Ab3EPLB6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 May 2013 07:01:58 -0400
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCHv3 04/18] mac80211: fix various components for the new 5 and 10 MHz widths
Date: Thu, 16 May 2013 13:00:31 +0200
Message-Id: <1368702045-27598-5-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130516_130220_978881_213D9FD0)
In-Reply-To: <1368702045-27598-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1368702045-27598-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a collection of minor fixes:
 * don't allow HT IEs in IBSS for 5/10 MHz
 * don't allow HT IEs in Mesh for 5/10 MHz
 * consider 5 and 10 MHz channels when downgrading
 * don't try HT rates for 5 and 10 MHz channels when selecting rates

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
---
 net/mac80211/ibss.c       |    2 ++
 net/mac80211/mesh.c       |    4 +++-
 net/mac80211/mesh_plink.c |    8 +++++++-
 net/mac80211/mlme.c       |   12 ++++++++++++
 net/mac80211/rate.c       |    8 +++++++-
 5 files changed, 31 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 170f9a7..4e1fb81 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -176,6 +176,8 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 
 	/* add HT capability and information IEs */
 	if (chandef.width != NL80211_CHAN_WIDTH_20_NOHT &&
+	    chandef.width != NL80211_CHAN_WIDTH_5 &&
+	    chandef.width != NL80211_CHAN_WIDTH_10 &&
 	    sband->ht_cap.ht_supported) {
 		pos = ieee80211_ie_build_ht_cap(pos, &sband->ht_cap,
 						sband->ht_cap.cap);
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 6952760..5227b73 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -417,7 +417,9 @@ int mesh_add_ht_cap_ie(struct ieee80211_sub_if_data *sdata,
 
 	sband = local->hw.wiphy->bands[band];
 	if (!sband->ht_cap.ht_supported ||
-	    sdata->vif.bss_conf.chandef.width == NL80211_CHAN_WIDTH_20_NOHT)
+	    sdata->vif.bss_conf.chandef.width == NL80211_CHAN_WIDTH_20_NOHT ||
+	    sdata->vif.bss_conf.chandef.width == NL80211_CHAN_WIDTH_5 ||
+	    sdata->vif.bss_conf.chandef.width == NL80211_CHAN_WIDTH_10)
 		return 0;
 
 	if (skb_tailroom(skb) < 2 + sizeof(struct ieee80211_ht_cap))
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 09bebed..02c05fa 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -154,8 +154,14 @@ static u32 mesh_set_ht_prot_mode(struct ieee80211_sub_if_data *sdata)
 	u16 ht_opmode;
 	bool non_ht_sta = false, ht20_sta = false;
 
-	if (sdata->vif.bss_conf.chandef.width == NL80211_CHAN_WIDTH_20_NOHT)
+	switch (sdata->vif.bss_conf.chandef.width) {
+	case NL80211_CHAN_WIDTH_20_NOHT:
+	case NL80211_CHAN_WIDTH_5:
+	case NL80211_CHAN_WIDTH_10:
 		return 0;
+	default:
+		break;
+	}
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(sta, &local->sta_list, list) {
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 29620bf..0eaee23 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -224,6 +224,12 @@ static u32 chandef_downgrade(struct cfg80211_chan_def *c)
 		c->width = NL80211_CHAN_WIDTH_20_NOHT;
 		ret = IEEE80211_STA_DISABLE_HT | IEEE80211_STA_DISABLE_VHT;
 		break;
+	case NL80211_CHAN_WIDTH_5:
+	case NL80211_CHAN_WIDTH_10:
+		WARN_ON_ONCE(1);
+		/* keep c->width */
+		ret = IEEE80211_STA_DISABLE_HT | IEEE80211_STA_DISABLE_VHT;
+		break;
 	}
 
 	WARN_ON_ONCE(!cfg80211_chandef_valid(c));
@@ -3809,6 +3815,12 @@ static int ieee80211_prep_channel(struct ieee80211_sub_if_data *sdata,
 	 */
 	ret = ieee80211_vif_use_channel(sdata, &chandef,
 					IEEE80211_CHANCTX_SHARED);
+
+	/* don't downgrade for 5 and 10 MHz channels, though. */
+	if (chandef.width == NL80211_CHAN_WIDTH_5 ||
+	    chandef.width == NL80211_CHAN_WIDTH_10)
+		return ret;
+
 	while (ret && chandef.width != NL80211_CHAN_WIDTH_20_NOHT) {
 		ifmgd->flags |= chandef_downgrade(&chandef);
 		ret = ieee80211_vif_use_channel(sdata, &chandef,
diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
index 8b95819..118e47b 100644
--- a/net/mac80211/rate.c
+++ b/net/mac80211/rate.c
@@ -397,8 +397,14 @@ static void rate_idx_match_mask(struct ieee80211_tx_rate *rate,
 			return;
 
 		/* if HT BSS, and we handle a data frame, also try HT rates */
-		if (chan_width == NL80211_CHAN_WIDTH_20_NOHT)
+		switch (chan_width) {
+		case NL80211_CHAN_WIDTH_20_NOHT:
+		case NL80211_CHAN_WIDTH_5:
+		case NL80211_CHAN_WIDTH_10:
 			return;
+		default:
+			break;
+		}
 
 		alt_rate.idx = 0;
 		/* keep protection flags */
-- 
1.7.10.4

