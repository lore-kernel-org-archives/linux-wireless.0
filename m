Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:59111 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750780AbZFAR4d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jun 2009 13:56:33 -0400
Date: Mon, 1 Jun 2009 14:56:31 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
	Marcel Holtmann <marcel@holtmann.org>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] rfkill: create useful userspace interface
Message-ID: <20090601175631.GB24704@khazad-dum.debian.net>
References: <20090601122839.GB11011@khazad-dum.debian.net> <1243859931.5299.17.camel@johannes.local> <20090601124553.GE11011@khazad-dum.debian.net> <1243860606.5299.21.camel@johannes.local> <20090601133351.GI11011@khazad-dum.debian.net> <1243866545.5299.25.camel@johannes.local> <20090601153620.GB15485@khazad-dum.debian.net> <1243870669.5299.29.camel@johannes.local> <20090601155020.GC15485@khazad-dum.debian.net> <1243871606.5299.30.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1243871606.5299.30.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 01 Jun 2009, Johannes Berg wrote:
> On Mon, 2009-06-01 at 12:50 -0300, Henrique de Moraes Holschuh wrote:
> > Yes, it "calls itself" right now... so I can certainly do that :)
> > 
> > However, the in-driver shortcut means I give rfkill a kick and say "the soft
> > state has changed, deal with it", instead of "please change the state" which
> > it might deny due to EPO, etc.
> 
> But ... now I'm confused ... why would the driver ever ask to change the
> state? Sounds like something that should be a button instead.

I have a stable userspace ABI that exposes a sysfs control that the user can
use to enable/disable bluetooth and wwan.  I need that thing to remain
working well for at least one more year before I can try to remove it.

And right now, it ignores EPO since such state change do not go through the
rfkill core (this is not a regression, but might as well get it fixed now
that I expect rfkill to see more and more usage).

Before you ask, thinkpad-acpi enable/disable radio support predates the
existence of the rfkill subsystem (it was called ibm-acpi back then), this
is the reason for the driver-specific way of enabling/disabling radios.

Anyway, this sort of stuff it is not an input device (and it is not supposed
to be subject to the whims of userspace hotkey processing to begin with), so
it can't go over the input layer.  That, and I have no desire to attempt to
get EV_SW SW_BLUETOOTH and EV_SW SW_WWAN past Dmitri without a good reason
(such as a device that actually has those switches...).

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
