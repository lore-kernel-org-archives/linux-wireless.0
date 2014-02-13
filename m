Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:37066 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756AbaBMUc6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Feb 2014 15:32:58 -0500
Message-ID: <52FD2BE2.50706@candelatech.com> (sfid-20140213_214141_889322_D65A8EFE)
Date: Thu, 13 Feb 2014 12:32:34 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] ath10k:  do not ratelimit ath10k_warn messages
References: <1392318562-32440-1-git-send-email-greearb@candelatech.com> <1392318562-32440-2-git-send-email-greearb@candelatech.com> <87fvnm7pml.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87fvnm7pml.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/13/2014 11:56 AM, Kalle Valo wrote:
> greearb@candelatech.com writes:
> 
>> These are too important to miss, and if we ever do have some
>> that are overly verbose
> 
> The thing is that in some platforms excessive amount log messages will
> cause watchdog to forcefully reboot the device. So I'm hesitant to
> remove this.
> 
> First of all, the goal is that ath10k will never issue even a single
> warning message. So even if you see just one, it means something is
> wrong. And just seeing the first few warnings should give you a pretty
> good hint what's going on.

I see lots of EAGAIN (-11) warnings sometime, and they come in bunches
in my scenario (with lots of vifs).

> Secondly, it's not like net_ratelimit() will hide all the warning
> messages. It will still show some of the messages even if it starts to
> throttle them.

In my case, it hid exactly the messages I needed to see in a hard
to reproduce bug, so I was a bit peeved :P

>> could ratelimit the call to ath10k_warn instead of doing the ratelimit
>> inside of ath10k_warn.
> 
> Not sure if I got this idea. Only to ratelimit some of the warnings or
> what do you mean by ratelimiting it outside ath10k_warn()?

If there are warnings that are likely to spam continuously,
then ratelimit only those, so something like:

if (netratelimit()) {
  ath10k_warn(...)
}


But, this is an easy patch for me to carry, so no worries if it
doesn't go upstream.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

