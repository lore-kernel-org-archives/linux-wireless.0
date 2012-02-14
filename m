Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:47225 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755449Ab2BNEBW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Feb 2012 23:01:22 -0500
Received: by obcva7 with SMTP id va7so7533994obc.19
        for <linux-wireless@vger.kernel.org>; Mon, 13 Feb 2012 20:01:22 -0800 (PST)
Date: Mon, 13 Feb 2012 22:01:20 -0600
From: "Saul St. John" <saul.stjohn@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Subject: [RFC] use alternate SPROM offset for 43224
Message-ID: <20120214040120.GA2077@eris.garyseven.net> (sfid-20120214_050132_226395_889E4666)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I don't know if this is correct in the general sense, but the wireless on my
mid-2010 MacBook Pro doesn't work without it.

Signed-off-by: Saul St. John <saul.stjohn@gmail.com>
---
 drivers/bcma/sprom.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/bcma/sprom.c b/drivers/bcma/sprom.c
index 6f230fb..06c87b5 100644
--- a/drivers/bcma/sprom.c
+++ b/drivers/bcma/sprom.c
@@ -228,8 +228,8 @@ int bcma_sprom_get(struct bcma_bus *bus)
 	/* Most cards have SPROM moved by additional offset 0x30 (48 dwords).
 	 * According to brcm80211 this applies to cards with PCIe rev >= 6
 	 * TODO: understand this condition and use it */
-	offset = (bus->chipinfo.id == 0x4331) ? BCMA_CC_SPROM :
-		BCMA_CC_SPROM_PCIE6;
+	offset = (bus->chipinfo.id == 0x4331 || bus->chipinfo.id == 43224) ? 
+ 			BCMA_CC_SPROM : BCMA_CC_SPROM_PCIE6;
 	bcma_sprom_read(bus, offset, sprom);
 
 	if (bus->chipinfo.id == 0x4331)
-- 
1.7.9

