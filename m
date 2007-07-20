Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fencepost.gnu.org ([140.186.70.10]:36497 "EHLO
	fencepost.gnu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764519AbXGTR5y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jul 2007 13:57:54 -0400
Received: from proski by fencepost.gnu.org with local (Exim 4.60)
	(envelope-from <proski@gnu.org>)
	id 1IBwkv-0006Qg-Ry
	for linux-wireless@vger.kernel.org; Fri, 20 Jul 2007 13:59:09 -0400
Subject: Re: bcm4301: A mac80211 driver using V3 firmware
From: Pavel Roskin <proski@gnu.org>
To: Ehud Gavron <gavron@Wetwork.Net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Broadcom Linux <bcm43xx-dev@lists.berlios.de>,
	wireless <linux-wireless@vger.kernel.org>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	Michael Buesch <mb@bu3sch.de>,
	Larry Finger <larry.finger@lwfinger.net>
In-Reply-To: <46A0E3F2.5080209@Wetwork.Net>
References: <46963C0F.3080104@lwfinger.net>
	 <20070719215801.GB12449@tuxdriver.com> <20070720012714.0dc0298a@morte>
	 <46A01209.4030200@lwfinger.net> <1184906596.9511.42.camel@dv>
	 <20070720134425.GC7428@tuxdriver.com> <1184947521.1962.15.camel@dv>
	 <46A0E3F2.5080209@Wetwork.Net>
Content-Type: text/plain
Date: Fri, 20 Jul 2007 13:57:48 -0400
Message-Id: <1184954268.1962.43.camel@dv>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello, Ehud!

On Fri, 2007-07-20 at 09:33 -0700, Ehud Gavron wrote:

> The USERs don't want to know what card they have or what driver they 
> need or PCI IDs.  That's all stuff that makes them say "Linux Bad, 
> *****s good." (Yeah I know, there's the whole driver moreass there and 
> PCI VENs too) but anyway...

Agreed.

> The driver should have a name that reflects its use and capabilities.

Not necessarily.  End users should be shielded from such details by
distributions.  Do you know the name of the Windows driver for your
network card?  Does it reflect "its use and capabilities"?

Now, if we are talking about power users, who can occasionally recompile
the kernel or install a program not from the distribution, they would be
helped by reasonable names of the drivers.

Also, distribution maintainers would feel better if the drivers are not
renamed, so that /etc/modprobe.d/ doesn't need to be scanned for the old
names on kernel upgrade.

> For example, bcm43xx is a reasonable name.  I don't like it personally 
> because the google links to the site (berlios.de) that tell me that's 
> why I need took a while to find but that's just semantics.

That's not a problem with the name.  If the first hit on Google was some
vomit inducing picture, then maybe.

> bcm43xx_mac80211 is a less reasonable name.  With respect to the coders 
> who have put time into making this usable on by 4306 and almost usable 
> on my 4311 I can say that I appreciate the effort... but the name needs 
> work.
> 
> If I was king of driver package naming, the driver that works with v3 
> and v4 firmware and supports crypto functions would be... 
> broadcom80211bg or bcm80211g
> The driver that only works with v3 (aka bcm43xx) broadcomv3
> The driver that only works with v4 (aka bcm43xx_mac80211) broadcomv4

You take just one aspect (firmware version) and put it into the name.
The original name was also taking just one aspect (802.11 stack).  I
fail to see why your approach it better.  I don't know any other Linux
(or _any_) driver that puts the firmware version into its name.

I believe you are implying that the firmware selection will be a
problem, so you prefer a name that would make it easy to solve that
problem.  But then you are not writing as a user, you are writing as
somebody who has been exposed to some internals.  Ask a random user if
the firmware version should be part of the driver name, and you'll get a
blank stare.

By the way, more information could be put into the module description,
which is shown by modinfo.

> As time advances and bcb43xx_mac80211/broadcomv4 is brought to spec so 
> it works great... its code would be integrated into 
> broadcom80211g/bcm80211g.

Now you put the name of the protocol into the driver, which is again
inconsistent with the existing naming and doesn't scale.  Suppose
802.11a support is fixed, would we need to rename the driver again?  And
that if the driver supports only 802.11b on some card?  Would not the
"80211g" part be misleading?

> That's my thinking.  As a USER.  As a linux advocate and zealot.

See above.  Users should not care about driver names.  If they do, we
have a bigger problem.

-- 
Regards,
Pavel Roskin

