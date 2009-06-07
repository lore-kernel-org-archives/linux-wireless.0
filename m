Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:36686 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750944AbZFGNy6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Jun 2009 09:54:58 -0400
Date: Sun, 7 Jun 2009 10:54:56 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Dan Williams <dcbw@redhat.com>,
	Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
	Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] rfkill: create useful userspace interface
Message-ID: <20090607135456.GE3340@khazad-dum.debian.net>
References: <1243885494.3015.29.camel@localhost.localdomain> <4A24559D.7010201@tuffmail.co.uk> <1243928308.3192.38.camel@localhost.localdomain> <1243929706.20064.7.camel@johannes.local> <4A24E3E4.1050505@tuffmail.co.uk> <1243932109.3192.73.camel@localhost.localdomain> <20090603041030.GB10464@khazad-dum.debian.net> <1244034216.22679.22.camel@localhost.localdomain> <20090603214040.GD22809@khazad-dum.debian.net> <1244089486.4145.33.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1244089486.4145.33.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 04 Jun 2009, Marcel Holtmann wrote:
> > > > > Forget about this EPO crap. That is just a stupid concept anyway.
> > > > 
> > > > Is it?  So, if I use the _hardware switch_ on my laptop to kill all
> > > > internal radios, it shouldn't be enforced by the OS on extra radios I
> > > > plugged?  Or on shitty internal WLAN cards that doesn't tie properly to
> > > > the mini-pci and mini-pcie hardware kill lines?
> > > > 
> > > > And any userspace PoS program can decide to bring up such radios that
> > > > are not hardware-killed even if I am clearly trying to disable them all?
> > > 
> > > You hardkilled.  Of course it should bring down everything.  If you
> > > don't want to hardkill, then disable specific radios via /sys or some
> > > UI.  The hardswitch is the "eject" button.
> > 
> > That's exactly my point.  I want EPO to mean "no, you cannot turn this crap
> > on, GO AWAY" for anyone but root (or whomever SELinux allowed to do it,
> > etc).
> 
> let me repeat, this is what you want and that is policy. Feel free to
> implement that in userspace. Leave such policy out of the kernel.

EPO is not policy, it is functionality.  Entering EPO and going out of
EPO state would be policy, though.

What happens while in EPO state is NOT policy.  The very definition of
EPO is that, once enabled, it cannot be overriden until it is disabled
(and it is usual to have strong rules for how it can be disabled, but
this is not important right now).  EPO is a term from real world
engineering, its meaning is set in stone.

You can remove the EPO functionality and add a "switch all radios off"
and "switch all radios on" accell commands.  But that's all you can do
if you depend on userspace.  It will -not- be EPO.

You can have EPO in the kernel, and have userspace command the kernel to
enter and exit EPO state.

I have more to say on that, and will do so in a separate email, but I
don't have the time to properly compose it right now.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
