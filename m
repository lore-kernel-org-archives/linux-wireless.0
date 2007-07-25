Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [77.235.43.93] ([77.235.43.93]:33150 "EHLO main.fasthost.gr"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750860AbXGYGTw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jul 2007 02:19:52 -0400
Message-ID: <46A6EB79.5040403@debian.org>
Date: Wed, 25 Jul 2007 09:19:37 +0300
From: Faidon Liambotis <paravoid@debian.org>
MIME-Version: 1.0
To: Pavel Roskin <proski@gnu.org>
CC: linux-wireless@vger.kernel.org, hermes@gibson.dropbear.id.au,
	Jouni Malinen <j@w1.fi>
Subject: Re: [PATCH 2.6.23 3/3] [wireless] orinoco: create a Kconfig option  for Prism2
References: <20070722131751.GA3009@void.cube.gr>	 <1185124453.3100.49.camel@mj>  <46A5269F.5050504@debian.org> <1185341420.12322.44.camel@dv>
In-Reply-To: <1185341420.12322.44.camel@dv>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pavel Roskin wrote:
> I'm sorry, but considering your original patch, I just cannot be sure
> that you will get the PCMCIA IDs right.  I cannot be sure I'll get it
> right myself.  It requires a lot of searching and detective work.
We can always begin with the set that is common to both (PCMCIA) drivers.
You're proposing to do nothing but at the same time you say that HostAP 
claims it can support some cards when it actually doesn't, which is a 
rather important bug IMHO.
I understand that you're maintaining orinoco and not hostap but this is 
an issue that affects your "users" too, not to mention the overall 
quality of the kernel.

My patch affected a douzine of PCMCIA IDs, don't you think we can safely 
correct these?

> On the other hand, I haven't heard many complains about the ID clash
> recently.  It seems to me that users learned how to deal with it.
> Distributions do a great job too.  For instance, Fedora renames network
> devices based on the MAC addresses, so the same configuration will work
> with either orinoco of hostap.
> 
> Of course, those who want to run an 802.11b AP know that they should
> choose hostap, but most users don't need that.
You haven't heard many complaints recently because there aren't many 
users recently...

And this is not about network interface names or AP mode.
You may disagree, but IMO HostAP is a *much* better driver for Prism2 
devices in all modes.

And if you have both drivers compiled as modules (as most distributions 
do) you have to either blacklist orinoco or manually unbind the driver 
from the hardware using /sys.

I'm maintaining hostap-utils for Debian and we are shipping a blacklist 
for orinoco for years because of the numerous reports of users who 
weren't be able to use HostAP.
This is suboptimal though, since it breaks (= no driver loaded) when the 
user actually has a Lucent Orinoco card.

I understand your reluctance but I think it's way past the time you 
should have passed Prism2 to HostAP.

Best regards,
Faidon
