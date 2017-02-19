Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from celine.tisys.org ([85.25.117.166]:37956 "EHLO celine.tisys.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750844AbdBSQ0G (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 19 Feb 2017 11:26:06 -0500
Date: Sun, 19 Feb 2017 17:25:21 +0100
From: Nils Holland <nholland@tisys.org>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH] Fix rtl8187 multicast reception
Message-ID: <20170219162521.GA15426@tisys.org> (sfid-20170219_172610_380849_0A45EBCD)
References: <20170219013520.GA3190@tisys.org>
 <2eb1dd33-4d71-86b7-c579-412419e2a2e5@lwfinger.net>
 <87lgt28vxz.fsf@purkki.adurom.net>
 <20170219094138.GA3228@tisys.org>
 <87y3x22tsn.fsf@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87y3x22tsn.fsf@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Feb 19, 2017 at 03:29:12PM +0200, Kalle Valo wrote:
> Nils Holland <nholland@tisys.org> writes:
> 
> > On Sun, Feb 19, 2017 at 09:46:16AM +0200, Kalle Valo wrote:
> >> Larry Finger <Larry.Finger@lwfinger.net> writes:
> >> 
> >> > On 02/18/2017 07:35 PM, Nils Holland wrote:
> >> >
> >> > I would prefer a module parameter that would allow this change to be
> >> > implemented only if the user takes special action. I suspect that you
> >> > will have no difficulty preparing such a change. If that is not true,
> >> > I would be happy to help.
> >> 
> >> I understand why you prefer having a module parameter but the thing is
> >> that being able to receive multicast frames is really basic
> >> functionality. We should not hide it under a module parameter.
> >
> > Well, this is a tough question, I have to admit that I have a somewhat
> > weird feeling making a change that also applies to other hardware that
> > I cannot test on, so I don't know about any negative consequences that
> > might arise there, especially when the change isn't based on some
> > official information from some documentation, but rather a result of
> > trial & error. So I can fully understand Larry's concerns and do in
> > fact think that a module parameter could be a nice solution, so that
> > by default the behavior if the driver does not change.
> 
> There are lots of hardware variations that cannot be tested when a patch
> is commited. If we followed the same methdology with all patches we
> would have thousands of module parameters in kernel in no time :)

Right, that's certainly true as well, and would be a problem, so too
much should be avoided.

> > On the other hand, use of this particular USB wifi card is probably
> > not so common these days so relatively few people would notice at all.
> > Tough! I guess I'll submit a module parameter based v2 of the patch
> > later today, just as Larry suggested!
> 
> Also remember to add a prefix to the title:
> 
> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#subject

Another helpful hint! Thanks, will keep that in mind for the next
submission! :-)

> >> Isn't there any other option, for example does anyone have hw to test
> >> this with other hw? (what exactly?) Or maybe we just take the risk and
> >> take it as is and revert if problems arise?
> >
> > Of course, if someone has other hw, more testing would be nice! Any
> > situation where the card is supposed to receive multicast frames
> > should be suitable as a test case - in my case, just connecting to my
> > local network and expecting to see the card pick up RAs and acquire an
> > IPv6 address is the easiest test case. This works nicely on several
> > other machines with completely different wifi hardware as well as
> > wired machines, but fails without the fix on the rtl8187b. It would,
> > for example, be interesting to see if a non-b 8187 behaves the same or
> > if things work there out of the box.
> 
> I'm not familiar with the driver so when you say "non-b 8187" what do
> you mean exactly? What kind of hardware are we talking about? How many
> different hardware versions are there that this patch affects? Is the
> firmware/hardware really so different that the chances are high that
> this breaks something?

The driver in question seems to apply to, all in all, 21 different usb
ids, so 21 different USB wifi cards. The existing code classifies
these into two different categories: rtl8187 and rtl8187b, which seem
to be different versions / revisions of a realtek usb wifi chip.
Depending on this classification - if a card is a rtl8187 or rtl8187b
- the existing code does things a bit different in several cases, for
example during initialization of the card (however, not during the
routine that sets the filters and where I've made my changes).

The card I have here and on which I noticed the problem and verified
the fix is one that the driver classifies as rtl8187b. All such
classified cards should use the same chip and thus likely behave the
same regarding the problem and fix. But as far as those cards
classified as rtl8187 are concerned, I don't have an idea how they
behave in practice. All I know is that my current patch would change
behavior on them as well.

If this sounds good to Larry, too, I might in fact - instead of using
a module parameter - change the patch in such a way that it only
changes behavior on cards classified as rtl8187b, which should behave
like mine and thus benefit from the change, and leave the code
affecting rtl8187 cards, which I honestly cannot say anything about,
alone. Probably sounds like a safer thing to do.

Greetings
Nils
