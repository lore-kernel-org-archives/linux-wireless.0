Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:62832 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755303Ab0JNRSG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Oct 2010 13:18:06 -0400
Received: by iwn35 with SMTP id 35so210103iwn.19
        for <linux-wireless@vger.kernel.org>; Thu, 14 Oct 2010 10:18:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1287071844.11341.5.camel@gnutoo-laptop>
References: <4CB6BE57.8010401@gmx.net> <1287071844.11341.5.camel@gnutoo-laptop>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 14 Oct 2010 10:17:43 -0700
Message-ID: <AANLkTikosEtFnWqRVzMBKtNsB=aqOpqQFKDOZS3+pXTE@mail.gmail.com>
Subject: Re: Compat-wireless N900
To: "Denis 'GNUtoo' Carikli" <GNUtoo@no-log.org>
Cc: George <george.news@gmx.net>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 14, 2010 at 8:57 AM, Denis 'GNUtoo' Carikli
<GNUtoo@no-log.org> wrote:
> On Thu, 2010-10-14 at 10:24 +0200, George wrote:
>> Hi all,
>>
>> I'm trying to use compat-wireless to upgrade my n900 wireless driver.
>> N900 is using WL1251 wireless driver and the omap1 kernel version used
>> it 2.6.28.
>>
>> The issue is that 2.6.28 does not have implemented many issues for
>> nl80211 netlink family which I wanted to test on my n900.
>>
>> I have recompiled the kernel to make cfg80211 and mac80211 modules, so I
>> can use compat-wireless. After that I have compiled compat-wireless by
>> selecting the driver family I need. All done under scratchbox.
>>
>> # scripts/driver-select wl12xx
>> # make KLIB=/lib/modules/2.6.28-myversion \
>>     KMODPATH_ARG=/lib/modules/2.6.28-myversion
>> # make  KLIB=/lib/modules/2.6.28-myversion \
>>     KMODPATH_ARG=/lib/modules/2.6.28-myversion install
>>
>> After that I have installed the new kernel and the drivers in the n900
>> and the system starts. `uname -a` reports I'm using my custom kernel.
>>
>> The problem is that the wireless modules are not working as expected and
>> I cannot get access to my wifi networks. Actually bluetooth is not
>> working as well, as far as I have tested.
>>
>> dmesg reports --> http://pastebin.com/xskKcGnE
> At first sight it seem that you have some mismatch issues,

Agreed, try:

for i in mac80211 cfg80211 wl1251_spi; do modprobe -l $i; done

This will show you where its picking up the modules upon load. If you
see some disagreement with paths, that's the issue. Compat-wireless
relies on stuffing them on your /lib/modules/$(uname -r)/updates/
directory and in order for these modules to take precedence over the
/lib/modules/$(uname -r)/kernel/ modules we rely on a file in
/etc/depmod.d/ which tells depmod to prefer updates first. For example
on an ubuntu box you get:

mcgrof@tux ~ $ cat /etc/depmod.d/ubuntu.conf
search updates ubuntu built-in

  Luis
