Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f173.google.com ([209.85.216.173]:56178 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757083Ab0BPVXx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Feb 2010 16:23:53 -0500
Received: by pxi3 with SMTP id 3so2898447pxi.28
        for <linux-wireless@vger.kernel.org>; Tue, 16 Feb 2010 13:23:52 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1266124222.13902.42.camel@mj>
References: <43e72e891002121810g25d21eb5y254969458a9a58e7@mail.gmail.com>
	<1266124222.13902.42.camel@mj>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 16 Feb 2010 13:23:32 -0800
Message-ID: <43e72e891002161323v70636defr2500784ffb44d775@mail.gmail.com>
Subject: Re: compat-wireless + Linux 2.6.26.8 testing results
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Feb 13, 2010 at 9:10 PM, Pavel Roskin <proski@gnu.org> wrote:
> On Fri, 2010-02-12 at 18:10 -0800, Luis R. Rodriguez wrote:
>> The bleeding edge compat-wireless updates were stuck due to a
>> bluetooth hunk failing on net/bluetooth/hidp/core.c, that should be
>> fixed now, at least it compiles for me down to 2.6.27. I also hadn't
>> updated a 2.6.33-rcx releases in a while, as well as 2.6.32.y release.
>> This should all now be in synch with upstream. I never got reports
>> about MQ support on older kernels so I just threw in the code, issues
>> can be dealt with once actually found.
>
> I've tried compiling all three tarballs against Linux 2.6.26.8.  It's a
> kernel with some hardware patches for arm architecture that are hard to
> port to newer kernels, so compat-wireless would be very helpful.
>
> compat-wireless-2.6.32.8 compiles just fine with ath5k selected.
>
> compat-wireless-2.6.33-rc8 fails:
>
> /home/proski/src/compat-wireless-2.6.33-rc8/net/mac80211/util.c: In
> function '__ieee80211_wake_queue':
> /home/proski/src/compat-wireless-2.6.33-rc8/net/mac80211/util.c:290:
> error: implicit declaration of function 'netif_tx_wake_queue'
> /home/proski/src/compat-wireless-2.6.33-rc8/net/mac80211/util.c:290:
> error: implicit declaration of function 'netdev_get_tx_queue'
> /home/proski/src/compat-wireless-2.6.33-rc8/net/mac80211/util.c: In
> function '__ieee80211_stop_queue':
> /home/proski/src/compat-wireless-2.6.33-rc8/net/mac80211/util.c:325:
> error: implicit declaration of function 'netif_tx_stop_queue'
>
> compat-wireless-2010-02-13 fails differently:
>
> /home/proski/src/compat-wireless-2010-02-13/net/mac80211/iface.c: In
> function 'ieee80211_if_setup':
> /home/proski/src/compat-wireless-2010-02-13/net/mac80211/iface.c:738:
> error: 'struct net_device' has no member named 'select_queue'
> /home/proski/src/compat-wireless-2010-02-13/net/mac80211/iface.c: In
> function 'ieee80211_setup_sdata':
> /home/proski/src/compat-wireless-2010-02-13/net/mac80211/iface.c:790:
> error: 'struct net_device' has no member named 'select_queue'
>
> I tried enabling CONFIG_NETDEVICES_MULTIQUEUE, but it made no
> difference.
>
> It looks like compat-wireless-2.6.33-rc8 and compat-wireless-2010-02-13
> don't have the patches to deal with the lack of netif_tx_wake_queue and
> select_queue in Linux 2.6.26.  compat-wireless-2.6.32.8 has such
> patches.

Oh right, so I was hoping to get some reports on results of MQ
backport on 2.6.32.y, I guess its OK enough to merge now and if its
borked we can remove older kernel support or something.

> If all drivers are selected, compat-wireless-2.6.32.8 fails:
>
> In file included
> from /home/proski/src/compat-wireless-2.6.32.8/drivers/net/b44.c:28:
> /home/proski/src/compat-wireless-2.6.32.8/include/linux/ssb/ssb.h: In
> function 'ssb_dma_sync_single_range_for_cpu':
> /home/proski/src/compat-wireless-2.6.32.8/include/linux/ssb/ssb.h:595:
> error: implicit declaration of function 'dma_sync_single_range_for_cpu'
> /home/proski/src/compat-wireless-2.6.32.8/include/linux/ssb/ssb.h: In
> function 'ssb_dma_sync_single_range_for_device':
> /home/proski/src/compat-wireless-2.6.32.8/include/linux/ssb/ssb.h:620:
> error: implicit declaration of function
> 'dma_sync_single_range_for_device'
>
> That appears to be caused by the lack of
> dma_sync_single_range_for_device on the arm architecture.

Interesting... well that would just mean we have to lift SSB off of
2.6.28 kernels.

> Other
> architectures have it.  "make -k" doesn't find any other errors.  All
> other drivers compile fine.

Thanks for the reports and tests.

  Luis
