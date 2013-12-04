Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:27519 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932750Ab3LDPml (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Dec 2013 10:42:41 -0500
From: Max.Stepanov@intel.com
To: linux-wireless@vger.kernel.org
Cc: Max Stepanov <Max.Stepanov@intel.com>
Subject: [RFC] cfg80211: read station mgmt keys via get_key call
Date: Wed,  4 Dec 2013 17:42:42 +0200
Message-Id: <1386171762-5422-1-git-send-email-Max.Stepanov@intel.com> (sfid-20131204_164249_975320_5DA925D7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Max Stepanov <Max.Stepanov@intel.com>

Allow to read management keys stored in a station's gtk key
array with cfg80211 get_key function.

Signed-off-by: Max Stepanov <Max.Stepanov@intel.com>
---
 net/mac80211/cfg.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 00fa219..e96960f 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -303,7 +303,8 @@ static int ieee80211_get_key(struct wiphy *wiphy, struct net_device *dev,
 
 		if (pairwise && key_idx < NUM_DEFAULT_KEYS)
 			key = rcu_dereference(sta->ptk[key_idx]);
-		else if (!pairwise && key_idx < NUM_DEFAULT_KEYS)
+		else if (!pairwise &&
+			 key_idx < NUM_DEFAULT_KEYS + NUM_DEFAULT_MGMT_KEYS)
 			key = rcu_dereference(sta->gtk[key_idx]);
 	} else
 		key = rcu_dereference(sdata->keys[key_idx]);
-- 
1.8.5.rc2

