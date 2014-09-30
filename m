Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:50521 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750760AbaI3EMM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Sep 2014 00:12:12 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Luciano Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH] mac80211: return the vif's chandef in ieee80211_cfg_get_channel()
Date: Tue, 30 Sep 2014 07:08:02 +0300
Message-Id: <1412050082-7763-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20140930_061228_073076_BA08FB12)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

The chandef of the channel context a vif is using may be different
than the chandef of the vif itself.  For instance, the bandwidth used
by the vif may be narrower than the one configured in the channel
context.  To avoid confusion, return the vif's chandef in
ieee80211_cfg_get_channel() instead of the chandef of the channel
context.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/cfg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 9b03d08..6a7339e 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3476,7 +3476,7 @@ static int ieee80211_cfg_get_channel(struct wiphy *wiphy,
 	rcu_read_lock();
 	chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
 	if (chanctx_conf) {
-		*chandef = chanctx_conf->def;
+		*chandef = sdata->vif.bss_conf.chandef;
 		ret = 0;
 	} else if (local->open_count > 0 &&
 		   local->open_count == local->monitors &&
-- 
1.9.1

