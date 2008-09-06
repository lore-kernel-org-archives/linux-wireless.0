Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from Viola.Opus1.COM ([192.245.12.8]:3348 "EHLO Viola.Opus1.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750823AbYIFEiH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Sep 2008 00:38:07 -0400
Received: from [172.17.0.188] ([61.8.118.66])
 by Opus1.COM (PMDF V6.2-X27 #9830) with ESMTPSA id
 <01MZ7U16R87K8YG025@Opus1.COM> for linux-wireless@vger.kernel.org; Fri,
 05 Sep 2008 21:38:03 -0700 (MST)
Date: Fri, 05 Sep 2008 21:38:00 -0700
From: gavron@wetwork.net
Subject: Re: Speed enhancement for BCM4306/2
In-reply-to: <48C1BA91.7050106@lwfinger.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Broadcom Wireless <bcm43xx-dev@berlios.de>,
	wireless <linux-wireless@vger.kernel.org>
Message-id: <48C20928.10202@wetwork.net> (sfid-20080906_063820_556844_9FAEB4A9)
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
References: <48C1BA91.7050106@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Is this close? 

E
--- /tmp/phy_g.c    2008-09-05 21:06:57.000000000 -0700
+++ phy_g.c    2008-09-05 21:36:18.000000000 -0700
@@ -2198,7 +2198,7 @@
     else
         b43_phy_initb6(dev);
 
-    if (phy->rev >= 2 || phy->gmode)
+    if (phy->rev >= 2 && phy->gmode)
         b43_phy_inita(dev);
 
     if (phy->rev >= 2) {
@@ -2216,9 +2216,9 @@
     if (phy->gmode || phy->rev >= 2) {
         tmp = b43_phy_read(dev, B43_PHY_VERSION_OFDM);
         tmp &= B43_PHYVER_VERSION;
-        if (tmp == 3 || tmp == 5) {
+        if (tmp == 4 || tmp == 5) {
             b43_phy_write(dev, B43_PHY_OFDM(0xC2), 0x1816);
-            b43_phy_write(dev, B43_PHY_OFDM(0xC3), 0x8006);
+            b43_phy_write(dev, B43_PHY_OFDM(0xC3), 0x8606);
         }
         if (tmp == 5) {
             b43_phy_write(dev, B43_PHY_OFDM(0xCC),
@@ -2226,7 +2226,7 @@
                        & 0x00FF) | 0x1F00);
         }
     }
-    if ((phy->rev <= 2 && phy->gmode) || phy->rev >= 2)
+    if ((phy->rev >=2)
         b43_phy_write(dev, B43_PHY_OFDM(0x7E), 0x78);
     if (phy->radio_rev == 8) {
         b43_phy_write(dev, B43_PHY_EXTG(0x01),


Larry Finger wrote:
> I recently found some places where the G-PHY initialization 
> specifications were wrong. I updated the relevant parts of the V3 
> specifications at http://bcm-specs.sipsolutions.net - the pages for 
> GPHY, B6PHY and B5PHY were changed.
>
> When I prepared a patch containing these changes, the speed of the 
> BCM4306/2 for OFDM rates more than doubled. As an example, when 
> iwconfig is used to set the rate at 36M, the TX rate increased from 
> 6.8 to 15.8 Mb/s.
>
> Unfortunately, direct submission of my patch would violate the 
> clean-room rules. Michael Buesch has other things that are more 
> important. As a result, we need someone to look at the changes on the 
> web page and prepare a patch for submission. I will be happy to test 
> your submission.
>
> Larry
> _______________________________________________
> Bcm43xx-dev mailing list
> Bcm43xx-dev@lists.berlios.de
> https://lists.berlios.de/mailman/listinfo/bcm43xx-dev
>   
