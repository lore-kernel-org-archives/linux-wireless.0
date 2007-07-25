Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fencepost.gnu.org ([140.186.70.10]:33368 "EHLO
	fencepost.gnu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757949AbXGYQcb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jul 2007 12:32:31 -0400
Received: from proski by fencepost.gnu.org with local (Exim 4.60)
	(envelope-from <proski@gnu.org>)
	id 1IDjoT-0001o3-Er
	for linux-wireless@vger.kernel.org; Wed, 25 Jul 2007 12:34:13 -0400
Subject: Re: [PATCH 2.6.23 3/3] [wireless] orinoco: create a Kconfig option  for Prism2
From: Pavel Roskin <proski@gnu.org>
To: Faidon Liambotis <paravoid@debian.org>
Cc: linux-wireless@vger.kernel.org, hermes@gibson.dropbear.id.au,
	Jouni Malinen <j@w1.fi>
In-Reply-To: <46A6EB79.5040403@debian.org>
References: <20070722131751.GA3009@void.cube.gr>
	 <1185124453.3100.49.camel@mj>  <46A5269F.5050504@debian.org>
	 <1185341420.12322.44.camel@dv>  <46A6EB79.5040403@debian.org>
Content-Type: text/plain
Date: Wed, 25 Jul 2007 12:32:24 -0400
Message-Id: <1185381144.3236.12.camel@dv>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2007-07-25 at 09:19 +0300, Faidon Liambotis wrote:
> Pavel Roskin wrote:
> > I'm sorry, but considering your original patch, I just cannot be sure
> > that you will get the PCMCIA IDs right.  I cannot be sure I'll get it
> > right myself.  It requires a lot of searching and detective work.
> We can always begin with the set that is common to both (PCMCIA) drivers.
> You're proposing to do nothing but at the same time you say that HostAP 
> claims it can support some cards when it actually doesn't, which is a 
> rather important bug IMHO.
> I understand that you're maintaining orinoco and not hostap but this is 
> an issue that affects your "users" too, not to mention the overall 
> quality of the kernel.

I understand, but I don't have all possible cards, and I depend on what
users are reporting.  In absence of reports, I prefer to work on things
I can actually test.

> My patch affected a douzine of PCMCIA IDs, don't you think we can safely 
> correct these?

0156:0002 alone is going to be a big headache.  Basically, you would
need to replace it with textual IDs for all Lucent cards and remove the
numeric ID.

> > On the other hand, I haven't heard many complains about the ID clash
> > recently.  It seems to me that users learned how to deal with it.
> > Distributions do a great job too.  For instance, Fedora renames network
> > devices based on the MAC addresses, so the same configuration will work
> > with either orinoco of hostap.
> > 
> > Of course, those who want to run an 802.11b AP know that they should
> > choose hostap, but most users don't need that.
> You haven't heard many complaints recently because there aren't many 
> users recently...
> 
> And this is not about network interface names or AP mode.
> You may disagree, but IMO HostAP is a *much* better driver for Prism2 
> devices in all modes.

Well, I agree that there are many things in hostap that are not in
orinoco, such as firmware download and WPA.

> And if you have both drivers compiled as modules (as most distributions 
> do) you have to either blacklist orinoco or manually unbind the driver 
> from the hardware using /sys.

The later is true for the drivers compiled into the kernel as well.

> I'm maintaining hostap-utils for Debian and we are shipping a blacklist 
> for orinoco for years because of the numerous reports of users who 
> weren't be able to use HostAP.
> This is suboptimal though, since it breaks (= no driver loaded) when the 
> user actually has a Lucent Orinoco card.

I agree, that's suboptimal.

> I understand your reluctance but I think it's way past the time you 
> should have passed Prism2 to HostAP.

I actually hoped that some userspace solution would appear that would
make it unnecessary to handle it in the drive.

-- 
Regards,
Pavel Roskin

