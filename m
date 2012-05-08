Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47910 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754857Ab2EHTXz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 May 2012 15:23:55 -0400
Message-ID: <1336505034.4320.5.camel@jlt3.sipsolutions.net> (sfid-20120508_212359_471573_B0CB9FBE)
Subject: [PATCH] cfg80211: remove double prototype
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 08 May 2012 21:23:54 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

cfg80211_calculate_bitrate() is defined in the external
header file cfg80211.h now, so no need to keep it in
the internal one as well.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/core.h |    2 --
 1 file changed, 2 deletions(-)

--- a/net/wireless/core.h	2012-05-08 21:22:05.000000000 +0200
+++ b/net/wireless/core.h	2012-05-08 21:22:34.000000000 +0200
@@ -445,8 +445,6 @@ int cfg80211_set_freq(struct cfg80211_re
 		      struct wireless_dev *wdev, int freq,
 		      enum nl80211_channel_type channel_type);
 
-u16 cfg80211_calculate_bitrate(struct rate_info *rate);
-
 int ieee80211_get_ratemask(struct ieee80211_supported_band *sband,
 			   const u8 *rates, unsigned int n_rates,
 			   u32 *mask);


