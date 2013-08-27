Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:40012 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466Ab3H0HGT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Aug 2013 03:06:19 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 4/4] ath10k: fix issues on non-preemptible systems
References: <1377066854-13981-1-git-send-email-michal.kazior@tieto.com>
	<1377507205-5386-1-git-send-email-michal.kazior@tieto.com>
	<1377507205-5386-5-git-send-email-michal.kazior@tieto.com>
Date: Tue, 27 Aug 2013 10:06:13 +0300
In-Reply-To: <1377507205-5386-5-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Mon, 26 Aug 2013 10:53:25 +0200")
Message-ID: <87ioyrmx3u.fsf@kamboji.qca.qualcomm.com> (sfid-20130827_090621_901388_747C4ED1)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Workers may not call into a sleepable function
> (e.g. mutex_lock). Since ath10k workers can run
> for a very long time it is necessary to explicitly
> allow process rescheduling in case there's no
> preemption.
>
> This fixes some issues with system freezes, hangs,
> watchdogs being triggered, userspace being
> unresponsive on slow host machines under heavy
> load.

I consider this more as a workaround as a real fix. Would NAPI be a
proper fix for issues like this?

NAPI support was removed from mac80211 six months ago, but I guess we
could try to get it back if we have a good reason:

http://marc.info/?l=linux-wireless&m=136204135907491

> --- a/drivers/net/wireless/ath/ath10k/htt_rx.c
> +++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
> @@ -1229,6 +1229,10 @@ static void ath10k_htt_rx_work(struct work_struct *work)
>  			break;
>  
>  		ath10k_htt_rx_process_skb(htt->ar, skb);
> +
> +#ifndef CONFIG_PREEMPT
> +		cond_resched();
> +#endif

Why the #ifndef? Why should we not call cond_resched() when PREEMPT is
enabled? Does something negative happen then?

-- 
Kalle Valo
