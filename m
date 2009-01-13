Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:54274 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751082AbZAMPSJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jan 2009 10:18:09 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Werner Almesberger <werner@openmoko.org>
Subject: Re: rfkill: how murderous can it be ?
Date: Tue, 13 Jan 2009 16:17:31 +0100
Cc: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org
References: <20090112191514.GA22112@almesberger.net> <1231788884.28887.4.camel@localhost.localdomain> <20090112211313.GK13290@almesberger.net>
In-Reply-To: <20090112211313.GK13290@almesberger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200901131617.31618.mb@bu3sch.de> (sfid-20090113_161814_333568_7E55354C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 12 January 2009 22:13:13 Werner Almesberger wrote:
> Dan Williams wrote:
> > Instead of putting a bunch of
> > complexity in the kernel and drivers that *already* has to be in
> > userspace, just punt it out to userspace where it's already done and
> > works well.
> 
> That's the way I like things :-) Can the information user space may
> have to recover include DHCP leases and routes ? I.e., can an rfkill
> implementation choose to just restart the network interface ?
> 
> Next: what happens while the device is rfkill'ed ? E.g., is it okay to
> just remove the interface, so any attempt to configure the interface
> while it's rfkill'ed would yield an ENODEV ?
> 
> Basically, could rfkill block/unblock semantics just be equivalent to
> removal and reloading of the module containing the respective WLAN
> device driver ? (Ignoring any response time issues for now.)

No. If you are in an rfkill situation, you're not required to kill the receiver.
(However, currently most (all?) devices kill both TX and RX).
So I think completely killing the interface is the wrong way to go.

And I don't think we should care about stuff above the MAC layer, too.
If the user hits rfkill, he should _expect_ all upper layer connections
to break (DHCP, TCP or whatever). That's a basic assumption about rfkill.
The default timeouts will handle that just fine.
In any way, this is nothing the kernel has to care about. It's userspace business, if any.

-- 
Greetings, Michael.
