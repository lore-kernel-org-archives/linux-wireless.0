Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms5.Sony.CO.JP ([211.125.136.201]:43302 "EHLO ms5.sony.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751250AbYCLHkh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Mar 2008 03:40:37 -0400
Date: Wed, 12 Mar 2008 16:41:11 +0900
From: Masakazu Mokuno <mokuno@sm.sony.co.jp>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] PS3: gelic: change the prefix of the net interface for wireless
Cc: linux-wireless@vger.kernel.org, kay.sievers@vrfy.org,
	sassmann@suse.de,
	Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
	geoffrey.levand@am.sony.com
Message-Id: <20080312162152.0B14.40F06B3A@sm.sony.co.jp> (sfid-20080312_074040_455830_CC5A3B82)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The gelic driver uses two net interfaces, one for ethernet and the
other for wireless. They share same MAC address and use 'eth' prefix
for the name.
As udev uses the MAC address to check uniqueness, this is
somewhat problematic.  So change the prefix of the network interface
name for the wireless so that udev can have an easy way to distinguish
interfaces.

Signed-off-by: Masakazu Mokuno <mokuno@sm.sony.co.jp>
---
 drivers/net/ps3_gelic_wireless.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/ps3_gelic_wireless.c
+++ b/drivers/net/ps3_gelic_wireless.c
@@ -2389,6 +2389,8 @@ static struct net_device *gelic_wl_alloc
 	if (!netdev)
 		return NULL;
 
+	strcpy(netdev->name, "wlan%d");
+
 	port = netdev_priv(netdev);
 	port->netdev = netdev;
 	port->card = card;

