Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:49418 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751042Ab0LIOeT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Dec 2010 09:34:19 -0500
Message-ID: <4D00E8E2.1030201@kernel.org>
Date: Thu, 09 Dec 2010 15:34:10 +0100
From: Tejun Heo <tj@kernel.org>
MIME-Version: 1.0
To: Ben Greear <greearb@candelatech.com>
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: Fix deadlock in ieee80211_do_stop.
References: <1289592426-5367-1-git-send-email-greearb@candelatech.com> <1289594998.3736.11.camel@jlt3.sipsolutions.net> <4CDDAA3B.9090007@candelatech.com> <1289596096.3736.13.camel@jlt3.sipsolutions.net> <4CDE699B.70401@kernel.org> <4CE1A344.7040201@candelatech.com> <4CE292F7.4090200@kernel.org> <1289929258.3673.1.camel@jlt3.sipsolutions.net> <4CE396A9.1050908@kernel.org> <1290020005.3777.6.camel@jlt3.sipsolutions.net> <4CE4C8DD.6010806@kernel.org> <51f5dd53c39a77fff4efc1a99b189725@localhost> <4CE4D41F.1080005@kernel.org> <1290099585.3801.1.camel@jlt3.sipsolutions.net> <4CE68AF4.8060507@kernel.org> <1290189452.3768.3.camel@jlt3.sipsolutions.net> <4CE6E430.6080804@candelatech.com> <AANLkTimf9D-HP8i99ReVrTqcDHrWchT=HSeTywe_=as0@mail.gmail.com> <4CFFC214.6000608@candelatech.com> <4CFFCC31.1050408@candelatech.com> <4CFFCE47.8040305@candelatech.com>
In-Reply-To: <4CFFCE47.8040305@candelatech.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

Sorry about the delay.

On 12/08/2010 07:28 PM, Ben Greear wrote:
>> And here's a log with lockdep enabled:
>>
>> http://www.candelatech.com/~greearb/minicom_ath9k_log2.txt
>>
>> The sysrq output starts at line 1346 in this file.
>>
>> Seems I have a decent environment for reproducing this today,
>> in case you have any debug you'd like me to add.

ip is trying to flush sdata->work while holding rtnl_lock.

  ip            D 0000001c     0 14687  14600 0x00000080
   ddcd99c0 00000046 7845a1f1 0000001c 00000000 ddcd9a84 8bc77ee2 0000001c
   78a04380 f4223ea0 78a04380 f422411c f4224118 f4224118 78a04380 78a04380
   005aba36 00000000 f3fd4c80 0000001c f4223ea0 f4223e02 0043e2ba 00000000
  Call Trace:
   [<7878cfaa>] schedule_timeout+0x16/0x9f
   [<7878ce7f>] wait_for_common+0xbb/0x101
   [<7878cf48>] wait_for_completion+0x12/0x14
   [<78447ce1>] flush_work+0x23/0x27
   [<f91a2646>] ieee80211_do_stop+0x25c/0x403 [mac80211]
   [<f91a27ff>] ieee80211_stop+0x12/0x16 [mac80211]
   [<786f6199>] __dev_close+0x73/0x88
   [<786f3e96>] __dev_change_flags+0xa5/0x11a
   [<786f6044>] dev_change_flags+0x13/0x3f
   [<78700827>] do_setlink+0x23a/0x525
   [<78700e55>] rtnl_newlink+0x283/0x45a
   [<7870038d>] rtnetlink_rcv_msg+0x188/0x19e
   [<7870e614>] netlink_rcv_skb+0x30/0x77
   [<787001fe>] rtnetlink_rcv+0x1b/0x22		<- rtnl lock
   [<7870e433>] netlink_unicast+0xbe/0x11a
   [<7870f004>] netlink_sendmsg+0x23e/0x255
   [<786e6304>] __sock_sendmsg+0x54/0x5b
   [<786e67ce>] sock_sendmsg+0x95/0xac
   [<786e6bf7>] sys_sendmsg+0x14d/0x19a
   [<786e7f76>] sys_socketcall+0x227/0x289
   [<784030dc>] sysenter_do_call+0x12/0x38

  kworker/u:3   R running      0    43      2 0x00000000
   f3ad9e8c 00000046 f8b4e008 00000000 78b6dbec f3ad9e1c 31e6ae69 00000024
   78a04380 f39e3430 78a04380 f39e36ac f39e36a8 f39e36ac 78a04380 78a04380
   000f5552 00000000 df4ce780 00000024 f39e3430 00000046 00000000 78bcc5fc
  Call Trace:
   [<7878cdab>] _cond_resched+0x2b/0x44
   [<7878d84f>] mutex_lock_nested+0x22/0x3b
   [<f919fddc>] ieee80211_sta_rx_queued_mgmt+0x2d/0x3a6 [mac80211]
   [<f91a2f53>] ieee80211_iface_work+0x1ff/0x282 [mac80211]
   [<78446fd4>] process_one_work+0x1af/0x2bf
   [<78448722>] worker_thread+0xf9/0x1bf
   [<7844b252>] kthread+0x62/0x67
   [<784036c6>] kernel_thread_helper+0x6/0x1a

But, sdata->work is busy running ieee80211_iface_work().  I _suspect_
for some reason iee80211_iface_work() isn't finishing.  That, or, the
new flush_work() implementation is broken and it's failing to flush
when a work is being executed back to back.  I'll prep a debug patch
to determine what's going on.

The rest of the system going down the toilet after this is mostly
caused by the held rtnl_lock above.

> And one more thing:  It seems it doesn't always block forever.
> The system in that last trace actually recovered after a
> minute or two, though it periodically enters the blocked
> state again.

And as this is not a deadlock but more of a livelock, yeah, it's quite
possible that it resolves itself in time.

Thanks.

-- 
tejun
