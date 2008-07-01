Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:46237 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753129AbYGAWsY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jul 2008 18:48:24 -0400
Date: Tue, 1 Jul 2008 19:48:17 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Michael Buesch <mb@bu3sch.de>,
	Adel Gadllah <adel.gadllah@gmail.com>,
	linux-wireless@vger.kernel.org, stefano.brivio@polimi.it,
	Larry Finger <larry.finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Ivo van Doorn <ivdoorn@gmail.com>
Message-ID: <20080701224817.GA4292@khazad-dum.debian.net> (sfid-20080702_004829_015391_A75D8F71)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bcc: 
Subject: Re: [PATCH/RFC] b43: remove input device usage for rfkill
Reply-To: 
In-Reply-To: <1214937876.3462.10.camel@johannes.berg>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3

Dmitry (input layer maintainer) added to CC.  This is a [gross misuse of
the] input layer issue.

On Tue, 01 Jul 2008, Johannes Berg wrote:
> On Tue, 2008-07-01 at 15:41 -0300, Henrique de Moraes Holschuh wrote:
> > On Tue, 01 Jul 2008, Johannes Berg wrote:
> > > > This is very important.  It will caracterize that input pin as either an
> > > > hardware rfkill line, or as an input device (in which case I would be wrong
> > > > when I asked to remove the input support from b43, but one step at a time).
> > > 
> > > Sorry, no, I think I got confused, it should be a hardware rfkill line.
> > 
> > I'd like to have a certain response for this.  Can you test, and assert
> > whether it is a rfkill line or not?
> > 
> > And, if it IS a rfkill line, I still need to know if it is flip-flop-like or
> > not...  I am not certain I got the right idea (I understood it was NOT
> > flip-flop-like).
> 
> No, it's not flip-flop, there's definitely an on/off bit that always
> matches the button/hardware state.

Ok, so based on the above information, here is the sad truth:  B43 has been
buggy all along, and in more ways than I would have expected.

1. That input pin is a hardware rfkill line.  It has to contribute to the
device-wide rfkill class state.  The rfkill API, before my patchset, simply
did NOT support such a thing (but some where in the incorrect impression
that it could, through the input layer.  That's not true).

2. hardware rfkill lines are NOT flip-flop, so if it is ever connected to an
input device, it has to work like a switch.   It has to tell the world
whether it is active or not active.  It doesn't go "pressed/unpressed" to
switch from active to inactive, then "pressed/unpressed" to switch to
inactive back to active (THAT would be a KEY_*).

So, b43 should NEVER have issued KEY_WLAN in the first place.  It should
have asked for a EV_SW SW_WLAN event, added EV_SW SW_WLAN handling to
rfkill-input (for completeness), and used that one instead of KEY_WLAN.

And this has *nothing* to do with rfkill at all.  It is pure input layer
stuff.

For those who are not used to the input layer, the rule is very simple (as
it was explained to me): Input events come from anywhere and evertwhere, and
are all equal.  You are not, and I do mean NOT allowed to have KEY_WLAN
coming from b43 be any more special to the system than KEY_WLAN coming from
a USB keyboard that was plugged into the system.

The entire system fights against you if you try to go against this rule.
Userspace doesn't, as a rule, expect that EV_KEY KEY_FOO from one input
device is to be treated any differently than EV_KEY KEY_FOO from some other
input device.  rfkill-input and other in-kernel input handlers don't,
either.

b43 cannot even add an input handle to trap and update its "emulation of a
switch through KEY_*" state, as it has no way of knowing WHAT userspace or
rfkill-input is going to do with KEY_WLAN in the first place.  What if it is
not a toggle, but rather it is being diverted to launch an application that
asks the user?  What if it is a multi-value selector, that changes state at
every KEY_WLAN event, and has more than two states?

THIS is the reason why the input layer must not EVER be used as an IPC to
propagate state changes, BTW.  Handlers *are* allowed to just ignore events,
for one.

So, unless that input pin in b43 is really a flip-flop and point (1) above
is wrong (thus making most of this email not apply to b43), I see no way to
salvage this mess, at all.

IMO, this all means that the input layer support in b43 has to go.  It is
not the best place to add a EV_SW SW_WLAN-issuing input device anyway, and
userspace will already need to be reconfigured to deal with the fact that
b43 simply cannot issue KEY_WLAN, so it is not even worth the effort to add
a temporary hack to issue such events.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
