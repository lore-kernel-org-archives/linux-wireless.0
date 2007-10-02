Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from tranquility.mcc.ac.uk ([130.88.200.145]:52887 "EHLO
	tranquility.mcc.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738AbXJBQfV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Oct 2007 12:35:21 -0400
Message-ID: <4702731E.5070502@gentoo.org> (sfid-20071002_173526_530574_C6D8142B)
Date: Tue, 02 Oct 2007 17:34:38 +0100
From: Daniel Drake <dsd@gentoo.org>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>
CC: Michael Buesch <mb@bu3sch.de>, Ulrich Kunitz <kune@deine-taler.de>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] z1211: Make the LEDs warning debug-only
References: <200709291223.20926.mb@bu3sch.de>
In-Reply-To: <200709291223.20926.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> This warning triggers now and then with an -ETIMEDOUT error.
> Though the LEDs work fine.
> Make this warning debug-only, as nobody is really interested
> in a LED failure that happens only now and then.
> If the LEDs don't work, one can easily enable debugging to see
> what's going on.
> This reduces dmesg spamming.
> 
> Signed-off-by: Michael Buesch <mb@bu3sch.de>

Acked-by: Daniel Drake <dsd@gentoo.org>

> 
> Index: wireless-2.6/drivers/net/wireless/z1211/zd_mac.c
> ===================================================================
> --- wireless-2.6.orig/drivers/net/wireless/z1211/zd_mac.c	2007-09-25 22:51:28.000000000 +0200
> +++ wireless-2.6/drivers/net/wireless/z1211/zd_mac.c	2007-09-29 12:19:54.000000000 +0200
> @@ -922,7 +922,7 @@ static void link_led_handler(struct work
>  	r = zd_chip_control_leds(chip,
>  		                 is_associated ? LED_ASSOCIATED : LED_SCANNING);
>  	if (r)
> -		dev_err(zd_mac_dev(mac), "zd_chip_control_leds error %d\n", r);
> +		dev_dbg_f(zd_mac_dev(mac), "zd_chip_control_leds error %d\n", r);
>  
>  	queue_delayed_work(zd_workqueue, &mac->housekeeping.link_led_work,
>  		           LINK_LED_WORK_DELAY);
> 

