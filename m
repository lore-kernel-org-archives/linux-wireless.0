Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:59606 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754886Ab3DORIU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Apr 2013 13:08:20 -0400
Received: by mail-we0-f171.google.com with SMTP id i48so2173850wef.16
        for <linux-wireless@vger.kernel.org>; Mon, 15 Apr 2013 10:08:19 -0700 (PDT)
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@gmail.com>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Subject: [PATCH] mac80211: adjust initial chandefs assignments in ieee80211_register_hw
Date: Mon, 15 Apr 2013 19:04:06 +0200
Message-Id: <1366045446-11286-1-git-send-email-karl.beldan@gmail.com> (sfid-20130415_190826_484250_DA4A11B8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Karl Beldan <karl.beldan@rivierawaves.com>

I noticed that monitor interfaces by default would start on 5GHz
while STA/AP ones would start 2GHZ - It stems from the fact that
ieee80211_register_hw unnecessarily adjusts the local->monitor_chandef
for each band.

This avoids this and while at it uses a single dflt_chandef to initialize
in one go local->{hw.conf.chandef,_oper_chandef,monitor_chandef}

Signed-off-by: Karl Beldan <karl.beldan@rivierawaves.com>
---
 net/mac80211/main.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 52136fd..b867d0a 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -668,6 +668,7 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 	int channels, max_bitrates;
 	bool supp_ht, supp_vht;
 	netdev_features_t feature_whitelist;
+	struct cfg80211_chan_def dflt_chandef = {};
 	static const u32 cipher_suites[] = {
 		/* keep WEP first, it may be removed below */
 		WLAN_CIPHER_SUITE_WEP40,
@@ -745,19 +746,18 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 		sband = local->hw.wiphy->bands[band];
 		if (!sband)
 			continue;
-		if (!local->use_chanctx && !local->_oper_chandef.chan) {
+
+		if (!dflt_chandef.chan) {
+			cfg80211_chandef_create(&dflt_chandef,
+						&sband->channels[0],
+						NL80211_CHAN_NO_HT);
 			/* init channel we're on */
-			struct cfg80211_chan_def chandef = {
-				.chan = &sband->channels[0],
-				.width = NL80211_CHAN_NO_HT,
-				.center_freq1 = sband->channels[0].center_freq,
-				.center_freq2 = 0
-			};
-			local->hw.conf.chandef = local->_oper_chandef = chandef;
+			if (!local->use_chanctx && !local->_oper_chandef.chan)
+				local->hw.conf.chandef = local->_oper_chandef =
+					dflt_chandef;
+			local->monitor_chandef = dflt_chandef;
 		}
-		cfg80211_chandef_create(&local->monitor_chandef,
-					&sband->channels[0],
-					NL80211_CHAN_NO_HT);
+
 		channels += sband->n_channels;
 
 		if (max_bitrates < sband->n_bitrates)
-- 
1.8.2

