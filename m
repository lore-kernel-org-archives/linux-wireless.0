Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:46419 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622AbbANJWr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Jan 2015 04:22:47 -0500
Received: by mail-wg0-f43.google.com with SMTP id k14so7709841wgh.2
        for <linux-wireless@vger.kernel.org>; Wed, 14 Jan 2015 01:22:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <21685.35179.110539.780864@gargle.gargle.HOWL>
References: <1420432796-10765-1-git-send-email-sujith@msujith.org>
	<87r3uy4t9y.fsf@kamboji.qca.qualcomm.com>
	<21685.35179.110539.780864@gargle.gargle.HOWL>
Date: Wed, 14 Jan 2015 10:22:46 +0100
Message-ID: <CA+BoTQmNkVKyeWB0fCFhG2MfMZYTz6Dp4+cs44Dm4HCKjTc3Zw@mail.gmail.com> (sfid-20150114_102253_010823_B8765D04)
Subject: Re: [PATCH] ath10k: Make HTT fill size configurable
From: Michal Kazior <michal.kazior@tieto.com>
To: Sujith Manoharan <sujith@msujith.org>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 13 January 2015 at 22:08, Sujith Manoharan <sujith@msujith.org> wrote:
> Kalle Valo wrote:
>> I'm not sure if I really like this path of having interfaces to
>> configure driver internals. I suspect that if we add this, we will have
>> even more later. It's a lot more documenting for us and more work to the
>> users to understand what parameters they should use. Also this means
>> that testing will be more challenging as people will use different
>> values and results won't be comparable.
>>
>> Isn't there any other way to solve the problem? Like automatically
>> changing the value somehow (no idea how) or some other means?
>
> We are limiting performance by restricting the fill size. A user
> will just use the default, which is still the same and remains
> unchanged. But, having a way to adjust this based on the platform
> seems reasonable to me and I think trying to change this value dynamically
> is overkill.

We should just fix the tx/rx processing instead. The HTT throttling
limit was originally introduced to deal with watchdog issues we've
seen on AP135. Tasklets were starving system too much.

I've been playing around with threaded irqs in ath10k in my tree and
I've seen improvement with Rx. However Tx instead becomes broken in
the process and I'm yet to find a definite and final answer why that
is the case. My suspicion is that NAPI, which is used by the ethernet
driver, runs in tasklets and they aren't frequent enough to trigger
ksoftirqd so they starve the system. The current non-threaded irq
approach yields more tasklet schedules for Tx and hits ksoftirqd more
often making it nice on userspace. If that's the case I don't really
have an idea how to solve this now.


Michał
