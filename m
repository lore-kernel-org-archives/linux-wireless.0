Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.openmoko.org ([88.198.124.205]:52306 "EHLO
	mail.openmoko.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753880AbZALVN3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Jan 2009 16:13:29 -0500
Date: Mon, 12 Jan 2009 19:13:13 -0200
From: Werner Almesberger <werner@openmoko.org>
To: Dan Williams <dcbw@redhat.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: rfkill: how murderous can it be ?
Message-ID: <20090112211313.GK13290@almesberger.net> (sfid-20090112_221335_712234_92EE3EEA)
References: <20090112191514.GA22112@almesberger.net> <1231788884.28887.4.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1231788884.28887.4.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Williams wrote:
> Instead of putting a bunch of
> complexity in the kernel and drivers that *already* has to be in
> userspace, just punt it out to userspace where it's already done and
> works well.

That's the way I like things :-) Can the information user space may
have to recover include DHCP leases and routes ? I.e., can an rfkill
implementation choose to just restart the network interface ?

Next: what happens while the device is rfkill'ed ? E.g., is it okay to
just remove the interface, so any attempt to configure the interface
while it's rfkill'ed would yield an ENODEV ?

Basically, could rfkill block/unblock semantics just be equivalent to
removal and reloading of the module containing the respective WLAN
device driver ? (Ignoring any response time issues for now.)

- Werner
