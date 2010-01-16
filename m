Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:2872 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198Ab0APThZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Jan 2010 14:37:25 -0500
From: Bob Copeland <me@bobcopeland.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 2/2] mac80211: pid: replace open-coded msecs_to_jiffies
Date: Sat, 16 Jan 2010 14:36:53 -0500
Message-Id: <1263670613-10864-3-git-send-email-me@bobcopeland.com>
In-Reply-To: <1263670613-10864-1-git-send-email-me@bobcopeland.com>
References: <1263670613-10864-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Code directly scaling by HZ and rounding can be more efficiently
and clearly performed with msecs_to_jiffies.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 net/mac80211/rc80211_pid_algo.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/rc80211_pid_algo.c b/net/mac80211/rc80211_pid_algo.c
index 29bc4c5..2652a37 100644
--- a/net/mac80211/rc80211_pid_algo.c
+++ b/net/mac80211/rc80211_pid_algo.c
@@ -157,9 +157,7 @@ static void rate_control_pid_sample(struct rc_pid_info *pinfo,
 
 	/* In case nothing happened during the previous control interval, turn
 	 * the sharpening factor on. */
-	period = (HZ * pinfo->sampling_period + 500) / 1000;
-	if (!period)
-		period = 1;
+	period = msecs_to_jiffies(pinfo->sampling_period);
 	if (jiffies - spinfo->last_sample > 2 * period)
 		spinfo->sharp_cnt = pinfo->sharpen_duration;
 
@@ -252,9 +250,7 @@ static void rate_control_pid_tx_status(void *priv, struct ieee80211_supported_ba
 	}
 
 	/* Update PID controller state. */
-	period = (HZ * pinfo->sampling_period + 500) / 1000;
-	if (!period)
-		period = 1;
+	period = msecs_to_jiffies(pinfo->sampling_period);
 	if (time_after(jiffies, spinfo->last_sample + period))
 		rate_control_pid_sample(pinfo, sband, sta, spinfo);
 }
-- 
1.6.3.3


