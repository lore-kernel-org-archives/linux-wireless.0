Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:40997 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752209AbYCPTYM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Mar 2008 15:24:12 -0400
Date: Sun, 16 Mar 2008 20:22:43 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: Michael Buesch <mb@bu3sch.de>
Subject: [PATCH v2] [RFT] b43legacy: fix bcm4303 crash
Message-ID: <20080316202243.6f946495@morte> (sfid-20080316_192434_669592_8626B46A)
In-Reply-To: <200803151914.51620.mb@bu3sch.de>
References: <20080315190121.70edbfcd@morte>
	<20080315190836.5020b884@morte>
	<200803151914.51620.mb@bu3sch.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This should fix an hard crash which happened upon driver loading on bcm4303
rev. 2 devices. The bug was originally reported here:
https://bugzilla.redhat.com/show_bug.cgi?id=384981.
Please test.

Signed-off-by: Stefano Brivio <stefano.brivio@polimi.it>
---
Sorry, I forgot to run 'quilt refresh'.

Index: wireless-testing/drivers/ssb/main.c
===================================================================
--- wireless-testing.orig/drivers/ssb/main.c
+++ wireless-testing/drivers/ssb/main.c
@@ -1082,6 +1082,12 @@ int ssb_bus_may_powerdown(struct ssb_bus
 		goto out;
 
 	cc = &bus->chipco;
+
+	if (!cc->dev)
+		goto out;
+	if (cc->dev->id.revision < 5)
+		goto out;
+
 	ssb_chipco_set_clockmode(cc, SSB_CLKMODE_SLOW);
 	err = ssb_pci_xtal(bus, SSB_GPIO_XTAL | SSB_GPIO_PLL, 0);
 	if (err)



-- 
Ciao
Stefano
