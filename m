Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4547 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758409AbYDCUEP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Apr 2008 16:04:15 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Larry.Finger@lwfinger.net,
	mcgrof@gmail.com, "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] cfg80211: default to regulatory max power for channel
Date: Thu,  3 Apr 2008 15:32:54 -0400
Message-Id: <1207251174-23860-1-git-send-email-linville@tuxdriver.com> (sfid-20080403_210421_297727_6416004C)
In-Reply-To: <47F5242D.80404@lwfinger.net>
References: <47F5242D.80404@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If the driver does not specify a maximum power output, default to the
regulatory max.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
Is this a worth alternative to Larry's b43legacy patch?  It looked like
ath5k wasn't setting max_power either -- how does it work?

 net/wireless/reg.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 8cc6037..185488d 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -136,7 +136,10 @@ static void handle_channel(struct ieee80211_channel *chan,
 	chan->flags = flags;
 	chan->max_antenna_gain = min(chan->orig_mag,
 					 rg->max_antenna_gain);
-	chan->max_power = min(chan->orig_mpwr, rg->max_power);
+	if (chan->orig_mpwr)
+		chan->max_power = min(chan->orig_mpwr, rg->max_power);
+	else
+		chan->max_power = rg->max_power;
 }
 
 static void handle_band(struct ieee80211_supported_band *sband,
-- 
1.5.3.3

