Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:51761 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727204AbeH2WIY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 29 Aug 2018 18:08:24 -0400
Received: by mail-it0-f67.google.com with SMTP id e14-v6so8995781itf.1
        for <linux-wireless@vger.kernel.org>; Wed, 29 Aug 2018 11:10:20 -0700 (PDT)
MIME-Version: 1.0
References: <1535381791-14908-1-git-send-email-sgruszka@redhat.com>
 <CAM0KTbB5k54BvA2UOmoss-PuGtgHE_SGy2cG4n4ROxPH7kxYXA@mail.gmail.com> <20180829102737.GA20763@redhat.com>
In-Reply-To: <20180829102737.GA20763@redhat.com>
From: Sid Hayn <sidhayn@gmail.com>
Date: Wed, 29 Aug 2018 18:10:01 +0000
Message-ID: <CAM0KTbALSzvxagKTtDV7X0G9wtnSEogxNbch046LCsN_rUz4eA@mail.gmail.com> (sfid-20180829_201024_464248_CFB13D1C)
Subject: Re: [PATCH v2 00/17] mt76 patches 2018-08-24 v2
To: sgruszka@redhat.com
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        lorenzo.bianconi@redhat.com, nbd@nbd.name,
        linux-mediatek@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I rebuilt wireless-testing (which updated today)  with
CONFIG_DEBUG_KMEMLEAK=y.  I am still able to replicate the issue, and
presently have 4 devices in the "No space left on device" state.

This is from /sys/kernel/debug/kmemleak:

unreferenced object 0xffff9183f9a4d000 (size 2048):
  comm "iwconfig", pid 14872, jiffies 4295540797 (age 1233.338s)
  hex dump (first 32 bytes):
    46 00 00 00 00 00 00 00 05 00 00 00 00 00 00 00  F...............
    12 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<000000003ec4c8c4>] sta_set_sinfo+0x5d2/0x890 [mac80211]
    [<000000008bbf0699>] ieee80211_get_station+0x4b/0x70 [mac80211]
    [<0000000030cbddbc>] cfg80211_wext_giwrate+0xdb/0x140 [cfg80211]
    [<000000001e9277be>] ioctl_standard_call+0x49/0xd0
    [<00000000a0eeae49>] wext_handle_ioctl+0xbe/0x120
    [<00000000832bf9a4>] sock_ioctl+0x164/0x360
    [<00000000d3578d89>] do_vfs_ioctl+0xa3/0x6c0
    [<0000000036a4185e>] ksys_ioctl+0x6b/0x80
    [<00000000e8443423>] __x64_sys_ioctl+0x11/0x20
    [<00000000e2ddce89>] do_syscall_64+0x50/0xf0
    [<000000005d6a8051>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
    [<00000000e724c32b>] 0xffffffffffffffff

None of my scripts directly use iwconfig, but it is possible that
wpa_supplicant or dhcpcd invoke it (although a grep of their source
code indicates they do not). In case it matters, this is what my
wpa_supplicant invokation looks like:

wpa_supplicant -Dnl80211 -i ${interface} -c test_config/${conffile}

I am leaving the system in this state for now, I can resume from
broken or reboot to working for whatever testing you suggest next.
This is a test rig, so it takes a few but I'm happy to rebuild
whatever you want however you want it to debug this.

Thanks,
Zero
On Wed, Aug 29, 2018 at 10:27 AM Stanislaw Gruszka <sgruszka@redhat.com> wrote:
>
> Hi Sid
>
> On Wed, Aug 29, 2018 at 02:26:44AM +0000, Sid Hayn wrote:
> > Thanks for working on this, I have a small stack of different devices
> > covered by this driver which I'm excited to test with.
> >
> > I'm running wireless-testing which may or may not be fully up to date
> > on the patches you have sent (head is at
> > c9cd161770dd1866207b70d41ec03c9a26eea94f from Aug 13th), so please
> > tell me if this has already been fixed.  I have a script that attempts
> > to connect to 16 differently configured SSIDs using 33 different (yet
> > compatible) wpa_supplicant.conf files and reports failures to me.
> > It's hardly perfect, but it gives me an idea if something is obviously
> > broken and needs a deeper dive.  When I run this script against a
> > device supported by mt76x2 or mt76x0 I get an unusual error.
> > Everything goes fine, connect, dhcp, disconnect, connect, dhcp,
> > disconnect, but after about 5 or 6 connections I start getting errors
> > like this during wpa_supplicant:
> >
> > Could not set interface t2uh flags (UP): No space left on device
> > nl80211: Could not set interface 't2uh' UP
> > nl80211: deinit ifname=t2uh disabled_11b_rates=0
> > t2uh: Failed to initialize driver interface
> >
> > and then this with dhcpcd:
> >
> > dhcpcd_prestartinterface: t2uh: No space left on device
> > t2uh: waiting for carrier
> >
> > the same happens with just ifconfig up:
> >
> > SIOCSIFFLAGS: No space left on device
>
> This looks like some memory leak, not sure where, but it quite probable
> that is in the m76x{0,2} driver. You can check periodically using 'free'
> command (or in more details by 'cat /proc/meminfo') if memory is
> leaking. Then compile kernel with CONFIG_DEBUG_KMEMLEAK to see where
> the leak happen.
>
> Regards
> Stanislaw
>
