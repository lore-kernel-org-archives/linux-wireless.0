Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:57011 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753456AbXFXIwF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Jun 2007 04:52:05 -0400
Message-ID: <467E3089.2080602@warmcat.com>
Date: Sun, 24 Jun 2007 09:51:21 +0100
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Jiri Benc <jbenc@suse.cz>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [WIP] mac80211: kill mgmt interface
References: <1182418939.10821.8.camel@johannes.berg>	 <20070621143558.68fc8e4a@griffin.suse.cz>	 <1182429920.21939.1.camel@johannes.berg>	 <20070621151441.500d62d5@griffin.suse.cz>	 <20070622154545.29eeebdb@griffin.suse.cz> <467BDCB1.1010604@warmcat.com>	 <1182526221.21939.94.camel@johannes.berg>	 <20070622174953.500817e0@griffin.suse.cz>	 <1182543620.21939.98.camel@johannes.berg>  <467CB691.2090806@warmcat.com>	 <1182581630.21939.105.camel@johannes.berg>  <467CE130.2080306@warmcat.com> <1182635313.21939.122.camel@johannes.berg>
In-Reply-To: <1182635313.21939.122.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:

> Don't get me wrong, I fully support your patches. I can see usefulness
> in what you're doing there, I even based my recent patch-frenzy on top
> of your patches ;) But I'm not fully convinced that this will be the

Thanks for the faith Johannes :-)

> best path for the userspace MLME (in whatever form); I do however think
> that it is the best option for wireless analysis/hacking/... tools or
> something like your penumbra.
> 
>> But Jiri's encapsulation method is an improvement if it can be
>> implemented okay for unassociated interfaces and so on.
> 
> Not convinced; it solves only a minor part of the problem, the hard
> things aren't solved (like that we need to see the decrypted frames that
> would normally be dropped by the kernel). Hence, I don't see any value
> in it by itself without solving the harder parts as well (or better even
> first), when solving that may end up using netlink for frames anyway.

The thing that it buys is allowing injection in a standardized format on
interfaces in any mode.  Currently the fact that a TX packet comes on a
Monitor Mode interface is used to infer the format of it, that it will
have a radiotap header.  That's not too ugly, but allowing
injection/radiotap format packets to be accepted on any interface in any
mode (eg, Master) and to use an ethhdr to determine the structure of the
packet is a bit more general and clean, since that is the job of the
ethhdr everywhere.

> I think what we need to accept is that the long-touted concept of a
> "userspace MLME" isn't really that, while it's dead simple to do
> *everything* in userspace by using a monitor interface with injection
> and then a tun interface that isn't really what we want. We want to push
> parts of the complexity to userspace while still having it
> kernel-assisted for various reasons like performance.

It'll be interesting to see what the genuine primitives are for the MLME
after you are finished ejecting the ioctl type cruft.  I don't have much
idea of what is truly needed as it stands.

-Andy
