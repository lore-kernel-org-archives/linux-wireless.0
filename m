Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from Viola.Opus1.COM ([192.245.12.8]:1254 "EHLO Viola.Opus1.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753090AbYIGAZR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Sep 2008 20:25:17 -0400
Received: from [172.17.0.188] ([61.8.118.66])
 by Opus1.COM (PMDF V6.2-X27 #9830) with ESMTPSA id
 <01MZ8ZH2FQK88X4NGL@Opus1.COM> for linux-wireless@vger.kernel.org; Sat,
 06 Sep 2008 17:25:15 -0700 (MST)
Date: Sat, 06 Sep 2008 17:25:09 -0700
From: gavron@wetwork.net
Subject: Re: Speed enhancement for BCM4306/2
In-reply-to: <48C31DBB.6000709@lwfinger.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Broadcom Wireless <bcm43xx-dev@berlios.de>,
	wireless <linux-wireless@vger.kernel.org>
Message-id: <48C31F65.2000406@wetwork.net> (sfid-20080907_022520_532438_229FDC46)
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
References: <48C1BA91.7050106@lwfinger.net> <48C20928.10202@wetwork.net>
 <48C20BD7.6080605@lwfinger.net> <48C20F64.1000700@wetwork.net>
 <48C2A1F5.6020607@lwfinger.net> <48C30B3E.2040302@wetwork.net>
 <48C3121C.9090309@lwfinger.net> <48C31646.2020205@wetwork.net>
 <48C31DBB.6000709@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



Larry Finger wrote:
> gavron@wetwork.net wrote:
>>
>>
>> Larry Finger wrote:
>>> gavron@wetwork.net wrote:
>>>> I haven't tried a build yet, but please let me know if I'm on the 
>>>> right track.
>>>>
>>>> E
>>>> # diff -uN /tmp/phy.c drivers/net/wireless/b43legacy/phy.c
>>>> --- /tmp/phy.c    2008-09-06 15:13:33.000000000 -0700
>>>> +++ drivers/net/wireless/b43legacy/phy.c    2008-09-06 
>>>> 15:54:03.000000000 -0700
>>>> @@ -1010,7 +1010,7 @@
>>>>         b43legacy_phy_initb5(dev);
>>>>     else
>>>>         b43legacy_phy_initb6(dev);
>>>> -    if (phy->rev >= 2 || phy->gmode)
>>>> +    if (phy->rev >= 2 && phy->gmode)
>>>>         b43legacy_phy_inita(dev);
>>>>
>>>>     if (phy->rev >= 2) {
>>>> @@ -1021,21 +1021,26 @@
>>>>         b43legacy_phy_write(dev, 0x0811, 0x0000);
>>>>         b43legacy_phy_write(dev, 0x0015, 0x00C0);
>>>>     }
>>>> -    if (phy->rev > 5) {
>>>> +    if (phy->rev >= 3) {
>>>
>>> AFAIK, this change is an error in the specs. I have since changed 
>>> it. Sorry I didn't catch it earlier.
>>>
>>> Otherwise, this patch seems to be correct. All you need now are the 
>>> fixes for b43legacy_phy_initb5() and b43legacy_phy_initb6().
>>>
>>> Larry
>>
>> Ok, I've re-looked at the specs and made the appropriate 
>> corrections.  I've also gone through all of the PHY specs and found 
>> one other correction.  It's enclosed below for review.
>>
>> Where do I go to find the stuff for ...initb5() and ...initb6()?
>
> That one was also an error in the specs - fixed now.
>
> On the V3 specifications site, click on the RecentChanges button and 
> select B5PHY and B6PHY to get the specs for the other routines. I 
> rechecked the specs, and all agree with my current (revised) routines.
>
>
> Larry

Try #5:
# diff -uN /tmp/phy.c drivers/net/wireless/b43legacy/phy.c
--- /tmp/phy.c    2008-09-06 15:13:33.000000000 -0700
+++ drivers/net/wireless/b43legacy/phy.c    2008-09-06 
17:24:29.000000000 -0700
@@ -595,12 +595,14 @@
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
@@ -771,7 +773,7 @@
         b43legacy_phy_write(dev, 0x002A, 0x8AC0);
     b43legacy_phy_write(dev, 0x0038, 0x0668);
     b43legacy_radio_set_txpower_bg(dev, 0xFFFF, 0xFFFF, 0xFFFF);
-    if (phy->radio_rev <= 5)
+    if (phy->radio_rev == 4 || phy->radio_rev == 5)
         b43legacy_phy_write(dev, 0x005D, (b43legacy_phy_read(dev,
                     0x005D) & 0xFF80) | 0x0003);
     if (phy->radio_rev <= 2)
@@ -1010,7 +1012,7 @@
         b43legacy_phy_initb5(dev);
     else
         b43legacy_phy_initb6(dev);
-    if (phy->rev >= 2 || phy->gmode)
+    if (phy->rev >= 2 && phy->gmode)
         b43legacy_phy_inita(dev);
 
     if (phy->rev >= 2) {
@@ -1025,17 +1027,22 @@
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
@@ -1078,7 +1085,7 @@
         else
             b43legacy_phy_write(dev, 0x002F, 0x0202);
     }
-    if (phy->gmode || phy->rev >= 2) {
+    if (phy->gmode) {
         b43legacy_phy_lo_adjust(dev, 0);
         b43legacy_phy_write(dev, 0x080F, 0x8078);
     }

