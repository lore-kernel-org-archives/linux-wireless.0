Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f182.google.com ([209.85.192.182]:59913 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755295AbaBRNhP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Feb 2014 08:37:15 -0500
Received: by mail-pd0-f182.google.com with SMTP id v10so16163020pde.41
        for <linux-wireless@vger.kernel.org>; Tue, 18 Feb 2014 05:37:14 -0800 (PST)
From: "Zhao, Gang" <gamerh2o@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 7/7] ieee80211: remove function ieee80211_{dsss_chan_to_freq, freq_to_dsss_chan}
Date: Tue, 18 Feb 2014 21:36:03 +0800
Message-Id: <c9305f68668f20186c1b2a8f8f3f6dac3d23b5db.1392728354.git.gamerh2o@gmail.com> (sfid-20140218_143720_850358_0BE8A4AF)
In-Reply-To: <cover.1392728354.git.gamerh2o@gmail.com>
References: <cover.1392728354.git.gamerh2o@gmail.com>
In-Reply-To: <cover.1392728354.git.gamerh2o@gmail.com>
References: <cover.1392728354.git.gamerh2o@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Function ieee80211_{dsss_chan_to_freq, freq_to_dsss_chan} have been
replaced with ieee80211_{channel_to_frequency, frequency_to_channel}.

There should be no users of the two functions now. So remove them.

Cc: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Zhao, Gang <gamerh2o@gmail.com>
---
 include/linux/ieee80211.h | 36 ------------------------------------
 1 file changed, 36 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 5f34935..0629904 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -2308,42 +2308,6 @@ static inline bool ieee80211_is_public_action(struct ieee80211_hdr *hdr,
 }
 
 /**
- * ieee80211_dsss_chan_to_freq - get channel center frequency
- * @channel: the DSSS channel
- *
- * Convert IEEE802.11 DSSS channel to the center frequency (MHz).
- * Ref IEEE 802.11-2007 section 15.6
- */
-static inline int ieee80211_dsss_chan_to_freq(int channel)
-{
-	if ((channel > 0) && (channel < 14))
-		return 2407 + (channel * 5);
-	else if (channel == 14)
-		return 2484;
-	else
-		return -1;
-}
-
-/**
- * ieee80211_freq_to_dsss_chan - get channel
- * @freq: the frequency
- *
- * Convert frequency (MHz) to IEEE802.11 DSSS channel
- * Ref IEEE 802.11-2007 section 15.6
- *
- * This routine selects the channel with the closest center frequency.
- */
-static inline int ieee80211_freq_to_dsss_chan(int freq)
-{
-	if ((freq >= 2410) && (freq < 2475))
-		return (freq - 2405) / 5;
-	else if ((freq >= 2482) && (freq < 2487))
-		return 14;
-	else
-		return -1;
-}
-
-/**
  * ieee80211_tu_to_usec - convert time units (TU) to microseconds
  * @tu: the TUs
  */
-- 
1.8.5.3

