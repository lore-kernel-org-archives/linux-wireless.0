Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:2901 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922Ab0APThj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Jan 2010 14:37:39 -0500
From: Bob Copeland <me@bobcopeland.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Bob Copeland <me@bobcopeland.com>,
	stefano.brivio@polimi.it, mattias.nissler@gmx.de
Subject: [PATCH 1/2] mac80211: fix sign error in pid controller
Date: Sat, 16 Jan 2010 14:36:52 -0500
Message-Id: <1263670613-10864-2-git-send-email-me@bobcopeland.com>
In-Reply-To: <1263670613-10864-1-git-send-email-me@bobcopeland.com>
References: <1263670613-10864-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

While testing the pid rate controller in mac80211_hwsim, I noticed
that once the controller reached 54 Mbit rates, it would fail to
lower the rate when necessary.  The debug log shows:

1945 186786 pf_sample 50 3534 3577 50

My interpretation is that the fixed point scaling of the target
error value (pf) is incorrect: the error value of 50 compared to
a target of 14 case should result in a scaling value of
(14-50) = -36 * 256 or -9216, but instead it is (14 * 256)-50, or
3534.

Correct this by doing fixed point scaling after subtraction.

Cc: stefano.brivio@polimi.it
Cc: mattias.nissler@gmx.de
Signed-off-by: Bob Copeland <me@bobcopeland.com>
---

Mattias / Stefano, please advise if I missed something.

 net/mac80211/rc80211_pid_algo.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/rc80211_pid_algo.c b/net/mac80211/rc80211_pid_algo.c
index 699d3ed..29bc4c5 100644
--- a/net/mac80211/rc80211_pid_algo.c
+++ b/net/mac80211/rc80211_pid_algo.c
@@ -190,7 +190,7 @@ static void rate_control_pid_sample(struct rc_pid_info *pinfo,
 	rate_control_pid_normalize(pinfo, sband->n_bitrates);
 
 	/* Compute the proportional, integral and derivative errors. */
-	err_prop = (pinfo->target << RC_PID_ARITH_SHIFT) - pf;
+	err_prop = (pinfo->target - pf) << RC_PID_ARITH_SHIFT;
 
 	err_avg = spinfo->err_avg_sc >> pinfo->smoothing_shift;
 	spinfo->err_avg_sc = spinfo->err_avg_sc - err_avg + err_prop;
-- 
1.6.3.3


