Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:42908 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750811AbaEGRF0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2014 13:05:26 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
Date: Wed,  7 May 2014 20:05:12 +0300
Message-Id: <1399482312-20151-1-git-send-email-luca@coelho.fi> (sfid-20140507_190530_115263_81DA4FA8)
Subject: [PATCH] mac80211: fix sparse warning caused by __ieee80211_channel_switch()
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

Commit 59af6928 (mac80211: fix CSA tx queue stopping) introduced a
sparse warning:

net/mac80211/cfg.c:3274:5: warning: symbol '__ieee80211_channel_switch' was not declared. Should it be static?

Fix it by declaring the function static.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
 net/mac80211/cfg.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 0c87c8c..3f8f005 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3271,8 +3271,9 @@ static int ieee80211_set_csa_beacon(struct ieee80211_sub_if_data *sdata,
 	return 0;
 }
 
-int __ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
-			       struct cfg80211_csa_settings *params)
+static int
+__ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
+			   struct cfg80211_csa_settings *params)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_local *local = sdata->local;
-- 
2.0.0.rc0

