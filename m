Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:37880 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754969AbeDCIfc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Apr 2018 04:35:32 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Ilan Peer <ilan.peer@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Tue,  3 Apr 2018 11:35:22 +0300
Message-Id: <20180403083522.31628-1-luca@coelho.fi> (sfid-20180403_103536_575416_056F59D2)
Subject: [PATCH] mac80211: Fix condition validating WMM IE
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ilan Peer <ilan.peer@intel.com>

Commit c470bdc1aaf3 ("mac80211: don't WARN on bad WMM parameters from
buggy APs") handled cases where an AP reports a zeroed WMM
IE. However, the condition that checks the validity accessed the wrong
index in the ieee80211_tx_queue_params array, thus wrongly deducing
that the parameters are invalid. Fix it.

Fixes: c470bdc1aaf3 ("mac80211: don't WARN on bad WMM parameters from buggy APs")
Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 net/mac80211/mlme.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 07b58d20e89c..e521f19b02c0 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1786,7 +1786,7 @@ static bool ieee80211_sta_wmm_params(struct ieee80211_local *local,
 		params[ac].acm = acm;
 		params[ac].uapsd = uapsd;
 
-		if (params->cw_min == 0 ||
+		if (params[ac].cw_min == 0 ||
 		    params[ac].cw_min > params[ac].cw_max) {
 			sdata_info(sdata,
 				   "AP has invalid WMM params (CWmin/max=%d/%d for ACI %d), using defaults\n",
-- 
2.16.2
