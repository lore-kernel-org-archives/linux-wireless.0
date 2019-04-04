Return-Path: <SRS0=xyYy=SG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA616C4360F
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 10:13:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 71B7F2147C
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 10:13:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="QdX3Bpn2";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Di/DKqro"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728897AbfDDKNC (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 4 Apr 2019 06:13:02 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:37474 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728798AbfDDKNC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Apr 2019 06:13:02 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 9A2E661A26; Thu,  4 Apr 2019 10:13:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1554372780;
        bh=K4gAea8VpmangVzTBxsWy4tPWz/KleUKhAioJ98/zeg=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=QdX3Bpn207xXNM5Bm5vwWfug1fYSttKrJdqC2xgy4la6yS9HkPFnyTLAm9+VS2b8q
         lg7aPPhSdzwYPl1Sl5rnXR+sJkpHwLc8eNj0k1CsnQw0blRCOOdmAL5SknqeW9DYG9
         FITI4e+Wm+lkgvmFyT8HgYkobuiohGPkfWjC3l4o=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 4E4AF61779;
        Thu,  4 Apr 2019 10:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1554372778;
        bh=K4gAea8VpmangVzTBxsWy4tPWz/KleUKhAioJ98/zeg=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=Di/DKqromNxVdVyWtTftbKp5bEBr56N6gi+XpGxbCoU+QB2ERM3F7Z+sGCl8AQwOr
         Jqc3f1JjDP6Zq8HgAfMen3z7dh5xLZozX+1KZehUrnG8BLoMWl3n5Ntouw5r/0kK69
         modbfHSdYRf3aL943VVTRaDLra7ZaHbruEWvzhF4=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 4E4AF61779
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] brcmfmac: convert dev_init_lock mutex to completion
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1552470749-3625-1-git-send-email-p.figiel@camlintechnologies.com>
References: <1552470749-3625-1-git-send-email-p.figiel@camlintechnologies.com>
To:     Piotr Figiel <p.figiel@camlintechnologies.com>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "arend.vanspriel@broadcom.com" <arend.vanspriel@broadcom.com>,
        "franky.lin@broadcom.com" <franky.lin@broadcom.com>,
        "hante.meuleman@broadcom.com" <hante.meuleman@broadcom.com>,
        "chi-hsien.lin@cypress.com" <chi-hsien.lin@cypress.com>,
        "wright.feng@cypress.com" <wright.feng@cypress.com>,
        "brcm80211-dev-list@cypress.com" <brcm80211-dev-list@cypress.com>,
        =?iso-8859-2?q?Krzysztof_Drobi=F1ski?= 
        <k.drobinski@camlintechnologies.com>,
        Pawel Lenkow <p.lenkow@camlintechnologies.com>,
        Lech Perczak <l.perczak@camlintechnologies.com>,
        Piotr Figiel <p.figiel@camlintechnologies.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190404101300.9A2E661A26@smtp.codeaurora.org>
Date:   Thu,  4 Apr 2019 10:13:00 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Piotr Figiel <p.figiel@camlintechnologies.com> wrote:

> Leaving dev_init_lock mutex locked in probe causes BUG and a WARNING when
> kernel is compiled with CONFIG_PROVE_LOCKING. Convert mutex to completion
> which silences those warnings and improves code readability.
> 
> Fix below errors when connecting the USB WiFi dongle:
> 
> brcmfmac: brcmf_fw_alloc_request: using brcm/brcmfmac43143 for chip BCM43143/2
> BUG: workqueue leaked lock or atomic: kworker/0:2/0x00000000/434
>      last function: hub_event
> 1 lock held by kworker/0:2/434:
>  #0: 18d5dcdf (&devinfo->dev_init_lock){+.+.}, at: brcmf_usb_probe+0x78/0x550 [brcmfmac]
> CPU: 0 PID: 434 Comm: kworker/0:2 Not tainted 4.19.23-00084-g454a789-dirty #123
> Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
> Workqueue: usb_hub_wq hub_event
> [<8011237c>] (unwind_backtrace) from [<8010d74c>] (show_stack+0x10/0x14)
> [<8010d74c>] (show_stack) from [<809c4324>] (dump_stack+0xa8/0xd4)
> [<809c4324>] (dump_stack) from [<8014195c>] (process_one_work+0x710/0x808)
> [<8014195c>] (process_one_work) from [<80141a80>] (worker_thread+0x2c/0x564)
> [<80141a80>] (worker_thread) from [<80147bcc>] (kthread+0x13c/0x16c)
> [<80147bcc>] (kthread) from [<801010b4>] (ret_from_fork+0x14/0x20)
> Exception stack(0xed1d9fb0 to 0xed1d9ff8)
> 9fa0:                                     00000000 00000000 00000000 00000000
> 9fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
> 9fe0: 00000000 00000000 00000000 00000000 00000013 00000000
> 
> ======================================================
> WARNING: possible circular locking dependency detected
> 4.19.23-00084-g454a789-dirty #123 Not tainted
> ------------------------------------------------------
> kworker/0:2/434 is trying to acquire lock:
> e29cf799 ((wq_completion)"events"){+.+.}, at: process_one_work+0x174/0x808
> 
> but task is already holding lock:
> 18d5dcdf (&devinfo->dev_init_lock){+.+.}, at: brcmf_usb_probe+0x78/0x550 [brcmfmac]
> 
> which lock already depends on the new lock.
> 
> the existing dependency chain (in reverse order) is:
> 
> -> #2 (&devinfo->dev_init_lock){+.+.}:
>        mutex_lock_nested+0x1c/0x24
>        brcmf_usb_probe+0x78/0x550 [brcmfmac]
>        usb_probe_interface+0xc0/0x1bc
>        really_probe+0x228/0x2c0
>        __driver_attach+0xe4/0xe8
>        bus_for_each_dev+0x68/0xb4
>        bus_add_driver+0x19c/0x214
>        driver_register+0x78/0x110
>        usb_register_driver+0x84/0x148
>        process_one_work+0x228/0x808
>        worker_thread+0x2c/0x564
>        kthread+0x13c/0x16c
>        ret_from_fork+0x14/0x20
>          (null)
> 
> -> #1 (brcmf_driver_work){+.+.}:
>        worker_thread+0x2c/0x564
>        kthread+0x13c/0x16c
>        ret_from_fork+0x14/0x20
>          (null)
> 
> -> #0 ((wq_completion)"events"){+.+.}:
>        process_one_work+0x1b8/0x808
>        worker_thread+0x2c/0x564
>        kthread+0x13c/0x16c
>        ret_from_fork+0x14/0x20
>          (null)
> 
> other info that might help us debug this:
> 
> Chain exists of:
>   (wq_completion)"events" --> brcmf_driver_work --> &devinfo->dev_init_lock
> 
>  Possible unsafe locking scenario:
> 
>        CPU0                    CPU1
>        ----                    ----
>   lock(&devinfo->dev_init_lock);
>                                lock(brcmf_driver_work);
>                                lock(&devinfo->dev_init_lock);
>   lock((wq_completion)"events");
> 
>  *** DEADLOCK ***
> 
> 1 lock held by kworker/0:2/434:
>  #0: 18d5dcdf (&devinfo->dev_init_lock){+.+.}, at: brcmf_usb_probe+0x78/0x550 [brcmfmac]
> 
> stack backtrace:
> CPU: 0 PID: 434 Comm: kworker/0:2 Not tainted 4.19.23-00084-g454a789-dirty #123
> Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
> Workqueue: events request_firmware_work_func
> [<8011237c>] (unwind_backtrace) from [<8010d74c>] (show_stack+0x10/0x14)
> [<8010d74c>] (show_stack) from [<809c4324>] (dump_stack+0xa8/0xd4)
> [<809c4324>] (dump_stack) from [<80172838>] (print_circular_bug+0x210/0x330)
> [<80172838>] (print_circular_bug) from [<80175940>] (__lock_acquire+0x160c/0x1a30)
> [<80175940>] (__lock_acquire) from [<8017671c>] (lock_acquire+0xe0/0x268)
> [<8017671c>] (lock_acquire) from [<80141404>] (process_one_work+0x1b8/0x808)
> [<80141404>] (process_one_work) from [<80141a80>] (worker_thread+0x2c/0x564)
> [<80141a80>] (worker_thread) from [<80147bcc>] (kthread+0x13c/0x16c)
> [<80147bcc>] (kthread) from [<801010b4>] (ret_from_fork+0x14/0x20)
> Exception stack(0xed1d9fb0 to 0xed1d9ff8)
> 9fa0:                                     00000000 00000000 00000000 00000000
> 9fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
> 9fe0: 00000000 00000000 00000000 00000000 00000013 00000000
> 
> Signed-off-by: Piotr Figiel <p.figiel@camlintechnologies.com>

Patch applied to wireless-drivers-next.git, thanks.

a9fd0953fa4a brcmfmac: convert dev_init_lock mutex to completion

-- 
https://patchwork.kernel.org/patch/10850843/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

