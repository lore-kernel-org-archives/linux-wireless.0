Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.187]:58564 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699AbbJUKxz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Oct 2015 06:53:55 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: glen lee <glen.lee@atmel.com>
Cc: linux-wireless@vger.kernel.org, Rachel Kim <rachel.kim@atmel.com>,
	devel@driverdev.osuosl.org, Chris Park <chris.park@atmel.com>,
	gregkh@linuxfoundation.org,
	Stanislav Kholmanskikh <kholmanskikh.s.s@gmail.com>,
	Johnny Kim <johnny.kim@atmel.com>,
	linux-kernel@vger.kernel.org, Tony Cho <tony.cho@atmel.com>,
	Leo Kim <leo.kim@atmel.com>
Subject: Re: [PATCH 00/19] staging/wilc1000 cleanups
Date: Wed, 21 Oct 2015 12:53:48 +0200
Message-ID: <4261822.eWDaN5tlMP@wuerfel> (sfid-20151021_125420_476830_48C66FAE)
In-Reply-To: <562763BC.5030107@atmel.com>
References: <1445381258-1455986-1-git-send-email-arnd@arndb.de> <562763BC.5030107@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 21 October 2015 19:06:52 glen lee wrote:
> Hi arnd,
> 
> Thanks for the all the patches. 
> About the patch ( use proper naming for global symbols ),
> We are planning to use this driver not only for wilc1000 but also for
> other atmel wireless driver. I'd appreciate if you could use wl instead of wilc1000.

Hmm, while I see that 'wilc1000' is too specific here, using just 'wl' might be
a little too general. The same namespace is used by drivers/mtd/ubi/wl.c,
drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c, and a number of local
identifiers in other drivers.

Would 'wilc' work as a prefix for all devices you are interested in here?

> And the global variable g_linux_wlan will be placed in netdevice private data
> and finally it will be removed. I already posted some of those patches.

Ok, so we need to coordinate a bit here. My patches also go in that direction
and remove the global variables from linux_wlan_sdio.c and linux_wlan_spi.c,
but did not remove the one from linux_wlan.c, because doing that depends on
the last [RFC] patch in my series, and I felt I had spent enough time on it
at that point ;-)

Would you be ok with taking my patches and rebasing them on top of yours
with the changes you want,  or do you need help from me with that?

	Arnd
