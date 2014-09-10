Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:63279 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751817AbaIJLLS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2014 07:11:18 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Eliad Peller <eliad@wizery.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 2/3] mac80211: set smps_mode according to ap params
Date: Wed, 10 Sep 2014 14:07:35 +0300
Message-Id: <1410347256-9324-2-git-send-email-emmanuel.grumbach@intel.com> (sfid-20140910_131123_328859_06299966)
In-Reply-To: <1410347256-9324-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1410347256-9324-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

Take the requested smps mode from the ap params
(instead of always starting with SMPS_OFF)

Signed-off-by: Eliad Peller <eliad@wizery.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/cfg.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 101ae6c..fb6a150 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -683,8 +683,19 @@ static int ieee80211_start_ap(struct wiphy *wiphy, struct net_device *dev,
 	if (old)
 		return -EALREADY;
 
-	/* TODO: make hostapd tell us what it wants */
-	sdata->smps_mode = IEEE80211_SMPS_OFF;
+	switch (params->smps_mode) {
+	case NL80211_SMPS_OFF:
+		sdata->smps_mode = IEEE80211_SMPS_OFF;
+		break;
+	case NL80211_SMPS_STATIC:
+		sdata->smps_mode = IEEE80211_SMPS_STATIC;
+		break;
+	case NL80211_SMPS_DYNAMIC:
+		sdata->smps_mode = IEEE80211_SMPS_DYNAMIC;
+		break;
+	default:
+		return -EINVAL;
+	}
 	sdata->needed_rx_chains = sdata->local->rx_chains;
 
 	mutex_lock(&local->mtx);
-- 
1.9.1

