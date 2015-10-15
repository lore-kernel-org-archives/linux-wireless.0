Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38709 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751682AbbJON6a (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Oct 2015 09:58:30 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 10/12] cfg80211: reg: fix antenna gain in chan_reg_rule_print_dbg()
Date: Thu, 15 Oct 2015 15:58:21 +0200
Message-Id: <1444917503-19118-10-git-send-email-johannes@sipsolutions.net> (sfid-20151015_155839_747116_478FEB33)
In-Reply-To: <1444917503-19118-1-git-send-email-johannes@sipsolutions.net>
References: <1444917503-19118-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Printing "N/A mBi" is strange - print just "N/A" instead.

Also add a missing opening parenthesis.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/reg.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index b1638c9c0798..724b7a90e931 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1145,7 +1145,7 @@ static void chan_reg_rule_print_dbg(const struct ieee80211_regdomain *regd,
 	if (!power_rule->max_antenna_gain)
 		snprintf(max_antenna_gain, sizeof(max_antenna_gain), "N/A");
 	else
-		snprintf(max_antenna_gain, sizeof(max_antenna_gain), "%d",
+		snprintf(max_antenna_gain, sizeof(max_antenna_gain), "%d mBi",
 			 power_rule->max_antenna_gain);
 
 	if (reg_rule->flags & NL80211_RRF_AUTO_BW)
@@ -1159,7 +1159,7 @@ static void chan_reg_rule_print_dbg(const struct ieee80211_regdomain *regd,
 	REG_DBG_PRINT("Updating information on frequency %d MHz with regulatory rule:\n",
 		      chan->center_freq);
 
-	REG_DBG_PRINT("%d KHz - %d KHz @ %s), (%s mBi, %d mBm)\n",
+	REG_DBG_PRINT("(%d KHz - %d KHz @ %s), (%s, %d mBm)\n",
 		      freq_range->start_freq_khz, freq_range->end_freq_khz,
 		      bw, max_antenna_gain,
 		      power_rule->max_eirp);
-- 
2.5.1

