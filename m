Return-Path: <SRS0=wq86=OV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	T_MIXED_ES,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8388DC65BAF
	for <linux-wireless@archiver.kernel.org>; Wed, 12 Dec 2018 19:17:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E281E2084E
	for <linux-wireless@archiver.kernel.org>; Wed, 12 Dec 2018 19:17:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=rsalveti-net.20150623.gappssmtp.com header.i=@rsalveti-net.20150623.gappssmtp.com header.b="XS5PUFya"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E281E2084E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=rsalveti.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726248AbeLLTRV (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 12 Dec 2018 14:17:21 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:34186 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726235AbeLLTRU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Dec 2018 14:17:20 -0500
Received: by mail-lj1-f195.google.com with SMTP id u6-v6so17301654ljd.1
        for <linux-wireless@vger.kernel.org>; Wed, 12 Dec 2018 11:17:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rsalveti-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qDyL5QoLGxCzyUkXtHONF+zq5tf4lbL8YbNxDxTty44=;
        b=XS5PUFyaE7z1wDrk95hflfVtPrtsFTChwYRP+DByHRtRL272KMAY0kHmWKw+r8dIGZ
         V85Pw56g/fOKOOudAhmv3nKFECyTU6jVfXLD4jv/orJ1wpwd7hXXs9dv+It/W4eQhC2Z
         yVScTyE5BJUzSHswCYv3gmCooWelO+QfpchiCvHJ7/sX9f8a4axc19tJdEP4uPJViKPZ
         t+j3W7DTPbyCuM5G+eXdi7bW4dQrP6YAsnJzM+H9qy1Bkde2vz3Q2uevPyMX/4XHIq5r
         8L85F2f92gyH3lnprH2r85UyrOBNy0cTln5+HylRWL48HMmRGh75/faY2vD/+/C/Bk60
         RpbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qDyL5QoLGxCzyUkXtHONF+zq5tf4lbL8YbNxDxTty44=;
        b=T9Rb3rGydcO2l2rFYtc4l3hlq+CWZjjHQ00L94xld0Lt0LPgNkpRjP+waWysRIeYcR
         batZURs9AM6+zYfwP/U+E/tHOtw++OgEiI5FlpdNG74/h0jiHLz235OSccAQcedZ7LsF
         GyQOuJS6K2GbQkCingbfefJp7dGB80GIzheh+YFtrrgOzUFlH017WargzKBdR/2StRqB
         79ZNcWJIsebsSAi7ZvYL0ZJFaxxZluw6QE8s2OOwVttDI1nFWUlg+gRvYjljPJc8rni6
         bDBB6CJmKXV+o2myxV9U+5hz0QPFNncqL04UNq5bMLN6Y+mxHeGKeN+EPLBPgjMUX3KB
         CozQ==
X-Gm-Message-State: AA+aEWabujPbfXFLfzyh6SvErcPn76kPSbv/PQEr7X4M7EfN7SDqPq72
        TPirz6VjLlSVxir+4RdPgu9WY9pjf7WjiT7DQ8I4ig==
X-Google-Smtp-Source: AFSGD/UJZ2LgDm4GHT4AiG4wk8fWvdz5rYI5kdSiADrZ7+HlFSM0FAe8UkVXQFCaZ+oPlY3eD+eRPkfE63eG32tZqls=
X-Received: by 2002:a2e:2106:: with SMTP id h6-v6mr12515115ljh.37.1544642237397;
 Wed, 12 Dec 2018 11:17:17 -0800 (PST)
MIME-Version: 1.0
References: <CAHYQr0pKurSS=nvLEaLzup1hgx4+RJ0CezA2nFeA=C4XBDQQog@mail.gmail.com>
 <20181211181944.GW39861@atomide.com> <CAHYQr0pk-WKM-aYR7ubM4GHx8PA82XP5ze9TW9WEJLzdO0f88A@mail.gmail.com>
 <20181211190128.GX39861@atomide.com> <CAHYQr0qc_Lav=1sEGcOmOykUftWRzd6+vis97eBpanEXzfUHaA@mail.gmail.com>
 <CALAqxLUVajBw_PkyhA0s=FhQQHWu1FBEMX+4oDTStRXr6L5Txw@mail.gmail.com>
 <20181211201221.GY39861@atomide.com> <CAHYQr0qffa_G2ZVnSsDfjqSgxuBBZB+8e6ZODpAWV_TMhqzFYg@mail.gmail.com>
 <CAHYQr0qhqce2QcwMLRMWnqhZTL4KzHKJLzt6tfCNLHUcEt9pyQ@mail.gmail.com>
 <20181212014556.GC39861@atomide.com> <c8625c42f04a4721b7efb7d7b6b3931c@ti.com>
In-Reply-To: <c8625c42f04a4721b7efb7d7b6b3931c@ti.com>
From:   Ricardo Salveti <rsalveti@rsalveti.net>
Date:   Wed, 12 Dec 2018 17:16:39 -0200
Message-ID: <CAHYQr0pN5ADWHbG5Tyes+KUPVXkTrcKDu2p4sAHz+sh6wpTcDw@mail.gmail.com>
Subject: Re: [EXTERNAL] Re: wlcore getting stuck on hikey after the runtime PM
 autosuspend support change
To:     eyalr@ti.com
Cc:     Tony Lindgren <tony@atomide.com>,
        John Stultz <john.stultz@linaro.org>,
        linux-wireless@vger.kernel.org, anders.roxell@linaro.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Dec 12, 2018 at 5:27 AM Reizer, Eyal <eyalr@ti.com> wrote:
> I Just tried on an available am335x-evm using 4.20.0-rc1 which I believe has all the patches merged already.
> I am using the same script  and not seeing any failure yet.
> See below:
>
> root@am335x-evm:/usr/share/wl18xx# uname -r
> 4.20.0-rc1-11287-gf487c00
> root@am335x-evm:/usr/share/wl18xx#
> root@am335x-evm:/usr/share/wl18xx#
> root@am335x-evm:/usr/share/wl18xx#
> root@am335x-evm:/usr/share/wl18xx#
> root@am335x-evm:/usr/share/wl18xx# while true; do ifconfig wlan0 down; ifconfig wlan0 up; done;
> [1378786.491101] wlcore: down
> [1378787.093006] wlcore: PHY firmware version: Rev 8.2.0.0.242
> [1378787.168523] wlcore: firmware booted (Rev 8.9.0.1.79)

I noticed your firmware is different here (8.9.0.1.79 instead of
8.9.0.0.79), but unclear if that would cause the issue.

Tested with 4.20-rc1 on my beaglebone black wireless and had the same
crash as with rc6:

[  157.947356] wlcore: PHY firmware version: Rev 8.2.0.0.242
[  157.994951] wlcore: firmware booted (Rev 8.9.0.0.79)
[  158.026020] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[  158.042400] wlcore: down
[  159.789119] ------------[ cut here ]------------
[  159.794351] WARNING: CPU: 0 PID: 629 at
drivers/net/wireless/ti/wlcore/sdio.c:145
wl12xx_sdio_raw_write+0x134/0x1c0 [wlcore_sdio]
[  159.809198] Modules linked in: ipt_MASQUERADE nf_conntrack_netlink
nfnetlink xfrm_user iptable_nat nf_nat_ipv4 xt_addrtype iptable_filter
ip_tables xt_conntrack x_tables nf_nat nf_conntrack nf_defrag_ipv6
nf_defrag_ipv4 libcrc32c br_netfilter bridge stp llc arc4 wl18xx
wlcore mac80211 musb_dsps musb_hdrc phy_am335x cppi41 udc_core
phy_am335x_control phy_generic snd_soc_hdmi_codec snd_soc_simple_card
snd_soc_simple_card_utils pm33xx wkup_m3_rproc wkup_m3_ipc remoteproc
virtio virtio_ring ti_emif_sram snd_soc_davinci_mcasp hci_uart
snd_soc_edma snd_soc_sdma tilcdc btqca btbcm btintel snd_soc_core
snd_pcm_dmaengine omap_mailbox snd_pcm wlcore_sdio snd_timer snd
soundcore musb_am335x rtc_omap tda998x at24 cpufreq_dt thermal_sys
fuse nhc_udp bluetooth_6lowpan nhc_routing nhc_hop nhc_mobility
nhc_fragment nhc_dest nhc_ipv6 6lowpan
[  159.891095] CPU: 0 PID: 629 Comm: ifconfig Not tainted
4.20.0-rc1-lmp-standard #1
[  159.905673] Hardware name: Generic AM33XX (Flattened Device Tree)
[  159.912806] Backtrace:
[  159.915412] [<c010f0b8>] (dump_backtrace) from [<c010f458>]
(show_stack+0x20/0x24)
[  159.924309]  r7:dc9f4410 r6:00000009 r5:00000000 r4:00000000
[  159.930269] [<c010f438>] (show_stack) from [<c0a0d510>]
(dump_stack+0x24/0x28)
[  159.939016] [<c0a0d4ec>] (dump_stack) from [<c013a864>]
(__warn.part.3+0xcc/0xe4)
[  159.947485] [<c013a798>] (__warn.part.3) from [<c013a9fc>]
(warn_slowpath_null+0x54/0x5c)
[  159.956626]  r6:bf1383b4 r5:00000091 r4:bf139be0
[  159.961995] [<c013a9a8>] (warn_slowpath_null) from [<bf1383b4>]
(wl12xx_sdio_raw_write+0x134/0x1c0 [wlcore_sdio])
[  159.973266]  r6:00004000 r5:c0f03088 r4:dd588400
[  159.978201] [<bf138280>] (wl12xx_sdio_raw_write [wlcore_sdio]) from
[<bf42d33c>] (wlcore_boot_upload_firmware+0x1ec/0x55c [wlcore])
[  159.991553]  r10:dcf58000 r9:de490d60 r8:bf138280 r7:00014000
r6:bf441480 r5:80904000
[  159.999766]  r4:00000001
[  160.003427] [<bf42d150>] (wlcore_boot_upload_firmware [wlcore])
from [<bf458228>] (wl18xx_boot+0x8e4/0xd4c [wl18xx])
[  160.015176]  r10:00000000 r9:00000014 r8:c0cdee98 r7:bf441480
r6:c0f03088 r5:00000000
[  160.023933]  r4:de490d60
[  160.026673] [<bf457944>] (wl18xx_boot [wl18xx]) from [<bf41da38>]
(wl1271_op_add_interface+0x580/0x9b0 [wlcore])
[  160.039580]  r9:00000003 r8:de490da0 r7:bf441480 r6:c0f03088
r5:de490d60 r4:00000000
[  160.048653] [<bf41d4b8>] (wl1271_op_add_interface [wlcore]) from
[<bf367df8>] (drv_add_interface+0x58/0x1a8 [mac80211])
[  160.060950]  r10:00000000 r9:ffffffff r8:00000001 r7:de4794e0
r6:de490460 r5:de490460
[  160.069167]  r4:de4794e0
[  160.073230] [<bf367da0>] (drv_add_interface [mac80211]) from
[<bf37f37c>] (ieee80211_do_open+0x490/0x984 [mac80211])
[  160.085115]  r7:de4794e0 r6:de490460 r5:de479000 r4:de4794e8
[  160.091854] [<bf37eeec>] (ieee80211_do_open [mac80211]) from
[<bf37f8c4>] (ieee80211_open+0x54/0x60 [mac80211])
[  160.103055]  r10:db213c60 r9:00000000 r8:00001002 r7:c0f03088
r6:bf3cb4e0 r5:c0f03088
[  160.114672]  r4:de4794e0
[  160.117620] [<bf37f870>] (ieee80211_open [mac80211]) from
[<c07f8fec>] (__dev_open+0xec/0x170)
[  160.132084]  r5:c0f03088 r4:de479000
[  160.135883] [<c07f8f00>] (__dev_open) from [<c07f940c>]
(__dev_change_flags+0x174/0x1d4)
[  160.145604]  r6:00001043 r5:00000001 r4:de479000
[  160.151249] [<c07f9298>] (__dev_change_flags) from [<c07f9494>]
(dev_change_flags+0x28/0x58)
[  160.160109]  r9:00000000 r8:c0fa2060 r7:de479144 r6:00000000
r5:00001002 r4:de479000
[  160.169241] [<c07f946c>] (dev_change_flags) from [<c0894650>]
(devinet_ioctl+0x6d4/0x704)
[  160.178361]  r9:00000000 r8:c0fa2060 r7:dcb0fd0c r6:c0f03088
r5:dcfffe08 r4:00000000
[  160.187128] [<c0893f7c>] (devinet_ioctl) from [<c0896918>]
(inet_ioctl+0x214/0x3c4)
[  160.195687]  r10:db213c60 r9:00000004 r8:00000051 r7:c0fa2060
r6:00008914 r5:be811b0c
[  160.204386]  r4:c0f03088
[  160.207064] [<c0896704>] (inet_ioctl) from [<c07d354c>]
(sock_ioctl+0x1d0/0x4e0)
[  160.215677]  r9:00000004 r8:c0fa2060 r7:be811b0c r6:d1041240
r5:c0f03088 r4:00008914
[  160.224361] [<c07d337c>] (sock_ioctl) from [<c02e4314>]
(do_vfs_ioctl+0xc0/0x95c)
[  160.232820]  r9:00000004 r8:be811b0c r7:00000004 r6:d1041240
r5:be811b0c r4:c0f03088
[  160.241466] [<c02e4254>] (do_vfs_ioctl) from [<c02e4c1c>]
(ksys_ioctl+0x6c/0x90)
[  160.249230]  r10:00000036 r9:00000004 r8:be811b0c r7:00008914
r6:00000000 r5:d1041240
[  160.258250]  r4:d1041240
[  160.261515] [<c02e4bb0>] (ksys_ioctl) from [<c02e4c58>] (sys_ioctl+0x18/0x1c)
[  160.269006]  r9:dcffe000 r8:c0101204 r7:00000036 r6:b6fe7900
r5:004c3e44 r4:be811b0c
[  160.278049] [<c02e4c40>] (sys_ioctl) from [<c0101000>]
(ret_fast_syscall+0x0/0x54)
[  160.286585] Exception stack(0xdcffffa8 to 0xdcfffff0)
[  160.292443] ffa0:                   be811b0c 004c3e44 00000004
00008914 be811b0c 00001002
[  160.301530] ffc0: be811b0c 004c3e44 b6fe7900 00000036 be811bec
004c4384 004c3e44 be811efe
[  160.310107] ffe0: 004c3ec4 be811afc 004ad0d1 b6f5e0f8
[  160.316308] ---[ end trace e1cf141728071aef ]---
[  160.321681] wl1271_sdio mmc2:0001:2: sdio write failed (-110)

I'm guessing this is just a timing issue that is happening on beagle,
and also possibly related to the kernel config used here.

Cheers,
--
Ricardo Salveti de Araujo
