Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:5645 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754703AbaK0MfU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Nov 2014 07:35:20 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: michal.kazior@tieto.com,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [RFC] mac80211: take reserved vif into account when calculating the min_def
Date: Thu, 27 Nov 2014 14:30:46 +0200
Message-Id: <1417091446-16308-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20141127_133530_532731_BC566918)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When we want to calculate the minimal bandwidth needed for
a channel context, we need to take into account vifs that
have reserved the channel context.
I hit an issue with iwlwifi and channel switch as a client.

We would allocate a virgin channel context and reserve it.
At that stage, the min_def was 20MHz.
Then we would use it after CSA, and start transmitting, but
the channel context was still 20MHz even if the GO was in
40MHz. This made the firmware unhappy.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/chan.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index 4c74e8d..769e0c5 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -256,7 +256,8 @@ ieee80211_get_chanctx_max_required_bw(struct ieee80211_local *local,
 		if (!ieee80211_sdata_running(sdata))
 			continue;
 
-		if (rcu_access_pointer(sdata->vif.chanctx_conf) != conf)
+		if (rcu_access_pointer(sdata->vif.chanctx_conf) != conf &&
+		    &sdata->reserved_chanctx->conf != conf)
 			continue;
 
 		switch (vif->type) {
@@ -271,6 +272,7 @@ ieee80211_get_chanctx_max_required_bw(struct ieee80211_local *local,
 		case NL80211_IFTYPE_WDS:
 		case NL80211_IFTYPE_MESH_POINT:
 			width = vif->bss_conf.chandef.width;
+			width = max(width, sdata->reserved_chandef.width);
 			break;
 		case NL80211_IFTYPE_UNSPECIFIED:
 		case NUM_NL80211_IFTYPES:
@@ -899,6 +901,8 @@ int ieee80211_vif_reserve_chanctx(struct ieee80211_sub_if_data *sdata,
 	sdata->reserved_radar_required = radar_required;
 	sdata->reserved_ready = false;
 
+	ieee80211_recalc_chanctx_min_def(local, new_ctx);
+
 	return 0;
 }
 
-- 
1.9.1

