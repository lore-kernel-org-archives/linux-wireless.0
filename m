Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45258 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932413AbcERO5C (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 May 2016 10:57:02 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Daniel Lenski <dlenski@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] Make firmware startup polling timeout configurable, and increase default
References: <1463525295-10818-1-git-send-email-dlenski@gmail.com>
	<1463525295-10818-2-git-send-email-dlenski@gmail.com>
	<wrfjeg903urr.fsf@redhat.com>
	<CAOw_LSEvU3OKm3MDe4FfHicd709548=S5Qm+wV=5mBOFV4TrKg@mail.gmail.com>
Date: Wed, 18 May 2016 10:57:00 -0400
In-Reply-To: <CAOw_LSEvU3OKm3MDe4FfHicd709548=S5Qm+wV=5mBOFV4TrKg@mail.gmail.com>
	(Daniel Lenski's message of "Tue, 17 May 2016 21:01:22 -0700")
Message-ID: <wrfj37pf1kjn.fsf@redhat.com> (sfid-20160518_165708_878493_C2595B08)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Daniel Lenski <dlenski@gmail.com> writes:
> Jes Sorensen <Jes.Sorensen@redhat.com> writes:
>>
>> Dan Lenski <dlenski@gmail.com> writes:
>> >
>> > This issue seems to occur because RTL8XXXU_FIRMWARE_POLL_MAX (1000) is
>> > too short, and the MCU fails to start up as quickly as expected.
>> >
>> > With a longer value (5000), the driver starts up consistently and
>> > successfully after cold-boot.
>>
>> I am not against increasing the maximum value here, however I would like
>> more details about the system where you see these problems. I have used
>> this driver extensively for a long time with my Lenovo Yoga 13 laptop
>> and not seen this issue.
>
> Mine is also a Yoga 13.

Interesting, I thought it might have been an ARM board and it could be
something else that wasn't happening correctly. So far I only know of
the Yogas and certain ARM boards that have the 8723au.

>> Second, I really don't think this warrants a module parameter. Bumping
>> the value should suffice.
>
> Okay. Adding a module parameter was useful for me in debugging, and I
> thought it might be a useful backup option for other end-users who may
> find that the default value doesn't suffice.
>
> It seems plausible to me that the delay is due to waiting for some
> kind of analog circuit to stabilize (PLL, maybe?) and that there could
> be a large variation among devices.

I am surprised your system is that different from mine, but I am fine
with bumping it. I don't really like to clutter the module parameters
unnecessarily, and if we bump this to 5000, I think it is unlikely
anyone else will hit this problem. If they do, I think there are other
issues at play.

>> Note that the patch should at least be relative to
>> wireless-drivers-next, or preferably my rtl8xxxu-devel tree. In both of
>> these trees, the rtl8xxxu driver has been split into multiple files and
>> your patch will not apply.
>>
>> Last, neither of the links you included for external bug reports work.
>
> Are you still unable to follow them in the second version of the patches that
> I submitted? (It appears that they were mangled by Gmane the first
> time I posted them.)
>
> Here they are again:
>
> http://ubuntuforums.org/showthread.php?t=2321756
>
> That is, thread #2321756 at ubuntuforums.org
>
> https://www.mail-archive.com/ubuntu-bugs@lists.ubuntu.com/msg4942468.html
>
> That is, Ubuntu bug #1574622

I found them from your second post.

Cheers,
Jes
