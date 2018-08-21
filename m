Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:42776 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726658AbeHUJlM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Aug 2018 05:41:12 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Haim Dreyfuss <haim.dreyfuss@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Tue, 21 Aug 2018 09:22:19 +0300
Message-Id: <20180821062220.29813-2-luca@coelho.fi> (sfid-20180821_082315_323423_80EC0318)
In-Reply-To: <20180821062220.29813-1-luca@coelho.fi>
References: <20180821062220.29813-1-luca@coelho.fi>
Subject: [PATCH 1/2] nl80211: Fix nla_put_u8 to u16 for NL80211_WMMR_TXOP
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Haim Dreyfuss <haim.dreyfuss@intel.com>

TXOP (also known as Channel Occupancy Time) is u16 and should be
added using nla_put_u16 instead of u8, fix that.

Fixes: 50f32718e125 ("nl80211: Add wmm rule attribute to NL80211_CMD_GET_WIPHY dump command")
Signed-off-by: Haim Dreyfuss <haim.dreyfuss@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 net/wireless/nl80211.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 5fb9b7dd9831..1760f38295d5 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -674,8 +674,8 @@ static int nl80211_msg_put_wmm_rules(struct sk_buff *msg,
 				rule->wmm_rule->client[j].cw_max) ||
 		    nla_put_u8(msg, NL80211_WMMR_AIFSN,
 			       rule->wmm_rule->client[j].aifsn) ||
-		    nla_put_u8(msg, NL80211_WMMR_TXOP,
-			       rule->wmm_rule->client[j].cot))
+		    nla_put_u16(msg, NL80211_WMMR_TXOP,
+				rule->wmm_rule->client[j].cot))
 			goto nla_put_failure;
 
 		nla_nest_end(msg, nl_wmm_rule);
-- 
2.18.0
