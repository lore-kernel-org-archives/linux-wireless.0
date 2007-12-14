Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:1706 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753653AbXLNTLV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Dec 2007 14:11:21 -0500
Subject: Can we please schedule orinoco_pci for removal?
From: Pavel Roskin <proski@gnu.org>
To: linux-wireless <linux-wireless@vger.kernel.org>,
	orinoco-devel <orinoco-devel@lists.sourceforge.net>
Content-Type: text/plain
Date: Fri, 14 Dec 2007 14:11:18 -0500
Message-Id: <1197659478.1539.23.camel@dv> (sfid-20071214_191124_898780_3F294D27)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello!

Examples of other drivers have convinced me that orinoco_pci should be
removed from the kernel.  It's superseded by hostap_pci.  Those replying
on orinoco_pci should look at hostap_pci now and make sure that it's
working for them.

orinoco_pci supports Prism 2.5/3 chipset only, so the support for other
related chipsets (Agere and Symbol) is useless for that driver.
Considering that all hostap drivers are Prism-only, orinoco_pci and
hostap_pci support exactly the same hardware.

Other backends for Orinoco deal with PCMCIA cards, inserted (or even
soldered) into proper PCMCIA adapters or into some less capable
replacements.  PCI cards are real 32-bit PCI devices, and stand apart to
a certain degree.  I think it would be useful if Orinoco driver
concentrates on supporting 16-bit PCMCIA cards.  That can possibly
include Orinoco USB.  There is still work to be done in that direction.

Let's not turn this discussion into another discussion whether Orinoco
should give up all Prism IDs in all drivers.  It's not as trivial as it
seems to some, as some cards can only be recognized by the firmware
version.  I'm aware of the problem.  It's a different issue.

So, what timeframe for orinoco_pci removal from the kernel would be
reasonable?

-- 
Regards,
Pavel Roskin
