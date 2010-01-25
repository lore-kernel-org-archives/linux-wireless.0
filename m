Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:62471 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752327Ab0AYSPr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jan 2010 13:15:47 -0500
From: <wey-yi.w.guy@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 1/1] mac80211: only single mutex locked to prevent deadlock
Date: Mon, 25 Jan 2010 10:12:16 -0800
Message-Id: <1264443136-30865-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Both ifmgd->mtx and sdata->local->iflist_mtx are locked in
ieee80211_mgd_probe_ap(), not sure it will cause deadlock condition. but
it is better to only has one mutex at a time.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 net/mac80211/mlme.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 1e1d16c..e23df14 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -914,10 +914,13 @@ static void ieee80211_mgd_probe_ap(struct ieee80211_sub_if_data *sdata,
 	if (already)
 		goto out;
 
+	mutex_unlock(&ifmgd->mtx);
+
 	mutex_lock(&sdata->local->iflist_mtx);
 	ieee80211_recalc_ps(sdata->local, -1);
 	mutex_unlock(&sdata->local->iflist_mtx);
 
+	mutex_lock(&ifmgd->mtx);
 	ifmgd->probe_send_count = 0;
 	ieee80211_mgd_probe_ap_send(sdata);
  out:
-- 
1.5.6.3

