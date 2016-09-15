Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:54518 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1756574AbcIONaT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Sep 2016 09:30:19 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>
Date: Thu, 15 Sep 2016 16:30:03 +0300
Message-Id: <20160915133003.24214-2-luca@coelho.fi> (sfid-20160915_153038_041554_003B2C2C)
In-Reply-To: <20160915133003.24214-1-luca@coelho.fi>
References: <20160915133003.24214-1-luca@coelho.fi>
Subject: [PATCH 2/2] mac80211_hwsim: statically initialize hwsim_radios list
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's no need to initialize at runtime, when the static
declaration macro can just be used instead, so do that.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 8c35ac8..431f13b 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -487,7 +487,7 @@ static const struct ieee80211_iface_combination hwsim_if_comb_p2p_dev[] = {
 };
 
 static spinlock_t hwsim_radio_lock;
-static struct list_head hwsim_radios;
+static LIST_HEAD(hwsim_radios);
 static int hwsim_radio_idx;
 
 static struct platform_driver mac80211_hwsim_driver = {
@@ -3376,7 +3376,6 @@ static int __init init_mac80211_hwsim(void)
 		mac80211_hwsim_unassign_vif_chanctx;
 
 	spin_lock_init(&hwsim_radio_lock);
-	INIT_LIST_HEAD(&hwsim_radios);
 
 	err = register_pernet_device(&hwsim_net_ops);
 	if (err)
-- 
2.9.3
