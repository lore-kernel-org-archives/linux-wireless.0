Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:37101 "EHLO
	mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbcERECF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 May 2016 00:02:05 -0400
Received: by mail-wm0-f42.google.com with SMTP id a17so59432339wme.0
        for <linux-wireless@vger.kernel.org>; Tue, 17 May 2016 21:02:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <wrfjeg903urr.fsf@redhat.com>
References: <1463525295-10818-1-git-send-email-dlenski@gmail.com>
 <1463525295-10818-2-git-send-email-dlenski@gmail.com> <wrfjeg903urr.fsf@redhat.com>
From: Daniel Lenski <dlenski@gmail.com>
Date: Tue, 17 May 2016 21:01:22 -0700
Message-ID: <CAOw_LSEvU3OKm3MDe4FfHicd709548=S5Qm+wV=5mBOFV4TrKg@mail.gmail.com> (sfid-20160518_060209_319547_A429EB9B)
Subject: Re: [PATCH] Make firmware startup polling timeout configurable, and
 increase default
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jes Sorensen <Jes.Sorensen@redhat.com> writes:
>
> Dan Lenski <dlenski@gmail.com> writes:
> >
> > This issue seems to occur because RTL8XXXU_FIRMWARE_POLL_MAX (1000) is
> > too short, and the MCU fails to start up as quickly as expected.
> >
> > With a longer value (5000), the driver starts up consistently and
> > successfully after cold-boot.
>
> I am not against increasing the maximum value here, however I would like
> more details about the system where you see these problems. I have used
> this driver extensively for a long time with my Lenovo Yoga 13 laptop
> and not seen this issue.

Mine is also a Yoga 13.

Here is the chipset description that the rtl8xxxu driver prints on load:

[    8.097402] usb 1-1.4: RTL8723AU rev B (TSMC) 1T1R, TX queues 2,
WiFi=1, BT=1, GPS=0, HI PA=0

What other details should I add about it?

> Second, I really don't think this warrants a module parameter. Bumping
> the value should suffice.

Okay. Adding a module parameter was useful for me in debugging, and I
thought it might
be a useful backup option for other end-users who may find that the
default value doesn't
suffice.

It seems plausible to me that the delay is due to waiting for some
kind of analog
circuit to stabilize (PLL, maybe?) and that there could be a large
variation among
devices.

> Note that the patch should at least be relative to
> wireless-drivers-next, or preferably my rtl8xxxu-devel tree. In both of
> these trees, the rtl8xxxu driver has been split into multiple files and
> your patch will not apply.
>
> Last, neither of the links you included for external bug reports work.

Are you still unable to follow them in the second version of the patches that
I submitted? (It appears that they were mangled by Gmane the first
time I posted them.)

Here they are again:

http://ubuntuforums.org/showthread.php?t=2321756

That is, thread #2321756 at ubuntuforums.org

https://www.mail-archive.com/ubuntu-bugs@lists.ubuntu.com/msg4942468.html

That is, Ubuntu bug #1574622

Thanks,
Dan
