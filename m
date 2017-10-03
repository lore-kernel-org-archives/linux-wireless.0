Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:47884 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750787AbdJCSuy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Oct 2017 14:50:54 -0400
Received: from [192.168.100.149] (firewall.candelatech.com [50.251.239.81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail2.candelatech.com (Postfix) with ESMTPSA id D20E440A5A2
        for <linux-wireless@vger.kernel.org>; Tue,  3 Oct 2017 11:50:53 -0700 (PDT)
Subject: Re: lockdep splat on 4.13.3 (plus hacks)
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <c54e3dd0-8e6e-41f2-cd0f-960cb623e8fa@candelatech.com>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <11522bd5-854c-b5c7-dcb3-858a488ca626@candelatech.com> (sfid-20171003_205057_710082_3D2EBF51)
Date: Tue, 3 Oct 2017 11:50:53 -0700
MIME-Version: 1.0
In-Reply-To: <c54e3dd0-8e6e-41f2-cd0f-960cb623e8fa@candelatech.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/03/2017 11:17 AM, Ben Greear wrote:
> We are seeing deadlocks related to wifi in our 4.13.3+ kernels,
> so I enabled lockdep and immediately saw this.  Anyone know if this
> is a known issue?  Otherwise, I guess it could be related to some local
> patch I have added...

I think I found the fix in the stable queue, so I guess it will be in
4.13.5 when that is out...

Will continue testing...

Thanks,
Ben

>
>
> [  476.172823] ============================================
> [  476.176863] WARNING: possible recursive locking detected
> [  476.180895] 4.13.3+ #1 Not tainted
> [  476.183025] --------------------------------------------
> [  476.187053] kworker/u8:2/281 is trying to acquire lock:
> [  476.190993]  (&sta->ampdu_mlme.mtx){+.+...}, at: [<ffffffffa09cd4e8>] __ieee80211_start_rx_ba_session+0x178/0x670 [mac80211]
> [  476.201004]
>                but task is already holding lock:
> [  476.204270]  (&sta->ampdu_mlme.mtx){+.+...}, at: [<ffffffffa09c93a6>] ieee80211_ba_session_work+0x46/0x2b0 [mac80211]
> [  476.213645]
>                other info that might help us debug this:
> [  476.217587]  Possible unsafe locking scenario:
>
> [  476.220930]        CPU0
> [  476.222082]        ----
> [  476.223236]   lock(&sta->ampdu_mlme.mtx);
> [  476.225957]   lock(&sta->ampdu_mlme.mtx);
> [  476.228673]
>                 *** DEADLOCK ***
>
> [  476.230689]  May be due to missing lock nesting notation
>
> [  476.234879] 3 locks held by kworker/u8:2/281:
> [  476.237941]  #0:  ("%s"wiphy_name(local->hw.wiphy)){++++.+}, at: [<ffffffff8113df8f>] process_one_work+0x14f/0x6a0
> [  476.247033]  #1:  ((&sta->ampdu_mlme.work)){+.+...}, at: [<ffffffff8113df8f>] process_one_work+0x14f/0x6a0
> [  476.255393]  #2:  (&sta->ampdu_mlme.mtx){+.+...}, at: [<ffffffffa09c93a6>] ieee80211_ba_session_work+0x46/0x2b0 [mac80211]
> [  476.265170]
>                stack backtrace:
> [  476.266928] CPU: 0 PID: 281 Comm: kworker/u8:2 Not tainted 4.13.3+ #1
> [  476.272073] Hardware name: _ _/ , BIOS 5.11 08/26/2016
> [  476.275927] Workqueue: phy1 ieee80211_ba_session_work [mac80211]
> [  476.280640] Call Trace:
> [  476.281792]  dump_stack+0x85/0xc7
> [  476.283811]  __lock_acquire+0x14ba/0x1520
> [  476.286526]  ? __save_stack_trace+0x6e/0xd0
> [  476.289412]  ? ret_from_fork+0x2a/0x40
> [  476.291867]  lock_acquire+0xac/0x200
> [  476.294145]  ? lock_acquire+0xac/0x200
> [  476.296610]  ? __ieee80211_start_rx_ba_session+0x178/0x670 [mac80211]
> [  476.301766]  ? __ieee80211_start_rx_ba_session+0x178/0x670 [mac80211]
> [  476.306910]  __mutex_lock+0x69/0x930
> [  476.309194]  ? __ieee80211_start_rx_ba_session+0x178/0x670 [mac80211]
> [  476.314343]  ? rcu_read_lock_sched_held+0x6d/0x80
> [  476.317766]  ? __sdata_dbg+0x14a/0x1a0 [mac80211]
> [  476.321181]  mutex_lock_nested+0x16/0x20
> [  476.323810]  ? mutex_lock_nested+0x16/0x20
> [  476.326626]  __ieee80211_start_rx_ba_session+0x178/0x670 [mac80211]
> [  476.331627]  ieee80211_ba_session_work+0x157/0x2b0 [mac80211]
> [  476.336078]  ? process_one_work+0x14f/0x6a0
> [  476.338985]  process_one_work+0x1ce/0x6a0
> [  476.341696]  worker_thread+0x46/0x400
> [  476.344061]  kthread+0x10f/0x150
> [  476.346001]  ? process_one_work+0x6a0/0x6a0
> [  476.348886]  ? kthread_create_on_node+0x40/0x40
> [  476.352122]  ret_from_fork+0x2a/0x40
>
> Thanks,
> Ben
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
