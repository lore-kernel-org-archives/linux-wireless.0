Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:33524 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097Ab2AKUjg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jan 2012 15:39:36 -0500
Date: Wed, 11 Jan 2012 14:39:32 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: zajec5@gmail.com, arend@broadcom.com, b43-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
Subject: [PATCH] bcma: Enable logging of SPROM offset
Message-ID: <4f0df384.FkBMG6tZuMiWW0Yf%Larry.Finger@lwfinger.net> (sfid-20120111_213939_848591_9E52DB9F)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The SPROM location has been relocated again for some devices. This patch
will log the offset when CONFIG_BCMA_DEBUG has been selected.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 
Index: wireless-testing-new/drivers/bcma/sprom.c
===================================================================
--- wireless-testing-new.orig/drivers/bcma/sprom.c
+++ wireless-testing-new/drivers/bcma/sprom.c
@@ -230,6 +230,7 @@ int bcma_sprom_get(struct bcma_bus *bus)
 	 * TODO: understand this condition and use it */
 	offset = (bus->chipinfo.id == 0x4331) ? BCMA_CC_SPROM :
 		BCMA_CC_SPROM_PCIE6;
+	pr_debug("SPROM offset 0x%x\n", offset);
 	bcma_sprom_read(bus, offset, sprom);
 
 	if (bus->chipinfo.id == 0x4331)
