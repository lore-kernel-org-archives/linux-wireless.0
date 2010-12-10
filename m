Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:51151 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756577Ab0LJQfS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Dec 2010 11:35:18 -0500
Message-ID: <4D0256BD.5040302@candelatech.com>
Date: Fri, 10 Dec 2010 08:35:09 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: Fix deadlock in ieee80211_do_stop.
References: <1289592426-5367-1-git-send-email-greearb@candelatech.com>	 <1289596096.3736.13.camel@jlt3.sipsolutions.net>	 <4CDE699B.70401@kernel.org> <4CE1A344.7040201@candelatech.com>	 <4CE292F7.4090200@kernel.org>	 <1289929258.3673.1.camel@jlt3.sipsolutions.net>	 <4CE396A9.1050908@kernel.org>	 <1290020005.3777.6.camel@jlt3.sipsolutions.net>	 <4CE4C8DD.6010806@kernel.org> <51f5dd53c39a77fff4efc1a99b189725@localhost>	 <4CE4D41F.1080005@kernel.org>	 <1290099585.3801.1.camel@jlt3.sipsolutions.net>	 <4CE68AF4.8060507@kernel.org>	 <1290189452.3768.3.camel@jlt3.sipsolutions.net>	 <4CE6E430.6080804@candelatech.com>	 <AANLkTimf9D-HP8i99ReVrTqcDHrWchT=HSeTywe_=as0@mail.gmail.com>	 <4CFFC214.6000608@candelatech.com> <4CFFCC31.1050408@candelatech.com>	 <4CFFCE47.8040305@candelatech.com>  <4D00E8E2.1030201@kernel.org> <1291905750.3540.14.camel@jlt3.sipsolutions.net> <4D00EBD8.4090805@kernel.org> <4D010114.5020604@gmail.com> <4D0156F6.4000306@candelate ch.com> <4D024307.2060108@gmail.co!
 m>
In-Reply-To: <4D024307.2060108@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/10/2010 07:11 AM, Tejun Heo wrote:
> Hello, Ben.
>
> On 12/09/2010 11:23 PM, Ben Greear wrote:
>> I saw a brief hang today, and did a sysrq-t, and then saw the timer
>> printout you added here.  But, I think that was caused by sysrq-t.
>> The system recovered and ran fine.
>
> It would be nice if you turn on printk timestamp.  How brief is brief?
> Can you please turn on printk timestamp?  @115200, the dump would have
> taken ~25 seconds so yes it was mostly caused by sysrq-t dump.  In the
> dump, iface_work is at the same position in R state.  It looks like
> the ifmgd->mtx.  Can you please confirm this with gdb?  This would
> only happen if the lock is highly contended.  Would this be the case
> Johaness?

I'm getting low on time before the holidays and have lots of other
bugs to go after, so not sure I'll get to this soon.

'Brief' was long enough for me to see 'sh' running at 100+ CPU for
a few refreshes in 'top', which is one of the symptoms of this bug
in my case (a bash script is calling 'ip' which is blocked on
rtnl, or some such thing).

>
>> The second time (after several hours of rebooting), the hang was worse
>> and the system ran OOM after maybe 30 seconds.  I did a sysrq-t then.
>>
>> I see quite a few printouts from your debug message, but all of them
>> after things start going OOM, and after sysrq-t.
>>
>> Here's the console capture:
>>
>> http://www.candelatech.com/~greearb/minicom_ath9k_log4.txt
>>
>> Let me know if you need more traces like this if I hit it again.
>
> I don't know the code very well but it looks very suspicious.  A task
> ends up trying to flush a work which can run for extended period of
> time during which memory is aggressively used for buffering (looks
> like skb's are piling up without any limit), which is likely to
> further slow down other stuff.  This sounds like an extremely fragile
> mechanism to me.  When the work is being constantly being rescheduled,
> cancel ends up waiting one fewer time then flush.  If the work is
> running and pending, flush waits for the pending one to finish, while
> cancel would kill the pending one and waits for only the current one
> to finish.  I think it could be that that difference is acting as a
> threshold between going bonkers and staying alive.
>
> Can you please test whether the following patch makes any difference?
> If flush_work() is misbehaving, the following wouldn't fix anything
> but if this livelock is indeed caused by iface_work running too long,
> the problem should go away.
>
> One way or the other, Johannes, please consider fixing the behavior
> here.  It's way too fragile.

Perhaps a related bug:  On module unload with lots of VIFS passing
traffic, I often see crashes due to what appears to be accessing
stale sdata pointers.  Perhaps the logic to disable rx of acks
and other skbs doesn't work properly in the STA shutdown path?

Thanks,
Ben

>
> Thanks.
>
> diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
> index 7aa8559..86bdfdd 100644
> --- a/net/mac80211/iface.c
> +++ b/net/mac80211/iface.c
> @@ -723,6 +723,7 @@ static void ieee80211_iface_work(struct work_struct *work)
>   	struct sk_buff *skb;
>   	struct sta_info *sta;
>   	struct ieee80211_ra_tid *ra_tid;
> +	unsigned int cnt = 0;
>
>   	if (!ieee80211_sdata_running(sdata))
>   		return;
> @@ -825,6 +826,11 @@ static void ieee80211_iface_work(struct work_struct *work)
>   		}
>
>   		kfree_skb(skb);
> +
> +		if (++cnt>  100) {
> +			ieee80211_queue_work(&local->hw, work);
> +			break;
> +		}
>   	}
>
>   	/* then other type-dependent work */


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
