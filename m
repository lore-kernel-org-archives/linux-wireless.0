Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:46476 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757843Ab2IMMRQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Sep 2012 08:17:16 -0400
Message-ID: <5051CEC3.8090806@openwrt.org> (sfid-20120913_141720_111146_D65FD9A9)
Date: Thu, 13 Sep 2012 14:17:07 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [RFT] cfg80211: fix possible circular lock on reg_regdb_search()
References: <1347408735-25745-1-git-send-email-mcgrof@do-not-panic.com>
In-Reply-To: <1347408735-25745-1-git-send-email-mcgrof@do-not-panic.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-09-12 2:12 AM, Luis R. Rodriguez wrote:
> From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
> 
> When call_crda() is called we kick off a witch hunt search
> for the same regulatory domain on our internal regulatory
> database and that work gets scheuled on a workqueue, this
> is done while the cfg80211_mutex is held. If that workqueue
> kicks off it will first lock reg_regdb_search_mutex and
> later cfg80211_mutex but to ensure two CPUs will not contend
> against cfg80211_mutex the right thing to do is to have the
> reg_regdb_search() wait until the cfg80211_mutex is let go.
> 
> The lockdep report is pasted below.
> 
> cfg80211: Calling CRDA to update world regulatory domain
> 
> ======================================================
> [ INFO: possible circular locking dependency detected ]
> 3.3.8 #3 Tainted: G           O
> -------------------------------------------------------
> kworker/0:1/235 is trying to acquire lock:
>  (cfg80211_mutex){+.+...}, at: [<816468a4>] set_regdom+0x78c/0x808 [cfg80211]
> 
> but task is already holding lock:
>  (reg_regdb_search_mutex){+.+...}, at: [<81646828>] set_regdom+0x710/0x808 [cfg80211]
> 
> which lock already depends on the new lock.
> 
> the existing dependency chain (in reverse order) is:
> 
> -> #2 (reg_regdb_search_mutex){+.+...}:
>        [<800a8384>] lock_acquire+0x60/0x88
>        [<802950a8>] mutex_lock_nested+0x54/0x31c
>        [<81645778>] is_world_regdom+0x9f8/0xc74 [cfg80211]
> 
> -> #1 (reg_mutex#2){+.+...}:
>        [<800a8384>] lock_acquire+0x60/0x88
>        [<802950a8>] mutex_lock_nested+0x54/0x31c
>        [<8164539c>] is_world_regdom+0x61c/0xc74 [cfg80211]
> 
> -> #0 (cfg80211_mutex){+.+...}:
>        [<800a77b8>] __lock_acquire+0x10d4/0x17bc
>        [<800a8384>] lock_acquire+0x60/0x88
>        [<802950a8>] mutex_lock_nested+0x54/0x31c
>        [<816468a4>] set_regdom+0x78c/0x808 [cfg80211]
> 
> other info that might help us debug this:
> 
> Chain exists of:
>   cfg80211_mutex --> reg_mutex#2 --> reg_regdb_search_mutex
> 
>  Possible unsafe locking scenario:
> 
>        CPU0                    CPU1
>        ----                    ----
>   lock(reg_regdb_search_mutex);
>                                lock(reg_mutex#2);
>                                lock(reg_regdb_search_mutex);
>   lock(cfg80211_mutex);
> 
>  *** DEADLOCK ***
> 
> 3 locks held by kworker/0:1/235:
>  #0:  (events){.+.+..}, at: [<80089a00>] process_one_work+0x230/0x460
>  #1:  (reg_regdb_work){+.+...}, at: [<80089a00>] process_one_work+0x230/0x460
>  #2:  (reg_regdb_search_mutex){+.+...}, at: [<81646828>] set_regdom+0x710/0x808 [cfg80211]
> 
> stack backtrace:
> Call Trace:
> [<80290fd4>] dump_stack+0x8/0x34
> [<80291bc4>] print_circular_bug+0x2ac/0x2d8
> [<800a77b8>] __lock_acquire+0x10d4/0x17bc
> [<800a8384>] lock_acquire+0x60/0x88
> [<802950a8>] mutex_lock_nested+0x54/0x31c
> [<816468a4>] set_regdom+0x78c/0x808 [cfg80211]
> 
> Reported-by: Felix Fietkau <nbd@openwrt.org>
> Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
With this patch I get a slightly different report:

[    9.480000] cfg80211: Calling CRDA to update world regulatory domain
[    9.490000] 
[    9.490000] ======================================================
[    9.490000] [ INFO: possible circular locking dependency detected ]
[    9.490000] 3.3.8 #4 Tainted: G           O
[    9.490000] -------------------------------------------------------
[    9.490000] kworker/0:1/235 is trying to acquire lock:
[    9.490000]  (reg_mutex#2){+.+...}, at: [<8164617c>] set_regdom+0x64/0x80c [cfg80211]
[    9.490000] 
[    9.490000] but task is already holding lock:
[    9.490000]  (reg_regdb_search_mutex){+.+...}, at: [<81646830>] set_regdom+0x718/0x80c [cfg80211]
[    9.490000] 
[    9.490000] which lock already depends on the new lock.
[    9.490000] 
[    9.490000] 
[    9.490000] the existing dependency chain (in reverse order) is:
[    9.490000] 
[    9.490000] -> #1 (reg_regdb_search_mutex){+.+...}:
[    9.490000]        [<800a8384>] lock_acquire+0x60/0x88
[    9.490000]        [<802950a8>] mutex_lock_nested+0x54/0x31c
[    9.490000]        [<81645778>] is_world_regdom+0x9f8/0xc74 [cfg80211]
[    9.490000] 
[    9.490000] -> #0 (reg_mutex#2){+.+...}:
[    9.490000]        [<800a77b8>] __lock_acquire+0x10d4/0x17bc
[    9.490000]        [<800a8384>] lock_acquire+0x60/0x88
[    9.490000]        [<802950a8>] mutex_lock_nested+0x54/0x31c
[    9.490000]        [<8164617c>] set_regdom+0x64/0x80c [cfg80211]
[    9.490000]        [<816468ac>] set_regdom+0x794/0x80c [cfg80211]
[    9.490000] 
[    9.490000] other info that might help us debug this:
[    9.490000] 
[    9.490000]  Possible unsafe locking scenario:
[    9.490000] 
[    9.490000]        CPU0                    CPU1
[    9.490000]        ----                    ----
[    9.490000]   lock(reg_regdb_search_mutex);
[    9.490000]                                lock(reg_mutex#2);
[    9.490000]                                lock(reg_regdb_search_mutex);
[    9.490000]   lock(reg_mutex#2);
[    9.490000] 
[    9.490000]  *** DEADLOCK ***
[    9.490000] 
[    9.490000] 4 locks held by kworker/0:1/235:
[    9.490000]  #0:  (events){.+.+..}, at: [<80089a00>] process_one_work+0x230/0x460
[    9.490000]  #1:  (reg_regdb_work){+.+...}, at: [<80089a00>] process_one_work+0x230/0x460
[    9.490000]  #2:  (cfg80211_mutex){+.+...}, at: [<81646824>] set_regdom+0x70c/0x80c [cfg80211]
[    9.490000]  #3:  (reg_regdb_search_mutex){+.+...}, at: [<81646830>] set_regdom+0x718/0x80c [cfg80211]
[    9.490000] 
[    9.490000] stack backtrace:
[    9.490000] Call Trace:
[    9.490000] [<80290fd4>] dump_stack+0x8/0x34
[    9.490000] [<80291bc4>] print_circular_bug+0x2ac/0x2d8
[    9.490000] [<800a77b8>] __lock_acquire+0x10d4/0x17bc
[    9.490000] [<800a8384>] lock_acquire+0x60/0x88
[    9.490000] [<802950a8>] mutex_lock_nested+0x54/0x31c
[    9.490000] [<8164617c>] set_regdom+0x64/0x80c [cfg80211]
[    9.490000] [<816468ac>] set_regdom+0x794/0x80c [cfg80211]
[    9.490000] 


