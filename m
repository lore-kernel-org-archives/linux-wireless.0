Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 958F749552B
	for <linux-wireless@vger.kernel.org>; Tue,  8 Sep 2026 22:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788906782; cv=none; b=grBi8OOiZP8qX0gQRd11n6PYhyI1MplTjP70YRDXRRwIDWPOAqBK39dhzvS6uP+QmPoVP2/g8HQtZ5BfQ/SqYD1Xo7hHGRPdF5czOyPZoJHXVehxlde7K3kAqk411ViByVBrHiaLEuy06PAjpfc4jF5XQBFn1esevlKngkRAHwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788906782; c=relaxed/simple;
	bh=mWTs1SecpwUi27e9yaWNJQxycizuF+70qfUmObeqQfI=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=j/F6Ipe4BJVBNlEmic9lTFpjDY7hPmAMy3lt/qBzOHcUZeNx5HyzR59SCnPBNX8Ly9yGE5I40brefVVJelGx+yB1DoZpl1uspNO8mvGNZG0rDTQrSaIRkHrMoFfdJJP5EPNvYdJpKWb63UMpXsfDFiXo4B2m01MjDEA7VpVPeYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SJrja4W3; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SJrja4W3"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-49b392ccaacso76248225e9.2
        for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2026 15:32:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788906774; x=1789511574; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=wZg+7/lZcuyEg8vObjRzCEloN0rwQV38AadPdIfb4Bc=;
        b=SJrja4W3TAfXJ2/72VhiF1CSMr4Q/7Ad0jioEmwz0BMcgzH6kSYk+lbI/1B3q235U/
         Xmy2qRvQ8+S4GAuxmxNOHCOGbXOLGBpMws93hqRHHrdEEdWPm66jqJucEH0uiYI7eVgx
         /dfqgfILHjyOQ7kqt0uckxGX/axRivPuKJLeDgV2FzbNussbRGkp97I2yyWb+cwujvV0
         3omaHhR4YghMDEjkcjQMR1zBwvEMdlzjz8Z5tBvRlA7AwdRRGHiwfxcgvmnENlfWb+LP
         22RTwQ4x9hNIPg3z5jY7LOrqeKVkDsOr1LJ3Uc1jpt87LTefzGuU4q+pBZWJ8PDRL+d5
         24qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788906774; x=1789511574;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wZg+7/lZcuyEg8vObjRzCEloN0rwQV38AadPdIfb4Bc=;
        b=GuuXsrNyIpADoqTbBO1Z2iJA9tutesFiI+lWQLKYN6E1/N7Qzq3ArGlXY8brcGUr1X
         3MYX4XBvDuoPNYEDjHRMfVtq+8MyuDMj6UxN3P3v/t/6nspF/j8fIJPYqS6Ywt4+Y5TF
         AUPXNsFd7uJnawYNd58Icy3uX/6yfUJarm5U5XRWO5fhNNfXnT1Amhmnckb5JeYOCNF5
         jao4xSZ2rKhl7OQNTlhVQVtfrZbRzE8QaxXpbl9UEFI769mTTRjz1crUnJNHTYtHPnoQ
         I52/7Jz9gpT77S3W0eiDAYzKgN+sfq+Q75yBhyJcKw7fCtKYGa4MYmYBnPgIZJvB1aZw
         XAuA==
X-Forwarded-Encrypted: i=1; AKwUvBzOQyfD4Msm9Z+TwwKtiJ9e2NIwTULypqATWh31nMtsk2GYqG6e955TPMG53jSiI5lfXsh6cySiHZwQIC7DzA==@vger.kernel.org
X-Gm-Message-State: AFuF++m8nawTbn0kNllmmXCLiHfo5A98DlkUM+fm6To9VCjx++6KdI7E
	63NtH7Pd/8RYz1APBWMMFyrQgxWrK2t3L9/HXpCP+Vsw5IPE28wAOLnGmhrS7Fah5Ho=
X-Gm-Gg: AYBFou3jLuRABSgKmJ9cNJT/XXQ2SdPuU/MyDdSxGTXpg2UJ9Umix74UsTCoDy3A1VF
	fhCD2uOHbowE6KSmnOV8zOybI31NSaiyVeETb+TOoKWG3R7DD0DZE39/Gj/cUSOLW2y2UfRDbmf
	ZdxsQTIp0sTTvL2ECtKHnCzUg4TKXboX7lb+nGxRUWxxRqO4PEWbJ773EqPEmZ7NJq5x8mQ9SV9
	SudGzLOf1P6b20bsiBsCa1l/YA/RjYnBZYSFoW5c7mo9OymwY3N04kCmLycjPD3UD+2UytdKM8u
	d/AZLcj97S1OF0JS7MKWDbM8DMneb65iu+H+TItDfgFAbciAdfk6sQX2HoMrDxz9Qj3LjbDzs/9
	cPlJs+4GOzpKQJGjfKlejAyRcRhE9Lu1BypCpA8/rr4RqFCVtWpntecJcC5j2S2xi1FccJlmI5p
	G+imVcDL+VSqT0zIHPfbRRfWDlhwUjGL/IXO4gnH1yaHGlOdFY7CRqu5C/GzWTEsfB/WRn3Q==
X-Received: by 2002:a05:600c:8012:b0:49c:d818:8764 with SMTP id 5b1f17b1804b1-49cf826818dmr328869515e9.11.1788906773820;
        Tue, 08 Sep 2026 15:32:53 -0700 (PDT)
Received: from [192.168.18.21] ([46.197.185.71])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49d00a5b19dsm362727575e9.2.2026.09.08.15.32.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Sep 2026 15:32:53 -0700 (PDT)
Message-ID: <35a68705-0bcf-4b65-9c0b-050c0344f985@gmail.com>
Date: Wed, 9 Sep 2026 01:32:52 +0300
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] wifi: cfg80211: avoid holding rtnl_mutex across all
 cfg80211_leave() calls
To: Ben Greear <greearb@candelatech.com>, linux-wireless@vger.kernel.org
References: <20260903151542.486376-2-omermetekaya0@gmail.com>
 <20260906002657.620076-1-omermetekaya0@gmail.com>
 <20260906002657.620076-2-omermetekaya0@gmail.com>
 <81a437a9-4ffd-4d6d-84c9-c093af5c46a5@candelatech.com>
 <b65da403-8144-4524-a076-5d25c86c0c14@gmail.com>
 <dce34788-a6fb-b2e0-4657-aab3843111b6@candelatech.com>
 <faf385e5-5fe7-4b66-bd06-e5f9a88d12ba@gmail.com>
 <bbb382ee-9ada-f060-9128-c2cb6e5f524c@candelatech.com>
Content-Language: en-US
From: =?UTF-8?Q?=C3=96mer_Mete_Kaya?= <omermetekaya0@gmail.com>
In-Reply-To: <bbb382ee-9ada-f060-9128-c2cb6e5f524c@candelatech.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 9/8/26 23:09, Ben Greear wrote:
> On 9/8/26 12:52, Ömer Mete Kaya wrote:
>>
>>
>> On 9/8/26 19:50, Ben Greear wrote:
>>> On 9/8/26 01:58, Ömer Mete Kaya wrote:
>>>>
>>>>
>>>> On 9/7/26 19:38, Ben Greear wrote:
>>>>> On 9/5/26 5:25 PM, Ömer Mete Kaya wrote:
>>>>>> reg_check_chans_work() holds rtnl_mutex for the entire duration of
>>>>>> iterating over all registered devices and calling cfg80211_leave() on
>>>>>> each invalid wdev. cfg80211_leave() can be slow (disconnect, stop AP,
>>>>>> leave mesh), causing rtnl_mutex starvation when many wireless
>>>>>> interfaces
>>>>>> are present. This results in tasks waiting for rtnl_mutex for longer
>>>>>> than hung_task_timeout_secs:
>>>>>>
>>>>>>      INFO: task hung in inet_rtm_newaddr
>>>>>>      INFO: task hung in inet6_rtm_newaddr
>>>>>>      INFO: task hung in nsim_destroy
>>>>>>      INFO: task hung in tun_chr_close
>>>>>>      INFO: task hung in switchdev_deferred_process_work
>>>>>
>>>>> Hello Omer,
>>>>>
>>>>> Considering that maybe something has mis-diagnosed the problem, could
>>>>> you share details of the stack traces of
>>>>> the hung processes and lockdep output to see if the hang is actually
>>>>> elsewhere?  What kernel version are you
>>>>> testing?
>>>>>
>>>>> Thanks,
>>>>> Ben
>>>>>
>>>>
>>>>
>>>> Hi Ben,
>>>>
>>>> Here is the evidence with stack traces and lockdep output. My kernel
>>>> version is 7.2.0-02677-g544d85de4dc2 (net/main HEAD) and both unpatched
>>>> and patched kernels were tested on the same setup(52 mac80211_hwsim
>>>> radios (mac80211_hwsim.radios=51)).
>>>>
>>>> Unpatched kernel:
>>>>
>>>> The lockdep output shows reg_check_chans_work as the rtnl_mutex holder
>>>> and ip as the waiter:
>>>>
>>>> locks held by kworker/0:2/11408: 3, on CPU#0:
>>>> #1: (reg_check_chans).work
>>>> #2: ffffffff91118180 (rtnl_mutex){+.+.}-{4:4},
>>>> at: reg_check_chans_work+0xad/0x1330
>>>>
>>>> locks held by ip/14180: 1, on CPU#0:
>>>> #0: ffffffff91118180 (rtnl_mutex){+.+.}-{4:4},
>>>> at: rtnl_getlink+0xbfb/0x13b0
>>>>
>>>> Hung task call trace:
>>>>
>>>> INFO: task ip:14180 blocked for more than 5 seconds.
>>>> Call Trace:
>>>> __schedule+0x1cba/0x6a40
>>>> schedule+0xe2/0x2e0
>>>> schedule_preempt_disabled+0x13/0x30
>>>> __mutex_lock+0x871/0x1cc0
>>>> rtnl_getlink+0xbfb/0x13b0
>>>> rtnetlink_rcv_msg+0x9a1/0xee0
>>>> netlink_rcv_skb+0x186/0x450
>>>> netlink_sendmsg+0x8e5/0xde0
>>>>
>>>> Kernel panic, not syncing: hung_task: blocked tasks
>>>>
>>>> I injected msleep(200) per wdev in reg_leave_invalid_chans() to model a
>>>> slow cfg80211_leave() operation, to measure the hold duration. With 52
>>>> interfaces this produced approximately 10.5 seconds of
>>>> continuous rtnl_mutex hold:
>>>>
>>>> cfg80211: reg_check_chans_work: rtnl held for 10499 ms
>>>>
>>>> The structural problem is clear regardless of the exact duration:
>>>> rtnl_mutex is held across all per-interface cleanup for every
>>>> registered device in a single acquisition.
>>>>
>>>> Patched kernel:
>>>>
>>>> rtnl_mutex is acquired per-device, each hold is brief:
>>>>
>>>> cfg80211: reg_check_chans_work: device 0 rtnl held 0 ms
>>>> cfg80211: reg_check_chans_work: device 1 rtnl held 0 ms
>>>> ...
>>>> cfg80211: reg_check_chans_work: device 51 rtnl held 0 ms
>>>>
>>>> No hung tasks were observed.
>>>
>>> At least my kernel tends to only warn about hung tasks that are blocked
>>> for minutes.  Did you adjust your kernel to make this timeout smaller?
>>
>> Yes, I reduced hung_task_timeout_secs to 5 seconds for the test.
>> With the default 140-second timeout my reproduction would not have
>> triggered a hang, though syzbot does with that timeout. Actually, I've
>> started to have doubts about the extent of its real-world impact, it
>> depends heavily on callback latency and number of active interfaces.
>>
>>> Do you actually have 52 real devices that cause this problem?  If so,
>>> what
>>> hardware is this?  Or you can only reproduce this with modified
>>> kernel that
>>> injects a 200ms sleep?
>>
>> I used mac80211_hwsim virtual radios,
>> and the hang could only be reproduced with artificial delays.
>> The 200ms value was chosen as a rough estimate of a slow
>> driver callback, not based on measured real hardware latency.
> 
> So you created a fake problem to make it fit what something
> thinks is the root cause.  I don't think that is helpful.

Agreed, but I already pointed out "my analysis was primarily code-based".

> Possibly root cause below is that something else holds wiphy.mtx, so
> reg_check_chans_work is blocked
> and cannot make progress. 

Actually a possibility, I wont be oppose since I cannot prove what
absolutely causes that 143 second timeout.

 Do you have full dmesg dump that includes all
> blocked processes
> and full lockdep dump?  Are you actually able to reproduce the problem
> w/out adding fake sleeps?

I cant produce from my own machine without fake sleeps because I lack
the actual hardware or a fuzzing ability as syzbot, its impossible with
a laptop and virtual radios. But according to syzbot's full crash report:

 INFO: task syz-executor:5585 blocked for more than 143 seconds.
      Not tainted syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor    state:D stack:25304 pid:5585  tgid:5585  ppid:1
 task_flags:0x400140 flags:0x00080002
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5510 [inline]
 __schedule+0x17d9/0x56c0 kernel/sched/core.c:7234
 __schedule_loop kernel/sched/core.c:7311 [inline]
 schedule+0x164/0x2b0 kernel/sched/core.c:7326
 schedule_preempt_disabled+0x13/0x30 kernel/sched/core.c:7383
 __mutex_lock_common kernel/locking/mutex.c:726 [inline]
 __mutex_lock+0x7bf/0x1550 kernel/locking/mutex.c:821
 rtnl_net_lock include/linux/rtnetlink.h:130 [inline]
 inet_rtm_newaddr+0x464/0x19e0 net/ipv4/devinet.c:978
 rtnetlink_rcv_msg+0x802/0xc00 net/core/rtnetlink.c:7076
 netlink_rcv_skb+0x226/0x4a0 net/netlink/af_netlink.c:2556
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x7bb/0x940 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1900
 sock_sendmsg_nosec+0x13a/0x180 net/socket.c:775
 __sock_sendmsg net/socket.c:790 [inline]
 __sys_sendto+0x408/0x5a0 net/socket.c:2252
 __do_sys_sendto net/socket.c:2259 [inline]
 __se_sys_sendto net/socket.c:2255 [inline]
 __x64_sys_sendto+0xde/0x100 net/socket.c:2255
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f0ee475d68e
RSP: 002b:00007ffe75fcc6c8 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 000055559003e500 RCX: 00007f0ee475d68e
RDX: 0000000000000028 RSI: 00007f0ee5544670 RDI: 0000000000000003
RBP: 0000000000000001 R08: 00007ffe75fcc744 R09: 000000000000000c
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000003
R13: 0000000000000000 R14: 00007f0ee5544670 R15: 0000000000000000
 </TASK>
Showing all locks held in the system:
4 locks held by kworker/0:1/10:
 #0: ffff88801aca5540
((wq_completion)events_power_efficient){+.+.}-{0:0}, at:
process_one_work kernel/workqueue.c:3297 [inline]
 #0: ffff88801aca5540
((wq_completion)events_power_efficient){+.+.}-{0:0}, at:
process_scheduled_works+0xa20/0x14e0 kernel/workqueue.c:3405
 #1: ffffc9000023fc40 ((reg_check_chans).work){+.+.}-{0:0}, at:
process_one_work kernel/workqueue.c:3297 [inline]
 #1: ffffc9000023fc40 ((reg_check_chans).work){+.+.}-{0:0}, at:
process_scheduled_works+0xa20/0x14e0 kernel/workqueue.c:3405
 #2: ffffffff8fded300 (rtnl_mutex){+.+.}-{4:4}, at:
reg_check_chans_work+0xac/0x1110 net/wireless/reg.c:2469
 #3: ffff8880129707a0 (&rdev->wiphy.mtx){+.+.}-{4:4}, at:
class_wiphy_constructor include/net/cfg80211.h:6884 [inline]
 #3: ffff8880129707a0 (&rdev->wiphy.mtx){+.+.}-{4:4}, at:
reg_leave_invalid_chans net/wireless/reg.c:2457 [inline]
 #3: ffff8880129707a0 (&rdev->wiphy.mtx){+.+.}-{4:4}, at:
reg_check_chans_work+0x1a1/0x1110 net/wireless/reg.c:2472
1 lock held by khungtaskd/25:
 #0: ffffffff8e959c20 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire
include/linux/rcupdate.h:300 [inline]
 #0: ffffffff8e959c20 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock
include/linux/rcupdate.h:840 [inline]
 #0: ffffffff8e959c20 (rcu_read_lock){....}-{1:3}, at:
debug_show_all_locks+0x2e/0x180 kernel/locking/lockdep.c:6775
2 locks held by kworker/u4:6/160:
1 lock held by klogd/4693:
1 lock held by dhcpcd/5000:
 #0: ffffffff8fded300 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_net_lock
include/linux/rtnetlink.h:130 [inline]
 #0: ffffffff8fded300 (rtnl_mutex){+.+.}-{4:4}, at:
inet6_rtm_newaddr+0x65e/0xdf0 net/ipv6/addrconf.c:5062
2 locks held by getty/5093:
 #0: ffff88803fac20a0 (&tty->ldisc_sem){++++}-{0:0}, at:
tty_ldisc_ref_wait+0x25/0x70 drivers/tty/tty_ldisc.c:243
 #1: ffffc90000ad82e8 (&ldata->atomic_read_lock){+.+.}-{4:4}, at:
n_tty_read+0x45a/0x1360 drivers/tty/n_tty.c:2211
3 locks held by kworker/u4:0/5354:
6 locks held by kworker/u4:1/5428:
 #0: ffff88801beb4940 ((wq_completion)netns){+.+.}-{0:0}, at:
process_one_work kernel/workqueue.c:3297 [inline]
 #0: ffff88801beb4940 ((wq_completion)netns){+.+.}-{0:0}, at:
process_scheduled_works+0xa20/0x14e0 kernel/workqueue.c:3405
 #1: ffffc90002467c40 (net_cleanup_work){+.+.}-{0:0}, at:
process_one_work kernel/workqueue.c:3297 [inline]
 #1: ffffc90002467c40 (net_cleanup_work){+.+.}-{0:0}, at:
process_scheduled_works+0xa20/0x14e0 kernel/workqueue.c:3405
 #2: ffffffff8fdde748 (pernet_ops_rwsem){++++}-{4:4}, at:
cleanup_net+0xf5/0x810 net/core/net_namespace.c:673
 #3: ffff8880122f4128 (&dev->mutex){....}-{4:4}, at: device_lock
include/linux/device.h:1102 [inline]
 #3: ffff8880122f4128 (&dev->mutex){....}-{4:4}, at: devl_dev_lock
net/devlink/devl_internal.h:124 [inline]
 #3: ffff8880122f4128 (&dev->mutex){....}-{4:4}, at:
devlink_pernet_pre_exit+0x129/0x420 net/devlink/core.c:557

Especially this:
#2: ffffffff8fded300 (rtnl_mutex){+.+.}-{4:4}, at:
reg_check_chans_work+0xac/0x1110 net/wireless/reg.c:2469
#3: ffff8880129707a0 (&rdev->wiphy.mtx){+.+.}-{4:4}, at:
reg_leave_invalid_chans net/wireless/reg.c:2457 [inline]
#3: ffff8880129707a0 (&rdev->wiphy.mtx){+.+.}-{4:4}, at:
reg_check_chans_work+0x1a1/0x1110 net/wireless/reg.c:2472

> 
>> actual syzbot crash report :
>>
>>    locks held by kworker running reg_check_chans_work:
>>      #2: rtnl_mutex, at: reg_check_chans_work+0xac net/wireless/
>> reg.c:2469
>>      #3: wiphy.mtx,  at: reg_check_chans_work+0x1a1 net/wireless/
>> reg.c:2472
>>
>>    locks held by syz-executor (inet6_rtm_newaddr):
>>      #0: rtnl_mutex, at: inet6_rtm_newaddr+0x65e
>>
>>    INFO: task syz-executor blocked for more than 143 seconds.
>>
>> This directly shows reg_check_chans_work holding rtnl_mutex while
>> inet6_rtm_newaddr waits — 143 seconds, with the default timeout.
> 
> You or your LLM is overly confident of root cause in my opinion.

I am not confident, I can stop defending it immediately if I see a
reason to the contrary, I just couldnt find another cause yet. If you
did, please let me know. You said you made a different fix before,
perhaps showing it might open my eyes.

> I will be happy to talk with a human about this since I am interested in
> weird wifi problems at scale, but please do not send more LLM responses.

Was never the case, probably a misunderstanding.

> Thanks,
> Ben
> 
Thanks,
Ömer Mete
