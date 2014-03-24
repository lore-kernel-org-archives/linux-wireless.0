Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:47423 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750924AbaCXH6L (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Mar 2014 03:58:11 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Ido Yariv <ido@wizery.com>,
	Ido Yariv <idox.yariv@intel.com>
Subject: [PATCH] mac80211: Disable SMPS for the monitor interface
Date: Mon, 24 Mar 2014 09:55:45 +0200
Message-Id: <1395647745-7857-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20140324_085815_883846_363BAFB4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ido Yariv <ido@wizery.com>

All antennas should be operational when monitoring to maximize
reception.

Signed-off-by: Ido Yariv <idox.yariv@intel.com>
---
 net/mac80211/chan.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index 57b8ab1..be677e0 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -522,6 +522,13 @@ void ieee80211_recalc_smps_chanctx(struct ieee80211_local *local,
 		rx_chains_static = max(rx_chains_static, needed_static);
 		rx_chains_dynamic = max(rx_chains_dynamic, needed_dynamic);
 	}
+
+	/* Disable SMPS for the monitor interface */
+	sdata = rcu_dereference(local->monitor_sdata);
+	if (sdata &&
+	    rcu_access_pointer(sdata->vif.chanctx_conf) == &chanctx->conf)
+		rx_chains_dynamic = rx_chains_static = local->rx_chains;
+
 	rcu_read_unlock();
 
 	if (!local->use_chanctx) {
-- 
1.8.3.2

