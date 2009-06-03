Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:36875 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753706AbZFCVig (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jun 2009 17:38:36 -0400
Date: Wed, 3 Jun 2009 18:38:35 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
	Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] rfkill: create useful userspace interface
Message-ID: <20090603213835.GC22809@khazad-dum.debian.net>
References: <1243867620.3015.17.camel@localhost.localdomain> <4A23FD91.8020200@tuffmail.co.uk> <1243885494.3015.29.camel@localhost.localdomain> <4A24559D.7010201@tuffmail.co.uk> <1243928308.3192.38.camel@localhost.localdomain> <1243929706.20064.7.camel@johannes.local> <4A24E3E4.1050505@tuffmail.co.uk> <1243932109.3192.73.camel@localhost.localdomain> <20090603041030.GB10464@khazad-dum.debian.net> <1244008862.4145.10.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1244008862.4145.10.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 03 Jun 2009, Marcel Holtmann wrote:
> any user program with proper rights (remember that /dev/rfkill can now
> be controlled by Unix permissions and SELinux) can bring up a specific
> device. That is policy and it belongs in userspace.

If I hardkill (EPO) the devices, I want them to stay hardkilled, and only a
system daemon (if that) should be able to mess with that.

I very much doubt I am the only one who see things that way :-)

I'd like to keep working towards that goal (no, we're not there yet), and
not away from it.

> This of course only works on soft blocked devices. The hard blocked
> devices stay off. And in case of ThinkPads where the button does the
> hard block, you can't bring it back from software.

Yes.  But the rfkill core is also meant to bring some band-aid help to the
devices that the hardware can't kill by itself.  That's good usability.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
