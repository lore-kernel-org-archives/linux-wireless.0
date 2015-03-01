Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:49636 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751283AbbCAHKq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Mar 2015 02:10:46 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Luciano Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 11/16] mac80211: remove duplicate check for quiescing when queueing work
Date: Sun,  1 Mar 2015 09:10:10 +0200
Message-Id: <1425193815-17785-12-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150301_083417_365403_4DA8131C)
In-Reply-To: <1425193815-17785-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1425193815-17785-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

In ieee80211_queue_work() we check if we're quiescing or suspended, so
it's not necessary to check for quiescing before calling this
function.  Remove duplicate checks.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/mlme.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index c5f3bd6..bc2975e 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1621,9 +1621,6 @@ void ieee80211_dynamic_ps_timer(unsigned long data)
 {
 	struct ieee80211_local *local = (void *) data;
 
-	if (local->quiescing || local->suspended)
-		return;
-
 	ieee80211_queue_work(&local->hw, &local->dynamic_ps_enable_work);
 }
 
@@ -3899,12 +3896,8 @@ static void ieee80211_sta_bcn_mon_timer(unsigned long data)
 {
 	struct ieee80211_sub_if_data *sdata =
 		(struct ieee80211_sub_if_data *) data;
-	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 
-	if (local->quiescing)
-		return;
-
 	if (sdata->vif.csa_active && !ifmgd->csa_waiting_bcn)
 		return;
 
@@ -3920,9 +3913,6 @@ static void ieee80211_sta_conn_mon_timer(unsigned long data)
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct ieee80211_local *local = sdata->local;
 
-	if (local->quiescing)
-		return;
-
 	if (sdata->vif.csa_active && !ifmgd->csa_waiting_bcn)
 		return;
 
-- 
1.9.1

