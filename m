Return-Path: <SRS0=DNYG=S3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A31AC4321A
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 16:52:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D57A420679
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 16:52:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Bp5hfexs";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="YRTGJ4a6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727502AbfDYQwd (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 25 Apr 2019 12:52:33 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:60528 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726020AbfDYQwd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Apr 2019 12:52:33 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id CCE6F60A05; Thu, 25 Apr 2019 16:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556211151;
        bh=mPkCligBzxQpDHwei4iLDe7tTNSG09r+LZiG/Z9mEeE=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=Bp5hfexsZmFvgd4xaF00cy8QORpwARaGqBk9PWJ0NjOpDprYk6+AK6AtOYPGqfdhX
         eWe2Llfgygq0YsVmHR2r7w2Ue1wwRx6xm7jgh4Bn4W3sOlwQ1+NGCUiiZ3OhtK6Z74
         JvtaB3QvRGruoCWJ4ATb30ZJ2UlWmnx8p78Pw/zo=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id CCC5060A50;
        Thu, 25 Apr 2019 16:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556211151;
        bh=mPkCligBzxQpDHwei4iLDe7tTNSG09r+LZiG/Z9mEeE=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=YRTGJ4a6JOtQhD1vdDoZEdfluOVLjh2QMtz5ADVE3rA9lGfMKFfmXPmPupThpBAeD
         OAkmIRCajRV7lt5zNnBymdQ6Z8r3jbpuI6hdSmOMDd1cU45GEzDufXc202VMhzAiJ0
         vO9R10I4vx/sZkYk5UvojW18BjTHEg47j8urgvDM=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org CCC5060A50
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] at76c50x-usb: Don't register led_trigger if
 usb_register_driver failed
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190408034529.27500-1-yuehaibing@huawei.com>
References: <20190408034529.27500-1-yuehaibing@huawei.com>
To:     Yue Haibing <yuehaibing@huawei.com>
Cc:     <linux-kernel@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190425165231.CCE6F60A05@smtp.codeaurora.org>
Date:   Thu, 25 Apr 2019 16:52:31 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Yue Haibing <yuehaibing@huawei.com> wrote:

> From: YueHaibing <yuehaibing@huawei.com>
> 
> Syzkaller report this:
> 
> [ 1213.468581] BUG: unable to handle kernel paging request at fffffbfff83bf338
> [ 1213.469530] #PF error: [normal kernel read fault]
> [ 1213.469530] PGD 237fe4067 P4D 237fe4067 PUD 237e60067 PMD 1c868b067 PTE 0
> [ 1213.473514] Oops: 0000 [#1] SMP KASAN PTI
> [ 1213.473514] CPU: 0 PID: 6321 Comm: syz-executor.0 Tainted: G         C        5.1.0-rc3+ #8
> [ 1213.473514] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1ubuntu1 04/01/2014
> [ 1213.473514] RIP: 0010:strcmp+0x31/0xa0
> [ 1213.473514] Code: 00 00 00 00 fc ff df 55 53 48 83 ec 08 eb 0a 84 db 48 89 ef 74 5a 4c 89 e6 48 89 f8 48 89 fa 48 8d 6f 01 48 c1 e8 03 83 e2 07 <42> 0f b6 04 28 38 d0 7f 04 84 c0 75 50 48 89 f0 48 89 f2 0f b6 5d
> [ 1213.473514] RSP: 0018:ffff8881f2b7f950 EFLAGS: 00010246
> [ 1213.473514] RAX: 1ffffffff83bf338 RBX: ffff8881ea6f7240 RCX: ffffffff825350c6
> [ 1213.473514] RDX: 0000000000000000 RSI: ffffffffc1ee19c0 RDI: ffffffffc1df99c0
> [ 1213.473514] RBP: ffffffffc1df99c1 R08: 0000000000000001 R09: 0000000000000004
> [ 1213.473514] R10: 0000000000000000 R11: ffff8881de353f00 R12: ffff8881ee727900
> [ 1213.473514] R13: dffffc0000000000 R14: 0000000000000001 R15: ffffffffc1eeaaf0
> [ 1213.473514] FS:  00007fa66fa01700(0000) GS:ffff8881f7200000(0000) knlGS:0000000000000000
> [ 1213.473514] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 1213.473514] CR2: fffffbfff83bf338 CR3: 00000001ebb9e005 CR4: 00000000007606f0
> [ 1213.473514] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [ 1213.473514] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [ 1213.473514] PKRU: 55555554
> [ 1213.473514] Call Trace:
> [ 1213.473514]  led_trigger_register+0x112/0x3f0
> [ 1213.473514]  led_trigger_register_simple+0x7a/0x110
> [ 1213.473514]  ? 0xffffffffc1c10000
> [ 1213.473514]  at76_mod_init+0x77/0x1000 [at76c50x_usb]
> [ 1213.473514]  do_one_initcall+0xbc/0x47d
> [ 1213.473514]  ? perf_trace_initcall_level+0x3a0/0x3a0
> [ 1213.473514]  ? kasan_unpoison_shadow+0x30/0x40
> [ 1213.473514]  ? kasan_unpoison_shadow+0x30/0x40
> [ 1213.473514]  do_init_module+0x1b5/0x547
> [ 1213.473514]  load_module+0x6405/0x8c10
> [ 1213.473514]  ? module_frob_arch_sections+0x20/0x20
> [ 1213.473514]  ? kernel_read_file+0x1e6/0x5d0
> [ 1213.473514]  ? find_held_lock+0x32/0x1c0
> [ 1213.473514]  ? cap_capable+0x1ae/0x210
> [ 1213.473514]  ? __do_sys_finit_module+0x162/0x190
> [ 1213.473514]  __do_sys_finit_module+0x162/0x190
> [ 1213.473514]  ? __ia32_sys_init_module+0xa0/0xa0
> [ 1213.473514]  ? __mutex_unlock_slowpath+0xdc/0x690
> [ 1213.473514]  ? wait_for_completion+0x370/0x370
> [ 1213.473514]  ? vfs_write+0x204/0x4a0
> [ 1213.473514]  ? do_syscall_64+0x18/0x450
> [ 1213.473514]  do_syscall_64+0x9f/0x450
> [ 1213.473514]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> [ 1213.473514] RIP: 0033:0x462e99
> [ 1213.473514] Code: f7 d8 64 89 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
> [ 1213.473514] RSP: 002b:00007fa66fa00c58 EFLAGS: 00000246 ORIG_RAX: 0000000000000139
> [ 1213.473514] RAX: ffffffffffffffda RBX: 000000000073bf00 RCX: 0000000000462e99
> [ 1213.473514] RDX: 0000000000000000 RSI: 0000000020000300 RDI: 0000000000000003
> [ 1213.473514] RBP: 00007fa66fa00c70 R08: 0000000000000000 R09: 0000000000000000
> [ 1213.473514] R10: 0000000000000000 R11: 0000000000000246 R12: 00007fa66fa016bc
> [ 1213.473514] R13: 00000000004bcefa R14: 00000000006f6fb0 R15: 0000000000000004
> 
> If usb_register failed, no need to call led_trigger_register_simple.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Fixes: 1264b951463a ("at76c50x-usb: add driver")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Patch applied to wireless-drivers-next.git, thanks.

09ac2694b047 at76c50x-usb: Don't register led_trigger if usb_register_driver failed

-- 
https://patchwork.kernel.org/patch/10888765/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

