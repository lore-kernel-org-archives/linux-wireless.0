Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:32706 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752149Ab2DVQFS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Apr 2012 12:05:18 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 1/1] mac80211: check for non-managed interface
Date: Sun, 22 Apr 2012 09:00:15 -0700
Message-Id: <1335110415-12695-1-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120422_180522_470988_8372D510)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Average beacon signal only keep tracked by managed interface,
give warning and return 0 for the others.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 net/mac80211/util.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 89c1e5b..2cbcb6a 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1799,5 +1799,10 @@ int ieee80211_ave_rssi(struct ieee80211_vif *vif)
 	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 
+	if (sdata->vif.type != NL80211_IFTYPE_STATION) {
+		/* non-managed type inferfaces */
+		WARN_ON(1);
+		return 0;
+	}
 	return ifmgd->ave_beacon_signal;
 }
-- 
1.7.0.4

