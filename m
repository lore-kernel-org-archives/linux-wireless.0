Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:49173 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061AbXLNGs2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Dec 2007 01:48:28 -0500
Subject: Re: [PATCH] PS3: gelic: Add wireless support for PS3
From: David Woodhouse <dwmw2@infradead.org>
To: Masakazu Mokuno <mokuno@sm.sony.co.jp>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	geoffrey.levand@am.sony.com,
	Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
In-Reply-To: <20071213211626.BF8E.MOKUNO@sm.sony.co.jp>
References: <20071213211626.BF8E.MOKUNO@sm.sony.co.jp>
Content-Type: text/plain
Date: Fri, 14 Dec 2007 01:48:52 -0500
Message-Id: <1197614933.3798.36.camel@shinybook.infradead.org> (sfid-20071214_064831_966266_5236A0F8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--- linux-2.6.23.ppc64/drivers/net/ps3_gelic_net.c~	2007-12-14 01:31:50.000000000 -0500
+++ linux-2.6.23.ppc64/drivers/net/ps3_gelic_net.c	2007-12-14 01:39:25.000000000 -0500
@@ -1139,7 +1139,7 @@ static irqreturn_t gelic_card_interrupt(
  *
  * see Documentation/networking/netconsole.txt
  */
-static void gelic_net_poll_controller(struct net_device *netdev)
+void gelic_net_poll_controller(struct net_device *netdev)
 {
 	struct gelic_card *card = netdev_card(netdev);
 
--- linux-2.6.23.ppc64/drivers/net/ps3_gelic_net.h~	2007-12-14 01:31:50.000000000 -0500
+++ linux-2.6.23.ppc64/drivers/net/ps3_gelic_net.h	2007-12-14 01:39:47.000000000 -0500
@@ -346,6 +346,7 @@ extern void gelic_net_tx_timeout(struct 
 extern int gelic_net_change_mtu(struct net_device *netdev, int new_mtu);
 extern int gelic_net_setup_netdev(struct net_device *netdev,
 				  struct gelic_card *card);
+extern void gelic_net_poll_controller(struct net_device *netdev);
 
 /* shared ethtool ops */
 extern void gelic_net_get_drvinfo(struct net_device *netdev,

-- 
dwmw2

