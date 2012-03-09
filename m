Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:33061 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295Ab2CINN6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Mar 2012 08:13:58 -0500
Received: by wgbdr13 with SMTP id dr13so1597845wgb.1
        for <linux-wireless@vger.kernel.org>; Fri, 09 Mar 2012 05:13:57 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net, nbd@openwrt.org,
	Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [PATCH] mac80211: Disable MCS > 7 in minstrel_ht when STA uses static SMPS
Date: Fri,  9 Mar 2012 14:13:45 +0100
Message-Id: <1331298825-22314-1-git-send-email-helmut.schaa@googlemail.com> (sfid-20120309_141418_799868_1058833C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Disable multi stream rates (MCS > 7) when a STA is in static SMPS mode
since it has only one active rx chain. Hence, it doesn't even make
sense to sample multi stream rates.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---

I haven't found a STA that makes use of static SMPS, so this is only compile tested.

 net/mac80211/rc80211_minstrel_ht.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index ff5f7b8..2b42564 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -692,6 +692,7 @@ minstrel_ht_update_caps(void *priv, struct ieee80211_supported_band *sband,
 	int ack_dur;
 	int stbc;
 	int i;
+	unsigned int smps;
 
 	/* fall back to the old minstrel for legacy stations */
 	if (!sta->ht_cap.ht_supported)
@@ -731,6 +732,9 @@ minstrel_ht_update_caps(void *priv, struct ieee80211_supported_band *sband,
 	    oper_chan_type != NL80211_CHAN_HT40PLUS)
 		sta_cap &= ~IEEE80211_HT_CAP_SUP_WIDTH_20_40;
 
+	smps = (sta_cap & IEEE80211_HT_CAP_SM_PS) >>
+		IEEE80211_HT_CAP_SM_PS_SHIFT;
+
 	for (i = 0; i < ARRAY_SIZE(mi->groups); i++) {
 		u16 req = 0;
 
@@ -748,6 +752,11 @@ minstrel_ht_update_caps(void *priv, struct ieee80211_supported_band *sband,
 		if ((sta_cap & req) != req)
 			continue;
 
+		/* Mark MCS > 7 as unsupported if STA is in static SMPS mode */
+		if (smps == WLAN_HT_CAP_SM_PS_STATIC &&
+		    minstrel_mcs_groups[i].streams > 1)
+			continue;
+
 		mi->groups[i].supported =
 			mcs->rx_mask[minstrel_mcs_groups[i].streams - 1];
 
-- 
1.7.7

