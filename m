Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34229 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755943Ab1HWTR5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Aug 2011 15:17:57 -0400
Date: Tue, 23 Aug 2011 22:15:35 +0300
From: Dan Carpenter <error27@gmail.com>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: "open list:BROADCOM SPECIFIC..." <linux-wireless@vger.kernel.org>,
	kernel-janitors@vger.kernel.org
Subject: [patch -next v2] bcma: signedness bug in bcma_get_next_core()
Message-ID: <20110823191535.GL12248@shale.localdomain> (sfid-20110823_211802_426822_10E133EA)
References: <20110818133809.GG4786@shale.localdomain>
 <CACna6rzwxA=OzQQ_VknsSq8BXXoH8U=GpdfkRTBWjFSNSjwsAA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CACna6rzwxA=OzQQ_VknsSq8BXXoH8U=GpdfkRTBWjFSNSjwsAA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The u32 would never be less than zero so the error handling would
break.  I changed it to s32 to match how bcma_erom_get_mst_port() is
declared.

Signed-off-by: Dan Carpenter <error27@gmail.com>
---
v2:  the first version used "int" instead of "s32".

diff --git a/drivers/bcma/scan.c b/drivers/bcma/scan.c
index 0ea390f..cad9948 100644
--- a/drivers/bcma/scan.c
+++ b/drivers/bcma/scan.c
@@ -281,7 +281,7 @@ static int bcma_get_next_core(struct bcma_bus *bus, u32 __iomem **eromptr,
 
 	/* get & parse master ports */
 	for (i = 0; i < ports[0]; i++) {
-		u32 mst_port_d = bcma_erom_get_mst_port(bus, eromptr);
+		s32 mst_port_d = bcma_erom_get_mst_port(bus, eromptr);
 		if (mst_port_d < 0)
 			return -EILSEQ;
 	}
