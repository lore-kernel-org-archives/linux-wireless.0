Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48709 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754285AbYIKWFD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Sep 2008 18:05:03 -0400
Subject: [PATCH] cfg80211: fix regdomain macro
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 12 Sep 2008 00:03:59 +0200
Message-Id: <1221170639.5956.1.camel@johannes.berg> (sfid-20080912_000524_174841_96412B86)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

D'oh.

# iw dev wlan0 info
Band 1:
	Frequencies:
		* 2412 MHz (disabled)
		* 2417 MHz (disabled)
		* 2422 MHz (disabled)
		* 2427 MHz (disabled)
		* 2432 MHz (disabled)
		* 2437 MHz (disabled)
		* 2442 MHz (disabled)
		* 2447 MHz (disabled)
		* 2452 MHz (disabled)
		* 2457 MHz (disabled)
		* 2462 MHz (disabled)
		* 2467 MHz (disabled)
		* 2472 MHz (disabled)
		* 2484 MHz (disabled)

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/net/cfg80211.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- everything.orig/include/net/cfg80211.h	2008-09-12 00:00:54.000000000 +0200
+++ everything/include/net/cfg80211.h	2008-09-12 00:01:06.000000000 +0200
@@ -339,9 +339,9 @@ struct ieee80211_regdomain {
 #define MBM_TO_DBM(gain) (gain / 100)
 
 #define REG_RULE(start, end, bw, gain, eirp, reg_flags) { \
-	.freq_range.start_freq_khz = (start) * 100, \
-	.freq_range.end_freq_khz = (end) * 100, \
-	.freq_range.max_bandwidth_khz = (bw) * 100, \
+	.freq_range.start_freq_khz = (start) * 1000, \
+	.freq_range.end_freq_khz = (end) * 1000, \
+	.freq_range.max_bandwidth_khz = (bw) * 1000, \
 	.power_rule.max_antenna_gain = (gain) * 100, \
 	.power_rule.max_eirp = (eirp) * 100, \
 	.flags = reg_flags, \


