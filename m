Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38715 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752556AbbJON7D (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Oct 2015 09:59:03 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 11/12] cfg80211: reg: reduce chan_reg_rule_print_dbg() ifdef
Date: Thu, 15 Oct 2015 15:58:22 +0200
Message-Id: <1444917503-19118-11-git-send-email-johannes@sipsolutions.net> (sfid-20151015_155907_883996_7C346A8F)
In-Reply-To: <1444917503-19118-1-git-send-email-johannes@sipsolutions.net>
References: <1444917503-19118-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The function is void and static, so just ifdef its contents
instead of duplicating the declaration.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/reg.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 724b7a90e931..ef327236e0f0 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1130,11 +1130,11 @@ const char *reg_initiator_name(enum nl80211_reg_initiator initiator)
 }
 EXPORT_SYMBOL(reg_initiator_name);
 
-#ifdef CONFIG_CFG80211_REG_DEBUG
 static void chan_reg_rule_print_dbg(const struct ieee80211_regdomain *regd,
 				    struct ieee80211_channel *chan,
 				    const struct ieee80211_reg_rule *reg_rule)
 {
+#ifdef CONFIG_CFG80211_REG_DEBUG
 	const struct ieee80211_power_rule *power_rule;
 	const struct ieee80211_freq_range *freq_range;
 	char max_antenna_gain[32], bw[32];
@@ -1163,15 +1163,8 @@ static void chan_reg_rule_print_dbg(const struct ieee80211_regdomain *regd,
 		      freq_range->start_freq_khz, freq_range->end_freq_khz,
 		      bw, max_antenna_gain,
 		      power_rule->max_eirp);
-}
-#else
-static void chan_reg_rule_print_dbg(const struct ieee80211_regdomain *regd,
-				    struct ieee80211_channel *chan,
-				    const struct ieee80211_reg_rule *reg_rule)
-{
-	return;
-}
 #endif
+}
 
 /*
  * Note that right now we assume the desired channel bandwidth
-- 
2.5.1

