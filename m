Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:59121 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751782AbZC3RVh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2009 13:21:37 -0400
Date: Mon, 30 Mar 2009 14:21:31 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: rfkill-input madness
Message-ID: <20090330172131.GA23749@khazad-dum.debian.net> (sfid-20090330_192140_703078_63F3FD61)
References: <1238159196.4452.1.camel@johannes.local> <20090327143007.GA24288@khazad-dum.debian.net> <1238188237.4452.17.camel@johannes.local> <20090328005214.GA7439@khazad-dum.debian.net> <1238262651.4217.21.camel@johannes.local> <20090330132344.GA11934@khazad-dum.debian.net> <1238422292.5970.9.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1238422292.5970.9.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 30 Mar 2009, Johannes Berg wrote:
> On Mon, 2009-03-30 at 10:23 -0300, Henrique de Moraes Holschuh wrote:
> > On Sat, 28 Mar 2009, Johannes Berg wrote:
> > > Ok so you want to add "global" states mostly -- that's fine, but not all
> > > that useful since userspace cannot really claim globally. I also don't
> > > see a point -- if userspace wanted to do global stuff it might just as
> > > well do nothing.
> > 
> > The point of doing global stuff is to do rfkill-input in userspace, the way
> > userspace might want to do it.
> > 
> > Without the global state being exposed, userspace really can't do anything
> > properly, and rfkill-input is needed for any semblance of good rfkill input
> > event handling.
> 
> Right -- but I've been wondering about those global states completely. I
> still need to look at input.c in more detail though. It seems that it
> can trivially get out of sync, if for example a global event turns _all_
> radios off, but then a wlan event turns wlan back on, and then what's
> the state of the "all" switch?

Here's what is (was :-) ) in rfkill-input:

1. There are per-type global switches (and no "all" switch)
2. There is a flag, EPO (emergency power off).

rfkill-input translates any "EV_SW SW_RFKILL_ALL ACTIVE" events into "enable
EPO".  It saves the states of the switches beforehand, so that it can
optionally restore them.

When something enables the EPO, all switches go into block.  And they refuse
to go out of block until the EPO flag is cleared.   I.e. it has the proper
semanthics for a safety device.

What happens when you clear EPO isn't much.  The rfkill core doesn't care
much, all that it knows is that switches are not prohibited to go out of
block anymore once the EPO flag is clear.

rfkill-input, OTOH, can be configured to do one of three things when it gets
"EV_SW SW_RFKILL_ALL INACTIVE":

1. just clear the EPO flag (the user will have to go and manually unblock
the switches through sysfs or normal events that rfkill-input processes)

2. clear the EPO flag, and restore the global switches to the state previous
to the EPO

3. clear the EPO, and unblock all switches.


So, there is NOT an "all" switch.  But there is the handling of the
SW_RFKILL_ALL event by rfkill-input.

> > I can't say I strongly want it, since I am happy enough with rfkill-input,
> > though.  But the API to userspace _is_ incomplete if the global states and
> > global functionality are not exposed.
> 
> I've kinda removed the entire userspace API part from rfkill, mostly out
> of laziness (so I guess I'll add it back) but also because I don't quite
> see the point. Has anyone come up with a usecase for it?

I'd talk that over with our Network Manager maintainer, he is the one who
might want it.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
