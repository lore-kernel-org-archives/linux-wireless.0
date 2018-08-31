Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:45470 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727263AbeHaMuc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 31 Aug 2018 08:50:32 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Shaul Triebitz <shaul.triebitz@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 31 Aug 2018 11:31:15 +0300
Message-Id: <20180831083130.15525-14-luca@coelho.fi> (sfid-20180831_104438_385662_9E17FB03)
In-Reply-To: <20180831083130.15525-1-luca@coelho.fi>
References: <20180831083130.15525-1-luca@coelho.fi>
Subject: [PATCH 13/28] mac80211: in AP mode, set bss_conf::he_supported
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Shaul Triebitz <shaul.triebitz@intel.com>

In AP mode, If AP advertises HE capabilities, set to true
bss_conf::he_supported so that the Driver knows about it.

Signed-off-by: Shaul Triebitz <shaul.triebitz@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 net/mac80211/cfg.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 884b2b29d2a2..64a74efa1301 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -909,6 +909,9 @@ static int ieee80211_start_ap(struct wiphy *wiphy, struct net_device *dev,
 
 	sdata->vif.bss_conf.beacon_int = params->beacon_interval;
 
+	if (params->he_cap)
+		sdata->vif.bss_conf.he_support = true;
+
 	mutex_lock(&local->mtx);
 	err = ieee80211_vif_use_channel(sdata, &params->chandef,
 					IEEE80211_CHANCTX_SHARED);
-- 
2.18.0
