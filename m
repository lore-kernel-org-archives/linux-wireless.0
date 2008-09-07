Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from Viola.Opus1.COM ([192.245.12.8]:1268 "EHLO Viola.Opus1.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752380AbYIGAln (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Sep 2008 20:41:43 -0400
Received: from [172.17.0.188] ([61.8.118.66])
 by Opus1.COM (PMDF V6.2-X27 #9830) with ESMTPSA id
 <01MZ902D65VC8YG025@Opus1.COM> for linux-wireless@vger.kernel.org; Sat,
 06 Sep 2008 17:41:42 -0700 (MST)
Date: Sat, 06 Sep 2008 17:41:33 -0700
From: gavron@wetwork.net
Subject: Re: Speed enhancement for BCM4306/2
In-reply-to: <48C321EF.30909@lwfinger.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Broadcom Wireless <bcm43xx-dev@berlios.de>,
	wireless <linux-wireless@vger.kernel.org>
Message-id: <48C3233D.60201@wetwork.net> (sfid-20080907_024155_400835_2D809E9F)
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
References: <48C1BA91.7050106@lwfinger.net> <48C20928.10202@wetwork.net>
 <48C20BD7.6080605@lwfinger.net> <48C20F64.1000700@wetwork.net>
 <48C2A1F5.6020607@lwfinger.net> <48C30B3E.2040302@wetwork.net>
 <48C3121C.9090309@lwfinger.net> <48C31646.2020205@wetwork.net>
 <48C31DBB.6000709@lwfinger.net> <48C31F65.2000406@wetwork.net>
 <48C321EF.30909@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



Larry Finger wrote:
> gavron@wetwork.net wrote:
>>
>> Try #5:
>> # diff -uN /tmp/phy.c drivers/net/wireless/b43legacy/phy.c
>> --- /tmp/phy.c    2008-09-06 15:13:33.000000000 -0700
>
> This one is pretty close, but I think you missed a change at line 16a 
> of B6PHY.
>
> One other thing - use the -uNp switch for diff.
>
> Larry
>
T6:
# diff -uNp /tmp/phy.c drivers/net/wireless/b43legacy/phy.c
--- /tmp/phy.c    2008-09-06 15:13:33.000000000 -0700
+++ drivers/net/wireless/b43legacy/phy.c    2008-09-06 
17:40:20.000000000 -0700
@@ -595,12 +595,14 @@ static void b43legacy_phy_initb5(struct
                     0x0035) & 0xFFC0) | 0x0064);
         b43legacy_phy_write(dev, 0x005D, (b43legacy_phy_read(dev,
                     0x005D) & 0xFF80) | 0x000A);
+        b43legacy_phy_write(dev, 0x5B, 0x0000);
+        b43legacy_phy_write(dev, 0x5C, 0x0000);
     }
 
     if (dev->bad_frames_preempt)
         b43legacy_phy_write(dev, B43legacy_PHY_RADIO_BITFIELD,
                     b43legacy_phy_read(dev,
-                    B43legacy_PHY_RADIO_BITFIELD) | (1 << 11));
+                    B43legacy_PHY_RADIO_BITFIELD) | (1 << 12));
 
     if (phy->analog == 1) {
         b43legacy_phy_write(dev, 0x0026, 0xCE00);
@@ -753,7 +755,7 @@ static void b43legacy_phy_initb6(struct
         b43legacy_radio_write16(dev, 0x0050, 0x0020);
     }
     if (phy->radio_rev <= 2) {
-        b43legacy_radio_write16(dev, 0x007C, 0x0020);
+        b43legacy_radio_write16(dev, 0x0050, 0x0020);
         b43legacy_radio_write16(dev, 0x005A, 0x0070);
         b43legacy_radio_write16(dev, 0x005B, 0x007B);
         b43legacy_radio_write16(dev, 0x005C, 0x00B0);
@@ -771,7 +773,7 @@ static void b43legacy_phy_initb6(struct
         b43legacy_phy_write(dev, 0x002A, 0x8AC0);
     b43legacy_phy_write(dev, 0x0038, 0x0668);
     b43legacy_radio_set_txpower_bg(dev, 0xFFFF, 0xFFFF, 0xFFFF);
-    if (phy->radio_rev <= 5)
+    if (phy->radio_rev == 4 || phy->radio_rev == 5)
         b43legacy_phy_write(dev, 0x005D, (b43legacy_phy_read(dev,
                     0x005D) & 0xFF80) | 0x0003);
     if (phy->radio_rev <= 2)
@@ -1010,7 +1012,7 @@ static void b43legacy_phy_initg(struct b
         b43legacy_phy_initb5(dev);
     else
         b43legacy_phy_initb6(dev);
-    if (phy->rev >= 2 || phy->gmode)
+    if (phy->rev >= 2 && phy->gmode)
         b43legacy_phy_inita(dev);
 
     if (phy->rev >= 2) {
@@ -1025,17 +1027,22 @@ static void b43legacy_phy_initg(struct b
         b43legacy_phy_write(dev, 0x0811, 0x0400);
         b43legacy_phy_write(dev, 0x0015, 0x00C0);
     }
-    if (phy->rev >= 2 || phy->gmode) {
+    if (phy->gmode) {
         tmp = b43legacy_phy_read(dev, 0x0400) & 0xFF;
-        if (tmp == 3 || tmp == 5) {
+        if (tmp == 3) {
+            b43legacy_phy_write(dev, 0x04C2, 0x1816);
+            b43legacy_phy_write(dev, 0x04C3, 0x8606);
+        }
+        if (tmp == 4 || tmp == 5) {
             b43legacy_phy_write(dev, 0x04C2, 0x1816);
             b43legacy_phy_write(dev, 0x04C3, 0x8006);
-            if (tmp == 5)
-                b43legacy_phy_write(dev, 0x04CC,
-                            (b43legacy_phy_read(dev,
-                             0x04CC) & 0x00FF) |
-                             0x1F00);
+            b43legacy_phy_write(dev, 0x04CC,
+                        (b43legacy_phy_read(dev,
+                        0x04CC) & 0x00FF) |
+                        0x1F00);
         }
+    }
+    if (phy->rev >= 2)
         b43legacy_phy_write(dev, 0x047E, 0x0078);
     }
     if (phy->radio_rev == 8) {
@@ -1078,7 +1085,7 @@ static void b43legacy_phy_initg(struct b
         else
             b43legacy_phy_write(dev, 0x002F, 0x0202);
     }
-    if (phy->gmode || phy->rev >= 2) {
+    if (phy->gmode) {
         b43legacy_phy_lo_adjust(dev, 0);
         b43legacy_phy_write(dev, 0x080F, 0x8078);

