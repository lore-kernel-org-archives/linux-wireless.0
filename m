Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:50423 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752666AbbANJsN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Jan 2015 04:48:13 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21686.15337.153726.847995@gargle.gargle.HOWL> (sfid-20150114_104819_108745_D5312B42)
Date: Wed, 14 Jan 2015 15:20:33 +0530
To: Michal Kazior <michal.kazior@tieto.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
	"ath10k\@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: Make HTT fill size configurable
In-Reply-To: <CA+BoTQmNkVKyeWB0fCFhG2MfMZYTz6Dp4+cs44Dm4HCKjTc3Zw@mail.gmail.com>
References: <1420432796-10765-1-git-send-email-sujith@msujith.org>
	<87r3uy4t9y.fsf@kamboji.qca.qualcomm.com>
	<21685.35179.110539.780864@gargle.gargle.HOWL>
	<CA+BoTQmNkVKyeWB0fCFhG2MfMZYTz6Dp4+cs44Dm4HCKjTc3Zw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior wrote:
> We should just fix the tx/rx processing instead. The HTT throttling
> limit was originally introduced to deal with watchdog issues we've
> seen on AP135. Tasklets were starving system too much.

Then the fill limit restriction is a workaround for AP135
and shouldn't be applicable for other platforms ?

> I've been playing around with threaded irqs in ath10k in my tree and
> I've seen improvement with Rx. However Tx instead becomes broken in
> the process and I'm yet to find a definite and final answer why that
> is the case. My suspicion is that NAPI, which is used by the ethernet
> driver, runs in tasklets and they aren't frequent enough to trigger
> ksoftirqd so they starve the system. The current non-threaded irq
> approach yields more tasklet schedules for Tx and hits ksoftirqd more
> often making it nice on userspace. If that's the case I don't really
> have an idea how to solve this now.

I haven't looked at the TX path in detail, but regarding RX, these
were the bottlenecks:

* RX batch indication.
* HTT fill level.
* netif_receive_skb() usage instead of netif_rx().

AFAIK, the internal driver schedules only one tasklet for a CE interrupt
and everything is done in that context, along with refilling HTT.
ath10k has several stages: ISR -> CE tasklet -> HTT tasklet -> Replenish tasklet.
The softirq count/load will definitely be high with so many tasklets ?

Sujith
