Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from celine.tisys.org ([85.25.117.166]:33028 "EHLO celine.tisys.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750868AbdBSJlq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 19 Feb 2017 04:41:46 -0500
Date: Sun, 19 Feb 2017 10:41:38 +0100
From: Nils Holland <nholland@tisys.org>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH] Fix rtl8187 multicast reception
Message-ID: <20170219094138.GA3228@tisys.org> (sfid-20170219_104158_395840_446E0BCB)
References: <20170219013520.GA3190@tisys.org>
 <2eb1dd33-4d71-86b7-c579-412419e2a2e5@lwfinger.net>
 <87lgt28vxz.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87lgt28vxz.fsf@purkki.adurom.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Feb 19, 2017 at 09:46:16AM +0200, Kalle Valo wrote:
> Larry Finger <Larry.Finger@lwfinger.net> writes:
> 
> > On 02/18/2017 07:35 PM, Nils Holland wrote:
> >> The rtl8187 doesn't seem to receive multicast data, which, among other
> >> thinks, make it fail to receive RAs in IPv6 networks.
> >>
> >> The cause seems to be that the RTL818X_RX_CONF_MULTICAST flag doesn't
> >> have any effect at all. Fix this issue by setting
> >> RTL818X_RX_CONF_MONITOR instead, which puts the card into monitor mode,
> >> and fixes the problem.
> >>
> >> Signed-off-by: Nils Holland <nholland@tisys.org>
> >> ---
> >> The problem and solution have been tested on an rtl8187b (0bda:8197), but
> >> the fix changes behavior on other cards supported by the driver as well
> >> (like non-b 8187's). Due to lack of hardware, I unfortunately cannot say
> >> if the issue exists on these cards in the first place, or if the fix has
> >> any unwanted consequences there.
> 
> BTW, this is good info to have in the actual commit log. No need put it
> under "---" line.

Thanks for the hint, I'll do that better the next time! :-)

> > I would prefer a module parameter that would allow this change to be
> > implemented only if the user takes special action. I suspect that you
> > will have no difficulty preparing such a change. If that is not true,
> > I would be happy to help.
> 
> I understand why you prefer having a module parameter but the thing is
> that being able to receive multicast frames is really basic
> functionality. We should not hide it under a module parameter.

Well, this is a tough question, I have to admit that I have a somewhat
weird feeling making a change that also applies to other hardware that
I cannot test on, so I don't know about any negative consequences that
might arise there, especially when the change isn't based on some
official information from some documentation, but rather a result of
trial & error. So I can fully understand Larry's concerns and do in
fact think that a module parameter could be a nice solution, so that
by default the behavior if the driver does not change. From an
end-user standpoint, it's probably always worse to see something break
which has always worked before than it is to have something not work
properly right from the start, but being able to easily find some
parameter to fix this. On the other hand, use of this particular USB
wifi card is probably not so common these days so relatively few
people would notice at all. Tough! I guess I'll submit a module
parameter based v2 of the patch later today, just as Larry suggested!

> Isn't there any other option, for example does anyone have hw to test
> this with other hw? (what exactly?) Or maybe we just take the risk and
> take it as is and revert if problems arise?

Of course, if someone has other hw, more testing would be nice! Any
situation where the card is supposed to receive multicast frames
should be suitable as a test case - in my case, just connecting to my
local network and expecting to see the card pick up RAs and acquire an
IPv6 address is the easiest test case. This works nicely on several
other machines with completely different wifi hardware as well as
wired machines, but fails without the fix on the rtl8187b. It would,
for example, be interesting to see if a non-b 8187 behaves the same or
if things work there out of the box. In that case, instead of doing a
module parameter, I could also change the fix so that it only does
something different on the b-variants of the card and doesn't change
behavior at all on non-b.

Greetings
Nils
