Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:3023 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753028Ab0L2WI5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Dec 2010 17:08:57 -0500
From: Bob Copeland <me@bobcopeland.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Bob Copeland <me@bobcopeland.com>
Subject: [PATCH] cfg80211: fix transposition of words in printk
Date: Wed, 29 Dec 2010 17:09:02 -0500
Message-Id: <1293660542-9346-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixes the misplaced article in the following:

"cfg80211: Updating information on frequency 5785 MHz for
    20 a MHz width channel with regulatory rule:"

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---

Take 2, sorry for the noise...

 net/wireless/reg.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 99d4183..37693b6 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -752,7 +752,7 @@ static void chan_reg_rule_print_dbg(struct ieee80211_channel *chan,
 		snprintf(max_antenna_gain, 32, "%d", power_rule->max_antenna_gain);
 
 	REG_DBG_PRINT("Updating information on frequency %d MHz "
-		      "for %d a MHz width channel with regulatory rule:\n",
+		      "for a %d MHz width channel with regulatory rule:\n",
 		      chan->center_freq,
 		      KHZ_TO_MHZ(desired_bw_khz));
 
-- 
1.7.1.1


