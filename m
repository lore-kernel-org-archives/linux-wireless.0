Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:59585 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592Ab1HRNkV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Aug 2011 09:40:21 -0400
Date: Thu, 18 Aug 2011 16:38:09 +0300
From: Dan Carpenter <error27@gmail.com>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: "open list:BROADCOM SPECIFIC..." <linux-wireless@vger.kernel.org>,
	kernel-janitors@vger.kernel.org
Subject: [patch -next] bcma: signedness bug in bcma_get_next_core()
Message-ID: <20110818133809.GG4786@shale.localdomain> (sfid-20110818_154026_133766_0812FB0B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The u32 would never be less than zero so the error handling would
break.  I changed it to int.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/bcma/scan.c b/drivers/bcma/scan.c
index 0ea390f..1361d8d 100644
--- a/drivers/bcma/scan.c
+++ b/drivers/bcma/scan.c
@@ -281,7 +281,7 @@ static int bcma_get_next_core(struct bcma_bus *bus, u32 __iomem **eromptr,
 
 	/* get & parse master ports */
 	for (i = 0; i < ports[0]; i++) {
-		u32 mst_port_d = bcma_erom_get_mst_port(bus, eromptr);
+		int mst_port_d = bcma_erom_get_mst_port(bus, eromptr);
 		if (mst_port_d < 0)
 			return -EILSEQ;
 	}
