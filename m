Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from swm.pp.se ([212.247.200.143]:60947 "EHLO uplift.swm.pp.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750941Ab1LJRa4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Dec 2011 12:30:56 -0500
Date: Sat, 10 Dec 2011 12:34:39 +0100 (CET)
From: Mikael Abrahamsson <swmike@swm.pp.se>
To: Nikolay Martynov <mar.kolya@gmail.com>
cc: linux-wireless@vger.kernel.org
Subject: Re: Spontaneous disconnections debugging
In-Reply-To: <CALGY4fvRCRwqvncw8nqkEN-mGB5syHXbWKpRspbxC=6Fccpa1g@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1112101231120.808@uplift.swm.pp.se> (sfid-20111210_183059_858793_C4105B31)
References: <CALGY4fvRCRwqvncw8nqkEN-mGB5syHXbWKpRspbxC=6Fccpa1g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 9 Dec 2011, Nikolay Martynov wrote:

>  I have an intel 5300 as client and openwrt ath9k based router as AP. 
> Some times (once in several days) I get wireless connection 
> spontaneously dropped with this message on client: wlan1: 
> deauthenticating from XX:XX:XX:XX:XX:XX by local choice (reason=3)

Ubuntu 11.10 on a Thinkpad X200 with Intel 5300:

$ dmesg | grep -i deauthenticating | grep "local choice" | wc -l
44
$ uptime
  18:31:07 up 1 day,  7:30,  3 users,  load average: 0.08, 0.03, 0.05

$ dmesg | grep "local choice" | cut -d ] -f2- | sort | uniq -c
      44  wlan0: deauthenticating from 00:21:91:dc:94:55 by local choice (reason=3)
      56  wlan0: disassociating from 00:21:91:dc:94:55 by local choice (reason=3)

>  Not that this really creates problems for me, connection is quickly
> restored and otherwise works fine.

For me it also mostly works fine, but sometimes I have to unload/reload 
the iwlagn module to make things work again, and sometimes the wifi LED 
just turns off and requires a reboot to get working again.

At least the 5300 stuff works much better in 3.0 than it did in 2.6.38.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
