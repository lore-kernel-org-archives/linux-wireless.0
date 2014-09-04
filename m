Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:52127 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755358AbaIDWjn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Sep 2014 18:39:43 -0400
Received: from mfilter20-d.gandi.net (mfilter20-d.gandi.net [217.70.178.148])
	by relay5-d.mail.gandi.net (Postfix) with ESMTP id B09B741C054
	for <linux-wireless@vger.kernel.org>; Fri,  5 Sep 2014 00:39:40 +0200 (CEST)
Received: from relay5-d.mail.gandi.net ([217.70.183.197])
	by mfilter20-d.gandi.net (mfilter20-d.gandi.net [10.0.15.180]) (amavisd-new, port 10024)
	with ESMTP id EiUdcSgcHvUF for <linux-wireless@vger.kernel.org>;
	Fri,  5 Sep 2014 00:39:39 +0200 (CEST)
Received: from nuvo (mon69-7-83-155-44-161.fbx.proxad.net [83.155.44.161])
	(Authenticated sender: hadess@hadess.net)
	by relay5-d.mail.gandi.net (Postfix) with ESMTPSA id 4C5D641C05A
	for <linux-wireless@vger.kernel.org>; Fri,  5 Sep 2014 00:39:39 +0200 (CEST)
Message-ID: <1409870378.19259.9.camel@hadess.net> (sfid-20140905_003947_779284_B3660241)
Subject: Broadcom Wi-Fi/Bluetooth on GPIO? (Baytrail tablet)
From: Bastien Nocera <hadess@hadess.net>
To: linux-wireless@vger.kernel.org
Date: Fri, 05 Sep 2014 00:39:38 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Heya,

On this tablet, based on a Baytrail SoC, I found reference of this
Broadcom device in the DSDT, and I believe it could be the
Bluetooth/Wi-Fi chipset (this one[1]?):
---8<---
Device (BRC3)
{
    Name (_ADR, One)  // _ADR: Address
    Name (_DEP, Package (0x01)  // _DEP: Dependencies
    {
        GPO2
    })
    Name (_HID, "BCM4321")  // _HID: Hardware ID 
    Name (_CID, "BCM43241")  // _CID: Compatible ID
    Name (GMOD, ResourceTemplate ()
    {
        GpioIo (Exclusive, PullDefault, 0x0000, 0x0000,
IoRestrictionOutputOnly,
            "\\_SB.GPO2", 0x00, ResourceConsumer, ,
            )
            {   // Pin list 
                0x0014
            }
    })
---8<---

Am I correct in thinking that it's a Broadcom chipset? What would it
take to get this supported in the kernel? I'm currently stuck on a
slightly older kernel (3.16.0) due to Intel graphics driver problems,
but I couldn't find anything directly related to this in the current
linus tree.

Cheers

[1]:
http://www.broadcom.com/products/Wireless-LAN/802.11-Wireless-LAN-Solutions/BCM43241

