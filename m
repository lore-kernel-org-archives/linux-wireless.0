Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:34645 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754223Ab0JNRZg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Oct 2010 13:25:36 -0400
Message-ID: <4CB74759.3030807@gmx.net>
Date: Thu, 14 Oct 2010 20:09:29 +0200
From: George <george.news@gmx.net>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: Denis 'GNUtoo' Carikli <GNUtoo@no-log.org>,
	linux-wireless@vger.kernel.org
Subject: Re: Compat-wireless N900
References: <4CB6BE57.8010401@gmx.net> <1287071844.11341.5.camel@gnutoo-laptop> <AANLkTikosEtFnWqRVzMBKtNsB=aqOpqQFKDOZS3+pXTE@mail.gmail.com>
In-Reply-To: <AANLkTikosEtFnWqRVzMBKtNsB=aqOpqQFKDOZS3+pXTE@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 14/10/2010 19:17, Luis R. Rodriguez wrote:
> On Thu, Oct 14, 2010 at 8:57 AM, Denis 'GNUtoo' Carikli
> <GNUtoo@no-log.org>  wrote:
>> On Thu, 2010-10-14 at 10:24 +0200, George wrote:
>>> Hi all,
>>>
>>> I'm trying to use compat-wireless to upgrade my n900 wireless driver.
>>> N900 is using WL1251 wireless driver and the omap1 kernel version used
>>> it 2.6.28.
>>>
>>> The issue is that 2.6.28 does not have implemented many issues for
>>> nl80211 netlink family which I wanted to test on my n900.
>>>
>>> I have recompiled the kernel to make cfg80211 and mac80211 modules, so I
>>> can use compat-wireless. After that I have compiled compat-wireless by
>>> selecting the driver family I need. All done under scratchbox.
>>>
>>> # scripts/driver-select wl12xx
>>> # make KLIB=/lib/modules/2.6.28-myversion \
>>>      KMODPATH_ARG=/lib/modules/2.6.28-myversion
>>> # make  KLIB=/lib/modules/2.6.28-myversion \
>>>      KMODPATH_ARG=/lib/modules/2.6.28-myversion install
>>>
>>> After that I have installed the new kernel and the drivers in the n900
>>> and the system starts. `uname -a` reports I'm using my custom kernel.
>>>
>>> The problem is that the wireless modules are not working as expected and
>>> I cannot get access to my wifi networks. Actually bluetooth is not
>>> working as well, as far as I have tested.
>>>
>>> dmesg reports -->  http://pastebin.com/xskKcGnE
>> At first sight it seem that you have some mismatch issues,
>
> Agreed, try:
>
> for i in mac80211 cfg80211 wl1251_spi; do modprobe -l $i; done
>
> This will show you where its picking up the modules upon load. If you
> see some disagreement with paths, that's the issue. Compat-wireless
> relies on stuffing them on your /lib/modules/$(uname -r)/updates/
> directory and in order for these modules to take precedence over the
> /lib/modules/$(uname -r)/kernel/ modules we rely on a file in
> /etc/depmod.d/ which tells depmod to prefer updates first. For example
> on an ubuntu box you get:
>
> mcgrof@tux ~ $ cat /etc/depmod.d/ubuntu.conf
> search updates ubuntu built-in
>

I have tried using even insmod and the modules load perfectly but the 
wlan device doesn't show up.
In dmesg nothing is displayed except for the cfg80211 and when I rmmod 
the module wl1251 (wl1251: removed or similar)

I'm still wondering what the hell I have to do.

TA
