Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52335 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1422721AbcIZRkC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Sep 2016 13:40:02 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/3] mwifiex: fix kernel crash for USB chipsets
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1474384744-14096-1-git-send-email-akarwar@marvell.com>
References: <1474384744-14096-1-git-send-email-akarwar@marvell.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: <linux-wireless@vger.kernel.org>, Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Shengzhen Li <szli@marvell.com>,
        Amitkumar Karwar <akarwar@marvell.com>
Message-Id: <20160926174001.EAB7061523@smtp.codeaurora.org> (sfid-20160926_194008_702267_0987F1CA)
Date: Mon, 26 Sep 2016 17:40:01 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <akarwar@marvell.com> wrote:
> From: Cathy Luo <cluo@marvell.com>
> 
> Following crash issue is observed during TCP traffic stress
> test
> 
> [ 2253.625439] NMI watchdog: BUG: soft lockup - CPU#3 stuck for 22s!
> [kworker/u17:1:5191]
> [ 2253.625520] Call Trace:
> [ 2253.625527]  [<ffffffffc0b47030>] ? moal_spin_lock+0x30/0x30
> [usb8xxx]
> [ 2253.625533]  [<ffffffffc0ac3ceb>] ? wlan_wmm_lists_empty+0xb/0xf0
> [mlan]
> [ 2253.625537]  [<ffffffffc0ab0ea3>] mlan_main_process+0x1b3/0x720
> [mlan]
> [ 2253.625540]  [<ffffffffc0b337f5>] woal_main_work_queue+0x45/0x80
> [usb8xxx]
> [ 2253.625543]  [<ffffffff8108aaf0>] process_one_work+0x150/0x3f0
> [ 2253.625545]  [<ffffffff8108b1e1>] worker_thread+0x121/0x520
> [ 2253.625547]  [<ffffffff8108b0c0>] ? rescuer_thread+0x330/0x330
> [ 2253.625549]  [<ffffffff81090222>] kthread+0xd2/0xf0
> [ 2253.625551]  [<ffffffff81090150>] ?
> kthread_create_on_node+0x1c0/0x1c0
> [ 2253.625553]  [<ffffffff8179423c>] ret_from_fork+0x7c/0xb0
> [ 2253.625555]  [<ffffffff81090150>] ?
> kthread_create_on_node+0x1c0/0x1c0
> 
> In mwifiex_usb_tx_complete(), we are updating port->block_status first
> and then freeing the skb attached to that URB. We may end up attaching
> new skb to URB in a corner case and same will be freed. This results in
> the kernel crash. The problem is solved by changing the sequence.
> 
> Signed-off-by: Cathy Luo <cluo@marvell.com>
> Signed-off-by: Shengzhen Li <szli@marvell.com>
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>

3 patches applied to wireless-drivers-next.git, thanks.

1afac196c167 mwifiex: fix kernel crash for USB chipsets
5476f8030d9a mwifiex: fix race condition causing tx timeout
ac3b561721e9 mwifiex: code rearrangement in mwifiex_usb_host_to_card()

-- 
https://patchwork.kernel.org/patch/9341883/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
