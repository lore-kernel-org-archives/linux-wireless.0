Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp4-g21.free.fr ([212.27.42.4]:57703 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750761Ab0HOS1L (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Aug 2010 14:27:11 -0400
Date: Sun, 15 Aug 2010 20:27:00 +0200 (CEST)
From: dimitri.gorokhovik@free.fr
To: linville@tuxdriver.com, stefano.brivio@polimi.it
Cc: linux-wireless@vger.kernel.org
Message-ID: <1944322236.136661281896820874.JavaMail.root@zimbra3-e1.priv.proxad.net>
In-Reply-To: <1682961998.136221281896329090.JavaMail.root@zimbra3-e1.priv.proxad.net>
Subject: [PATCH]: b43: is there such a thing as radio 0x2062 rev 2?
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On a DELL D630 with BCM4312 (low-power PHY 4e4:4315 rev 01), I was able to fix the problem:

Aug 15 17:14:45 dimitri kernel: b43-phy0 debug: RC calib: Failed to switch to channel 7, error = -5

by bumping the radio's version (0x2062 rev 2) to 0x2063 (kept rev 2). 

Before the fix, the hardware detected as:

Aug 15 17:14:45 dimitri kernel: b43-phy0: Broadcom 4312 WLAN found (core revision 15)
Aug 15 17:14:45 dimitri kernel: b43-phy0 debug: Found PHY: Analog 6, Type 5, Revision 1
Aug 15 17:14:45 dimitri kernel: b43-phy0 debug: Found Radio: Manuf 0x17F, Version 0x2062, Revision 2

The problem manifested itself (permanently) as:

Aug 15 18:18:10 dimitri kernel: b43-phy0: Loading firmware version 478.104 (2008-07-01 00:50:23)
Aug 15 18:18:10 dimitri kernel: b43-phy0 debug: b2062: Using crystal tab entry 19200 kHz.
Aug 15 18:18:10 dimitri kernel: b43-phy0 debug: RC calib: Failed to switch to channel 7, error = -5


The patch follows, tested on 2.6.32.18 and 2.6.35.2, both built for x86_64.

---
b43: Bump the radio version 0x2063-rev-2 to 0x2063. 

Signed-off-by: <dimitri.gorokhovik@free.fr>
---
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 7965b70..d245a23 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -4084,6 +4084,7 @@ static int b43_phy_versioning(struct b43_wldev *dev)
        case B43_PHYTYPE_LP:
                if (radio_ver != 0x2062 && radio_ver != 0x2063)
                        unsupported = 1;
+		radio_ver += radio_rev > 1;
                break;
        default:
                B43_WARN_ON(1);
