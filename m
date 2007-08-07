Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:43773
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759516AbXHGPqH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Aug 2007 11:46:07 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Andrew Morton <akpm@linux-foundation.org>,
	John Linville <linville@tuxdriver.com>
Subject: [PATCH] ssb: Make extif driver compilation depend on extif config
Date: Tue, 7 Aug 2007 17:44:39 +0200
Cc: Aurelien Jarno <aurelien@aurel32.net>,
	Felix Fietkau <nbd@openwrt.org>, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200708071744.40287.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Compilation of the extif driver must depend on
CONFIG_SSB_DRIVER_EXTIF.
Sorry, my fault.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

--

John, please apply to wireless-dev
Andrew, please apply to -mm after applying the other ssb patches.


diff --git a/drivers/ssb/Makefile b/drivers/ssb/Makefile
index 811343d..bcde58d 100644
--- a/drivers/ssb/Makefile
+++ b/drivers/ssb/Makefile
@@ -7,7 +7,8 @@ ssb-$(CONFIG_SSB_PCMCIAHOST)		+= pcmcia.
 
 # built-in drivers
 ssb-y					+= driver_chipcommon.o
-ssb-$(CONFIG_SSB_DRIVER_MIPS)		+= driver_mipscore.o driver_extif.o
+ssb-$(CONFIG_SSB_DRIVER_MIPS)		+= driver_mipscore.o
+ssb-$(CONFIG_SSB_DRIVER_EXTIF)		+= driver_extif.o
 ssb-$(CONFIG_SSB_DRIVER_PCICORE)	+= driver_pcicore.o
 
 obj-$(CONFIG_SSB)			+= ssb.o

-- 
Greetings Michael.
