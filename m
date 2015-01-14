Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:37551 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752305AbbANKMj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Jan 2015 05:12:39 -0500
Received: by mail-wg0-f44.google.com with SMTP id y19so7929968wgg.3
        for <linux-wireless@vger.kernel.org>; Wed, 14 Jan 2015 02:12:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <21686.15337.153726.847995@gargle.gargle.HOWL>
References: <1420432796-10765-1-git-send-email-sujith@msujith.org>
	<87r3uy4t9y.fsf@kamboji.qca.qualcomm.com>
	<21685.35179.110539.780864@gargle.gargle.HOWL>
	<CA+BoTQmNkVKyeWB0fCFhG2MfMZYTz6Dp4+cs44Dm4HCKjTc3Zw@mail.gmail.com>
	<21686.15337.153726.847995@gargle.gargle.HOWL>
Date: Wed, 14 Jan 2015 11:12:37 +0100
Message-ID: <CA+BoTQkX1KFxpyiotADSaFaEea5BrmgvWLTaSRgMbKzHHP=a2Q@mail.gmail.com> (sfid-20150114_111247_729446_2268DD1B)
Subject: Re: [PATCH] ath10k: Make HTT fill size configurable
From: Michal Kazior <michal.kazior@tieto.com>
To: Sujith Manoharan <sujith@msujith.org>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 14 January 2015 at 10:50, Sujith Manoharan <sujith@msujith.org> wrote:
> Michal Kazior wrote:
>> We should just fix the tx/rx processing instead. The HTT throttling
>> limit was originally introduced to deal with watchdog issues we've
>> seen on AP135. Tasklets were starving system too much.
>
> Then the fill limit restriction is a workaround for AP135
> and shouldn't be applicable for other platforms ?

If I were to narrow down I'd say all uniprocessors. AP135 is just an
example where the problem easily occurs since it has an underpowered
cpu for the task. Even a more powerful single-core system will get
into trouble - all you need is a couple extra netfilter rules, nat,
some running services or additional processing hardware (usb anyone?).


>> I've been playing around with threaded irqs in ath10k in my tree and
>> I've seen improvement with Rx. However Tx instead becomes broken in
>> the process and I'm yet to find a definite and final answer why that
>> is the case. My suspicion is that NAPI, which is used by the ethernet
>> driver, runs in tasklets and they aren't frequent enough to trigger
>> ksoftirqd so they starve the system. The current non-threaded irq
>> approach yields more tasklet schedules for Tx and hits ksoftirqd more
>> often making it nice on userspace. If that's the case I don't really
>> have an idea how to solve this now.
>
> I haven't looked at the TX path in detail, but regarding RX, these
> were the bottlenecks:
>
> * RX batch indication.
> * HTT fill level.
> * netif_receive_skb() usage instead of netif_rx().
>
> AFAIK, the internal driver schedules only one tasklet for a CE interrupt
> and everything is done in that context, along with refilling HTT.
> ath10k has several stages: ISR -> CE tasklet -> HTT tasklet -> Replenish tasklet.
> The softirq count/load will definitely be high with so many tasklets ?

Apparently this isn't enough. Also, tasklets aren't subject to regular
scheduling policies and they just steal time from other threads. This
is important if you consider how much time a single tasklet can run -
you can actually estimate this.

800mbps is 100mbytes/s. Assume this is what host system can handle at 100% cpu.
HTT Rx ring is 1000 frames long which is ~1.5mbyte of data (assuming
1500bytes for each packet).
You eventually end up with cycles which drain entire htt rx ring and
then replenish it if you push more traffic that host cpu can take.
100mbytes / 1.5mbytes = ~66runs/s which is ~15ms for each tasklet run.
That's a lot. You might not get a chance to cycle through all the
running processes to give them their timeslice for a few seconds..

If you starve userspace which runs a watchdog process you'll end up
failing to poke the watchdog timer in kernel and you'll get a reboot.

I'm starting to think tasklets are plain evil for network drivers :P


Michał
