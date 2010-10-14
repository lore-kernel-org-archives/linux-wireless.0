Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp204.alice.it ([82.57.200.100]:57044 "EHLO smtp204.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752341Ab0JNQDH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Oct 2010 12:03:07 -0400
Subject: Re: Compat-wireless N900
From: Denis 'GNUtoo' Carikli <GNUtoo@no-log.org>
To: George <george.news@gmx.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4CB6BE57.8010401@gmx.net>
References: <4CB6BE57.8010401@gmx.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Oct 2010 17:57:24 +0200
Message-ID: <1287071844.11341.5.camel@gnutoo-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-10-14 at 10:24 +0200, George wrote:
> Hi all,
> 
> I'm trying to use compat-wireless to upgrade my n900 wireless driver. 
> N900 is using WL1251 wireless driver and the omap1 kernel version used 
> it 2.6.28.
> 
> The issue is that 2.6.28 does not have implemented many issues for 
> nl80211 netlink family which I wanted to test on my n900.
> 
> I have recompiled the kernel to make cfg80211 and mac80211 modules, so I 
> can use compat-wireless. After that I have compiled compat-wireless by 
> selecting the driver family I need. All done under scratchbox.
> 
> # scripts/driver-select wl12xx
> # make KLIB=/lib/modules/2.6.28-myversion \
>     KMODPATH_ARG=/lib/modules/2.6.28-myversion
> # make  KLIB=/lib/modules/2.6.28-myversion \
>     KMODPATH_ARG=/lib/modules/2.6.28-myversion install
> 
> After that I have installed the new kernel and the drivers in the n900 
> and the system starts. `uname -a` reports I'm using my custom kernel.
> 
> The problem is that the wireless modules are not working as expected and 
> I cannot get access to my wifi networks. Actually bluetooth is not 
> working as well, as far as I have tested.
> 
> dmesg reports --> http://pastebin.com/xskKcGnE
At first sight it seem that you have some mismatch issues,
Try to compile the maemo 2.6.28 kenrel without the wireless modules or
replace the wireless modules by the compat-wireless ones.
(normally the compat-wireless modules should take the precedence but as
it seem here, it didn't work)

by the way, are you aware of the meego 2.6.35 kernel, it might not be
complete yet, but may solve some of your problems.

Denis.


