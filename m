Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:39216 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753574AbZFCGB0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jun 2009 02:01:26 -0400
Subject: Re: [PATCH] rfkill: create useful userspace interface
From: Marcel Holtmann <marcel@holtmann.org>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
	Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20090603041030.GB10464@khazad-dum.debian.net>
References: <4A238EA2.4040106@tuffmail.co.uk>
	 <1243858256.5299.14.camel@johannes.local>
	 <1243867620.3015.17.camel@localhost.localdomain>
	 <4A23FD91.8020200@tuffmail.co.uk>
	 <1243885494.3015.29.camel@localhost.localdomain>
	 <4A24559D.7010201@tuffmail.co.uk>
	 <1243928308.3192.38.camel@localhost.localdomain>
	 <1243929706.20064.7.camel@johannes.local> <4A24E3E4.1050505@tuffmail.co.uk>
	 <1243932109.3192.73.camel@localhost.localdomain>
	 <20090603041030.GB10464@khazad-dum.debian.net>
Content-Type: text/plain
Date: Wed, 03 Jun 2009 08:01:02 +0200
Message-Id: <1244008862.4145.10.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Henrique,

> > Forget about this EPO crap. That is just a stupid concept anyway.
> 
> Is it?  So, if I use the _hardware switch_ on my laptop to kill all
> internal radios, it shouldn't be enforced by the OS on extra radios I
> plugged?  Or on shitty internal WLAN cards that doesn't tie properly to
> the mini-pci and mini-pcie hardware kill lines?
> 
> And any userspace PoS program can decide to bring up such radios that
> are not hardware-killed even if I am clearly trying to disable them all?

any user program with proper rights (remember that /dev/rfkill can now
be controlled by Unix permissions and SELinux) can bring up a specific
device. That is policy and it belongs in userspace.

This of course only works on soft blocked devices. The hard blocked
devices stay off. And in case of ThinkPads where the button does the
hard block, you can't bring it back from software.

Regards

Marcel


