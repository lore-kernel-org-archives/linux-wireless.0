Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39617 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754696Ab2GXPkO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jul 2012 11:40:14 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] wireless: remove obsolete chan no/center freq conversion functions
Date: Tue, 24 Jul 2012 17:40:12 +0200
Message-Id: <1343144412-8562-1-git-send-email-johannes@sipsolutions.net> (sfid-20120724_174020_200174_ADAAB4D4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There are a number of functions that shouldn't really
be used when modern functions that take the band are
available in cfg80211. Remove these, but for now keep
 * ieee80211_freq_to_dsss_chan and
 * ieee80211_dsss_chan_to_freq
as they're used in older drivers.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/linux/ieee80211.h |   80 ---------------------------------------------
 1 file changed, 80 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index e02fc68..2385119 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -1935,36 +1935,6 @@ static inline bool ieee80211_is_public_action(struct ieee80211_hdr *hdr,
 }
 
 /**
- * ieee80211_fhss_chan_to_freq - get channel frequency
- * @channel: the FHSS channel
- *
- * Convert IEEE802.11 FHSS channel to frequency (MHz)
- * Ref IEEE 802.11-2007 section 14.6
- */
-static inline int ieee80211_fhss_chan_to_freq(int channel)
-{
-	if ((channel > 1) && (channel < 96))
-		return channel + 2400;
-	else
-		return -1;
-}
-
-/**
- * ieee80211_freq_to_fhss_chan - get channel
- * @freq: the channels frequency
- *
- * Convert frequency (MHz) to IEEE802.11 FHSS channel
- * Ref IEEE 802.11-2007 section 14.6
- */
-static inline int ieee80211_freq_to_fhss_chan(int freq)
-{
-	if ((freq > 2401) && (freq < 2496))
-		return freq - 2400;
-	else
-		return -1;
-}
-
-/**
  * ieee80211_dsss_chan_to_freq - get channel center frequency
  * @channel: the DSSS channel
  *
@@ -2000,56 +1970,6 @@ static inline int ieee80211_freq_to_dsss_chan(int freq)
 		return -1;
 }
 
-/* Convert IEEE802.11 HR DSSS channel to frequency (MHz) and back
- * Ref IEEE 802.11-2007 section 18.4.6.2
- *
- * The channels and frequencies are the same as those defined for DSSS
- */
-#define ieee80211_hr_chan_to_freq(chan) ieee80211_dsss_chan_to_freq(chan)
-#define ieee80211_freq_to_hr_chan(freq) ieee80211_freq_to_dsss_chan(freq)
-
-/* Convert IEEE802.11 ERP channel to frequency (MHz) and back
- * Ref IEEE 802.11-2007 section 19.4.2
- */
-#define ieee80211_erp_chan_to_freq(chan) ieee80211_hr_chan_to_freq(chan)
-#define ieee80211_freq_to_erp_chan(freq) ieee80211_freq_to_hr_chan(freq)
-
-/**
- * ieee80211_ofdm_chan_to_freq - get channel center frequency
- * @s_freq: starting frequency == (dotChannelStartingFactor/2) MHz
- * @channel: the OFDM channel
- *
- * Convert IEEE802.11 OFDM channel to center frequency (MHz)
- * Ref IEEE 802.11-2007 section 17.3.8.3.2
- */
-static inline int ieee80211_ofdm_chan_to_freq(int s_freq, int channel)
-{
-	if ((channel > 0) && (channel <= 200) &&
-	    (s_freq >= 4000))
-		return s_freq + (channel * 5);
-	else
-		return -1;
-}
-
-/**
- * ieee80211_freq_to_ofdm_channel - get channel
- * @s_freq: starting frequency == (dotChannelStartingFactor/2) MHz
- * @freq: the frequency
- *
- * Convert frequency (MHz) to IEEE802.11 OFDM channel
- * Ref IEEE 802.11-2007 section 17.3.8.3.2
- *
- * This routine selects the channel with the closest center frequency.
- */
-static inline int ieee80211_freq_to_ofdm_chan(int s_freq, int freq)
-{
-	if ((freq > (s_freq + 2)) && (freq <= (s_freq + 1202)) &&
-	    (s_freq >= 4000))
-		return (freq + 2 - s_freq) / 5;
-	else
-		return -1;
-}
-
 /**
  * ieee80211_tu_to_usec - convert time units (TU) to microseconds
  * @tu: the TUs
-- 
1.7.10.4

