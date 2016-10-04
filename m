Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:42449 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751451AbcJDNcV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Oct 2016 09:32:21 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Thomas Pedersen <twp@qca.qualcomm.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: remove unnecessary mesh check
Date: Tue,  4 Oct 2016 15:32:16 +0200
Message-Id: <1475587936-30704-1-git-send-email-johannes@sipsolutions.net> (sfid-20161004_153224_067478_1EF86258)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

sta_info_get_bss() is equivalent to sta_info_get() in the
mesh case, since sta->sdata->bss will be NULL (it's only
set for AP/AP_VLAN interfaces.) Thus, the mesh check here
isn't actually needed - remove it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index fd6541f3ade3..7d0172395589 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -357,10 +357,7 @@ static int ieee80211_add_key(struct wiphy *wiphy, struct net_device *dev,
 	mutex_lock(&local->sta_mtx);
 
 	if (mac_addr) {
-		if (ieee80211_vif_is_mesh(&sdata->vif))
-			sta = sta_info_get(sdata, mac_addr);
-		else
-			sta = sta_info_get_bss(sdata, mac_addr);
+		sta = sta_info_get_bss(sdata, mac_addr);
 		/*
 		 * The ASSOC test makes sure the driver is ready to
 		 * receive the key. When wpa_supplicant has roamed
-- 
2.8.1
