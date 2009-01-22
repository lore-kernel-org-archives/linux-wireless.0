Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:42508 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759559AbZAVXGl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2009 18:06:41 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 22 Jan 2009 15:06:41 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <johannes@sipsolutions.net>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 04/12] cfg80211: Fix sanity check on 5 GHz when processing country IE
Date: Thu, 22 Jan 2009 15:05:46 -0800
Message-ID: <1232665554-26132-5-git-send-email-lrodriguez@atheros.com> (sfid-20090123_000703_900413_EF0FA4A9)
In-Reply-To: <1232665554-26132-4-git-send-email-lrodriguez@atheros.com>
References: <1232665554-26132-1-git-send-email-lrodriguez@atheros.com>
 <1232665554-26132-2-git-send-email-lrodriguez@atheros.com>
 <1232665554-26132-3-git-send-email-lrodriguez@atheros.com>
 <1232665554-26132-4-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes two issues with the sanity check loop when processing
the country IE:

1. Do not use frequency for the current subband channel check,
   this was a big fat typo.
2. Apply the 5 GHz 4-channel steps when considering max channel
   on each subband as was done with a recent patch.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/wireless/reg.c |   30 +++++++++++++++++++-----------
 1 files changed, 19 insertions(+), 11 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 70691de..c744788 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -498,6 +498,7 @@ static struct ieee80211_regdomain *country_ie_2_rd(
 	 * calculate the number of reg rules we will need. We will need one
 	 * for each channel subband */
 	while (country_ie_len >= 3) {
+		int end_channel = 0;
 		struct ieee80211_country_ie_triplet *triplet =
 			(struct ieee80211_country_ie_triplet *) country_ie;
 		int cur_sub_max_channel = 0, cur_channel = 0;
@@ -509,9 +510,25 @@ static struct ieee80211_regdomain *country_ie_2_rd(
 			continue;
 		}
 
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
 		cur_channel = triplet->chans.first_channel;
-		cur_sub_max_channel = ieee80211_channel_to_frequency(
-			cur_channel + triplet->chans.num_channels);
+		cur_sub_max_channel = end_channel;
 
 		/* Basic sanity check */
 		if (cur_sub_max_channel < cur_channel)
@@ -590,15 +607,6 @@ static struct ieee80211_regdomain *country_ie_2_rd(
 			end_channel = triplet->chans.first_channel +
 				triplet->chans.num_channels;
 		else
-			/*
-			 * 5 GHz -- For example in country IEs if the first
-			 * channel given is 36 and the number of channels is 4
-			 * then the individual channel numbers defined for the
-			 * 5 GHz PHY by these parameters are: 36, 40, 44, and 48
-			 * and not 36, 37, 38, 39.
-			 *
-			 * See: http://tinyurl.com/11d-clarification
-			 */
 			end_channel =  triplet->chans.first_channel +
 				(4 * (triplet->chans.num_channels - 1));
 
-- 
1.6.1.rc3.51.g5832d

