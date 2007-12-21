Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from MGW4.Sony.CO.JP ([137.153.0.46]:42044 "EHLO mgw4.sony.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751875AbXLUJ0U (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Dec 2007 04:26:20 -0500
Date: Fri, 21 Dec 2007 18:26:09 +0900
From: Masakazu Mokuno <mokuno@sm.sony.co.jp>
To: David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] PS3: gelic: Add wireless support for PS3
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	geoffrey.levand@am.sony.com,
	Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
In-Reply-To: <1197614933.3798.36.camel@shinybook.infradead.org>
References: <20071213211626.BF8E.MOKUNO@sm.sony.co.jp> <1197614933.3798.36.camel@shinybook.infradead.org>
Message-Id: <20071221182516.BA49.40F06B3A@sm.sony.co.jp> (sfid-20071221_092635_148024_5BEBAE52)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

	Hi David,

On Fri, 14 Dec 2007 01:48:52 -0500
David Woodhouse <dwmw2@infradead.org> wrote:

> --- linux-2.6.23.ppc64/drivers/net/ps3_gelic_net.c~	2007-12-14 01:31:50.000000000 -0500
> +++ linux-2.6.23.ppc64/drivers/net/ps3_gelic_net.c	2007-12-14 01:39:25.000000000 -0500
> @@ -1139,7 +1139,7 @@ static irqreturn_t gelic_card_interrupt(
>   *
>   * see Documentation/networking/netconsole.txt
>   */
> -static void gelic_net_poll_controller(struct net_device *netdev)
> +void gelic_net_poll_controller(struct net_device *netdev)
>  {
>  	struct gelic_card *card = netdev_card(netdev);
>  
> --- linux-2.6.23.ppc64/drivers/net/ps3_gelic_net.h~	2007-12-14 01:31:50.000000000 -0500
> +++ linux-2.6.23.ppc64/drivers/net/ps3_gelic_net.h	2007-12-14 01:39:47.000000000 -0500
> @@ -346,6 +346,7 @@ extern void gelic_net_tx_timeout(struct 
>  extern int gelic_net_change_mtu(struct net_device *netdev, int new_mtu);
>  extern int gelic_net_setup_netdev(struct net_device *netdev,
>  				  struct gelic_card *card);
> +extern void gelic_net_poll_controller(struct net_device *netdev);
>  
>  /* shared ethtool ops */
>  extern void gelic_net_get_drvinfo(struct net_device *netdev,


Thank you for your reviewing.  I'll fix it.

-- 
Masakazu MOKUNO

