Return-Path: <SRS0=n0sb=OU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	T_MIXED_ES autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55346C6783B
	for <linux-wireless@archiver.kernel.org>; Tue, 11 Dec 2018 20:45:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 04CF02084E
	for <linux-wireless@archiver.kernel.org>; Tue, 11 Dec 2018 20:45:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=rsalveti-net.20150623.gappssmtp.com header.i=@rsalveti-net.20150623.gappssmtp.com header.b="BbYPoxdo"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 04CF02084E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=rsalveti.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726208AbeLKUpa (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 11 Dec 2018 15:45:30 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:36194 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726146AbeLKUp3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Dec 2018 15:45:29 -0500
Received: by mail-lj1-f193.google.com with SMTP id g11-v6so14282483ljk.3
        for <linux-wireless@vger.kernel.org>; Tue, 11 Dec 2018 12:45:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rsalveti-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3fVYv242KYHmFnAgM8q4n9tKQWqYoR623RBeBUc2Ot4=;
        b=BbYPoxdo0/qgLhsKkc0w/dVdbna/EwkRwqXsvfC+NDmWAw5NX/rV9SDxMeNaxJhb23
         SuxecvLhkAtRb1AVflgyNt6HZpsNejui2XTbno+KWe8aiUcjfmXvfjU4oPy+0nEc2f7Y
         oAfWTALd/iOZtK6SDRif9o2TXDZZibYIIaKnlECqRytasUtAf953AIucrNQrrwtY8piT
         hxpgtPoa9PMW6H6rFrcpOzK31ftcZh1ILP8P6FgfwoTbZx5fjX3MuM4FmTA02uitQ8HD
         1nfDiYQOowuG5kQbdFXf37ARsjuM5tM9jH7KDEya0draK7L7CilIsl/ltqA/QjZ1bsR1
         +bFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3fVYv242KYHmFnAgM8q4n9tKQWqYoR623RBeBUc2Ot4=;
        b=O1r3xPPerhxWmPTAVMYENrs6GTq9hmfK7bg2iyVGhQ6CpNKN0myHKaGC29AfrFlceu
         Mq45mNjTCp442vgFPmXaeQADtVxNHHjgGFnJoKpCfLK5BgIW8BFyCNcib7gLLaRGYjnN
         3dMGLFbX/AXFj6AP7B0Ke3bnqVLytbFJyiqwbQhyKJt85zfO1Mb8r/RRDA6d4SYddtMW
         zC/ThBF/6fji36bkgQhREAAa9YSKqJgElPse3U6EJBA8PUKeUe716um3oq3+SEPbogs1
         is+lNjAmyvXwlIBKZGcB1RPnQurOzL0pZm0UnD+7iD1PrQkBmaXq/+M7Z3xdthEKvq9V
         rhwA==
X-Gm-Message-State: AA+aEWYGqi+cGScy06rRYIEQX9p/D1ch+yTEKyt98Vnu9UmRtDgZlKKX
        xuzhcbwEJI9LmG/sYhb9NSoq0khjnNZqpsLEBvF1lA==
X-Google-Smtp-Source: AFSGD/VsONzcwBzF4mWLs6cvhW0xnSUIFqCYd+FiI26y/s2dvFQ9K8GX4YcLLH/WLzSe+Xmj3U9C3OPEtvIdwjtk5g4=
X-Received: by 2002:a2e:2106:: with SMTP id h6-v6mr10329028ljh.37.1544561126547;
 Tue, 11 Dec 2018 12:45:26 -0800 (PST)
MIME-Version: 1.0
References: <CAHYQr0pKurSS=nvLEaLzup1hgx4+RJ0CezA2nFeA=C4XBDQQog@mail.gmail.com>
 <20181211181944.GW39861@atomide.com> <CAHYQr0pk-WKM-aYR7ubM4GHx8PA82XP5ze9TW9WEJLzdO0f88A@mail.gmail.com>
 <20181211190128.GX39861@atomide.com> <CAHYQr0qc_Lav=1sEGcOmOykUftWRzd6+vis97eBpanEXzfUHaA@mail.gmail.com>
 <CALAqxLUVajBw_PkyhA0s=FhQQHWu1FBEMX+4oDTStRXr6L5Txw@mail.gmail.com>
 <20181211201221.GY39861@atomide.com> <CAHYQr0qffa_G2ZVnSsDfjqSgxuBBZB+8e6ZODpAWV_TMhqzFYg@mail.gmail.com>
In-Reply-To: <CAHYQr0qffa_G2ZVnSsDfjqSgxuBBZB+8e6ZODpAWV_TMhqzFYg@mail.gmail.com>
From:   Ricardo Salveti <rsalveti@rsalveti.net>
Date:   Tue, 11 Dec 2018 18:44:49 -0200
Message-ID: <CAHYQr0qhqce2QcwMLRMWnqhZTL4KzHKJLzt6tfCNLHUcEt9pyQ@mail.gmail.com>
Subject: Re: wlcore getting stuck on hikey after the runtime PM autosuspend
 support change
To:     Tony Lindgren <tony@atomide.com>
Cc:     John Stultz <john.stultz@linaro.org>,
        linux-wireless@vger.kernel.org, anders.roxell@linaro.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, Dec 11, 2018 at 6:23 PM Ricardo Salveti <rsalveti@rsalveti.net> wrote:
>
> On Tue, Dec 11, 2018 at 6:12 PM Tony Lindgren <tony@atomide.com> wrote:
> >
> > * John Stultz <john.stultz@linaro.org> [181211 19:51]:
> > > On Tue, Dec 11, 2018 at 11:25 AM Ricardo Salveti <rsalveti@rsalveti.net> wrote:
> > > > Then tried to reproduce with a simple 'while true; do ip link set dev
> > > > wlan0 down; ip link set dev wlan0 up; done;' and it was already enough
> > > > to cause the same hang. Adding a simple sleep 1 after down/up is
> > > > already enough to make it work, so something might be missing during
> > > > the down/up process that only happens when they get called right after
> > > > the other.
> >
> > With while true test above, I'm getting:
> >
> > wlcore: ERROR timeout waiting for the hardware to complete initialization
> >
> > Then after ctrl-c, wlan0 connects to the access point just fine
> > for me.
> >
> > Is that what you're seeing or some oops?

Tried the same while true test on my beaglebone black wireless and
also got a trace, but without hanging the kernel (sdio write failed
instead):

root@beaglebone-yocto:~# while true; do ifconfig wlan0 down; ifconfig
wlan0 up; done;
[   31.467917] wlcore: down
[   33.205670] ------------[ cut here ]------------
[   33.211048] WARNING: CPU: 0 PID: 407 at
drivers/net/wireless/ti/wlcore/sdio.c:145
wl12xx_sdio_raw_write+0x134/0x1c0 [wlcore_sdio]
[   33.226358] Modules linked in: arc4 wl18xx wlcore mac80211
musb_dsps musb_hdrc cppi41 udc_core snd_soc_hdmi_codec phy_am335x
phy_generic phy_am335x_control pm33xx snd_soc_simple_card
snd_soc_simple_card_utils wkup_m3_ipc wkup_m3_rproc remoteproc virtio
virtio_ring ti_emif_sram snd_soc_davinci_mcasp hci_uart snd_soc_edma
snd_soc_sdma btqca btbcm tilcdc btintel snd_soc_core snd_pcm_dmaengine
snd_pcm snd_timer omap_mailbox wlcore_sdio snd soundcore musb_am335x
rtc_omap at24 tda998x cpufreq_dt thermal_sys fuse bluetooth_6lowpan
nhc_udp nhc_dest nhc_fragment nhc_hop nhc_ipv6 nhc_mobility
nhc_routing 6lowpan
[   33.292595] CPU: 0 PID: 407 Comm: ifconfig Not tainted
4.20.0-rc6-lmp-standard #1
[   33.304730] Hardware name: Generic AM33XX (Flattened Device Tree)
[   33.311136] Backtrace:
[   33.314930] [<c010f118>] (dump_backtrace) from [<c010f4b8>]
(show_stack+0x20/0x24)
[   33.323540]  r7:dc94cc10 r6:00000009 r5:00000000 r4:00000000
[   33.329520] [<c010f498>] (show_stack) from [<c0a0f230>]
(dump_stack+0x24/0x28)
[   33.338072] [<c0a0f20c>] (dump_stack) from [<c013a804>]
(__warn.part.3+0xcc/0xe4)
[   33.346441] [<c013a738>] (__warn.part.3) from [<c013a99c>]
(warn_slowpath_null+0x54/0x5c)
[   33.355623]  r6:bf1393b4 r5:00000091 r4:bf13abe0
[   33.360512] [<c013a948>] (warn_slowpath_null) from [<bf1393b4>]
(wl12xx_sdio_raw_write+0x134/0x1c0 [wlcore_sdio])
[   33.372301]  r6:00004000 r5:c0f03088 r4:dd69ec00
[   33.377244] [<bf139280>] (wl12xx_sdio_raw_write [wlcore_sdio]) from
[<bf40b33c>] (wlcore_boot_upload_firmware+0x1ec/0x55c [wlcore])
[   33.390554]  r10:dca18000 r9:dcba4d60 r8:bf139280 r7:00014000
r6:bf41f480 r5:80904000
[   33.399378]  r4:00000001
[   33.402673] [<bf40b150>] (wlcore_boot_upload_firmware [wlcore])
from [<bf436228>] (wl18xx_boot+0x8e4/0xd4c [wl18xx])
[   33.414270]  r10:00000000 r9:00000014 r8:c0cdf170 r7:bf41f480
r6:c0f03088 r5:00000000
[   33.422993]  r4:dcba4d60
[   33.425722] [<bf435944>] (wl18xx_boot [wl18xx]) from [<bf3fba38>]
(wl1271_op_add_interface+0x580/0x9b0 [wlcore])
[   33.437644]  r9:00000003 r8:dcba4da0 r7:bf41f480 r6:c0f03088
r5:dcba4d60 r4:00000000
[   33.446685] [<bf3fb4b8>] (wl1271_op_add_interface [wlcore]) from
[<bf345e10>] (drv_add_interface+0x58/0x1a8 [mac80211])
[   33.458858]  r10:00000000 r9:ffffffff r8:00000001 r7:de7eb4e0
r6:dcba4460 r5:dcba4460
[   33.467670]  r4:de7eb4e0
[   33.470571] [<bf345db8>] (drv_add_interface [mac80211]) from
[<bf35d3a0>] (ieee80211_do_open+0x490/0x984 [mac80211])
[   33.482807]  r7:de7eb4e0 r6:dcba4460 r5:de7eb000 r4:de7eb4e8
[   33.488965] [<bf35cf10>] (ieee80211_do_open [mac80211]) from
[<bf35d8e8>] (ieee80211_open+0x54/0x60 [mac80211])
[   33.500593]  r10:db2f2aa0 r9:00000000 r8:00001002 r7:c0f03088
r6:bf3a94e0 r5:c0f03088
[   33.509482]  r4:de7eb4e0
[   33.512904] [<bf35d894>] (ieee80211_open [mac80211]) from
[<c07fa648>] (__dev_open+0xec/0x170)
[   33.521946]  r5:c0f03088 r4:de7eb000
[   33.526686] [<c07fa55c>] (__dev_open) from [<c07faa68>]
(__dev_change_flags+0x174/0x1d4)
[   33.535768]  r6:00001043 r5:00000001 r4:de7eb000
[   33.540656] [<c07fa8f4>] (__dev_change_flags) from [<c07faaf0>]
(dev_change_flags+0x28/0x58)
[   33.550439]  r9:00000000 r8:c0fa2060 r7:de7eb144 r6:00000000
r5:00001002 r4:de7eb000
[   33.559205] [<c07faac8>] (dev_change_flags) from [<c0895d80>]
(devinet_ioctl+0x6d4/0x704)
[   33.568345]  r9:00000000 r8:c0fa2060 r7:dd0e4a0c r6:c0f03088
r5:dd1cbe08 r4:00000000
[   33.576962] [<c08956ac>] (devinet_ioctl) from [<c0898048>]
(inet_ioctl+0x214/0x3c4)
[   33.585575]  r10:db2f2aa0 r9:00000004 r8:00000051 r7:c0fa2060
r6:00008914 r5:be9f7b0c
[   33.594298]  r4:c0f03088
[   33.596979] [<c0897e34>] (inet_ioctl) from [<c07d4b14>]
(sock_ioctl+0x1d0/0x4e0)
[   33.605773]  r9:00000004 r8:c0fa2060 r7:be9f7b0c r6:dccc9b40
r5:c0f03088 r4:00008914
[   33.614530] [<c07d4944>] (sock_ioctl) from [<c02e4b9c>]
(do_vfs_ioctl+0xc0/0x95c)
[   33.622983]  r9:00000004 r8:be9f7b0c r7:00000004 r6:dccc9b40
r5:be9f7b0c r4:c0f03088
[   33.631144] [<c02e4adc>] (do_vfs_ioctl) from [<c02e54a4>]
(ksys_ioctl+0x6c/0x90)
[   33.639762]  r10:00000036 r9:00000004 r8:be9f7b0c r7:00008914
r6:00000000 r5:dccc9b40
[   33.648502]  r4:dccc9b40
[   33.651177] [<c02e5438>] (ksys_ioctl) from [<c02e54e0>] (sys_ioctl+0x18/0x1c)
[   33.659609]  r9:dd1ca000 r8:c0101204 r7:00000036 r6:b6fdb900
r5:004d5e44 r4:be9f7b0c
[   33.668370] [<c02e54c8>] (sys_ioctl) from [<c0101000>]
(ret_fast_syscall+0x0/0x54)
[   33.676833] Exception stack(0xdd1cbfa8 to 0xdd1cbff0)
[   33.682604] bfa0:                   be9f7b0c 004d5e44 00000004
00008914 be9f7b0c 00001002
[   33.691187] bfc0: be9f7b0c 004d5e44 b6fdb900 00000036 be9f7bec
004d6384 004d5e44 be9f7efe
[   33.700592] bfe0: 004d5ec4 be9f7afc 004bf0d1 b6f520f8
[   33.706359] ---[ end trace 39415e1e5f535790 ]---
[   33.711217] wl1271_sdio mmc2:0001:2: sdio write failed (-110)

Looks like it could be the same issue, but showing up differently on
hikey due the mmc controller used.

Thanks,
-- 
Ricardo Salveti de Araujo
