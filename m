Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:49369 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754401AbYJ2V5S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2008 17:57:18 -0400
Date: Wed, 29 Oct 2008 21:51:42 +0000
From: Russell King <rmk+pcmcia@arm.linux.org.uk>
To: Dave <kilroyd@googlemail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
	linux-pcmcia@lists.infradead.org,
	orinoco-devel@lists.sourceforge.net,
	linux-wireless@vger.kernel.org,
	Dominik Brodowski <linux@dominikbrodowski.net>,
	Andrey Borzenkov <arvidjaar@mail.ru>
Subject: Re: [Orinoco-devel] 2.6.28-rc2: new PCMCIA device instance after resume - orinoco can't download firmware
Message-ID: <20081029215142.GA29780@flint.arm.linux.org.uk> (sfid-20081029_225723_291826_B05FB593)
References: <200810282219.51492.arvidjaar@mail.ru> <200810291819.20848.arvidjaar@mail.ru> <4908B03C.400@gmail.com> <200810292143.06027.rjw@sisk.pl> <4908CD44.8070503@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4908CD44.8070503@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 29, 2008 at 08:53:24PM +0000, Dave wrote:
> Looking at the pcmcia code it looks like ds_event is getting a
> CS_EVENT_CARD_INSERTION event. Should we be processing that event ?

You can get that on resume if PCMCIA thinks the card has changed -
and it determines that by comparing its cache of the CIS with what
is in the card on resume.  If the cache doesn't match the CIS, it
assumes the card has changed, and does a remove-insert cycle instead
of resume.

So the question to ask is: why is the card's CIS changing on resume?

Try putting some debug in verify_cis_cache() in drivers/pcmcia/cistpl.c.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
