Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:42782 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726668AbeHUJlM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Aug 2018 05:41:12 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Haim Dreyfuss <haim.dreyfuss@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Tue, 21 Aug 2018 09:22:20 +0300
Message-Id: <20180821062220.29813-3-luca@coelho.fi> (sfid-20180821_083156_268999_B3B06CC5)
In-Reply-To: <20180821062220.29813-1-luca@coelho.fi>
References: <20180821062220.29813-1-luca@coelho.fi>
Subject: [PATCH 2/2] nl80211: Pass center frequency in KHZ instead of MHZ
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Haim Dreyfuss <haim.dreyfuss@intel.com>

freq_reg_info expects to get the frequency in KHZ Instead we
accidently pass it in MHZ.  Thus, currently the function always return
ERR rule.  Fix that.

Fixes: 50f32718e125 ("nl80211: Add wmm rule attribute to NL80211_CMD_GET_WIPHY dump command")
Signed-off-by: Haim Dreyfuss <haim.dreyfuss@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 net/wireless/nl80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 1760f38295d5..fbe9e0d98e1b 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -766,7 +766,7 @@ static int nl80211_msg_put_channel(struct sk_buff *msg, struct wiphy *wiphy,
 
 	if (large) {
 		const struct ieee80211_reg_rule *rule =
-			freq_reg_info(wiphy, chan->center_freq);
+			freq_reg_info(wiphy, MHZ_TO_KHZ(chan->center_freq));
 
 		if (!IS_ERR(rule) && rule->wmm_rule) {
 			if (nl80211_msg_put_wmm_rules(msg, rule))
-- 
2.18.0
