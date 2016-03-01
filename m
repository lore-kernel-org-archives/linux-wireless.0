Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41831 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750739AbcCABac (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 20:30:32 -0500
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Kalle Valo <kvalo@codeaurora.org>,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH 106/113] rtl8xxxu: convert rtl8723bu_init_bt() into rtl8723b_enable_rf()
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
	<1456783551-28315-107-git-send-email-Jes.Sorensen@redhat.com>
	<CAGRGNgUYaoRoXAXOcdyxwnFNhW15_D=HGDVHVd5UAVVqS+h5MQ@mail.gmail.com>
	<wrfja8mjhy7q.fsf@redhat.com>
	<CAGRGNgWRZFpMiVOE5Ri=uOH-+PoHApGPMQRHk=ssx=+yFWvH-w@mail.gmail.com>
	<wrfjk2lngijc.fsf@redhat.com>
	<CAGRGNgXgp4__T+Nj_yrV8JtbQz88CRr90BJkUKu-=HxZX1dCOA@mail.gmail.com>
Date: Mon, 29 Feb 2016 20:30:30 -0500
In-Reply-To: <CAGRGNgXgp4__T+Nj_yrV8JtbQz88CRr90BJkUKu-=HxZX1dCOA@mail.gmail.com>
	(Julian Calaby's message of "Tue, 1 Mar 2016 11:32:36 +1100")
Message-ID: <wrfjy4a3f0i1.fsf@redhat.com> (sfid-20160301_023036_375514_AE32DCAA)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Julian Calaby <julian.calaby@gmail.com> writes:
> Hi Jes,
>
> On Tue, Mar 1, 2016 at 11:15 AM, Jes Sorensen <Jes.Sorensen@redhat.com> wrote:
>> Julian Calaby <julian.calaby@gmail.com> writes:
>> Well again, prettying things up by merging a lot of patches together
>> reduces the maintainability and the debug option. Patches often sit
>> outside a maintainer's tree for a long time, and the sub-maintainer and
>> developer may have to go back and bisect his/her way to a bug that was
>> introduced in the middle.
>
> I'm not advocating turning this into a couple of huge patches, I'm
> saying that two patches that introduce a new op and adjust code to use
> it should either be one patch or patches n and n+1, not separated by
> tens of unrelated patches; and I'm saying that there's no point
> keeping the history that a particular message used to be much more
> verbose.

As I said earlier, there are a few places where you could squash one
patch into another. It requires rewriting history and potentially
hitting patch conflicts. If it added value, I would agree with you, but
I don't see any case where it does.

>> Linux development is not only what happens in the official tree, it's
>> also how it got there.
>
> I've seen tens of new drivers introduced and accepted into Linux in
> the time I've been watching these mailing lists and they tend to fall
> into one of three categories:
> 1. Vendor dumps a huge ten-thousand line patch adding the new driver
> then is told to split it up for review. (E.g. most SCSI drivers)
> 2. Developer submits a new driver in 10-20 patches which logically
> bring up the device and add features. (E.g. most new WiFi drivers and
> practically all drivers on the ARM list I follow)
> 3. Developer submits basic support for a device then releases dribs
> and drabs of patches to add features. (E.g. b43)
>
> You're trying to do both 2 and 3 here.

Well I am sure you have seen a lot of drivers come and go over time, so
have I. I also wrote some of them.

For the initial submission of rtl8xxxu I did merge it all into one,
because it was a completely new driver. However since then I received
feedback, fixed bugs, and started adding new features.

SCSI is a lot simpler than WiFi. Sure I could merge this into 10-20
large patches and post those, but that would affect other portions of
the code, not just support for the new pieces. It is very common for
Linux drivers to take a large number of changes in a set of patches.
It's how Linux evolves.

>>> I can see a lot of scope for reducing the number of patches in this
>>> patch set, so if you'd like me to play around with that, just ask.
>>
>> Unless you plan to test every single change you suggest against all the
>> supported USB parts, then I'd say thanks, but no thanks.
>
> Fair point. Look, at least rip out the *eu specific stuff until it's
> complete. It's ugly to write write a bunch of stuff to add support for
> a chipset, never get there, then disable it in the last patch.

Trying to isolate the 8192eu support from the 8723bu support at this
point would be insane. The two are so intermingled that it's not doable
without breaking everything. It would take a lot of time and the end
code would be the same.

I could have included the 50-60 additional patches to bring up 8192eu
with this patchset, but I know Kalle prefers fewer patches at a
time. This was the smallest I could do which would include functional
8723bu support. Alternatively I could have pushed 20 patches at a time,
leaving the code dysfunctional until I reached the set level of this
patchset and then enabled support for the 8723bu at that time.

In my oppinion having a half deck of patches that aren't providing any
functional feature, in the tree, would be far worse than taking the full
set in in one go.

The good news is that once the 8192eu changes are in as well, adding
support for the 8188eu and 8192du should be a lot simpler and require
fewer changes since both generations of chips will then be covered.

I also plan to reorganize the code to split it more into sub-drivers,
making it easier to develop support for new chips down the line. Having
had that in place for 8723bu/8192eu development would have been nice,
but I only learned of the differences and what needed to be split out as
I went along.

>> The whole point of git is to commit often, and keep the history.
>
> I agree that committing often is essential for modern development, but
> I don't think keeping every last detail of the code's history is
> worthwhile.

We'll have to agree to disagree on that one. If you decide to write your
own driver at some point, I will fully support you keeping the history
of that code, the way you prefer.

Jes
