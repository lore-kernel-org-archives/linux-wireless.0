Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:49396 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751628AbdG1OtQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Jul 2017 10:49:16 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2,01/20] mwifiex: reunite copy-and-pasted remove/reset code
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170725011336.99993-2-briannorris@chromium.org>
References: <20170725011336.99993-2-briannorris@chromium.org>
To: Brian Norris <briannorris@chromium.org>
Cc: Ganapathi Bhat <gbhat@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        <linux-kernel@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        linux-wireless@vger.kernel.org,
        Brian Norris <briannorris@chromium.org>
Message-Id: <20170728144915.83AC260272@smtp.codeaurora.org> (sfid-20170728_164930_424886_1748502C)
Date: Fri, 28 Jul 2017 14:49:15 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Brian Norris <briannorris@chromium.org> wrote:

> When PCIe FLR code was added, it explicitly copy-and-pasted much of
> mwifiex_remove_card() into mwifiex_shutdown_sw(). This is unnecessary,
> as almost all of the code should be reused.
> 
> Let's reunite what we can for now.
> 
> The only functional changes for now:
> 
>  * call netif_device_detach() in the remove() code path -- this wasn't
>    done before, but it really should be a no-op, when the device is
>    getting totally unregistered soon anyway
> 
>  * call the ->down_dev() driver callback only after we've finished all
>    SW teardown -- this should have no significant effect, since the only
>    user (pcie.c) does very minimal work there, and it doesn't matter
>    that we reorder this
> 
> Signed-off-by: Brian Norris <briannorris@chromium.org>

20 patches applied to wireless-drivers-next.git, thanks.

b6658b66d8a6 mwifiex: reunite copy-and-pasted remove/reset code
4b1f5a0d2eeb mwifiex: reset interrupt status across device reset
7dc4a6b5ca94 mwifiex: pcie: don't allow cmd buffer reuse after reset
643acea6297f mwifiex: re-register wiphy across reset
ce32d1d83702 mwifiex: unregister wiphy before freeing resources
6417dba33538 mwifiex: don't short-circuit netdev notifiers on interface deletion
c253a62da9b4 mwifiex: fixup init_channel_scan_gap error case
9557d9f2e62b mwifiex: ensure "disable auto DS" struct is initialized
5e6588b9d4ab mwifiex: fix misnomers in mwifiex_free_lock_list()
f7d7e4b689ca mwifiex: make mwifiex_free_cmd_buffer() return void
fe8d730adaee mwifiex: utilize netif_tx_{wake,stop}_all_queues()
8395fd9b194c mwifiex: don't open-code ARRAY_SIZE()
463df4719084 mwifiex: drop 'add_tail' param from mwifiex_insert_cmd_to_pending_q()
605db27f7405 mwifiex: pcie: remove unnecessary masks
87a602126aaf mwifiex: pcie: unify MSI-X / non-MSI-X interrupt process
37680819c6e1 mwifiex: debugfs: allow card_reset() to cancel things
2f47150ab3ef mwifiex: pcie: disable device DMA before unmapping/freeing buffers
43a0c9aea64d mwifiex: pcie: remove unnecessary 'pdev' check
2d98cfd17e92 mwifiex: keep mwifiex_cancel_pending_ioctl() static
0bc03cfd8247 mwifiex: drop num CPU notice

-- 
https://patchwork.kernel.org/patch/9860943/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
