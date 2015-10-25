Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:12646 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752814AbbJYJAJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Oct 2015 05:00:09 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 08/10] mac80211: Remove WARN_ON_ONCE in ieee80211_recalc_smps
Date: Sun, 25 Oct 2015 10:59:40 +0200
Message-Id: <1445763582-11421-8-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151025_100018_299697_CA450DBF)
In-Reply-To: <1445763582-11421-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1445763582-11421-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>

The recalc_smps work can run after the station disassociates.
At this stage we already released the channel, but the work
will be cancelled only when the interface stops.
In this scenario we can hit the warning in ieee80211_recalc_smps, so
just remove it.

Signed-off-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/util.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 29c55ce..4ec576b 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2142,7 +2142,13 @@ void ieee80211_recalc_smps(struct ieee80211_sub_if_data *sdata)
 	chanctx_conf = rcu_dereference_protected(sdata->vif.chanctx_conf,
 					lockdep_is_held(&local->chanctx_mtx));
 
-	if (WARN_ON_ONCE(!chanctx_conf))
+	/*
+	 * This function can be called from a work, thus it may be possible
+	 * that the chanctx_conf is removed (due to a disconnection, for
+	 * example).
+	 * So nothing should be done in such case.
+	 */
+	if (!chanctx_conf)
 		goto unlock;
 
 	chanctx = container_of(chanctx_conf, struct ieee80211_chanctx, conf);
-- 
2.1.4

