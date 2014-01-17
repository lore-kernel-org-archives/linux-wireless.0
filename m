Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f48.google.com ([209.85.160.48]:63787 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171AbaAQFaW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jan 2014 00:30:22 -0500
Received: by mail-pb0-f48.google.com with SMTP id rr13so3632165pbb.7
        for <linux-wireless@vger.kernel.org>; Thu, 16 Jan 2014 21:30:21 -0800 (PST)
From: ZHAO Gang <gamerh2o@gmail.com>
To: Stefano Brivio <stefano.brivio@polimi.it>
Cc: <b43-dev@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 2/2] b43: use kernel api to replace b43 specific helper function
Date: Fri, 17 Jan 2014 13:27:34 +0800
Message-Id: <c7ed453b30f30ee193ec0969904da001bef5dc3e.1389935084.git.gamerh2o@gmail.com> (sfid-20140117_063032_656977_E5E79615)
In-Reply-To: <a8aa052ea196de8256dcdc5b3ae81cfa64d3f9ff.1389935084.git.gamerh2o@gmail.com>
References: <a8aa052ea196de8256dcdc5b3ae81cfa64d3f9ff.1389935084.git.gamerh2o@gmail.com>
In-Reply-To: <a8aa052ea196de8256dcdc5b3ae81cfa64d3f9ff.1389935084.git.gamerh2o@gmail.com>
References: <a8aa052ea196de8256dcdc5b3ae81cfa64d3f9ff.1389935084.git.gamerh2o@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use ieee80211_channel_to_frequency() to replace b43_channel_to_freq_{2,5}ghz(),
and remove unused b43_freq_to_channel_{2,5}ghz().

Signed-off-by: ZHAO Gang <gamerh2o@gmail.com>
---
 drivers/net/wireless/b43/main.h | 35 -----------------------------------
 drivers/net/wireless/b43/xmit.c | 12 ++++++------
 2 files changed, 6 insertions(+), 41 deletions(-)

diff --git a/drivers/net/wireless/b43/main.h b/drivers/net/wireless/b43/main.h
index abac25e..f476fc3 100644
--- a/drivers/net/wireless/b43/main.h
+++ b/drivers/net/wireless/b43/main.h
@@ -58,41 +58,6 @@ enum b43_verbosity {
 #endif
 };
 
-
-/* Lightweight function to convert a frequency (in Mhz) to a channel number. */
-static inline u8 b43_freq_to_channel_5ghz(int freq)
-{
-	return ((freq - 5000) / 5);
-}
-static inline u8 b43_freq_to_channel_2ghz(int freq)
-{
-	u8 channel;
-
-	if (freq == 2484)
-		channel = 14;
-	else
-		channel = (freq - 2407) / 5;
-
-	return channel;
-}
-
-/* Lightweight function to convert a channel number to a frequency (in Mhz). */
-static inline int b43_channel_to_freq_5ghz(u8 channel)
-{
-	return (5000 + (5 * channel));
-}
-static inline int b43_channel_to_freq_2ghz(u8 channel)
-{
-	int freq;
-
-	if (channel == 14)
-		freq = 2484;
-	else
-		freq = 2407 + (5 * channel);
-
-	return freq;
-}
-
 static inline int b43_is_cck_rate(int rate)
 {
 	return (rate == B43_CCK_RATE_1MB ||
diff --git a/drivers/net/wireless/b43/xmit.c b/drivers/net/wireless/b43/xmit.c
index 50e5ddb..218a0f3 100644
--- a/drivers/net/wireless/b43/xmit.c
+++ b/drivers/net/wireless/b43/xmit.c
@@ -806,7 +806,8 @@ void b43_rx(struct b43_wldev *dev, struct sk_buff *skb, const void *_rxhdr)
 		B43_WARN_ON(1);
 		/* FIXME: We don't really know which value the "chanid" contains.
 		 *        So the following assignment might be wrong. */
-		status.freq = b43_channel_to_freq_5ghz(chanid);
+		status.freq =
+			ieee80211_channel_to_frequency(chanid, status.band);
 		break;
 	case B43_PHYTYPE_G:
 		status.band = IEEE80211_BAND_2GHZ;
@@ -819,13 +820,12 @@ void b43_rx(struct b43_wldev *dev, struct sk_buff *skb, const void *_rxhdr)
 	case B43_PHYTYPE_HT:
 		/* chanid is the SHM channel cookie. Which is the plain
 		 * channel number in b43. */
-		if (chanstat & B43_RX_CHAN_5GHZ) {
+		if (chanstat & B43_RX_CHAN_5GHZ)
 			status.band = IEEE80211_BAND_5GHZ;
-			status.freq = b43_channel_to_freq_5ghz(chanid);
-		} else {
+		else
 			status.band = IEEE80211_BAND_2GHZ;
-			status.freq = b43_channel_to_freq_2ghz(chanid);
-		}
+		status.freq =
+			ieee80211_channel_to_frequency(chanid, status.band);
 		break;
 	default:
 		B43_WARN_ON(1);
-- 
1.8.4.2

