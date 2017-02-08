Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55392 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754234AbdBHPlA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Feb 2017 10:41:00 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/2] rt2x00usb: do not anchor rx and tx urb's
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1486552690-27597-1-git-send-email-sgruszka@redhat.com>
References: <1486552690-27597-1-git-send-email-sgruszka@redhat.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        Vishal Thanki <vishalthanki@gmail.com>
Message-Id: <20170208153002.536D460A01@smtp.codeaurora.org> (sfid-20170208_164114_881679_1709E08A)
Date: Wed,  8 Feb 2017 15:30:02 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> We might kill TX or RX urb during rt2x00usb_flush_entry(), what can
> cause anchor list corruption like shown below:
> 
> [ 2074.035633] WARNING: CPU: 2 PID: 14480 at lib/list_debug.c:33 __list_add+0xac/0xc0
> [ 2074.035634] list_add corruption. prev->next should be next (ffff88020f362c28), but was dead000000000100. (prev=ffff8801d161bb70).
> <snip>
> [ 2074.035670] Call Trace:
> [ 2074.035672]  [<ffffffff813bde47>] dump_stack+0x63/0x8c
> [ 2074.035674]  [<ffffffff810a2231>] __warn+0xd1/0xf0
> [ 2074.035676]  [<ffffffff810a22af>] warn_slowpath_fmt+0x5f/0x80
> [ 2074.035678]  [<ffffffffa073855d>] ? rt2x00usb_register_write_lock+0x3d/0x60 [rt2800usb]
> [ 2074.035679]  [<ffffffff813dbe4c>] __list_add+0xac/0xc0
> [ 2074.035681]  [<ffffffff81591c6c>] usb_anchor_urb+0x4c/0xa0
> [ 2074.035683]  [<ffffffffa07322af>] rt2x00usb_kick_rx_entry+0xaf/0x100 [rt2x00usb]
> [ 2074.035684]  [<ffffffffa0732322>] rt2x00usb_clear_entry+0x22/0x30 [rt2x00usb]
> 
> To fix do not anchor TX and RX urb's, it is not needed as during
> shutdown we kill those urbs in rt2x00usb_free_entries().
> 
> Cc: Vishal Thanki <vishalthanki@gmail.com>
> Fixes: 8b4c0009313f ("rt2x00usb: Use usb anchor to manage URB")
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

2 patches applied to wireless-drivers-next.git, thanks.

93c7018ec16b rt2x00usb: do not anchor rx and tx urb's
0488a6121dfe rt2x00usb: fix anchor initialization

-- 
https://patchwork.kernel.org/patch/9562337/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
