Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:35559 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751180AbZC0OaR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Mar 2009 10:30:17 -0400
Date: Fri, 27 Mar 2009 11:30:08 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: rfkill-input madness
Message-ID: <20090327143007.GA24288@khazad-dum.debian.net> (sfid-20090327_153021_388438_9585E99E)
References: <1238159196.4452.1.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1238159196.4452.1.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 27 Mar 2009, Johannes Berg wrote:
>         ******IMPORTANT******
>         When rfkill-input is ACTIVE, userspace is NOT TO CHANGE THE STATE OF AN RFKILL
>         SWITCH IN RESPONSE TO AN INPUT EVENT also handled by rfkill-input, unless it
>         has set to true the user_claim attribute for that particular switch.  This rule
>         is *absolute*; do NOT violate it.
>         ******IMPORTANT******
>         
>         ...
>         
>         When rfkill-input is not active, userspace must initiate a rfkill status
>         change by writing to the "state" attribute in order for anything to happen.
> 
> 
> How the hell is userspace supposed to know whether rfkill-input is
> active or not? Does anybody fucking care to implement any of this mess
> in userspace?

I think rephrasing that warning to: "set user_claim to 1 on any switches
that you're going to mess with in response to rfkill input events" would be
a LOT better.  I should have written it that way.

The truth is that userspace doestn't have to care about rfkill-input, unless
it is trying to do what rfkill-input is supposed to (i.e. listening to input
events and then trying to update switches), and if it is going to do that,
it needs stuff that I never sent in for review.

Anyway, I got sidetracked because I was Not Happy with the userspace ABI but
couldn't come up with anything better.  Better at least get those patches
into the open.  I just pushed a rebased version of the patches to somewhere
public.

It is at:
git://repo.or.cz/linux-2.6/linux-acpi-2.6/ibm-acpi-2.6.git rfkill

Please take a look and tell me what you think, and whether there is anything
worth bothering with in there (FWIW, the patchset worked just fine last time
I checked).


As for your second question, I have been looking at the issues re. input
devices and X.org evdev in the last two days, and the fact is that: it will
have to be handled in userspace on most non-embedded scenarios, if things
don't change in userspace soon.

The problem is that X.org will exclusive-grab any input devices you let it
touch, and rfkill_input will never see any events, anyway.   So, right now,
for the vast majority of the users, either an input device is not in use, or
it is in exclusive-grab mode feeding X.org evdev.

At this point, I don't have a clue on what would be the best way to go about
addressing this issue, that is causing problems not only to rfkill_input,
but also to anyone who would like to have hotkey handling outside of X.org
in a system daemon, but still have x.org see the keys (without ugly 'event
repeater' hacks).

I have no idea if we should talk to the X.org people to see if we can drop
that exclusive grab?  Allow kernel-side input handlers to ignore exclusive
grabs?  Have rfkill-input be a you-want-it-in-the-kernel solution and simply
don't care at all about userspace interfering with it?

I was about to try to locate someone that deals with evdev to ask his ideas
on the subject.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
