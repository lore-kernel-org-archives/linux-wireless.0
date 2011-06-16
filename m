Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:43319 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758429Ab1FPOq4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jun 2011 10:46:56 -0400
MIME-Version: 1.0
Date: Thu, 16 Jun 2011 16:44:57 +0200
Message-ID: <BANLkTikXUd8uorD+juMDvFubr3cz+OZnaQ@mail.gmail.com> (sfid-20110616_164711_973544_238988E0)
Subject: Faking MMIO ops? Fooling a driver
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I analyze MMIO dumps of closed source driver and found such a place:
W 2 3855.911536 9 0xb06003fc 0x810 0x0 0
R 2 3855.911540 9 0xb06003fe 0x0 0x0 0
W 2 3855.911541 9 0xb06003fe 0x0 0x0 0

After translation:
 phy_read(0x0810) -> 0x0000
phy_write(0x0810) <- 0x0000

So it's quite obvious, the driver is reading PHY register, masking it
and writing masked value. Unfortunately from just looking at such
place we can not guess the mask driver uses.

I'd like to fake value read from 0xb06003fe to be 0xFFFF.
Is there some ready method for doing such a trick?

Dump comes from Kernel hacking → Tracers → MMIO and ndiswrapper.

-- 
Rafał
