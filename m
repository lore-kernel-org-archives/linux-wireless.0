Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:16966 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750857AbaAGLN3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jan 2014 06:13:29 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH] mac80211: allow to set smps mode to OFF in AP mode
Date: Tue,  7 Jan 2014 13:11:41 +0200
Message-Id: <1389093101-12186-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20140107_121332_507073_ACA94FD5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In managed mode, we should not ask for OFF mode because the
power settings may still require DYNAMIC. In AP mode, this
should be allowed since the default settings is OFF and
AUTOMATIC is not allowed.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/ht.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/ht.c b/net/mac80211/ht.c
index 9a8be8f..fab7b91 100644
--- a/net/mac80211/ht.c
+++ b/net/mac80211/ht.c
@@ -479,10 +479,9 @@ void ieee80211_request_smps(struct ieee80211_vif *vif,
 			 vif->type != NL80211_IFTYPE_AP))
 		return;
 
-	if (WARN_ON(smps_mode == IEEE80211_SMPS_OFF))
-		smps_mode = IEEE80211_SMPS_AUTOMATIC;
-
 	if (vif->type == NL80211_IFTYPE_STATION) {
+		if (WARN_ON(smps_mode == IEEE80211_SMPS_OFF))
+			smps_mode = IEEE80211_SMPS_AUTOMATIC;
 		if (sdata->u.mgd.driver_smps_mode == smps_mode)
 			return;
 		sdata->u.mgd.driver_smps_mode = smps_mode;
-- 
1.8.3.2

