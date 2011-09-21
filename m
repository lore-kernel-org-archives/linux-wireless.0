Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:58835 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750825Ab1IUVHl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Sep 2011 17:07:41 -0400
Message-ID: <4E7A521B.50104@xenotime.net> (sfid-20110921_230759_489171_E4B830FA)
Date: Wed, 21 Sep 2011 14:07:39 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: [PATCH -next] bcma: main.c and driver_mips.c need linux/export.h
References: <20110920173102.d38155c7defbbc29beaae7c0@canb.auug.org.au>	<4E78CFC0.4020003@xenotime.net>	<CACna6rxGrd-ORWZrc0xsAOKptU_Xj3eGh9qSfX9vJYCPTZrCRg@mail.gmail.com>	<4E78FCDB.1010002@xenotime.net>	<CACna6rywFitSNkkwo6tNy887vdsoyHG5Cadk6Bb8_qBJ+gc42w@mail.gmail.com>	<4E7A084C.3000304@xenotime.net> <CACna6ryNw+YgTiO5dBSGcTfUabM_yO0LaSsbGpC_X6JrQudnBQ@mail.gmail.com>
In-Reply-To: <CACna6ryNw+YgTiO5dBSGcTfUabM_yO0LaSsbGpC_X6JrQudnBQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Randy Dunlap <rdunlap@xenotime.net>

main.c and driver_mips.c use EXPORT_SYMBOL() etc.
so they should include <linux/export.h>.

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 drivers/bcma/driver_mips.c |    1 +
 drivers/bcma/main.c        |    1 +
 2 files changed, 2 insertions(+)

--- next-2011-0921.orig/drivers/bcma/driver_mips.c
+++ next-2011-0921/drivers/bcma/driver_mips.c
@@ -14,6 +14,7 @@
 
 #include <linux/bcma/bcma.h>
 
+#include <linux/export.h>
 #include <linux/serial.h>
 #include <linux/serial_core.h>
 #include <linux/serial_reg.h>
--- next-2011-0921.orig/drivers/bcma/main.c
+++ next-2011-0921/drivers/bcma/main.c
@@ -7,6 +7,7 @@
 
 #include "bcma_private.h"
 #include <linux/module.h>
+#include <linux/export.h>
 #include <linux/bcma/bcma.h>
 #include <linux/slab.h>
 
