Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:58120 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752672AbaKGN3I (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Nov 2014 08:29:08 -0500
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, emmanuel.grumbach@intel.com
Date: Fri,  7 Nov 2014 15:28:33 +0200
Message-Id: <1415366914-10997-2-git-send-email-luca@coelho.fi> (sfid-20141107_142915_804804_09412FAC)
In-Reply-To: <1415366914-10997-1-git-send-email-luca@coelho.fi>
References: <1415366914-10997-1-git-send-email-luca@coelho.fi>
Subject: [PATCH 1/2] mac80211: fix order of setting ch_switch and drv_pre_channel_switch call
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

There was a mistake when merging commit 6d027bcc (mac80211: add
pre_channel_switch driver operation) for upstream.  The assignment of
the values in the ch_switch structure came below the call to
drv_pre_channel_switch.  Fix the order.

Fixes: 6d027bcc (mac80211: add pre_channel_switch driver operation)
Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
 net/mac80211/cfg.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index c5be146..a43a148 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3158,6 +3158,12 @@ __ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 		goto out;
 	}
 
+	ch_switch.timestamp = 0;
+	ch_switch.device_timestamp = 0;
+	ch_switch.block_tx = params->block_tx;
+	ch_switch.chandef = params->chandef;
+	ch_switch.count = params->count;
+
 	err = drv_pre_channel_switch(sdata, &ch_switch);
 	if (err)
 		goto out;
@@ -3175,12 +3181,6 @@ __ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 		goto out;
 	}
 
-	ch_switch.timestamp = 0;
-	ch_switch.device_timestamp = 0;
-	ch_switch.block_tx = params->block_tx;
-	ch_switch.chandef = params->chandef;
-	ch_switch.count = params->count;
-
 	err = ieee80211_set_csa_beacon(sdata, params, &changed);
 	if (err) {
 		ieee80211_vif_unreserve_chanctx(sdata);
-- 
2.1.1

