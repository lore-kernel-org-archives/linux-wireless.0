Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from setoy.chost.de ([217.160.209.225]:60226 "EHLO smtp.chost.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932938Ab0FELd3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Jun 2010 07:33:29 -0400
From: Sascha Silbe <sascha-pgp@silbe.org>
To: linux-wireless@vger.kernel.org
Date: Sat, 05 Jun 2010 13:30:12 +0200
Subject: [PATCH] libertas: Fix ethtool reporting no WOL options supported if WOL is not already active
Reply-To: Sascha Silbe <sascha-ml-reply-to-2010-2@silbe.org>
Message-Id: <1274806808-24185-2-git-send-email-sascha-pgp@silbe.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes the libertas driver incorrectly reporting that Wake-on-LAN
is not supported if Wake-on-LAN is currently disabled.

Signed-off-by: Sascha Silbe <sascha-pgp@silbe.org>
Acked-by: Dan Williams <dcbw@redhat.com>
---
 drivers/net/wireless/libertas/ethtool.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

Resend with Acked-By Dan and Signed-Off-By, no other changes.

Without patch:

root@xo15-minimal:~# ethtool wlan0
Settings for wlan0:
        Supports Wake-on: d
        Wake-on: d
root@xo15-minimal:~# ethtool -s wlan0 wol pum
root@xo15-minimal:~# ethtool wlan0
Settings for wlan0:
        Supports Wake-on: pumb
        Wake-on: pum
root@xo15-minimal:~# ethtool -s wlan0 wol d
root@xo15-minimal:~# ethtool wlan0
Settings for wlan0:
        Supports Wake-on: d
        Wake-on: d
root@xo15-minimal:~# 


With patch:

xo-sascha:~# ethtool eth0
Settings for eth0:
        Supports Wake-on: pumb
        Wake-on: d
xo-sascha:~# ethtool -s eth0 wol pum
xo-sascha:~# ethtool eth0
Settings for eth0:
        Supports Wake-on: pumb
        Wake-on: pum
xo-sascha:~# ethtool -s eth0 wol d
xo-sascha:~# ethtool eth0
Settings for eth0:
        Supports Wake-on: pumb
        Wake-on: d

diff --git a/drivers/net/wireless/libertas/ethtool.c b/drivers/net/wireless/libertas/ethtool.c
index 6eb9a88..4a337b7 100644
--- a/drivers/net/wireless/libertas/ethtool.c
+++ b/drivers/net/wireless/libertas/ethtool.c
@@ -145,14 +145,11 @@ static void lbs_ethtool_get_wol(struct net_device *dev,
 {
 	struct lbs_private *priv = dev->ml_priv;
 
-	if (priv->wol_criteria == 0xffffffff) {
-		/* Interface driver didn't configure wake */
-		wol->supported = wol->wolopts = 0;
-		return;
-	}
-
 	wol->supported = WAKE_UCAST|WAKE_MCAST|WAKE_BCAST|WAKE_PHY;
 
+	if (priv->wol_criteria == EHS_REMOVE_WAKEUP)
+		return;
+
 	if (priv->wol_criteria & EHS_WAKE_ON_UNICAST_DATA)
 		wol->wolopts |= WAKE_UCAST;
 	if (priv->wol_criteria & EHS_WAKE_ON_MULTICAST_DATA)
-- 
1.6.5

