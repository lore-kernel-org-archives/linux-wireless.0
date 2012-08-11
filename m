Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:40365 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754326Ab2HKA0C (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Aug 2012 20:26:02 -0400
Received: by yenl14 with SMTP id l14so961596yen.19
        for <linux-wireless@vger.kernel.org>; Fri, 10 Aug 2012 17:26:01 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linux-wireless@vger.kernel.org
Cc: dquan@qca.qualcomm.com,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [RFT 1/2] cfg80211: add a helper for processing 5 GHz beacon hints
Date: Fri, 10 Aug 2012 17:25:49 -0700
Message-Id: <1344644750-14000-2-git-send-email-mcgrof@do-not-panic.com> (sfid-20120811_022606_555323_2818B304)
In-Reply-To: <1344644750-14000-1-git-send-email-mcgrof@do-not-panic.com>
References: <1344644750-14000-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

Add a helper for doing the work required for processing
a beacon hint. This allows us to re-use the code if
we later want to do the same processing.

This commit has no functional change, it only introduces
a helper.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 net/wireless/reg.c |   45 +++++++++++++++++++++++++++++----------------
 1 file changed, 29 insertions(+), 16 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 2ded3c7..8525ece 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1028,30 +1028,19 @@ static bool ignore_reg_update(struct wiphy *wiphy,
 	return false;
 }
 
-static void handle_reg_beacon(struct wiphy *wiphy,
-			      unsigned int chan_idx,
-			      struct reg_beacon *reg_beacon)
+static bool reg_chan_process_beacon_hint(struct wiphy *wiphy,
+					 struct ieee80211_channel *chan)
 {
-	struct ieee80211_supported_band *sband;
-	struct ieee80211_channel *chan;
-	bool channel_changed = false;
 	struct ieee80211_channel chan_before;
-
-	assert_cfg80211_lock();
-
-	sband = wiphy->bands[reg_beacon->chan.band];
-	chan = &sband->channels[chan_idx];
-
-	if (likely(chan->center_freq != reg_beacon->chan.center_freq))
-		return;
+	bool channel_changed = false;
 
 	if (chan->beacon_found)
-		return;
+		return false;
 
 	chan->beacon_found = true;
 
 	if (wiphy->flags & WIPHY_FLAG_DISABLE_BEACON_HINTS)
-		return;
+		return false;
 
 	chan_before.center_freq = chan->center_freq;
 	chan_before.flags = chan->flags;
@@ -1068,6 +1057,30 @@ static void handle_reg_beacon(struct wiphy *wiphy,
 
 	if (channel_changed)
 		nl80211_send_beacon_hint_event(wiphy, &chan_before, chan);
+
+	return channel_changed;
+}
+
+static void handle_reg_beacon(struct wiphy *wiphy,
+			      unsigned int chan_idx,
+			      struct reg_beacon *reg_beacon)
+{
+	struct ieee80211_supported_band *sband;
+	struct ieee80211_channel *chan;
+	bool channel_changed = false;
+
+	assert_cfg80211_lock();
+
+	sband = wiphy->bands[reg_beacon->chan.band];
+	chan = &sband->channels[chan_idx];
+
+	if (likely(chan->center_freq != reg_beacon->chan.center_freq))
+		return;
+
+	channel_changed = reg_chan_process_beacon_hint(wiphy, chan);
+
+	if (channel_changed)
+		return; /* some band hint could potenially go here */
 }
 
 /*
-- 
1.7.10.4

