Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lana.hrz.tu-chemnitz.de ([134.109.132.3]:50537 "EHLO
	lana.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753501AbYHAUjB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Aug 2008 16:39:01 -0400
From: Stefan Bauer <stefan.bauer@cs.tu-chemnitz.de>
To: rt2400-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
Subject: rt61pci: 2.6.26 Regression: TX/RX LED not flickering anymore
Date: Fri, 1 Aug 2008 22:38:49 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200808012238.49755.stefan.bauer@cs.tu-chemnitz.de> (sfid-20080801_223907_059344_905B2911)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I think there's a little regression somewhere in the driver for the following 
device:

lspci -v
01:04.0 Network controller: RaLink RT2561/RT61 802.11g PCI
        Subsystem: RaLink Unknown device 2561
        Flags: bus master, slow devsel, latency 32, IRQ 10
        Memory at d3060000 (32-bit, non-prefetchable) [size=32K]
        Capabilities: [40] Power Management version 2

The card has 2 LEDs, link and TX/RX. The latter used to flicker nicely on data 
transfer until 2.6.25. With 2.6.26 and 2.6.27-rc1, it's always on.

Configs can be found here:
<http://www-user.tu-chemnitz.de/~stefb/rt61pci_led/2.6.25.13.config>
<http://www-user.tu-chemnitz.de/~stefb/rt61pci_led/2.6.26.config>
<http://www-user.tu-chemnitz.de/~stefb/rt61pci_led/2.6.27-rc1.config>

If any logs are necessary, please tell me.

I would appreciate any hint or patch (against 2.6.26 or .27-rc*), but if there 
isn't any clue what could have caused this I could do a bisect, too (but it 
could take some time).

Regards,
Stefan
