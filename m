Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60568 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754326Ab2HKA0F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Aug 2012 20:26:05 -0400
Received: by mail-pb0-f46.google.com with SMTP id rr13so3542514pbb.19
        for <linux-wireless@vger.kernel.org>; Fri, 10 Aug 2012 17:26:05 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linux-wireless@vger.kernel.org
Cc: dquan@qca.qualcomm.com,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [RFT 2/2] cfg80211: add 5 GHz UNII band regulatory hints
Date: Fri, 10 Aug 2012 17:25:50 -0700
Message-Id: <1344644750-14000-3-git-send-email-mcgrof@do-not-panic.com> (sfid-20120811_022610_031309_D52B4407)
In-Reply-To: <1344644750-14000-1-git-send-email-mcgrof@do-not-panic.com>
References: <1344644750-14000-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

It turns out that what is known as UNII 1 (5180 MHz - 5240 MHz)
and UNII 3 (5745 MHz - 5825 MHz) share the same regulatory
permissions globally. This fact can be used to enable enhancing
world roaming quite a bit by taking advantage of beacon hints [0].

If we receive a beacon hint on UNII 1 it means we can not only
take advantage of that beacon hint to lift passive scan flags
on that channel but all other UNII 1 channels. The same applies
to UNII 3.

This implements UNII 1 and UNII 3 beacon hints.

[0] http://wireless.kernel.org/en/developers/Regulatory/processing_rules#Beacon_hints

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 net/wireless/reg.c |  124 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 123 insertions(+), 1 deletion(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 8525ece..2366ea2 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1061,6 +1061,128 @@ static bool reg_chan_process_beacon_hint(struct wiphy *wiphy,
 	return channel_changed;
 }
 
+enum reg_5ghz_unii_band {
+	REG_5GHZ_UNKNOWN,	/* all others */
+	REG_5GHZ_UNII_1,	/* 5180 MHz - 5240 MHz */
+	REG_5GHZ_UNII_2,	/* 5260 MHz - 5320 MHz */
+	REG_5GHZ_MID_BAND,	/* 5500 MHz - 5700 MHz */
+	REG_5GHZ_UNII_3,	/* 5745 MHz - 5825 MHz */
+};
+
+static bool reg_is_5ghz_unii_1(struct ieee80211_channel *chan)
+{
+	if (chan->center_freq >= 5180 &&
+	    chan->center_freq <= 5240)
+		return true;
+	return false;
+}
+
+static bool reg_is_5ghz_unii_2(struct ieee80211_channel *chan)
+{
+	if (chan->center_freq >= 5260 &&
+	    chan->center_freq <= 5320 )
+		return true;
+	return false;
+}
+
+static bool reg_is_5ghz_mid_band(struct ieee80211_channel *chan)
+{
+	if (chan->center_freq >= 5500 &&
+	    chan->center_freq <= 5700)
+		return true;
+	return false;
+}
+
+static bool reg_is_5ghz_unii_3(struct ieee80211_channel *chan)
+{
+	if (chan->center_freq >= 5745 &&
+	    chan->center_freq <= 5825)
+		return true;
+	return false;
+}
+
+static enum reg_5ghz_unii_band
+reg_get_5ghz_unii_band(struct ieee80211_channel *chan)
+{
+	if (reg_is_5ghz_unii_1(chan))
+		return REG_5GHZ_UNII_1;
+	if (reg_is_5ghz_unii_2(chan))
+		return REG_5GHZ_UNII_2;
+	if (reg_is_5ghz_mid_band(chan))
+		return REG_5GHZ_MID_BAND;
+	if (reg_is_5ghz_mid_band(chan))
+		return REG_5GHZ_UNII_3;
+
+	return REG_5GHZ_UNKNOWN;
+}
+
+static void reg_unii_5ghz_beacon_hint_unii(struct wiphy *wiphy,
+					   struct ieee80211_channel *chan,
+					   enum reg_5ghz_unii_band unii_band)
+{
+	struct ieee80211_supported_band *sband;
+	unsigned int i;
+
+	assert_cfg80211_lock();
+
+	sband = wiphy->bands[chan->band];
+
+	/*
+	 * Only process UNII 1 hints for UNII 1 channels
+	 * Only process UNII 3 hints for UNII 3 channels
+	 */
+	for (i = 0; i < sband->n_channels; i++) {
+		struct ieee80211_channel *c = &sband->channels[i];
+
+		switch (unii_band) {
+		case REG_5GHZ_UNII_1:
+			if (!reg_is_5ghz_unii_1(c))
+				continue;
+			break;
+		case REG_5GHZ_UNII_3:
+			if (!reg_is_5ghz_unii_3(c))
+				continue;
+			break;
+		default:
+			WARN_ONCE(1, "unexpected regulatory unii hint\n");
+			continue;
+		}
+
+		reg_chan_process_beacon_hint(wiphy, chan);
+	}
+
+	REG_DBG_PRINT("Processed 5 GHz UNII %d beacon hint\n",
+		      (unii_band == REG_5GHZ_UNII_1) ? 1 : 3);
+}
+
+static void reg_unii_5ghz_beacon_hint(struct wiphy *wiphy,
+				      struct ieee80211_channel *chan)
+{
+	enum reg_5ghz_unii_band unii_band = reg_get_5ghz_unii_band(chan);
+
+	switch (unii_band) {
+	case REG_5GHZ_UNKNOWN:
+		return;
+	/*
+	 * These should not happen given that typically DFS
+	 * is always enabled on the rest of the 5 GHz frequencies.
+	 * We'll just bail out.
+	 */
+	case REG_5GHZ_UNII_2:
+	case REG_5GHZ_MID_BAND:
+		return;
+	/*
+	 * 5 GHz UNII hints are only enabled for UNII1 and UNII3
+	 */
+	case REG_5GHZ_UNII_1:
+	case REG_5GHZ_UNII_3:
+		reg_unii_5ghz_beacon_hint_unii(wiphy, chan, unii_band);
+		break;
+	default:
+		break;
+	}
+}
+
 static void handle_reg_beacon(struct wiphy *wiphy,
 			      unsigned int chan_idx,
 			      struct reg_beacon *reg_beacon)
@@ -1080,7 +1202,7 @@ static void handle_reg_beacon(struct wiphy *wiphy,
 	channel_changed = reg_chan_process_beacon_hint(wiphy, chan);
 
 	if (channel_changed)
-		return; /* some band hint could potenially go here */
+		reg_unii_5ghz_beacon_hint(wiphy, chan);
 }
 
 /*
-- 
1.7.10.4

