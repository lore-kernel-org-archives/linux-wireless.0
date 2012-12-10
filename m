Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:58196 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751310Ab2LJR5j (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2012 12:57:39 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH 1/2] mac80211: flush AP_VLAN stations when tearing down the BSS AP
Date: Mon, 10 Dec 2012 18:57:35 +0100
Message-Id: <1355162256-34131-1-git-send-email-nbd@openwrt.org> (sfid-20121210_185749_963172_D9A790D5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/mac80211/cfg.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 5c61677..a5d4361 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -998,8 +998,10 @@ static int ieee80211_stop_ap(struct wiphy *wiphy, struct net_device *dev)
 	old_probe_resp = rtnl_dereference(sdata->u.ap.probe_resp);
 
 	/* turn off carrier for this interface and dependent VLANs */
-	list_for_each_entry(vlan, &sdata->u.ap.vlans, u.vlan.list)
+	list_for_each_entry(vlan, &sdata->u.ap.vlans, u.vlan.list) {
+		sta_info_flush(local, vlan);
 		netif_carrier_off(vlan->dev);
+	}
 	netif_carrier_off(dev);
 
 	/* remove beacon and probe response */
-- 
1.7.12.2

