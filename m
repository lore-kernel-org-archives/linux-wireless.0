Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:38235 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932562Ab1EQXFu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 May 2011 19:05:50 -0400
Received: by vws1 with SMTP id 1so721868vws.19
        for <linux-wireless@vger.kernel.org>; Tue, 17 May 2011 16:05:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1305364803.3437.10.camel@jlt3.sipsolutions.net>
References: <1305363652.3437.8.camel@jlt3.sipsolutions.net> <1305364803.3437.10.camel@jlt3.sipsolutions.net>
From: Javier Cardona <javier@cozybit.com>
Date: Tue, 17 May 2011 16:05:29 -0700
Message-ID: <BANLkTikyymbnXHANmB3N0ecJWdkY9xCG=Q@mail.gmail.com> (sfid-20110518_010553_355694_92498F87)
Subject: Re: [PATCH] mac80211: fix and simplify mesh locking
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, May 14, 2011 at 2:20 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Sat, 2011-05-14 at 11:00 +0200, Johannes Berg wrote:
>> From: Johannes Berg <johannes.berg@intel.com>
>>
>> The locking in mesh_{mpath,mpp}_table_grow not only
>> has an rcu_read_unlock() missing, it's also racy
>> (though really only technically since it's invoked
>> from a single function only) since it obtains the
>> new size of the table without any locking, so two
>> invocations of the function could attempt the same
>> resize.
>
> Actually, it _can_ happen, if you have multiple mesh interfaces.

I'm seeing this after trying your patch, probably because the
allocations mesh_table_alloc() can block.  In the past I had tried to
allocate the table before entering the critical section.  If that is
not possible for the race condition you mention,  then I guess we'll
have to make those allocations GFP_ATOMIC?

  363.767523] BUG: scheduling while atomic: kworker/u:2/621/0x10000200
[  363.768239] 3 locks held by kworker/u:2/621:
[  363.768516]  #0:  (name){.+.+.+}, at: [<c10429e7>]
process_one_work+0x17c/0x31d
[  363.769605]  #1:  ((&sdata->work)){+.+.+.}, at: [<c10429e7>]
process_one_work+0x17c/0x31d
[  363.770149]  #2:  (pathtbl_resize_lock){++.-+.}, at: [<c8fb01ce>]
mesh_mpath_table_grow+0xf/0x5c [mac80211]
[  363.771122] Modules linked in: mac80211_hwsim mac80211
[  363.771824] Pid: 621, comm: kworker/u:2 Not tainted 2.6.39-rc7-wl+ #399
[  363.772304] Call Trace:
[  363.772611]  [<c8faf69f>] ? mesh_table_alloc+0x25/0xc2 [mac80211]
[  363.772969]  [<c102c049>] __schedule_bug+0x5e/0x65
[  363.773350]  [<c14672af>] schedule+0x68/0x699
[  363.773608]  [<c1058328>] ? __lock_acquire+0xab3/0xb59
[  363.773900]  [<c105694e>] ? valid_state+0x1a/0x13d
[  363.774244]  [<c1056c10>] ? mark_lock+0x19f/0x1d9
[  363.774527]  [<c105720b>] ? check_usage_forwards+0x68/0x68
[  363.774873]  [<c1056c8d>] ? mark_held_locks+0x43/0x5b
[  363.775303]  [<c8faf69f>] ? mesh_table_alloc+0x25/0xc2 [mac80211]
[  363.775654]  [<c102e544>] __cond_resched+0x16/0x26
[  363.775918]  [<c1467a92>] _cond_resched+0x1d/0x28


Javier


-- 
Javier Cardona
cozybit Inc.
http://www.cozybit.com
