Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpo-eml03.kpnxchange.com ([213.75.38.152]:13412 "EHLO
	cpsmtpo-eml03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751968AbYI1NQZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Sep 2008 09:16:25 -0400
Message-ID: <48DF83A4.1050901@kpnplanet.nl> (sfid-20080928_151629_831574_B93B429B)
Date: Sun, 28 Sep 2008 15:16:20 +0200
From: Gertjan van Wingerde <gwingerde@kpnplanet.nl>
MIME-Version: 1.0
To: Ivo van Doorn <ivdoorn@gmail.com>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net,
	linville@tuxdriver.com, akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH -mm] rt2x00: fix Kconfig dependencies
References: <48D82A43.7040604@oracle.com> <200809240045.28976.IvDoorn@gmail.com> <48DF4863.9070806@kpnplanet.nl> <200809281124.07434.IvDoorn@gmail.com>
In-Reply-To: <200809281124.07434.IvDoorn@gmail.com>
Content-Type: multipart/mixed;
 boundary="------------020506080803030205050708"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------020506080803030205050708
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Ivo van Doorn wrote:
> On Sunday 28 September 2008, Gertjan van Wingerde wrote:
>    
>> Ivo,
>>
>> Ivo van Doorn wrote:
>>      
>>>> Ivo, please explain what rt2x00 module(s) you want to be built. In
>>>> English
>>>> if possible, not in Kconfig language...
>>>>
>>>>          
>>> There are 3 kind of rt2x00 modules:
>>> 	rt2x00lib
>>> 	rt2x00pci/usb
>>> 	rt2x00 driver (rt2400pci, rt2500pci, rt61pci, rt2500usb, rt73usb)
>>>
>>> When the user selects any of the rt2x00 drivers, the rt2x00pci/usb and rt2x00lib
>>> are selected. For rt2x00lib there are some additional configuration options like
>>> RT2X00_LIB_RFKILL and RT2X00_LIB_LEDS which will build into rt2x00lib.
>>>
>>> This means that when rt2400pci is selected as module, rt2x00pci and rt2x00lib
>>> must be built as modules as well and when rt2400pci is selected as buildin
>>> rt2x00pci and rt2x00lib must be buildin as well.
>>>
>>> But with the optional rt2x00lib configuration options the breakage you reported
>>> is possible. So we either need:
>>> 	1) Force rt2x00lib / driver to be compiled as module when RFKILL/LEDS were
>>> 	    compiled as module
>>> 	2) Disable config option when invalid config combination is found
>>>
>>> Personally I would favor 1), because 2) could lead to confusion to users
>>> who think they selected everything they needed to enable support for it in
>>> rt2x00.
>>>
>>>        
>> Find attached a patch that implements option 2, along with adding a
>> warning to the user when rfkill support in rt2x00 is disabled due to the
>> invalid config combination. I've looked at implementing option 1, but
>> couldn't find a way to do it without disabling the entire rt2x00 module
>> when rfkill wasn't available.
>>
>> I guess we can live with this option for now, until we have figured out
>> how to do option 1.
>>      
>
> Sounds good, but please change RT2X00 in RT2X00_LIB
>
> 	default y if (RT2X00=y&&  RFKILL=y) || (RT2X00=m&&  RFKILL!=n)
>
> Could you also do a similar thing for the LED handling?
> That way we can fix the entire thing with a single patch. :)

Here is an updated patch. This required some more surgery to the Kconfig 
file, as symbols had to be moved in the file.
This patch fixes the build issues for both rfkill and leds support.

---
Gertjan.

--------------020506080803030205050708
Content-Type: text/plain;
 name="0001-rt2x00-Fix-build-errors-due-to-modularized-rfkill-o.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0001-rt2x00-Fix-build-errors-due-to-modularized-rfkill-o.pat";
 filename*1="ch"

>From 0638bdd1e7b578c9fb0a91c768c105a369ff6ac1 Mon Sep 17 00:00:00 2001
From: Gertjan van Wingerde <gwingerde@kpnplanet.nl>
Date: Sun, 28 Sep 2008 15:11:38 +0200
Subject: [PATCH] rt2x00: Fix build errors due to modularized rfkill or leds and built-in rt2x00.

Fix by disabling rt2x00 rfkill support when rt2x00 is built-in and rfkill has been modularized, and
a similar scheme for the relationship between leds_class and rt2x00..
Also, give a warning to the end-user when rfkill-/leds-support is disabled this way, so that the
end-user has at least some clues on what is going on.

Proper fixing required some general updates of the Kconfig-structure for the rt2x00 driver, whereby
internal configuration symbols had to be moved to after the user-visible configuration symbols.

Signed-off-by: Gertjan van Wingerde <gwingerde@kpnplanet.nl>
---
 drivers/net/wireless/rt2x00/Kconfig |   69 +++++++++++++++++------------------
 1 files changed, 34 insertions(+), 35 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/Kconfig b/drivers/net/wireless/rt2x00/Kconfig
index b686dc4..f839ce0 100644
--- a/drivers/net/wireless/rt2x00/Kconfig
+++ b/drivers/net/wireless/rt2x00/Kconfig
@@ -1,5 +1,5 @@
-config RT2X00
-	tristate "Ralink driver support"
+menuconfig RT2X00
+	bool "Ralink driver support"
 	depends on MAC80211 && WLAN_80211 && EXPERIMENTAL
 	---help---
 	  This will enable the experimental support for the Ralink drivers,
@@ -17,39 +17,6 @@ config RT2X00
 
 if RT2X00
 
-config RT2X00_LIB
-	tristate
-
-config RT2X00_LIB_PCI
-	tristate
-	select RT2X00_LIB
-
-config RT2X00_LIB_USB
-	tristate
-	select RT2X00_LIB
-
-config RT2X00_LIB_FIRMWARE
-	boolean
-	depends on RT2X00_LIB
-	select FW_LOADER
-
-config RT2X00_LIB_CRYPTO
-	boolean
-	depends on RT2X00_LIB
-
-config RT2X00_LIB_RFKILL
-	boolean
-	depends on RT2X00_LIB
-	depends on RFKILL
-	default y
-
-config RT2X00_LIB_LEDS
-	boolean
-	depends on RT2X00_LIB
-	depends on NEW_LEDS
-	depends on LEDS_CLASS
-	default y
-
 config RT2400PCI
 	tristate "Ralink rt2400 (PCI/PCMCIA) support"
 	depends on PCI
@@ -109,6 +76,38 @@ config RT73USB
 
 	  When compiled as a module, this driver will be called "rt73usb.ko".
 
+config RT2X00_LIB_PCI
+	tristate
+	select RT2X00_LIB
+
+config RT2X00_LIB_USB
+	tristate
+	select RT2X00_LIB
+
+config RT2X00_LIB
+	tristate
+
+config RT2X00_LIB_FIRMWARE
+	boolean
+	select FW_LOADER
+
+config RT2X00_LIB_CRYPTO
+	boolean
+
+config RT2X00_LIB_RFKILL
+	boolean
+	default y if (RT2X00_LIB=y && RFKILL=y) || (RT2X00_LIB=m && RFKILL!=n)
+
+comment "rt2x00 rfkill support disabled due to modularized RFKILL and built-in rt2x00"
+	depends on RT2X00_LIB=y && RFKILL=m
+
+config RT2X00_LIB_LEDS
+	boolean
+	default y if (RT2X00_LIB=y && LEDS_CLASS=y) || (RT2X00_LIB=m && LEDS_CLASS!=n)
+
+comment "rt2x00 leds support disabled due to modularized LEDS_CLASS and built-in rt2x00"
+	depends on RT2X00_LIB=y && LEDS_CLASS=m
+
 config RT2X00_LIB_DEBUGFS
 	bool "Ralink debugfs support"
 	depends on RT2X00_LIB && MAC80211_DEBUGFS
-- 
1.5.6.5


--------------020506080803030205050708--
