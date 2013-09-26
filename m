Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from postler.einfach.org ([91.250.116.113]:42323 "EHLO
	postler.einfach.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957Ab3IZQpy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Sep 2013 12:45:54 -0400
From: Bruno Randolf <br1@einfach.org>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Bruno Randolf <br1@einfach.org>
Subject: [PATCH] iw: sync frequency to channel mapping with kernel
Date: Thu, 26 Sep 2013 17:45:45 +0100
Message-Id: <1380213945-31815-1-git-send-email-br1@einfach.org> (sfid-20130926_184557_421767_18605AFC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use ieee80211_frequency_to_channel() and ieee80211_channel_to_frequency() as in
the current kernel. This is necessary to properly print the channel numbers for
4.9GHz channels which can be used in Japan.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 iw.h   |  2 +-
 phy.c  |  8 ++++++--
 util.c | 54 +++++++++++++++++++++++++++++++++++-------------------
 3 files changed, 42 insertions(+), 22 deletions(-)

diff --git a/iw.h b/iw.h
index 854d356..317f0a6 100644
--- a/iw.h
+++ b/iw.h
@@ -148,7 +148,7 @@ void print_vht_info(__u32 capa, const __u8 *mcs);
 char *channel_width_name(enum nl80211_chan_width width);
 const char *iftype_name(enum nl80211_iftype iftype);
 const char *command_name(enum nl80211_commands cmd);
-int ieee80211_channel_to_frequency(int chan);
+int ieee80211_channel_to_frequency(int chan, enum nl80211_band band);
 int ieee80211_frequency_to_channel(int freq);
 
 void print_ssid_escaped(const uint8_t len, const uint8_t *data);
diff --git a/phy.c b/phy.c
index 7f8ce26..58636af 100644
--- a/phy.c
+++ b/phy.c
@@ -113,8 +113,12 @@ static int handle_freqchan(struct nl_msg *msg, bool chan,
 	if (*end)
 		return 1;
 
-	if (chan)
-		freq = ieee80211_channel_to_frequency(freq);
+	if (chan) {
+		enum nl80211_band band;
+		band = freq <= 14 ? NL80211_BAND_2GHZ : NL80211_BAND_5GHZ;
+		freq = ieee80211_channel_to_frequency(freq, band);
+	}
+
 
 	NLA_PUT_U32(msg, NL80211_ATTR_WIPHY_FREQ, freq);
 
diff --git a/util.c b/util.c
index e3d0c27..4542749 100644
--- a/util.c
+++ b/util.c
@@ -260,34 +260,50 @@ const char *command_name(enum nl80211_commands cmd)
 	return cmdbuf;
 }
 
-int ieee80211_channel_to_frequency(int chan)
+int ieee80211_channel_to_frequency(int chan, enum nl80211_band band)
 {
-	if (chan < 14)
-		return 2407 + chan * 5;
-
-	if (chan == 14)
-		return 2484;
-
-	/* FIXME: dot11ChannelStartingFactor (802.11-2007 17.3.8.3.2) */
-	return (chan + 1000) * 5;
+	/* see 802.11 17.3.8.3.2 and Annex J
+	 * there are overlapping channel numbers in 5GHz and 2GHz bands */
+	if (chan <= 0)
+		return 0; /* not supported */
+	switch (band) {
+	case NL80211_BAND_2GHZ:
+		if (chan == 14)
+			return 2484;
+		else if (chan < 14)
+			return 2407 + chan * 5;
+		break;
+	case NL80211_BAND_5GHZ:
+		if (chan >= 182 && chan <= 196)
+			return 4000 + chan * 5;
+		else
+			return 5000 + chan * 5;
+		break;
+	case NL80211_BAND_60GHZ:
+		if (chan < 5)
+			return 56160 + chan * 2160;
+		break;
+	default:
+		;
+	}
+	return 0; /* not supported */
 }
 
 int ieee80211_frequency_to_channel(int freq)
 {
+	/* see 802.11-2007 17.3.8.3.2 and Annex J */
 	if (freq == 2484)
 		return 14;
-
-	if (freq < 2484)
+	else if (freq < 2484)
 		return (freq - 2407) / 5;
-
-	/* FIXME: dot11ChannelStartingFactor (802.11-2007 17.3.8.3.2) */
-	if (freq < 45000)
-		return freq/5 - 1000;
-
-	if (freq >= 58320 && freq <= 64800)
+	else if (freq >= 4910 && freq <= 4980)
+		return (freq - 4000) / 5;
+	else if (freq <= 45000) /* DMG band lower limit */
+		return (freq - 5000) / 5;
+	else if (freq >= 58320 && freq <= 64800)
 		return (freq - 56160) / 2160;
-
-	return 0;
+	else
+		return 0;
 }
 
 void print_ssid_escaped(const uint8_t len, const uint8_t *data)
-- 
1.8.1.2

