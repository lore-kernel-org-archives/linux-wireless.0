Return-Path: <SRS0=opxv=OW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A4D7C65BAE
	for <linux-wireless@archiver.kernel.org>; Thu, 13 Dec 2018 13:54:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F59920849
	for <linux-wireless@archiver.kernel.org>; Thu, 13 Dec 2018 13:54:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="SWT5PL1w";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Iay5FC1D"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2F59920849
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729549AbeLMNyH (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 13 Dec 2018 08:54:07 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:43596 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729477AbeLMNyH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Dec 2018 08:54:07 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 0A793602F8; Thu, 13 Dec 2018 13:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1544709246;
        bh=nPiXomwx4vqRrhrxBskGpdJawAINHzNHm5i8qnJ3jOg=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=SWT5PL1wY6Ts9OUAhz0nPyXFfE8BMK4+Ss0nFp3WCuzCSfsTlFaE74oSLzKZVGG+0
         LF6Fvv3i4d1XTHRfuAbnX8tMlBjOFHnkAxeiMMyaw+u9vGrnS8uRMqgkO5Jbuy3RC3
         4JxrJugXNP27Xmo1DTw0KRFXVsvp36sxX0iAGSCw=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id AFA7260237;
        Thu, 13 Dec 2018 13:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1544709245;
        bh=nPiXomwx4vqRrhrxBskGpdJawAINHzNHm5i8qnJ3jOg=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=Iay5FC1DwgiemgzrvEUkwnFBcp1FWJQs7TzsoK8RQhwuKuxId+V1aQU/mAd6O+yHU
         w00Ntw7Y/nNniQB+6ys13GJ/Y5Yb0ULWWWoTFat2C7LFtGuueiONi45DcWbZTnNKWS
         cQ/yKROaD+UGgW6VQFgZYmAWhczLAzu04cZes43Y=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org AFA7260237
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [4.20 PATCH] Revert "mwifiex: restructure rx_reorder_tbl_lock
 usage"
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20181130175957.167031-1-briannorris@chromium.org>
References: <20181130175957.167031-1-briannorris@chromium.org>
To:     Brian Norris <briannorris@chromium.org>
Cc:     <linux-kernel@vger.kernel.org>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Xinming Hu <huxinming820@gmail.com>,
        linux-wireless@vger.kernel.org,
        Brian Norris <briannorris@chromium.org>, stable@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181213135406.0A793602F8@smtp.codeaurora.org>
Date:   Thu, 13 Dec 2018 13:54:05 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Brian Norris <briannorris@chromium.org> wrote:

> This reverts commit 5188d5453bc9380ccd4ae1086138dd485d13aef2, because it
> introduced lock recursion:
> 
>   BUG: spinlock recursion on CPU#2, kworker/u13:1/395
>    lock: 0xffffffc0e28a47f0, .magic: dead4ead, .owner: kworker/u13:1/395, .owner_cpu: 2
>   CPU: 2 PID: 395 Comm: kworker/u13:1 Not tainted 4.20.0-rc4+ #2
>   Hardware name: Google Kevin (DT)
>   Workqueue: MWIFIEX_RX_WORK_QUEUE mwifiex_rx_work_queue [mwifiex]
>   Call trace:
>    dump_backtrace+0x0/0x140
>    show_stack+0x20/0x28
>    dump_stack+0x84/0xa4
>    spin_bug+0x98/0xa4
>    do_raw_spin_lock+0x5c/0xdc
>    _raw_spin_lock_irqsave+0x38/0x48
>    mwifiex_flush_data+0x2c/0xa4 [mwifiex]
>    call_timer_fn+0xcc/0x1c4
>    run_timer_softirq+0x264/0x4f0
>    __do_softirq+0x1a8/0x35c
>    do_softirq+0x54/0x64
>    netif_rx_ni+0xe8/0x120
>    mwifiex_recv_packet+0xfc/0x10c [mwifiex]
>    mwifiex_process_rx_packet+0x1d4/0x238 [mwifiex]
>    mwifiex_11n_dispatch_pkt+0x190/0x1ac [mwifiex]
>    mwifiex_11n_rx_reorder_pkt+0x28c/0x354 [mwifiex]
>    mwifiex_process_sta_rx_packet+0x204/0x26c [mwifiex]
>    mwifiex_handle_rx_packet+0x15c/0x16c [mwifiex]
>    mwifiex_rx_work_queue+0x104/0x134 [mwifiex]
>    worker_thread+0x4cc/0x72c
>    kthread+0x134/0x13c
>    ret_from_fork+0x10/0x18
> 
> This was clearly not tested well at all. I simply performed 'wget' in a
> loop and it fell over within a few seconds.
> 
> Fixes: 5188d5453bc9 ("mwifiex: restructure rx_reorder_tbl_lock usage")
> Cc: <stable@vger.kernel.org>
> Cc: Ganapathi Bhat <gbhat@marvell.com>
> Signed-off-by: Brian Norris <briannorris@chromium.org>

Patch applied to wireless-drivers.git, thanks.

1aa48f088615 Revert "mwifiex: restructure rx_reorder_tbl_lock usage"

-- 
https://patchwork.kernel.org/patch/10706959/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

