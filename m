Return-Path: <SRS0=DNYG=S3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D536AC43218
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 16:40:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 42B6B20693
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 16:40:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="C+bXTSqw";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="m3Yq4EHa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727444AbfDYQkG (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 25 Apr 2019 12:40:06 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:54166 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726065AbfDYQkG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Apr 2019 12:40:06 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id B9BE360EA5; Thu, 25 Apr 2019 16:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556210404;
        bh=KY3ZuT7j7tVDJrKg8WCjzWvmb190SfxevK0VsdJxO+8=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=C+bXTSqwvoMb2Mp2FhFTbYmuJvNsGhLaCwbR5YYAA/cSTKZODpyZ+Jl0aCUEM2Ypg
         xKyUFmVMTDlnh9EuntGILPFz6HDiMzgE9lUWlV2k93fJzcuQxsAF4z2DJAv8UG+1Hj
         yCIREG4nrALf055UpCyJfJAzNnhNFzkHC/Oi++ok=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 5F1C860E42;
        Thu, 25 Apr 2019 16:39:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556210401;
        bh=KY3ZuT7j7tVDJrKg8WCjzWvmb190SfxevK0VsdJxO+8=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=m3Yq4EHa9gz8+dnUYhbDa5BgMNcDfWNJ9oXZEWrbpRyk/hHKoFcQQRr/daMaEt2ZO
         rHHMaeo5q9txFvZipH0Qgtb1dDzJDhFWtoEpHvYVaj6X57b2OXxlE1Xwmu3XFpePRV
         FYMT5FWp1xoZrZpVwSpXxl7uWaxC8kZrBGzLc7ME=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 5F1C860E42
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ssb: Fix possible NULL pointer dereference in
 ssb_host_pcmcia_exit
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190306115658.25076-1-yuehaibing@huawei.com>
References: <20190306115658.25076-1-yuehaibing@huawei.com>
To:     Yue Haibing <yuehaibing@huawei.com>
Cc:     <ast@kernel.org>, <daniel@iogearbox.net>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190425164004.B9BE360EA5@smtp.codeaurora.org>
Date:   Thu, 25 Apr 2019 16:40:02 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Yue Haibing <yuehaibing@huawei.com> wrote:

> From: YueHaibing <yuehaibing@huawei.com>
> 
> Syzkaller report this:
> 
> kasan: GPF could be caused by NULL-ptr deref or user memory access
> general protection fault: 0000 [#1] SMP KASAN PTI
> CPU: 0 PID: 4492 Comm: syz-executor.0 Not tainted 5.0.0-rc7+ #45
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1ubuntu1 04/01/2014
> RIP: 0010:sysfs_remove_file_ns+0x27/0x70 fs/sysfs/file.c:468
> Code: 00 00 00 41 54 55 48 89 fd 53 49 89 d4 48 89 f3 e8 ee 76 9c ff 48 8d 7d 30 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 75 2d 48 89 da 48 b8 00 00 00 00 00 fc ff df 48 8b 6d
> RSP: 0018:ffff8881e9d9fc00 EFLAGS: 00010206
> RAX: dffffc0000000000 RBX: ffffffff900367e0 RCX: ffffffff81a95952
> RDX: 0000000000000006 RSI: ffffc90001405000 RDI: 0000000000000030
> RBP: 0000000000000000 R08: fffffbfff1fa22ed R09: fffffbfff1fa22ed
> R10: 0000000000000001 R11: fffffbfff1fa22ec R12: 0000000000000000
> R13: ffffffffc1abdac0 R14: 1ffff1103d3b3f8b R15: 0000000000000000
> FS:  00007fe409dc1700(0000) GS:ffff8881f1200000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000001b2d721000 CR3: 00000001e98b6005 CR4: 00000000007606f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> PKRU: 55555554
> Call Trace:
>  sysfs_remove_file include/linux/sysfs.h:519 [inline]
>  driver_remove_file+0x40/0x50 drivers/base/driver.c:122
>  pcmcia_remove_newid_file drivers/pcmcia/ds.c:163 [inline]
>  pcmcia_unregister_driver+0x7d/0x2b0 drivers/pcmcia/ds.c:209
>  ssb_modexit+0xa/0x1b [ssb]
>  __do_sys_delete_module kernel/module.c:1018 [inline]
>  __se_sys_delete_module kernel/module.c:961 [inline]
>  __x64_sys_delete_module+0x3dc/0x5e0 kernel/module.c:961
>  do_syscall_64+0x147/0x600 arch/x86/entry/common.c:290
>  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> RIP: 0033:0x462e99
> Code: f7 d8 64 89 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fe409dc0c58 EFLAGS: 00000246 ORIG_RAX: 00000000000000b0
> RAX: ffffffffffffffda RBX: 000000000073bf00 RCX: 0000000000462e99
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 00000000200000c0
> RBP: 0000000000000002 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 00007fe409dc16bc
> R13: 00000000004bccaa R14: 00000000006f6bc8 R15: 00000000ffffffff
> Modules linked in: ssb(-) 3c59x nvme_core macvlan tap pata_hpt3x3 rt2x00pci null_blk tsc40 pm_notifier_error_inject notifier_error_inject mdio cdc_wdm nf_reject_ipv4 ath9k_common ath9k_hw ath pppox ppp_generic slhc ehci_platform wl12xx wlcore tps6507x_ts ioc4 nf_synproxy_core ide_gd_mod ax25 can_dev iwlwifi can_raw atm tm2_touchkey can_gw can sundance adp5588_keys rt2800mmio rt2800lib rt2x00mmio rt2x00lib eeprom_93cx6 pn533 lru_cache elants_i2c ip_set nfnetlink gameport tipc hampshire nhc_ipv6 nhc_hop nhc_udp nhc_fragment nhc_routing nhc_mobility nhc_dest 6lowpan silead brcmutil nfc mt76_usb mt76 mac80211 iptable_security iptable_raw iptable_mangle iptable_nat nf_nat_ipv4 nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 iptable_filter bpfilter ip6_vti ip_gre sit hsr veth vxcan batman_adv cfg80211 rfkill chnl_net caif nlmon vcan bridge stp llc ip6_gre ip6_tunnel tunnel6 tun joydev mousedev serio_raw ide_pci_generic piix floppy ide_core sch_fq_codel ip_tables x_tables ipv6
>  [last unloaded: 3c59x]
> Dumping ftrace buffer:
>    (ftrace buffer empty)
> ---[ end trace 3913cbf8011e1c05 ]---
> 
> In ssb_modinit, it does not fail SSB init when ssb_host_pcmcia_init failed,
> however in ssb_modexit, ssb_host_pcmcia_exit calls pcmcia_unregister_driver
> unconditionally, which may tigger a NULL pointer dereference issue as above.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Fixes: 399500da18f7 ("ssb: pick PCMCIA host code support from b43 driver")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Patch applied to wireless-drivers-next.git, thanks.

b2c01aab9646 ssb: Fix possible NULL pointer dereference in ssb_host_pcmcia_exit

-- 
https://patchwork.kernel.org/patch/10841029/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

