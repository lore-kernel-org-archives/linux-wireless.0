Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hpsmtp-eml16.kpnxchange.com ([213.75.38.116]:48449 "EHLO
	hpsmtp-eml16.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751377AbYI1JSq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Sep 2008 05:18:46 -0400
Message-ID: <48DF4863.9070806@kpnplanet.nl> (sfid-20080928_111854_337825_4A8B4823)
Date: Sun, 28 Sep 2008 11:03:31 +0200
From: Gertjan van Wingerde <gwingerde@kpnplanet.nl>
MIME-Version: 1.0
To: Ivo van Doorn <ivdoorn@gmail.com>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net,
	linville@tuxdriver.com, akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH -mm] rt2x00: fix Kconfig dependencies
References: <48D82A43.7040604@oracle.com> <200809240009.32167.IvDoorn@gmail.com> <20080923153043.7aa806b8.randy.dunlap@oracle.com> <200809240045.28976.IvDoorn@gmail.com>
In-Reply-To: <200809240045.28976.IvDoorn@gmail.com>
Content-Type: multipart/mixed;
 boundary="------------080101030705020709070409"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------080101030705020709070409
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Ivo,

Ivo van Doorn wrote:
>> Ivo, please explain what rt2x00 module(s) you want to be built. In 
>> English
>> if possible, not in Kconfig language...
>>      
>
> There are 3 kind of rt2x00 modules:
> 	rt2x00lib
> 	rt2x00pci/usb
> 	rt2x00 driver (rt2400pci, rt2500pci, rt61pci, rt2500usb, rt73usb)
>
> When the user selects any of the rt2x00 drivers, the rt2x00pci/usb and rt2x00lib
> are selected. For rt2x00lib there are some additional configuration options like
> RT2X00_LIB_RFKILL and RT2X00_LIB_LEDS which will build into rt2x00lib.
>
> This means that when rt2400pci is selected as module, rt2x00pci and rt2x00lib
> must be built as modules as well and when rt2400pci is selected as buildin
> rt2x00pci and rt2x00lib must be buildin as well.
>
> But with the optional rt2x00lib configuration options the breakage you reported
> is possible. So we either need:
> 	1) Force rt2x00lib / driver to be compiled as module when RFKILL/LEDS were
> 	    compiled as module
> 	2) Disable config option when invalid config combination is found
>
> Personally I would favor 1), because 2) could lead to confusion to users
> who think they selected everything they needed to enable support for it in
> rt2x00.
>    

Find attached a patch that implements option 2, along with adding a 
warning to the user when rfkill support in rt2x00 is disabled due to the 
invalid config combination. I've looked at implementing option 1, but 
couldn't find a way to do it without disabling the entire rt2x00 module 
when rfkill wasn't available.

I guess we can live with this option for now, until we have figured out 
how to do option 1.

---
Gertjan.

--------------080101030705020709070409
Content-Type: text/plain;
 name="0001-rt2x00-Fix-build-errors-due-to-modularized-RFKILL-a.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0001-rt2x00-Fix-build-errors-due-to-modularized-RFKILL-a.pat";
 filename*1="ch"

>From bcdd7594bf24a813387c908198de4d74906d196a Mon Sep 17 00:00:00 2001
From: Gertjan van Wingerde <gwingerde@kpnplanet.nl>
Date: Sun, 28 Sep 2008 10:53:46 +0200
Subject: [PATCH] rt2x00: Fix build errors due to modularized RFKILL and built-in rt2x00.

Fix by disabling rt2x00 rfkill support when rt2x00 is built-in and RFKILL has been modularized.
Also, give a warning to the end-user when rfkill-support is supported this way, so that the end-user
has at least some clues on what is going on.

Signed-off-by: Gertjan van Wingerde <gwingerde@kpnplanet.nl>
---
 drivers/net/wireless/rt2x00/Kconfig |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/Kconfig b/drivers/net/wireless/rt2x00/Kconfig
index b686dc4..64c94d7 100644
--- a/drivers/net/wireless/rt2x00/Kconfig
+++ b/drivers/net/wireless/rt2x00/Kconfig
@@ -39,9 +39,10 @@ config RT2X00_LIB_CRYPTO
 
 config RT2X00_LIB_RFKILL
 	boolean
-	depends on RT2X00_LIB
-	depends on RFKILL
-	default y
+	default y if (RT2X00=y && RFKILL=y) || (RT2X00=m && RFKILL!=n)
+
+comment "rt2x00 rfkill support disabled due to modularized RFKILL and built-in rt2x00"
+	depends on RT2X00=y && RFKILL=m
 
 config RT2X00_LIB_LEDS
 	boolean
-- 
1.5.6.5


--------------080101030705020709070409--
