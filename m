Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:46908 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755167AbdESGCv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 May 2017 02:02:51 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [01/11] mwifiex: fixup error cases in mwifiex_add_virtual_intf()
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170512164208.38725-1-briannorris@chromium.org>
References: <20170512164208.38725-1-briannorris@chromium.org>
To: Brian Norris <briannorris@chromium.org>
Cc: Ganapathi Bhat <gbhat@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        <linux-kernel@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        linux-wireless@vger.kernel.org,
        Doug Anderson <dianders@chromium.org>,
        Brian Norris <briannorris@chromium.org>
Message-Id: <20170519060250.3457960585@smtp.codeaurora.org> (sfid-20170519_080307_427778_63B29EAB)
Date: Fri, 19 May 2017 06:02:50 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Brian Norris <briannorris@chromium.org> wrote:
> If we fail to add an interface in mwifiex_add_virtual_intf(), we might
> hit a BUG_ON() in the networking code, because we didn't tear things
> down properly. Among the problems:
> 
>  (a) when failing to allocate workqueues, we fail to unregister the
>      netdev before calling free_netdev()
>  (b) even if we do try to unregister the netdev, we're still holding the
>      rtnl lock, so the device never properly unregistered; we'll be at
>      state NETREG_UNREGISTERING, and then hit free_netdev()'s:
> 	BUG_ON(dev->reg_state != NETREG_UNREGISTERED);
>  (c) we're allocating some dependent resources (e.g., DFS workqueues)
>      after we've registered the interface; this may or may not cause
>      problems, but it's good practice to allocate these before registering
>  (d) we're not even trying to unwind anything when mwifiex_send_cmd() or
>      mwifiex_sta_init_cmd() fail
> 
> To fix these issues, let's:
> 
>  * add a stacked set of error handling labels, to keep error handling
>    consistent and properly ordered (resolving (a) and (d))
>  * move the workqueue allocations before the registration (to resolve
>    (c); also resolves (b) by avoiding error cases where we have to
>    unregister)
> 
> [Incidentally, it's pretty easy to interrupt the alloc_workqueue() in,
> e.g., the following:
> 
>   iw phy phy0 interface add mlan0 type station
> 
> by sending it SIGTERM.]
> 
> This bugfix covers commits like commit 7d652034d1a0 ("mwifiex: channel
> switch support for mwifiex"), but parts of this bug exist all the way
> back to the introduction of dynamic interface handling in commit
> 93a1df48d224 ("mwifiex: add cfg80211 handlers add/del_virtual_intf").
> 
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Brian Norris <briannorris@chromium.org>

11 patches applied to wireless-drivers-next.git, thanks.

8535107aa4ef mwifiex: fixup error cases in mwifiex_add_virtual_intf()
e0b636e5ee15 mwifiex: Don't release tx_ba_stream_tbl_lock while iterating
90ad0be83676 mwifiex: Don't release cmd_pending_q_lock while iterating
09bdb6500551 mwifiex: Add locking to mwifiex_11n_delba
0f13acf0c612 mwifiex: don't drop lock between list-retrieval / list-deletion
6eb2d002d4ea mwifiex: don't leak stashed beacon buffer on reset
bc69ca391eff mwifiex: remove useless 'mwifiex_lock'
7170862738dc mwifiex: remove redundant 'adapter' check in mwifiex_adapter_cleanup
7ade530e7384 mwifiex: 11h: drop unnecessary check for '!priv'
fa4651e12ae8 mwifiex: pcie: remove useless pdev check
68efd0386988 mwifiex: pcie: stop setting/clearing 'surprise_removed'

-- 
https://patchwork.kernel.org/patch/9724599/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
