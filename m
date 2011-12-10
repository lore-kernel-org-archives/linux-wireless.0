Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:46022 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941Ab1LJRmH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Dec 2011 12:42:07 -0500
Received: by yenm11 with SMTP id m11so2862458yen.19
        for <linux-wireless@vger.kernel.org>; Sat, 10 Dec 2011 09:42:06 -0800 (PST)
Message-ID: <4EE399EB.2060100@lwfinger.net> (sfid-20111210_184211_270459_F8C99B29)
Date: Sat, 10 Dec 2011 11:42:03 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Mikael Abrahamsson <swmike@swm.pp.se>
CC: Nikolay Martynov <mar.kolya@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: Spontaneous disconnections debugging
References: <CALGY4fvRCRwqvncw8nqkEN-mGB5syHXbWKpRspbxC=6Fccpa1g@mail.gmail.com> <alpine.DEB.2.00.1112101231120.808@uplift.swm.pp.se>
In-Reply-To: <alpine.DEB.2.00.1112101231120.808@uplift.swm.pp.se>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/10/2011 05:34 AM, Mikael Abrahamsson wrote:
> On Fri, 9 Dec 2011, Nikolay Martynov wrote:
>
>> I have an intel 5300 as client and openwrt ath9k based router as AP. Some
>> times (once in several days) I get wireless connection spontaneously dropped
>> with this message on client: wlan1: deauthenticating from XX:XX:XX:XX:XX:XX by
>> local choice (reason=3)
>
> Ubuntu 11.10 on a Thinkpad X200 with Intel 5300:
>
> $ dmesg | grep -i deauthenticating | grep "local choice" | wc -l
> 44
> $ uptime
> 18:31:07 up 1 day, 7:30, 3 users, load average: 0.08, 0.03, 0.05
>
> $ dmesg | grep "local choice" | cut -d ] -f2- | sort | uniq -c
> 44 wlan0: deauthenticating from 00:21:91:dc:94:55 by local choice (reason=3)
> 56 wlan0: disassociating from 00:21:91:dc:94:55 by local choice (reason=3)
>
>> Not that this really creates problems for me, connection is quickly
>> restored and otherwise works fine.
>
> For me it also mostly works fine, but sometimes I have to unload/reload the
> iwlagn module to make things work again, and sometimes the wifi LED just turns
> off and requires a reboot to get working again.
>
> At least the 5300 stuff works much better in 3.0 than it did in 2.6.38.

I would suggest that both of you try the bleeding-edge compat-wireless, or the 
kernel from the wireless-testing git tree, before doing any debugging. I'm not 
involved in iwlagn development, but there have been a lot of changes since 3.0.

Larry

