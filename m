Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:35764 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755133AbYGBQDF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jul 2008 12:03:05 -0400
Date: Wed, 2 Jul 2008 13:02:58 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Michael Buesch <mb@bu3sch.de>,
	Adel Gadllah <adel.gadllah@gmail.com>,
	linux-wireless@vger.kernel.org, stefano.brivio@polimi.it,
	Larry Finger <larry.finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Ivo van Doorn <ivdoorn@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH/RFC] b43: remove input device usage for rfkill
Message-ID: <20080702160258.GB11309@khazad-dum.debian.net> (sfid-20080702_180309_436913_9771F60E)
References: <20080701225207.GB4292@khazad-dum.debian.net> <1214952993.3462.14.camel@johannes.berg> <20080701235747.GG4292@khazad-dum.debian.net> <1214983270.3462.18.camel@johannes.berg> <1214983918.13270.2.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1214983918.13270.2.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 02 Jul 2008, Johannes Berg wrote:
> > (I've written real input drivers before) but rather that nobody really
> > knows how userspace/kernel interaction wrt. rfkill should work.
> 
> Oh and there's no need to explain on the mailing list, just make sure
> the new rfkill docs are clear wrt. the way forward.

Ok.  Is what we currently have (i.e. what is in -next/wireless-testing)
already enough?  Are there any topics I should try to clarify better on
Documentation/rfkill.txt ?

> Another thing that just occurred to me: it might be nice to have a few
> (per-hardware, global?) LED triggers that can be bound to LEDs and that
> always reflect the state the driver says the radio has (hw-rfkill) or
> the driver is asked to enforce (sw-rfkill)

Well, it should be doable with the new rfkill notify chain.  The chain is
called on every rfkill state change, and it will also get called when global
state changes (I am working on exposing the global state to userspace and
the rest of the kernel, now.  I don't exactly know the best way to go about
it, expect an RFC post soon about it).

So, one could write a separate module (e.g. rfkill-led) that registers with
the notify chain, and feeds the events to as many led triggers as he wants
to.  That would add LED trigger support to every rfkill driver in one go.

You could have different triggers for global states (there is one global
state per switch type), as well as triggers for each individual kill switch,
the notify chain exports enough data (a pointer to the rfkill structure) for
that (and if it doesn't, we ought to fix it so that it will :-) ).

Would "rfkill switch registered" and "rfkill switch unregistered"
notifications on the rfkill notify chain help write something like a led
trigger driver?  If so, I will add them.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
