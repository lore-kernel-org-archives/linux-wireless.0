Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:45266 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751926Ab3ILKt5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Sep 2013 06:49:57 -0400
Message-ID: <52319C4D.6030803@hauke-m.de> (sfid-20130912_125000_701001_5987B93B)
Date: Thu, 12 Sep 2013 12:49:49 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: Broadcom PCI ID 14e4:4313 reuse?
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arend,

In OpenWrt someone reported that he has a BCM4313 with the PCI id
14e4:4313 [0]. The b43 wiki [1] says this was used for a BCM4311 with
just ieee80211a support.

Is it correct that BCM4313 also uses this PCI id, this chip was was
directly soldered onto a router? Is the b43 wiki wrong and 14e4:4313 was
not used for the BCM4311 or was this PCI id reused for a different device?

I am planing to prepare a patch adding support for a BCM4313 with the
PCI ID of 14e4:4313 and I will ignore that there could be some BCM4311
with this PCI id.

Log of BCM4313:

[    0.316000] pci 0000:01:00.0: [14e4:4313] type 00 class 0x028000
(...)
[   10.616000] PCI: Enabling device 0000:01:00.0 (0000 -> 0002)
[   10.624000] bcma: bus0: Found chip with id 0x4313, rev 0x01 and
package 0x08
[   10.628000] bcma: bus0: Core 0 found: ChipCommon (manuf 0x4BF, id
0x800, rev 0x24, class 0x0)
[   10.640000] bcma: bus0: Core 1 found: IEEE 802.11 (manuf 0x4BF, id
0x812, rev 0x18, class 0x0)
[   10.648000] bcma: bus0: Core 2 found: PCIe (manuf 0x4BF, id 0x820,
rev 0x11, class 0x0)
[   10.656000] bcma: bus0: Using fallback SPROM failed (err -2)
[   10.660000] bcma: bus0: No SPROM available
[   10.676000] bcma: bus0: Bus registered
[   11.040000] b43-phy0: Broadcom 4313 WLAN found (core revision 24)
[   11.048000] b43-phy0 ERROR: FOUND UNSUPPORTED PHY (Analog 10, Type 8
(LCN), Revision 1)


[0]: https://dev.openwrt.org/ticket/13551
[1]: http://wireless.kernel.org/en/users/Drivers/b43

Hauke
