Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f182.google.com ([209.85.223.182]:33350 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752939AbbCLTjB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2015 15:39:01 -0400
Received: by iecvj10 with SMTP id vj10so54621710iec.0
        for <linux-wireless@vger.kernel.org>; Thu, 12 Mar 2015 12:39:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87bnjytitc.fsf@kamboji.qca.qualcomm.com>
References: <1425929918-860-1-git-send-email-linux@rempel-privat.de>
	<87385dz2yx.fsf@kamboji.qca.qualcomm.com>
	<CAJ-Vmon6j71Eurbe7Sg2ZB06hbOymVYSge_-LeUKCXRDmLE5mw@mail.gmail.com>
	<54FF5431.3020708@rempel-privat.de>
	<87bnjytitc.fsf@kamboji.qca.qualcomm.com>
Date: Thu, 12 Mar 2015 12:38:43 -0700
Message-ID: <CAJ-VmomN07UrX4mLZv5bZiuFPt6kqZxPRLmbonifTfhgb_jB3g@mail.gmail.com> (sfid-20150312_203914_149860_026C1A76)
Subject: Re: [PATCH] ath9k_htc: force FW v1.4.0
From: Adrian Chadd <adrian@freebsd.org>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Oleksij Rempel <linux@rempel-privat.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath9k-devel <ath9k-devel@lists.ath9k.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12 March 2015 at 07:02, Kalle Valo <kvalo@codeaurora.org> wrote:
> Oleksij Rempel <linux@rempel-privat.de> writes:
>
>> Am 10.03.2015 um 16:35 schrieb Adrian Chadd:
>>> Yeah, let's have it warn for a month or two.
>>>
>>> There's some pending work that will break the API with 1.3 firmware,
>>> so it has to happen sooner rather than later. But yeah, maybe warn for
>>> about a month would be good. the older firmware is still in the git
>>> tree in case people want it.
>>
>> I'm not sure if warning patch will do the trick.
>> Let me resend this patch in one or two months. Are you ok with it?
>> Like Adrian said, there are pending patches (since 2013) which will
>> brake compatibility with 1.3
>
> Yeah, that's better. The crystall ball[1] says that 4.2 will be released
> in August, that should be plenty of time for user space to catch up. So
> if you resend this end of April or so the patch should go to 4.2.
>
> [1] http://phb-crystal-ball.org/
>

*laugh*

ok. i've just spoken with Linus about what should be done, and then
Kyle for linux-firmware maintainer bits. The 1.3.1 firmware will
appear again shortly, and then a new subdirectory with per-version
firmware images.

So moving forward ath9k_htc can just check to see if the newer
firmware is available, and fall back to the older firmware if needs
be.

If earlier kernels are booted then the linux-firmware install will
still have htc_{7010,9271}.fw as 1.3.1, so those kernels will still
work.

Now - as for how long the tip of ath9k_htc development should work
with older firmware - that's a good question. I think yes, waiting a
couple more months before merging it in so userspace can catch up is
fine.

Thanks!


-a
