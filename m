Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:45290 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727495AbeHaMh6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 31 Aug 2018 08:37:58 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        "Dreyfuss, Haim" <haim.dreyfuss@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 31 Aug 2018 11:31:04 +0300
Message-Id: <20180831083130.15525-3-luca@coelho.fi> (sfid-20180831_103150_317047_1DBCD289)
In-Reply-To: <20180831083130.15525-1-luca@coelho.fi>
References: <20180831083130.15525-1-luca@coelho.fi>
Subject: [PATCH 02/28] mac80211: fix WMM TXOP calculation
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Dreyfuss, Haim" <haim.dreyfuss@intel.com>

In commit 9236c4523e5b ("mac80211: limit wmm params to comply
with ETSI requirements"), we have limited the WMM parameters to
comply with 802.11 and ETSI standard.  Mistakenly the TXOP value
was caluclated wrong.  Fix it by taking the minimum between
802.11 to ETSI to make sure we are not violating both.

Fixes: e552af058148 ("mac80211: limit wmm params to comply with ETSI requirements")
Signed-off-by: Haim Dreyfuss <haim.dreyfuss@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 net/mac80211/util.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index d886789ff59e..c03362f34bf4 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1266,8 +1266,7 @@ void ieee80211_regulatory_limit_wmm_params(struct ieee80211_sub_if_data *sdata,
 	qparam->cw_min = max_t(u16, qparam->cw_min, wmm_ac->cw_min);
 	qparam->cw_max = max_t(u16, qparam->cw_max, wmm_ac->cw_max);
 	qparam->aifs = max_t(u8, qparam->aifs, wmm_ac->aifsn);
-	qparam->txop = !qparam->txop ? wmm_ac->cot / 32 :
-		min_t(u16, qparam->txop, wmm_ac->cot / 32);
+	qparam->txop = min_t(u16, qparam->txop, wmm_ac->cot / 32);
 	rcu_read_unlock();
 }
 
-- 
2.18.0
