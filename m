Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:49183 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753533Ab1CYOar (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Mar 2011 10:30:47 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net
Subject: [PATCH] mac80211: fix a crash in minstrel_ht in HT mode with no supported MCS rates
Date: Fri, 25 Mar 2011 15:30:38 +0100
Message-Id: <1301063438-20460-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When a client connects in HT mode but does not provide any valid MCS
rates, the function that finds the next sample rate gets stuck in an
infinite loop.
Fix this by falling back to legacy rates if no usable MCS rates are found.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Cc: stable@kernel.org
---
 net/mac80211/rc80211_minstrel_ht.c |   25 ++++++++++++++++++-------
 1 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index 8212a8b..dbdebed 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -659,18 +659,14 @@ minstrel_ht_update_caps(void *priv, struct ieee80211_supported_band *sband,
 	struct ieee80211_mcs_info *mcs = &sta->ht_cap.mcs;
 	struct ieee80211_local *local = hw_to_local(mp->hw);
 	u16 sta_cap = sta->ht_cap.cap;
+	int n_supported = 0;
 	int ack_dur;
 	int stbc;
 	int i;
 
 	/* fall back to the old minstrel for legacy stations */
-	if (!sta->ht_cap.ht_supported) {
-		msp->is_ht = false;
-		memset(&msp->legacy, 0, sizeof(msp->legacy));
-		msp->legacy.r = msp->ratelist;
-		msp->legacy.sample_table = msp->sample_table;
-		return mac80211_minstrel.rate_init(priv, sband, sta, &msp->legacy);
-	}
+	if (!sta->ht_cap.ht_supported)
+		goto use_legacy;
 
 	BUILD_BUG_ON(ARRAY_SIZE(minstrel_mcs_groups) !=
 		MINSTREL_MAX_STREAMS * MINSTREL_STREAM_GROUPS);
@@ -725,7 +721,22 @@ minstrel_ht_update_caps(void *priv, struct ieee80211_supported_band *sband,
 
 		mi->groups[i].supported =
 			mcs->rx_mask[minstrel_mcs_groups[i].streams - 1];
+
+		if (mi->groups[i].supported)
+			n_supported++;
 	}
+
+	if (!n_supported)
+		goto use_legacy;
+
+	return;
+
+use_legacy:
+	msp->is_ht = false;
+	memset(&msp->legacy, 0, sizeof(msp->legacy));
+	msp->legacy.r = msp->ratelist;
+	msp->legacy.sample_table = msp->sample_table;
+	return mac80211_minstrel.rate_init(priv, sband, sta, &msp->legacy);
 }
 
 static void
-- 
1.7.3.2

