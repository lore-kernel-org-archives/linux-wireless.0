Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:41776 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757246Ab0LIWX5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Dec 2010 17:23:57 -0500
Message-ID: <4D0156F6.4000306@candelatech.com>
Date: Thu, 09 Dec 2010 14:23:50 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: Fix deadlock in ieee80211_do_stop.
References: <1289592426-5367-1-git-send-email-greearb@candelatech.com>	 <4CDDAA3B.9090007@candelatech.com>	 <1289596096.3736.13.camel@jlt3.sipsolutions.net>	 <4CDE699B.70401@kernel.org> <4CE1A344.7040201@candelatech.com>	 <4CE292F7.4090200@kernel.org>	 <1289929258.3673.1.camel@jlt3.sipsolutions.net>	 <4CE396A9.1050908@kernel.org>	 <1290020005.3777.6.camel@jlt3.sipsolutions.net>	 <4CE4C8DD.6010806@kernel.org> <51f5dd53c39a77fff4efc1a99b189725@localhost>	 <4CE4D41F.1080005@kernel.org>	 <1290099585.3801.1.camel@jlt3.sipsolutions.net>	 <4CE68AF4.8060507@kernel.org>	 <1290189452.3768.3.camel@jlt3.sipsolutions.net>	 <4CE6E430.6080804@candelatech.com>	 <AANLkTimf9D-HP8i99ReVrTqcDHrWchT=HSeTywe_=as0@mail.gmail.com>	 <4CFFC214.6000608@candelatech.com> <4CFFCC31.1050408@candelatech.com>	 <4CFFCE47.8040305@candelatech.com>  <4D00E8E2.1030201@kernel.org> <1291905750.3540.14.camel@jlt3.sipsolutions.net> <4D00EBD8.4090805@kernel.org> <4D010114.5020604@gmail.com>
In-Reply-To: <4D010114.5020604@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/09/2010 08:17 AM, Tejun Heo wrote:
> On 12/09/2010 03:46 PM, Tejun Heo wrote:
>>> Right, so we're flushing here under RTNL ... I believe this is the one
>>> that Ben hacked up to not flush or so?
>>
>> He made it to cancel instead of flush.
>
> This makes me think that it's more likely to be a problem in the
> flush_work() implementation.  I went over the code carefully again but
> couldn't find anything suspicious.  Plus, most of the implementation
> is shared between cancel and flush.
>
> I'm gonna write some test code and see whether the flush code behaves
> as expected but in the mean time can you please apply the following
> patch, trigger the problem and report the kernel log?  Also, please
> include the sysrq task dump.  Let's see whether the worker is always
> stuck at the same spot.

I saw a brief hang today, and did a sysrq-t, and then saw the timer
printout you added here.  But, I think that was caused by sysrq-t.
The system recovered and ran fine.

The second time (after several hours of rebooting), the hang was worse
and the system ran OOM after maybe 30 seconds.  I did a sysrq-t then.

I see quite a few printouts from your debug message, but all of them
after things start going OOM, and after sysrq-t.

Here's the console capture:


http://www.candelatech.com/~greearb/minicom_ath9k_log4.txt


Let me know if you need more traces like this if I hit it again.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

