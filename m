Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:53792 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756091Ab2EBAAh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 May 2012 20:00:37 -0400
Received: by lahj13 with SMTP id j13so42537lah.19
        for <linux-wireless@vger.kernel.org>; Tue, 01 May 2012 17:00:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAKVccoUNwk7zKzckY-bNNvgf0FNDqZhnruzgTPOtxSXRuq3myQ@mail.gmail.com>
References: <CAKVccoW8GCE=QSC9db6EnoEOsnBkKNoEvqzRrn8orbkf=U66Dg@mail.gmail.com>
 <4F9BFA14.3070008@lwfinger.net> <CAKVccoWRdcB87DB22=hy9wvEuR7exB7LV8zEGwq1+ug6YK2Zig@mail.gmail.com>
 <CAKVccoX-rjdapPE9N4vK6GYGrLVBQmD5yzz79ko4Uv=Uj=K6gA@mail.gmail.com>
 <4F9DD22F.8010305@lwfinger.net> <CAKVccoWbiKMPSH-jHHS+L+B-C1+ZZntxdP45ZxuxaN3h3C1iGA@mail.gmail.com>
 <4F9DE46E.6030103@lwfinger.net> <CAKVccoVU6uMNF0ShZO2jpsJzcf2MhaYzhELimS051TX2hVvyXQ@mail.gmail.com>
 <CAKVccoXJxLVm=3v2QnvKq1b3N76eXoNR45GfJ0TzRYx-BuM-fA@mail.gmail.com>
 <4F9DFF0A.7080604@lwfinger.net> <20120430120037.GG9863@alittletooquiet.net>
 <CAKVccoU_eWtStR=XJEBuUSQJOTMfXuHuHNxs+xbEwd+mdFiG0Q@mail.gmail.com>
 <4F9F55F9.3090800@lwfinger.net> <CAKVccoV+fNYVZUjkNSPzp=T8TC6L_zqUdocp=oYBP0=r-M9HRA@mail.gmail.com>
 <4F9F6B67.5000400@lwfinger.net> <CAKVccoVA=Rk8AkD+h0n9aeV95h0iMcnQgM_WMJq3rjzoFvkU-w@mail.gmail.com>
 <CAKVccoX=u=qX_OJ8RMSxpNEMGYdGVzimZURJ+ZeNZjhW1jPt6Q@mail.gmail.com>
 <4F9FF3D3.1020006@lwfinger.net> <CAKVccoUNwk7zKzckY-bNNvgf0FNDqZhnruzgTPOtxSXRuq3myQ@mail.gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Wed, 2 May 2012 10:00:16 +1000
Message-ID: <CAGRGNgVw42wDHWMra64hursybHZUvWrTf8bjPUTCn2GkLrR04Q@mail.gmail.com> (sfid-20120502_020042_105235_86B6A258)
Subject: Re: rtl8192ce makes keyboard repeat and mouse freeze
To: simple w8 <simplew8@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Forest Bond <forest@alittletooquiet.net>,
	wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Wed, May 2, 2012 at 1:49 AM, simple w8 <simplew8@gmail.com> wrote:
> But isnt strange that the wifi driver can interfere in the keyboard
> when typing? and also be capable to interfere with the pointer device?

It is very strange. I've had it happen to me before with a RAlink wireless card.

>From the behaviour, I'd expect it to be some form of misconfiguration
of the interrupts on your system, (i.e. keyboard / mouse interrupts
are being delayed / dropped) this could be caused by:
- the drivers not setting them up correctly for *your particular system*,
- your hardware being mis-configured or damaged
- ACPI not passing the correct data to Linux
- or some combination of all the above.

In my case, it was definitely an issue with the wireless card's
driver, however that doesn't mean that it's the same for you.

It's simply impossible to duplicate these sorts of issues without the
exact system that has the problem, so unless someone else has an
identical system and is experiencing this exact problem, only you will
be able to debug this.

Given that there are many people out there with working Realtek
wireless cards who are not experiencing this problem, it's unlikely
that this is an issue with that particular driver.

Also, there are many people (myself included) who use Microsoft
hardware products with their Linux computers without incident, so it
is unlikely to be related to the vendor of your keyboard / mouse.

To debug this, the first thing I'd do is read through your entire
dmesg output from a clean boot that's exhibiting these symptoms and
see if Linux is complaining about anything or if there are any errors.
Following up on any errors would probably be a good place to start. If
there is some form of misconfiguration of your hardware, it is likely
to be listed there, and following up on that would be another good
thing to do.

If there aren't any errors or warnings, the next thing I'd check
whether the Realtek card and the keyboard / mice controllers (USB host
or PS/2 port or whatever) are sharing any hardware resources. If they
are, you may be able to fix your system by convincing your BIOS to let
them have their own stuff. Another thing to look at is if there are
any changes to the resources your BIOS gives various devices when the
system has the card and when it doesn't, this may point you in the
direction of a different driver that has issues. (saving dmesgs,
stripping out the timestamps and diffing them is a good way to find
issues like this)

That's about the limit of my knowledge on this, but following up on
any errors or warnings in the dmesg output and talking to the
maintainers of any relevant hardware (or the subsystems it's attached
to) would be a good start.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
