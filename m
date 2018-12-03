Return-Path: <SRS0=6FTc=OM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B690C04EBF
	for <linux-wireless@archiver.kernel.org>; Mon,  3 Dec 2018 12:37:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5184020850
	for <linux-wireless@archiver.kernel.org>; Mon,  3 Dec 2018 12:37:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="bKhVj0L2";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="c/AkalGr"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5184020850
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726347AbeLCMib (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 3 Dec 2018 07:38:31 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:59026 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725975AbeLCMib (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Dec 2018 07:38:31 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 0F4C3602FE; Mon,  3 Dec 2018 12:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1543840658;
        bh=H6mnuv4zm64hPJlmEmTVvIAIS4KtYpg6l1c9ZlouEKc=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=bKhVj0L2+Cz5SCDMmkRliDVUrkm4em/yxrMtKtg1azBpeY1h+EWO+ly3kHs9ClxEE
         2FsHlcO6HFpYhTmS1a7oA3S3NZ07TqNGZfeiCas1EtwNEJeQx9PCb8Bop5zMH0Z/cm
         Q98Jy2D+HHOD4Hg5RdoypXhCRhKcjIV9PHyQJ5KU=
Received: from x230.qca.qualcomm.com (37-33-92-201.bb.dnainternet.fi [37.33.92.201])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 9F98A60246;
        Mon,  3 Dec 2018 12:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1543840657;
        bh=H6mnuv4zm64hPJlmEmTVvIAIS4KtYpg6l1c9ZlouEKc=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=c/AkalGrDYkkxBrbXcfZeN2G4s6T68cSRIgnzjGk0wVIckGILv5p7k+H0ghSMqgQ9
         icYkLeLUV6dI4Pr8HBY1zTMW03QiVxgveO59D3wFFXNpMQQUv+27fwOKU/9VR9Uzlr
         PLBgR9C1cVdeD/qZ5nn+WcHQYEVvW3xpnreHih5c=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 9F98A60246
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Brian Norris <briannorris@chromium.org>
Cc:     <linux-kernel@vger.kernel.org>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Xinming Hu <huxinming820@gmail.com>,
        linux-wireless@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [4.20 PATCH] Revert "mwifiex: restructure rx_reorder_tbl_lock usage"
References: <20181130175957.167031-1-briannorris@chromium.org>
Date:   Mon, 03 Dec 2018 14:37:33 +0200
In-Reply-To: <20181130175957.167031-1-briannorris@chromium.org> (Brian
        Norris's message of "Fri, 30 Nov 2018 09:59:57 -0800")
Message-ID: <87h8fug50y.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Brian Norris <briannorris@chromium.org> writes:

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
> ---
> This is a 4.19 regression, but IMO the revert should be merged ASAP.

Ok, I'll queue this for 4.20.

-- 
Kalle Valo
