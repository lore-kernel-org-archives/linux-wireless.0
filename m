Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from madara.hpl.hp.com ([192.6.19.124]:60372 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933083AbXCHTOY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Mar 2007 14:14:24 -0500
Date: Thu, 8 Mar 2007 11:13:22 -0800
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org,
	netdev <netdev@vger.kernel.org>, Jeff Garzik <jgarzik@pobox.com>,
	Dan Williams <dcbw@redhat.com>,
	Jouni Malinen <jkm@devicescape.com>
Subject: Re: wireless extensions vs. 64-bit architectures
Message-ID: <20070308191322.GA24598@bougret.hpl.hp.com>
Reply-To: jt@hpl.hp.com
References: <1173144447.15891.93.camel@johannes.berg> <20070306171316.GA19669@bougret.hpl.hp.com> <200703061943.07350.mb@bu3sch.de> <20070307020310.GA20466@bougret.hpl.hp.com> <1173364747.14001.7.camel@johannes.berg> <20070308184954.GA24485@bougret.hpl.hp.com> <1173380909.3248.52.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1173380909.3248.52.camel@johannes.berg>
From: Jean Tourrilhes <jt@hpl.hp.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 08, 2007 at 08:08:29PM +0100, Johannes Berg wrote:
> On Thu, 2007-03-08 at 10:49 -0800, Jean Tourrilhes wrote:
> 
> > 	A proper fix would involve forcing the alignement in the
> > kernel. Unfortunately, that would break 64bit->64bit configs. I think
> > I can build a workaround for this in iwlib.
> 
> Not easily I think. You'd have to get something that has a well-defined
> result and see whether padding is present or not. The MAC address might
> be good enough (due to len being 24 instead of the expected 20) though.
> Thing is that it's really hard to figure out (even at runtime) whether
> the kernel and machine are 64 or 32-bits.

	I'm looking into that. The good thing is that we have
redundant information, so we can check that things don't match. It's a
bit more complex because some of those take variable parameters.

> I'd think this is a kernel bug and 32-bit userspace should rightfully be
> able to expect 32-bit aligned structs, no? Actually fixing it in the
> kernel would not be trivial though.

	What we could do is have every 64 bit kernel return things on
a 32 bit boundary, irrespective of userspace used. That would break
current 64 bit userspace.

> johannes

	Thanks !

	Jean

