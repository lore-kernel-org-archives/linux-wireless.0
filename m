Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:56994 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751157AbeCZNVJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Mar 2018 09:21:09 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH] mac80211: don't WARN on bad WMM parameters from buggy APs
Date: Mon, 26 Mar 2018 16:21:04 +0300
Message-Id: <20180326132104.26709-1-emmanuel.grumbach@intel.com> (sfid-20180326_152112_792933_D52F42BD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Apparently, some APs are buggy enough to send a zeroed
WMM IE. Don't WARN on this since this is not caused by a bug
on the client's system.

This aligns the condition of the WARNING in drv_conf_tx
with the validity check in ieee80211_sta_wmm_params.
We will now pick the default values whenever we get
a zeroed WMM IE.

This has been reported here:
https://bugzilla.kernel.org/show_bug.cgi?id=199161

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/mlme.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 39b660b9a908..a6b628964b84 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1785,7 +1785,8 @@ static bool ieee80211_sta_wmm_params(struct ieee80211_local *local,
 		params[ac].acm = acm;
 		params[ac].uapsd = uapsd;
 
-		if (params[ac].cw_min > params[ac].cw_max) {
+		if (params->cw_min == 0 ||
+		    params[ac].cw_min > params[ac].cw_max) {
 			sdata_info(sdata,
 				   "AP has invalid WMM params (CWmin/max=%d/%d for ACI %d), using defaults\n",
 				   params[ac].cw_min, params[ac].cw_max, aci);
-- 
2.14.3
