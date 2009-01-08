Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:41673 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757361AbZAHBoO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jan 2009 20:44:14 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 07 Jan 2009 17:44:14 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <johannes@sipsolutions.net>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 6/6] cfg80211: Fix parsed country IE info for 5 GHz
Date: Wed, 7 Jan 2009 17:43:37 -0800
Message-ID: <1231379017-28363-7-git-send-email-lrodriguez@atheros.com> (sfid-20090108_024418_736251_58BFAA58)
In-Reply-To: <1231379017-28363-6-git-send-email-lrodriguez@atheros.com>
References: <1231379017-28363-1-git-send-email-lrodriguez@atheros.com>
 <1231379017-28363-2-git-send-email-lrodriguez@atheros.com>
 <1231379017-28363-3-git-send-email-lrodriguez@atheros.com>
 <1231379017-28363-4-git-send-email-lrodriguez@atheros.com>
 <1231379017-28363-5-git-send-email-lrodriguez@atheros.com>
 <1231379017-28363-6-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The country IE number of channels on 5 GHz specifies the number
of 5 GHz channels, not the number of sequential channel numbers.
For example, if in a country IEs if the first channel given is 36
and the number of channels passed is 4 then the individual channel
numbers defined for the 5 GHz PHY by these parameters

are: 36, 40, 44, 48
not: 36, 37, 38, 39

See: http://tinyurl.com/11d-clarification

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/wireless/reg.c |   21 +++++++++++++++++++--
 1 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index bea98ed..b34fd84 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -563,6 +563,7 @@ static struct ieee80211_regdomain *country_ie_2_rd(
 
 	/* This time around we fill in the rd */
 	while (country_ie_len >= 3) {
+		int end_channel = 0;
 		struct ieee80211_country_ie_triplet *triplet =
 			(struct ieee80211_country_ie_triplet *) country_ie;
 		struct ieee80211_reg_rule *reg_rule = NULL;
@@ -584,6 +585,23 @@ static struct ieee80211_regdomain *country_ie_2_rd(
 
 		reg_rule->flags = flags;
 
+		/* 2 GHz */
+		if (triplet->chans.first_channel <= 14)
+			end_channel = triplet->chans.first_channel +
+				triplet->chans.num_channels;
+		else
+			/*
+			 * 5 GHz -- For example in country IEs if the first
+			 * channel given is 36 and the number of channels is 4
+			 * then the individual channel numbers defined for the
+			 * 5 GHz PHY by these parameters are: 36, 40, 44, and 48
+			 * and not 36, 37, 38, 39.
+			 *
+			 * See: http://tinyurl.com/11d-clarification
+			 */
+			end_channel =  triplet->chans.first_channel +
+				(4 * (triplet->chans.num_channels - 1));
+
 		/* The +10 is since the regulatory domain expects
 		 * the actual band edge, not the center of freq for
 		 * its start and end freqs, assuming 20 MHz bandwidth on
@@ -593,8 +611,7 @@ static struct ieee80211_regdomain *country_ie_2_rd(
 				triplet->chans.first_channel) - 10);
 		freq_range->end_freq_khz =
 			MHZ_TO_KHZ(ieee80211_channel_to_frequency(
-				triplet->chans.first_channel +
-					triplet->chans.num_channels) + 10);
+				end_channel) + 10);
 
 		/* Large arbitrary values, we intersect later */
 		/* Increment this if we ever support >= 40 MHz channels
-- 
1.6.1.rc3.51.g5832d

