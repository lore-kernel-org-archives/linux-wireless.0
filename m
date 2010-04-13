Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42753 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187Ab0DMNPS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Apr 2010 09:15:18 -0400
Date: Tue, 13 Apr 2010 09:11:09 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Ferdinand Rau <RauFerd@web.de>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Bug report: Controller RESET (DMA error) long after connecting
Message-ID: <20100413131108.GB6331@tuxdriver.com>
References: <4375153.331710.1271156960878.JavaMail.fmail@mwmweb085>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4375153.331710.1271156960878.JavaMail.fmail@mwmweb085>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 13, 2010 at 01:09:20PM +0200, Ferdinand Rau wrote:
> Hi,
> 
> I'm on a Dell Vostro 1310 (running Debian testing) using a BCM4312 wireless chip and the firmware retrieved by the b43-fwcutter from git (the debian version didn't work with my card - the upgrade to kernel 2.6.31 only happend recently).
> I basically followed the instructions on this site:
> http://www.linuxwireless.org/en/users/Drivers/b43#fw-b43-lp
> 
> The wireless connection works in principle (can connect to different networks, can ping, can browse), but at some point the following error happens and the connection is reset every few seconds afterwards rendering it unusable:
> > ERROR: Fatal DMA error: 0x00000400, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000
> > Controller RESET (DMA error) ...
> 
> Similar to this thread (?): https://lists.berlios.de/pipermail/bcm43xx-dev/2009-November/006273.html

Chances are that your device will work in PIO mode -- you can try
building a kernel w/ CONFIG_B43_FORCE_PIO.  In 2.6.34, there is code
to switch automatically to PIO mode when such errors are observed.

Hth!

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
