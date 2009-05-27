Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:57913 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754940AbZE0TVD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 May 2009 15:21:03 -0400
Date: Wed, 27 May 2009 16:21:00 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Will Keaney <keaneyw@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [PATCH v11] rfkill: rewrite
Message-ID: <20090527192100.GD14440@khazad-dum.debian.net>
References: <1242942720.4212.19.camel@johannes.local> <1243068246.4606.45.camel@johannes.local> <4A1BDE51.7020009@gmail.com> <20090526131533.GA3932@tuxdriver.com> <20090527025516.GC22235@khazad-dum.debian.net> <1243405682.26933.0.camel@johannes.local> <20090527140020.GA14440@khazad-dum.debian.net> <1243434258.4170.6.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1243434258.4170.6.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 27 May 2009, Johannes Berg wrote:
> On Wed, 2009-05-27 at 11:00 -0300, Henrique de Moraes Holschuh wrote:
> > I need that userspace interface (writes to the state attribute) in place and
> > working.  It _is_ a big regression for thinkpad-acpi to have it return
> > -EOPNOTSUPP.
> 
> You're free to implement a sane API -- I don't think the current API is
> feasible because we need to be able to set the soft state regardless of
> the hard state, query each state separately, and ideally poll the

Well, the "state" attribute doesn't get in the way for that.  Only
expectations that it would REMAIN on a given soft state do, and that's
implied nowhere in the "state" attribute ABI.  Those assurances were never
made, and even "claim" wouldn't be able to pull them off.

And you can simply error out if the request to change radio state fails
because of EPO or hard-blocking, nobody said it has to always work.

So can we get that?   I don't want to touch the "claim" stuff, I too think
it is not a good way of doing things, and it is not really used by anyone.

Writes to "state" would still merge well with the new core way of doing
things: you return -EPERM if in EPO mode, otherwise you try to change the
radio state to the requested state, and error out if you can't.  It is that
simple.  You can return -EACCESS if the state change failed due to
hard-block for bonus points, but that certainly isn't required.

> I was suggesting earlier today to John that it might make sense to
> create a character device for each rfkill instance so that you can
>  * read soft/hard state from it
>  * while the device is open for write, that's the equivalent of
>    user_claim
>  * you can poll() the fd for the device instead of having to listen to
>    the stupid uevents

Hmm, you CAN poll() sysfs, you know?  The API is atrocious, but it is there.
Thinkpad-ACPI implements this on some of its driver-specific attributes.

We could add poll() support for "state", actually.  The crap about this is
that userspace needs an out-of-band way to be able to know if poll() is
there for a given sysfs attribute, as it doesn't get an error if the support
is not there and just waits for events that will never arrive (who makes up
these half-baked PoS interfaces?)

That said, I don't have anything against the char device.  Just don't remove
the simple "state" attribute if you end up switching to, say, netlink or
IOCTL.

And truth to be told, you will need a deprecation period if you want to move
away from "state".  It is in-use ABI, so it is covered by the stable ABI
policy.

> Without user_claim userspace can have no expectation of actually having
> control over the state attribute. If your userspace tools do not always
> user_claim before I believe they are broken.

Nevertheless, it works and people use it.  They don't care if a hotkey will
change the state (in fact, they probably WANT it to).  It is used as "turn
off this crap now" and "turn it back on now".  Not "keep it off" and "keep
it on".  Since very little stuff touches it, it ends up being predictable,
and thus, useful.

So can I please have writes to "state" back?  Unlike the other stuff that
never worked quite right (like "claim" -- btw it DID work right with
thinkpad-acpi and rfkill-input :-) ), it is in active use.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
