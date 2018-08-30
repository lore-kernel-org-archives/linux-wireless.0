Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:50370 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727496AbeH3OKR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 30 Aug 2018 10:10:17 -0400
Date: Thu, 30 Aug 2018 12:08:50 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Sid Hayn <sidhayn@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        lorenzo.bianconi@redhat.com, nbd@nbd.name,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH v2 00/17] mt76 patches 2018-08-24 v2
Message-ID: <20180830100848.GA3029@redhat.com> (sfid-20180830_120858_101112_DA5ED840)
References: <1535381791-14908-1-git-send-email-sgruszka@redhat.com>
 <CAM0KTbB5k54BvA2UOmoss-PuGtgHE_SGy2cG4n4ROxPH7kxYXA@mail.gmail.com>
 <20180829102737.GA20763@redhat.com>
 <CAM0KTbALSzvxagKTtDV7X0G9wtnSEogxNbch046LCsN_rUz4eA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAM0KTbALSzvxagKTtDV7X0G9wtnSEogxNbch046LCsN_rUz4eA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 29, 2018 at 06:10:01PM +0000, Sid Hayn wrote:
> I rebuilt wireless-testing (which updated today)  with
> CONFIG_DEBUG_KMEMLEAK=y.  I am still able to replicate the issue, and
> presently have 4 devices in the "No space left on device" state.
> 
> This is from /sys/kernel/debug/kmemleak:
> 
> unreferenced object 0xffff9183f9a4d000 (size 2048):
>   comm "iwconfig", pid 14872, jiffies 4295540797 (age 1233.338s)
>   hex dump (first 32 bytes):
>     46 00 00 00 00 00 00 00 05 00 00 00 00 00 00 00  F...............
>     12 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>   backtrace:
>     [<000000003ec4c8c4>] sta_set_sinfo+0x5d2/0x890 [mac80211]
>     [<000000008bbf0699>] ieee80211_get_station+0x4b/0x70 [mac80211]
>     [<0000000030cbddbc>] cfg80211_wext_giwrate+0xdb/0x140 [cfg80211]
>     [<000000001e9277be>] ioctl_standard_call+0x49/0xd0
>     [<00000000a0eeae49>] wext_handle_ioctl+0xbe/0x120
>     [<00000000832bf9a4>] sock_ioctl+0x164/0x360
>     [<00000000d3578d89>] do_vfs_ioctl+0xa3/0x6c0
>     [<0000000036a4185e>] ksys_ioctl+0x6b/0x80
>     [<00000000e8443423>] __x64_sys_ioctl+0x11/0x20
>     [<00000000e2ddce89>] do_syscall_64+0x50/0xf0
>     [<000000005d6a8051>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>     [<00000000e724c32b>] 0xffffffffffffffff

I do not see what can leak here. Did you run clear and scan commands,
i.e:

echo clear > /sys/kernel/debug/kmemleak
Run test
echo scan > /sys/kernel/debug/kmemleak
cat /sys/kernel/debug/kmemleak

to get results ? I forgot that this is required (full docs can
be found here: 
https://www.kernel.org/doc/html/v4.16/dev-tools/kmemleak.html).

> None of my scripts directly use iwconfig, but it is possible that
> wpa_supplicant or dhcpcd invoke it (although a grep of their source
> code indicates they do not). In case it matters, this is what my
> wpa_supplicant invokation looks like:
> 
> wpa_supplicant -Dnl80211 -i ${interface} -c test_config/${conffile}
> 
> I am leaving the system in this state for now, I can resume from
> broken or reboot to working for whatever testing you suggest next.
> This is a test rig, so it takes a few but I'm happy to rebuild
> whatever you want however you want it to debug this.

You can move /usr/sbin/iwconfig somewhere and see what will fail,
or remove WEXT support from kernel, perhaps that itself will solve
the problem ;-)

Regards
Stanislaw
