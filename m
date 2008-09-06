Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from Viola.Opus1.COM ([192.245.12.8]:3394 "EHLO Viola.Opus1.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751239AbYIFFEl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Sep 2008 01:04:41 -0400
Received: from [172.17.0.188] ([61.8.118.66])
 by Opus1.COM (PMDF V6.2-X27 #9830) with ESMTPSA id
 <01MZ7UY6B0EK8YG025@Opus1.COM> for linux-wireless@vger.kernel.org; Fri,
 05 Sep 2008 22:04:39 -0700 (MST)
Date: Fri, 05 Sep 2008 22:04:36 -0700
From: gavron@wetwork.net
Subject: Re: Speed enhancement for BCM4306/2
In-reply-to: <48C20BD7.6080605@lwfinger.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Broadcom Wireless <bcm43xx-dev@berlios.de>,
	wireless <linux-wireless@vger.kernel.org>
Message-id: <48C20F64.1000700@wetwork.net> (sfid-20080906_070456_494108_2B309741)
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
References: <48C1BA91.7050106@lwfinger.net> <48C20928.10202@wetwork.net>
 <48C20BD7.6080605@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



Larry Finger wrote:
> gavron@wetwork.net wrote:
>> Is this close?
>> E
>>
>
> It is close, but I think you are working on b43. My changes are for 
> b43legacy and all changes will be in drivers/net/wireless/b43legacy/phy.c
>
> Larry

Ok, here's try #2. 

E
/home/2.6.27/rc4-wl/drivers/net/wireless/b43legacy# diff -uN /tmp/phy.c 
phy.c
--- /tmp/phy.c    2008-09-05 21:56:20.000000000 -0700
+++ phy.c    2008-09-05 22:03:28.000000000 -0700
@@ -1010,7 +1010,7 @@
         b43legacy_phy_initb5(dev);
     else
         b43legacy_phy_initb6(dev);
-    if (phy->rev >= 2 || phy->gmode)
+    if (phy->rev >= 2 && phy->gmode)
         b43legacy_phy_inita(dev);
 
     if (phy->rev >= 2) {
@@ -1027,15 +1027,17 @@
     }
     if (phy->rev >= 2 || phy->gmode) {
         tmp = b43legacy_phy_read(dev, 0x0400) & 0xFF;
-        if (tmp == 3 || tmp == 5) {
+        if (tmp == 4 || tmp == 5) {
             b43legacy_phy_write(dev, 0x04C2, 0x1816);
-            b43legacy_phy_write(dev, 0x04C3, 0x8006);
+            b43legacy_phy_write(dev, 0x04C3, 0x8606);
             if (tmp == 5)
                 b43legacy_phy_write(dev, 0x04CC,
                             (b43legacy_phy_read(dev,
                              0x04CC) & 0x00FF) |
                              0x1F00);
         }
+    }
+    if (phy->rev >= 2)
         b43legacy_phy_write(dev, 0x047E, 0x0078);
     }
     if (phy->radio_rev == 8) {

