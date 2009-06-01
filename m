Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:35136 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753429AbZFAMth (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jun 2009 08:49:37 -0400
Date: Mon, 1 Jun 2009 09:49:31 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
	Marcel Holtmann <marcel@holtmann.org>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] rfkill: create useful userspace interface
Message-ID: <20090601124931.GF11011@khazad-dum.debian.net>
References: <1243524688.10632.0.camel@johannes.local> <9b2b86520905310213n7be56260lc0c2cf3c109fe065@mail.gmail.com> <1243763887.19302.29.camel@johannes.local> <1243796509.6570.35.camel@localhost.localdomain> <1243841639.5299.8.camel@johannes.local> <4A238EA2.4040106@tuffmail.co.uk> <20090601122839.GB11011@khazad-dum.debian.net> <1243860230.5299.19.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1243860230.5299.19.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 01 Jun 2009, Johannes Berg wrote:
> > Just don't expose a rfkill type until the first rfkill structure of that
> > type gets registered.  THAT closes all holes in a sensible,
> > principle-of-least-suprise way.  The current code (including the rewrite)
> > already deals with defaults and firmware-backed state storage just fine in
> > that case.   All you need is a full interface that deals with global state
> > hotplug (which ain't difficult, that's one or two more notifications only).
> 
> Global state hotplug is just not really possible to support, and I don't

I used 'expose' for a reason.  You don't expose them to userspace until
there is an user for that type.   You don't even have to hide it again after
the last user gets unregistered...

That's not hotplug as in 'create a new rfkill type for the kernel'.

> think even your original code supported that, since it cannot affect
> previously registered rfkill instances. You definitely don't want to
> hotplug a wireless device and turn off all others "due to that".

You do recall how the 'override system default' machinery worked?  It would
return an error if a rfkill struct of that type had already been registered,
or if a call to set the default for that particular rfkill type had already
happened.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
