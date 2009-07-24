Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from promwad.com ([83.149.69.23]:59785 "EHLO promwad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752618AbZGXQku (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jul 2009 12:40:50 -0400
Message-ID: <4A69E3F3.60403@promwad.com>
Date: Fri, 24 Jul 2009 19:40:19 +0300
From: Ivan Kuten <ivan.kuten@promwad.com>
Reply-To: ivan.kuten@promwad.com
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: WPA2, compat-wireless-2.6.31-rc3, kernel 2.6.28 - rtl8187 -
 association works but no ping
References: <4A682BBD.90101@promwad.com>	<43e72e890907230917w226c4697v41f907623e5f7d8@mail.gmail.com> 	<4A696D33.8050606@promwad.com>	<43e72e890907240824n5bcff378m1278eb948055a9a5@mail.gmail.com> 	<4A69D8C6.9040103@promwad.com> <43e72e890907240923h41408c99qfe48e4224149cb2d@mail.gmail.com>
In-Reply-To: <43e72e890907240923h41408c99qfe48e4224149cb2d@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> On Fri, Jul 24, 2009 at 8:52 AM, Ivan Kuten<ivan.kuten@promwad.com> wrote:
>> No Network Manager.
>> Just:
>> wpa_supplicant -Dwext -iwlan0 -c /home/ACORP.conf -dd &
>> /sbin/udhcpc -n -q -i wlan0 -s /bin/default.script
> 
> How did you get the eth0 IP? ps -ef?
> 
>   Luis
> 
> 
> 

in rc script it's ifconfig eth0 192.168.5.1
it's the same behaviour without eth0. I'm using eth0 for netconsole because
a lot of debug printks over slow UART bring kernel to crash.

I can't neither dhcp nor ping via wlan0. but association is ok.

It is a Blackfin board with busybox, not a desktop PC with NetworkManager stuff.

here is ps - nothing special:
  PID  Uid        VSZ Stat Command
    1 root        588 S   /init
    2 root            SW< [kthreadd]
    3 root            SW< [ksoftirqd/0]
    4 root            SW< [events/0]
    5 root            SW< [khelper]
   60 root            SW< [kblockd/0]
   74 root            SW< [khubd]
   93 root            SW  [pdflush]
   94 root            SW  [pdflush]
   95 root            SW< [kswapd0]
  101 root            SW< [mediabox2fb]
  162 root            SW< [mtdblockd]
  164 root            SW< [bfin-spi.0]
  179 root            SW< [uwbd]
  184 root            SW< [wusbd]
  209 root            SWN [jffs2_gcd_mtd2]
  214 root        864 R   -/bin/sh
  215 root        496 S   /bin/watchdogd -f -s
  217 root        764 S   /sbin/syslogd -n
  220 root        772 S   /sbin/klogd -n
  230 root            SW< [bf537_trackball]
  234 root        500 S   netsettings_updater
  236 root        504 S   /bin/Apek
  241 root        512 S   /bin/keyhandler
  283 root            SW< [phy0]
  303 root       1776 S   wpa_supplicant -Dwext -iwlan0 -c /home/ACORP.conf -dd
  334 root        768 R   ps -ef

The question is how to verify is it kernel or wpa_supplicant bug or some timing issue.

Regards,
Ivan

