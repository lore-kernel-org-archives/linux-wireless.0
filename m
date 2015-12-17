Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yk0-f179.google.com ([209.85.160.179]:33338 "EHLO
	mail-yk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753451AbbLQTYg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Dec 2015 14:24:36 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFwOT3azA9pBXeJFOm5oxNhQFOKWMX7Gq9Ey8mKrrFJQAw@mail.gmail.com>
References: <rbhuamrc6ajy3l1qereb60l8.1440494220682@email.android.com>
 <20150825193408.GR8051@wotan.suse.de> <s5h4mjnnobb.wl-tiwai@suse.de>
 <CAKdAkRR+HUM_6SaSwPL0m9_B=Rb3HiXzCS1QGwnYr9HgSCigeA@mail.gmail.com>
 <E7B1D079BA13FB44A978CC8F69C7D6A9055A1C48@SHSMSX101.ccr.corp.intel.com>
 <s5h1teqpqbn.wl-tiwai@suse.de> <E7B1D079BA13FB44A978CC8F69C7D6A9055A1CFB@SHSMSX101.ccr.corp.intel.com>
 <1440576394.2443.17.camel@loki> <CA+55aFypOcK6fiiUo8FtN1srw8M9FZtqcSsFfA2eVeFu7Nug7w@mail.gmail.com>
 <CACVXFVMhhS1UNvK2KZJ4UUWL-H+OGy+Y4iLKSHtjsUry9rFrgw@mail.gmail.com>
 <20150829011130.GK8051@wotan.suse.de> <CACVXFVMp88FtcC0vGr802aG9p7bG3S2Gm0ZAKKkcikCK6ygPeQ@mail.gmail.com>
 <s5hzj1algbk.wl-tiwai@suse.de> <55E1724E.6040303@broadcom.com>
 <20150829183802.480b1425@tom-T450> <55E2BE0E.1070907@broadcom.com> <CA+55aFwOT3azA9pBXeJFOm5oxNhQFOKWMX7Gq9Ey8mKrrFJQAw@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Thu, 17 Dec 2015 11:24:15 -0800
Message-ID: <CAB=NE6V+iU3TRkxyJEsy3FSig6wOqzydK0wjQvpsrmBkHuUQOg@mail.gmail.com> (sfid-20151217_202451_220086_BE78A0D8)
Subject: Re: Problems loading firmware using built-in drivers with kernels
 that use initramfs.
To: Linus Torvalds <torvalds@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Daniel Vetter <daniel.vetter@intel.com>,
	Josh Boyer <jwboyer@fedoraproject.org>
Cc: Arend van Spriel <arend@broadcom.com>,
	Ming Lei <ming.lei@canonical.com>,
	Takashi Iwai <tiwai@suse.de>,
	Liam Girdwood <liam.r.girdwood@linux.intel.com>,
	"Jie, Yang" <yang.jie@intel.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	"joonas.lahtinen@linux.intel.com" <joonas.lahtinen@linux.intel.com>,
	Tom Gundersen <teg@jklm.no>, Al Viro <viro@zeniv.linux.org.uk>,
	Kay Sievers <kay@vrfy.org>,
	David Woodhouse <dwmw2@infradead.org>,
	lkml <linux-kernel@vger.kernel.org>,
	yalin wang <yalin.wang2010@gmail.com>,
	Ming Lei <tom.leiming@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	linux-security-module <linux-security-module@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Aug 30, 2015 at 11:11 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Sun, Aug 30, 2015 at 1:25 AM, Arend van Spriel <arend@broadcom.com> wrote:
>> On 08/29/2015 12:38 PM, Ming Lei wrote:
>>
>> Does this mean a built-in driver can not get firmware from initramfs or
>> built in the kernel early. Seems a bit too aggressive.
>
> Yeah, that seems wrong. Loading firmware from initramfs is required
> for some things, like disk drivers. Of course, depending on how it's
> done, it's all after the SYSTEM_BOOTING phase, but ..
>
> What we *might* do is to not allow it for the user-mode helper
> fallback,

FWIW, that's what we did, request_firmware_direct() now skips the
silly usermode helper. I'll note that Greg pointed out to me that
Daniel (was this right?) might have some use cases for the usermode
helper in the future on graphics though. Daniel is that right? Can you
clarify the use case, I'd just like to document this and keep it in
mind for future design changes on firmware_class. Also, it occurs to
me that if you have a need for it, perhaps others might and if we can
avoid *others* from coming up with their own solution that'd be best,
specifically as this is related to file loading -- more on this later
generalized possible use cases in another thread I'll Cc you folks on.

> but I think it's more likely that we'll just deprecate the
> usermode helper fw loader entirely, so adding new error cases for it
> seems pointless.

I was shooting hard to deprecate the usermodehelper, Greg has noted
that we can only phase it out though, so that is what I will be
shooting for: a sysdata API, what will have firmware signing support
later will *not* make use of the usermode helper. The old APIs will
still use it.

[0] http://lkml.kernel.org/r/20151006090821.GB9030@kroah.com

 Luis
