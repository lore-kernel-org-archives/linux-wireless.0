Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:36270 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753177AbbAOAPK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Jan 2015 19:15:10 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21687.1828.923192.384081@gargle.gargle.HOWL> (sfid-20150115_011516_069868_F5A46708)
Date: Thu, 15 Jan 2015 05:47:40 +0530
To: Michal Kazior <michal.kazior@tieto.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
	"ath10k\@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: Make HTT fill size configurable
In-Reply-To: <CA+BoTQkX1KFxpyiotADSaFaEea5BrmgvWLTaSRgMbKzHHP=a2Q@mail.gmail.com>
References: <1420432796-10765-1-git-send-email-sujith@msujith.org>
	<87r3uy4t9y.fsf@kamboji.qca.qualcomm.com>
	<21685.35179.110539.780864@gargle.gargle.HOWL>
	<CA+BoTQmNkVKyeWB0fCFhG2MfMZYTz6Dp4+cs44Dm4HCKjTc3Zw@mail.gmail.com>
	<21686.15337.153726.847995@gargle.gargle.HOWL>
	<CA+BoTQkX1KFxpyiotADSaFaEea5BrmgvWLTaSRgMbKzHHP=a2Q@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior wrote:
> If I were to narrow down I'd say all uniprocessors. AP135 is just an
> example where the problem easily occurs since it has an underpowered
> cpu for the task. Even a more powerful single-core system will get
> into trouble - all you need is a couple extra netfilter rules, nat,
> some running services or additional processing hardware (usb anyone?).

There are platforms which offload such network operations to the HW.
AP148 is an example.

> Apparently this isn't enough. Also, tasklets aren't subject to regular
> scheduling policies and they just steal time from other threads. This
> is important if you consider how much time a single tasklet can run -
> you can actually estimate this.
> 
> 800mbps is 100mbytes/s. Assume this is what host system can handle at 100% cpu.
> HTT Rx ring is 1000 frames long which is ~1.5mbyte of data (assuming
> 1500bytes for each packet).
> You eventually end up with cycles which drain entire htt rx ring and
> then replenish it if you push more traffic that host cpu can take.
> 100mbytes / 1.5mbytes = ~66runs/s which is ~15ms for each tasklet run.
> That's a lot. You might not get a chance to cycle through all the
> running processes to give them their timeslice for a few seconds..
> 
> If you starve userspace which runs a watchdog process you'll end up
> failing to poke the watchdog timer in kernel and you'll get a reboot.
> 
> I'm starting to think tasklets are plain evil for network drivers :P

Well, we need a way to lift the fill level restriction for platforms
that can afford a higher value, until the tx/rx engine in ath10k is
rewritten - and I don't want to carry an internal patch...

Sujith
