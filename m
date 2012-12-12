Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:59816 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754080Ab2LLVzb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Dec 2012 16:55:31 -0500
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [RFC 2/6] wifi: Don't spam logs with 'Found new beacon' messages.
Date: Wed, 12 Dec 2012 13:54:51 -0800
Message-Id: <1355349295-30960-2-git-send-email-greearb@candelatech.com> (sfid-20121212_225535_981449_212B81FE)
In-Reply-To: <1355349295-30960-1-git-send-email-greearb@candelatech.com>
References: <1355349295-30960-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

We saw logs fill with this (at very high speeds):

cfg80211: Found new beacon on frequency: 5745 MHz (Ch 149) on wiphy0
cfg80211: Found new beacon on frequency: 5745 MHz (Ch 149) on wiphy0
cfg80211: Found new beacon on frequency: 5745 MHz (Ch 149) on wiphy0
cfg80211: Found new beacon on frequency: 5745 MHz (Ch 149) on wiphy0
cfg80211: Found new beacon on frequency: 5745 MHz (Ch 149) on wiphy0
cfg80211: Found new beacon on frequency: 5745 MHz (Ch 149) on wiphy0
cfg80211: Found new beacon on frequency: 5745 MHz (Ch 149) on wiphy0
cfg80211: Found new beacon on frequency: 5745 MHz (Ch 149) on wiphy0
cfg80211: Found new beacon on frequency: 5745 MHz (Ch 149) on wiphy0
cfg80211: Found new beacon on frequency: 5745 MHz (Ch 149) on wiphy0
cfg80211: Found new beacon on frequency: 5745 MHz (Ch 149) on wiphy0
cfg80211: Found new beacon on frequency: 5745 MHz (Ch 149) on wiphy0

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 net/wireless/reg.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 6e53089..8aa7867 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -2067,11 +2067,12 @@ int regulatory_hint_found_beacon(struct wiphy *wiphy,
 	if (!reg_beacon)
 		return -ENOMEM;
 
-	REG_DBG_PRINT("Found new beacon on "
-		      "frequency: %d MHz (Ch %d) on %s\n",
-		      beacon_chan->center_freq,
-		      ieee80211_frequency_to_channel(beacon_chan->center_freq),
-		      wiphy_name(wiphy));
+	if (printk_ratelimit())
+		REG_DBG_PRINT("Found new beacon on "
+			      "frequency: %d MHz (Ch %d) on %s\n",
+			      beacon_chan->center_freq,
+			      ieee80211_frequency_to_channel(beacon_chan->center_freq),
+			      wiphy_name(wiphy));
 
 	memcpy(&reg_beacon->chan, beacon_chan,
 		sizeof(struct ieee80211_channel));
-- 
1.7.3.4

