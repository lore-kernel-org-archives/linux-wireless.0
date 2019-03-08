Return-Path: <SRS0=wltO=RL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C109C43381
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Mar 2019 02:34:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F37BA2081B
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Mar 2019 02:34:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="mjzKw/LH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726427AbfCHCeI (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 7 Mar 2019 21:34:08 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:34181 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726283AbfCHCeH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Mar 2019 21:34:07 -0500
Received: by mail-pg1-f193.google.com with SMTP id i130so12864602pgd.1
        for <linux-wireless@vger.kernel.org>; Thu, 07 Mar 2019 18:34:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=UTZumptBdSe2N4uc+wXtQ84GftVlF9+XICQPEoUB5wU=;
        b=mjzKw/LHi0Ml4H3WhRnf6j6SUuzlEYtG27psMclgewkCimKdqb3mjbglXi54lo6lqm
         Tt4tCr6KVefbc/jW4i0oXBxSESp7CvVdGF8YBfiKX3KTUW6rB1LAZWZZheCOalUxaVjm
         Rad1WqNbeoKegWMX3hY8LVUQi60fA8J/KHvMA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=UTZumptBdSe2N4uc+wXtQ84GftVlF9+XICQPEoUB5wU=;
        b=ucdz1D21T0QBT68lupRLpEUFeGsgo2VXBLuB/DYNfVjfb1byUsMjczgGtA1RfIJ0Za
         cV5LZZUbvw6NerlyHSkDfsMg4qW/6HDRklAB9dcgNJeo+yabdmDFlTXJXzNci5RZEAB9
         eFc2CoxHRX/CIKZzECkwDflKUpGoH3nPZr6javwJnmN+jqcebuVa6vwaxMsx+VIyPoaa
         vqEO25iq/lAdbfaImxgNHsEHWS7ILNMt97Kjv4vXOnAzkAJzmWE2OPI1o/q7nR9uH+oI
         URnZaBVYU5yfvmm8crn590RE6No5u5BnCacdvVBwASZLQaRudCiSSg4l2lMGeB4dkYnO
         qgbQ==
X-Gm-Message-State: APjAAAUrOVwzNg/JvE9naoIwvtO9JtjqFnRHkt5ACsclA61P5xR2WUoQ
        9xFiPaXKhRza4dkxUbvaPiNHPg==
X-Google-Smtp-Source: APXvYqzBENnfkUI9dx+EcdiVybb2yGOekoIWT2Yb1FAZimDak7QIQVqvh1E3fPP3UfYU3HyKPjvmWQ==
X-Received: by 2002:a17:902:e711:: with SMTP id co17mr15987990plb.171.1552012446853;
        Thu, 07 Mar 2019 18:34:06 -0800 (PST)
Received: from google.com ([2620:15c:202:1:534:b7c0:a63c:460c])
        by smtp.gmail.com with ESMTPSA id p2sm14653048pfi.95.2019.03.07.18.34.05
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 07 Mar 2019 18:34:05 -0800 (PST)
Date:   Thu, 7 Mar 2019 18:34:03 -0800
From:   Brian Norris <briannorris@chromium.org>
To:     Ganapathi Bhat <gbhat@marvell.com>
Cc:     linux-kernel@vger.kernel.org,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Xinming Hu <huxinming820@gmail.com>,
        linux-wireless@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [4.20 PATCH] Revert "mwifiex: restructure rx_reorder_tbl_lock
 usage"
Message-ID: <20190308023401.GA121759@google.com>
References: <20181130175957.167031-1-briannorris@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181130175957.167031-1-briannorris@chromium.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi again Ganapathi,

By the way, I was a little curious about what went wrong here, so I dug
in a little further:

On Fri, Nov 30, 2018 at 09:59:57AM -0800, Brian Norris wrote:
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

TL;DR: the problem was right here ^^^
where you started running mwifiex_11n_dispatch_pkt() (via
mwifiex_11n_scan_and_dispatch()) while holding a spinlock.

When you do that, you eventually call netif_rx_ni(), which specifically
defers to softirq contexts. Then, if you happen to have your flush timer
expiring just before that, you end up in mwifiex_flush_data(), which
also needs that spinlock.

There are a few possible ways to handle this:
(a) prevent processing softirqs in that context; e.g., with
    local_bh_disable(). This seems somewhat of a hack.
    (Side note: I think most of the locks in this driver really could be
    spin_lock_bh(), not spin_lock_irqsave() -- we don't really care
    about hardirq context for 99% of these locks.)
(b) restructure so that packet processing (e.g., netif_rx_ni()) is done
    outside of the spinlock.

It's actually not that hard to do (b). You can just queue your skb's up
in a temporary sk_buff_head list and process them all at once after
you've finished processing the reorder table. I have a local patch to do
this, and I might send it your way if I can give it a bit more testing.

Brian

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
