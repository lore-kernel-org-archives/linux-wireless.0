Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:43673 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbZFDEUv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Jun 2009 00:20:51 -0400
Subject: Re: [PATCH] rfkill: create useful userspace interface
From: Marcel Holtmann <marcel@holtmann.org>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
	Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20090603213835.GC22809@khazad-dum.debian.net>
References: <1243867620.3015.17.camel@localhost.localdomain>
	 <4A23FD91.8020200@tuffmail.co.uk>
	 <1243885494.3015.29.camel@localhost.localdomain>
	 <4A24559D.7010201@tuffmail.co.uk>
	 <1243928308.3192.38.camel@localhost.localdomain>
	 <1243929706.20064.7.camel@johannes.local> <4A24E3E4.1050505@tuffmail.co.uk>
	 <1243932109.3192.73.camel@localhost.localdomain>
	 <20090603041030.GB10464@khazad-dum.debian.net>
	 <1244008862.4145.10.camel@localhost.localdomain>
	 <20090603213835.GC22809@khazad-dum.debian.net>
Content-Type: text/plain
Date: Thu, 04 Jun 2009 06:20:28 +0200
Message-Id: <1244089228.4145.31.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Henrique,

> > any user program with proper rights (remember that /dev/rfkill can now
> > be controlled by Unix permissions and SELinux) can bring up a specific
> > device. That is policy and it belongs in userspace.
> 
> If I hardkill (EPO) the devices, I want them to stay hardkilled, and only a
> system daemon (if that) should be able to mess with that.
> 
> I very much doubt I am the only one who see things that way :-)
> 
> I'd like to keep working towards that goal (no, we're not there yet), and
> not away from it.

please re-read my reply. The permission of the /dev/rfkill device are up
to the distributions now. They can use UID/GID permissions and also
SELinux to enforce them. However this again is policy that is up to
userspace and we leave it there.

If you don't wanna have anybody else mess with RFKILL states, then
make /dev/rfkill read/write only by root. If you don't wanna have
anybody mess with it, make it read-only for all I care.

And let me repeat this, the concept of EPO is a policy and not something
the kernel should enforce by itself.

> > This of course only works on soft blocked devices. The hard blocked
> > devices stay off. And in case of ThinkPads where the button does the
> > hard block, you can't bring it back from software.
> 
> Yes.  But the rfkill core is also meant to bring some band-aid help to the
> devices that the hardware can't kill by itself.  That's good usability.

And that is again policy that is up to the userspace. If there is no
hard kill-line available, software or band-aid fixes don't help. It is
like putting a sheet of paper over a hole ;)

Regards

Marcel


