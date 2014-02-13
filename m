Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:14317 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066AbaBMT44 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Feb 2014 14:56:56 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <greearb@candelatech.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/2] ath10k:  do not ratelimit ath10k_warn messages
References: <1392318562-32440-1-git-send-email-greearb@candelatech.com>
	<1392318562-32440-2-git-send-email-greearb@candelatech.com>
Date: Thu, 13 Feb 2014 21:56:50 +0200
In-Reply-To: <1392318562-32440-2-git-send-email-greearb@candelatech.com>
	(greearb@candelatech.com's message of "Thu, 13 Feb 2014 11:09:22
	-0800")
Message-ID: <87fvnm7pml.fsf@kamboji.qca.qualcomm.com> (sfid-20140213_205702_283131_161E403E)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

greearb@candelatech.com writes:

> These are too important to miss, and if we ever do have some
> that are overly verbose

The thing is that in some platforms excessive amount log messages will
cause watchdog to forcefully reboot the device. So I'm hesitant to
remove this.

First of all, the goal is that ath10k will never issue even a single
warning message. So even if you see just one, it means something is
wrong. And just seeing the first few warnings should give you a pretty
good hint what's going on.

Secondly, it's not like net_ratelimit() will hide all the warning
messages. It will still show some of the messages even if it starts to
throttle them.

Thirdly, if you think net_ratelimit() is throttling too much you can
always tune it yourself:

DEFINE_RATELIMIT_STATE(net_ratelimit_state, 5 * HZ, 10);

> could ratelimit the call to ath10k_warn instead of doing the ratelimit
> inside of ath10k_warn.

Not sure if I got this idea. Only to ratelimit some of the warnings or
what do you mean by ratelimiting it outside ath10k_warn()?

-- 
Kalle Valo
