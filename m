Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:61094 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753062AbXIOXZw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Sep 2007 19:25:52 -0400
Message-ID: <46EC6A25.2010204@lwfinger.net>
Date: Sat, 15 Sep 2007 18:26:29 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] b43legacy: Fix machine check errors for PPC architecture  with BCM4306/2
References: <46ec18d6.puwbD1oRuPgUil6/%Larry.Finger@lwfinger.net> <200709152147.57431.mb@bu3sch.de> <46EC4844.1060003@lwfinger.net> <200709152358.08887.mb@bu3sch.de>
In-Reply-To: <200709152358.08887.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> 
> There is no such thing as "connected".
> The bit is called "gmode". Why do you change it back to the wrong name?
> The V3 specs are simply _wrong_. It has nothing to do with the backplane
> or anything else like that. The bit just selects between the A-PHY and
> the BG-PHY. Of course, if there is no A-PHY it will obviously machine-check
> on access, if it's selected.
> 
> V3 specs assume that the meaning is "connected", because it was misinterpreted
> to be a "PHY connect" flag. But it really is a "PHY select" flag, to select
> between two different PHYs. If it's enabled, the G-PHY will be selected (and
> the A-PHY otherwise).
> 
> Btw, while we are at it: The V3 specs are wrong regarding the gmode (or connected)
> bit in other areas as well, because there was even more confusion with
> other PHY flags. The PHY specification is pretty broken in the v3 specs.

The critical part of the legacy code in this regard is from phy_calibrate():

        if (phy->type == B43legacy_PHYTYPE_G && phy->rev == 1) {
                b43legacy_wireless_core_reset(dev, 0);
                b43legacy_phy_initg(dev);
                b43legacy_wireless_core_reset(dev, B43legacy_TMSLOW_GMODE);
        }

If phy_initg is going to work correctly, then gmode has to follow the state of the MACCTL_GMODE bit
in MMIO_MACCTL. Apparently GPHYs with rev > 1 do not care about this bit, but the BCM4306/2 does.
The changes can be accomplished by the following patch:

Index: wireless-dev/drivers/net/wireless/b43legacy/main.c
===================================================================
--- wireless-dev.orig/drivers/net/wireless/b43legacy/main.c
+++ wireless-dev/drivers/net/wireless/b43legacy/main.c
@@ -738,8 +738,11 @@ void b43legacy_wireless_core_reset(struc

        macctl = b43legacy_read32(dev, B43legacy_MMIO_MACCTL);
        macctl &= ~B43legacy_MACCTL_GMODE;
-       if (flags & B43legacy_TMSLOW_GMODE)
+       if (flags & B43legacy_TMSLOW_GMODE) {
                macctl |= B43legacy_MACCTL_GMODE;
+               dev->phy.gmode = 1;
+       } else
+               dev->phy.gmode = 0;
        macctl |= B43legacy_MACCTL_IHR_ENABLED;
        b43legacy_write32(dev, B43legacy_MMIO_MACCTL, macctl);
 }

The above patch and a revised comment for the gmode variable will be the contents of V3 of my patch.
I hope that you find it acceptable. In my position as maintainer, I can push stuff through, but I
prefer that you are in agreement.

Larry

