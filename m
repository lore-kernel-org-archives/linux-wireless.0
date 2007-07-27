Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:52677 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757407AbXG0JTD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jul 2007 05:19:03 -0400
Subject: Re: [PATCH] bcm43xx-mac80211: Fix specs typo for baseband  attenuation
From: David Woodhouse <dwmw2@infradead.org>
To: Larry Finger <larry.finger@lwfinger.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Bcm43xx-dev@lists.berlios.de,
	Michael Buesch <mb@bu3sch.de>
In-Reply-To: <46A8ECD6.30204@lwfinger.net>
References: <46a8ccbd.wNQamvQ9e0RJ0XZK%Larry.Finger@lwfinger.net>
	 <20070726172138.GA6068@tuxdriver.com> <46A8E044.6080206@lwfinger.net>
	 <20070726181334.GB6068@tuxdriver.com>  <46A8ECD6.30204@lwfinger.net>
Content-Type: text/plain
Date: Fri, 27 Jul 2007 10:18:52 +0100
Message-Id: <1185527932.14697.535.camel@pmac.infradead.org>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2007-07-26 at 13:49 -0500, Larry Finger wrote:
> No matter, the change is needed to make some older cards work. Now I
> know why bcm43xx-mac80211 never worked on my BCM4306 until today. 

Hm, it has worked for me in the past, and your patch fixes it so it
works again (at least as well as it ever did).

I still get constant complaints of 'eth1: duplicate address detected'
due to the fact that it sees its own outgoing packets, and IPv6 doesn't
work.

Then when unloading the module I get...

bcm43xx_mac80211: Radio turned off
Freeing alive inet6 address c1cefc80
unregister_netdevice: waiting for eth1 to become free. Usage count = 2


... and I have to reboot before anything related to networking works
again. When I unload the module from X rather than from a vt, the
machine sometimes locks up hard -- which I suspect is a different
problem, but I have no clue what.

-- 
dwmw2

