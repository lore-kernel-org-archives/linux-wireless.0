Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:59092 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752444AbZFGPg3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Jun 2009 11:36:29 -0400
Subject: Re: [PATCH] rfkill: create useful userspace interface
From: Marcel Holtmann <marcel@holtmann.org>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Dan Williams <dcbw@redhat.com>,
	Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
	Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20090607135456.GE3340@khazad-dum.debian.net>
References: <1243885494.3015.29.camel@localhost.localdomain>
	 <4A24559D.7010201@tuffmail.co.uk>
	 <1243928308.3192.38.camel@localhost.localdomain>
	 <1243929706.20064.7.camel@johannes.local> <4A24E3E4.1050505@tuffmail.co.uk>
	 <1243932109.3192.73.camel@localhost.localdomain>
	 <20090603041030.GB10464@khazad-dum.debian.net>
	 <1244034216.22679.22.camel@localhost.localdomain>
	 <20090603214040.GD22809@khazad-dum.debian.net>
	 <1244089486.4145.33.camel@localhost.localdomain>
	 <20090607135456.GE3340@khazad-dum.debian.net>
Content-Type: text/plain
Date: Sun, 07 Jun 2009 17:36:01 +0200
Message-Id: <1244388961.23850.93.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Henrique,

> > > > > > Forget about this EPO crap. That is just a stupid concept anyway.
> > > > > 
> > > > > Is it?  So, if I use the _hardware switch_ on my laptop to kill all
> > > > > internal radios, it shouldn't be enforced by the OS on extra radios I
> > > > > plugged?  Or on shitty internal WLAN cards that doesn't tie properly to
> > > > > the mini-pci and mini-pcie hardware kill lines?
> > > > > 
> > > > > And any userspace PoS program can decide to bring up such radios that
> > > > > are not hardware-killed even if I am clearly trying to disable them all?
> > > > 
> > > > You hardkilled.  Of course it should bring down everything.  If you
> > > > don't want to hardkill, then disable specific radios via /sys or some
> > > > UI.  The hardswitch is the "eject" button.
> > > 
> > > That's exactly my point.  I want EPO to mean "no, you cannot turn this crap
> > > on, GO AWAY" for anyone but root (or whomever SELinux allowed to do it,
> > > etc).
> > 
> > let me repeat, this is what you want and that is policy. Feel free to
> > implement that in userspace. Leave such policy out of the kernel.
> 
> EPO is not policy, it is functionality.  Entering EPO and going out of
> EPO state would be policy, though.
> 
> What happens while in EPO state is NOT policy.  The very definition of
> EPO is that, once enabled, it cannot be overriden until it is disabled
> (and it is usual to have strong rules for how it can be disabled, but
> this is not important right now).  EPO is a term from real world
> engineering, its meaning is set in stone.
> 
> You can remove the EPO functionality and add a "switch all radios off"
> and "switch all radios on" accell commands.  But that's all you can do
> if you depend on userspace.  It will -not- be EPO.
> 
> You can have EPO in the kernel, and have userspace command the kernel to
> enter and exit EPO state.

I fully disagree with you here and your concept of EPO and how it is
suppose to work is fully flawed. EPO is a policy and if you define it as
all radios go off, then that is fine, but again it is your policy. It is
not mine and with us two disagreeing on this, it makes it clear that it
should not be done inside the kernel.

In addition to that, the EPO only works if your RFKILL lines are
actually hardwired in system. If it involves any kind of software
besides firmware (that includes ACPI to some sort) it makes no
difference whatsoever.

Also there is no problem in doing this in userspace and have proper
enforcement for this. I did mention Unix access rights and SELinux
before and the same applies here. If you wanna enforce EPO on all soft
kill states, then you have to build your system the right way. And you
certainly can do this now with /dev/rfkill.

Regards

Marcel


