Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.platinumzone24.at ([88.198.159.93]:41899 "EHLO
	mail.platinumzone24.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933436Ab0GSTKv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jul 2010 15:10:51 -0400
Message-ID: <4C449CF2.7090800@davizone.at>
Date: Mon, 19 Jul 2010 20:44:02 +0200
From: David Gnedt <david.gnedt@davizone.at>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH] mac80211: set carrier on for monitor interfaces on ieee80211_open
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If a station interface is reused as monitor interface it is possible that
the carrier is still set to off. This breaks packet injection on that
monitor interface.
Force the carrier on in monitor interface initialisation like it is also done
for other interface types (e.g. adhoc, mesh point, ap).

Signed-off-by: David Gnedt <david.gnedt@davizone.at>
---
 net/mac80211/iface.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 910729f..d07d223 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -249,6 +249,8 @@ static int ieee80211_open(struct net_device *dev)
 			local->fif_other_bss++;

 		ieee80211_configure_filter(local);
+
+		netif_carrier_on(dev);
 		break;
 	default:
 		res = drv_add_interface(local, &sdata->vif);
-- 
1.6.3.3

