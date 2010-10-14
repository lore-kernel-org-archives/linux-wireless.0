Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:39739 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753146Ab0JNQpX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Oct 2010 12:45:23 -0400
Message-ID: <4CB73DED.40305@gmx.net>
Date: Thu, 14 Oct 2010 19:29:17 +0200
From: George <george.news@gmx.net>
MIME-Version: 1.0
To: Denis 'GNUtoo' Carikli <GNUtoo@no-log.org>
CC: linux-wireless@vger.kernel.org
Subject: Re: Compat-wireless N900
References: <4CB6BE57.8010401@gmx.net> <1287071844.11341.5.camel@gnutoo-laptop>
In-Reply-To: <1287071844.11341.5.camel@gnutoo-laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 14/10/2010 17:57, Denis 'GNUtoo' Carikli wrote:
> On Thu, 2010-10-14 at 10:24 +0200, George wrote:
>> Hi all,
>>
>> I'm trying to use compat-wireless to upgrade my n900 wireless driver.
>> N900 is using WL1251 wireless driver and the omap1 kernel version used
>> it 2.6.28.
>>
>> The issue is that 2.6.28 does not have implemented many issues for
>> nl80211 netlink family which I wanted to test on my n900.

What I want is to get iw and nl80211 working properly so I can use 
netlink sockets to get all the information. Currently I cannot do 
anything as every iw command reports operation not supported.

>> I have recompiled the kernel to make cfg80211 and mac80211 modules, so I
>> can use compat-wireless. After that I have compiled compat-wireless by
>> selecting the driver family I need. All done under scratchbox.
>>
>> # scripts/driver-select wl12xx
>> # make KLIB=/lib/modules/2.6.28-myversion \
>>      KMODPATH_ARG=/lib/modules/2.6.28-myversion
>> # make  KLIB=/lib/modules/2.6.28-myversion \
>>      KMODPATH_ARG=/lib/modules/2.6.28-myversion install
>>
>> After that I have installed the new kernel and the drivers in the n900
>> and the system starts. `uname -a` reports I'm using my custom kernel.
>>
>> The problem is that the wireless modules are not working as expected and
>> I cannot get access to my wifi networks. Actually bluetooth is not
>> working as well, as far as I have tested.
>>
>> dmesg reports -->  http://pastebin.com/xskKcGnE
> At first sight it seem that you have some mismatch issues,
> Try to compile the maemo 2.6.28 kenrel without the wireless modules or
> replace the wireless modules by the compat-wireless ones.
> (normally the compat-wireless modules should take the precedence but as
> it seem here, it didn't work)

If I compile the kernel withouth the wireless modules then they are not 
going to be recognized and compat-wireless will complain that .config 
that kernel was compiled without wireless.

On the other hand, what do you mean by replacing the wireless modules? 
just cut and paste from compat-wireless.

The issue is that 2.6.28 has nl80211, cfg80211 and mac80211 on their 
very stages. I think what will solve my problem is just updating those 
modules, but for that I have to change also the driver.

Besides that, the main problemm, as some guys pointed in the IRC 
channel, is that wl1251 driver is spi and they need something about the 
board interfaces.

> by the way, are you aware of the meego 2.6.35 kernel, it might not be
> complete yet, but may solve some of your problems.

Yes I'm aware of that. I have compiled the kernel and try to load it on 
the n900 with maemo rootfs and ... crashes.

Actually I have meego (mmc rootfs) also running on my N900 and wireless 
drivers work perfect. The problem is that the gui and develepment SDK 
and toolchains are still underdevelopment and I cannot then use 
something like the maemo scratchbox.

I have compiled an small application directly on the n900 with meego, 
but for larger applications it is not viable.


>
> Denis.
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

