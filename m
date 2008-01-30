Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out02.alice-dsl.net ([88.44.60.12]:13860 "EHLO
	smtp-out02.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbYA3JXZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jan 2008 04:23:25 -0500
Date: Wed, 30 Jan 2008 10:07:03 +0100
From: Andi Kleen <andi@firstfloor.org>
To: jirislaby@gmail.com, linux-wireless@vger.kernel.org,
	ath5k-devel@lists.ath5k.org, linville@tuxdriver.com
Subject: ath5k Kconfig / lspci / pci_device_id consistency
Message-ID: <20080130090703.GA9218@basil.nowhere.org> (sfid-20080130_092331_116838_618C207A)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hallo,

I was pleasantly surprised at first that ath5k has finally made it into mainline.
That is because my laptop has an atheros chipset and in tree support makes
things much easier for me.

Then I noticed that the chips it claims to support in Kconfig

   Currently the following chip versions are supported:

          MAC: AR5211 AR5212
          PHY: RF5111/2111 RF5112/2112 RF5413/2413

did not include the chip on my laptop; an AR5006X according to lspci.

But when I actually look at the driver's pci_device_id table it seems
to be supported. I have

08:0a.0 Class 0200: 168c:001b (rev 01)

which seems to match ath5k/base.c

        { PCI_VDEVICE(ATHEROS, 0x001b), .driver_data = AR5K_AR5212 }, /* 5413 Eagle */

But the name in the comment does not agree with what lspci reports:

08:0a.0 Ethernet controller: Atheros Communications, Inc. AR5006X 802.11abg NIC (rev 01)

So who has the correct name? The comments in the driver or lspci? Or are there
valid aliases?  And can Kconfig be fixed up to include all chips supported by
the driver, preferably with the same names as lspci reports please?

I have not actually tested yet if it really works.

Thanks,
-Andi

