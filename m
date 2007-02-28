Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail8.sea5.speakeasy.net ([69.17.117.10]:33545 "EHLO
	mail8.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385AbXB1Dq7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Feb 2007 22:46:59 -0500
Date: Tue, 27 Feb 2007 19:46:46 -0800
From: Jouni Malinen <jkmaline@cc.hut.fi>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] hostap: Add D-Link DWL-650 Rev. P1 product id
Message-ID: <20070228034646.GA10278@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It looks like some of the PC Card manfid/product strings were lost
when Host AP driver was converted to use PCMCIA_DEVICE_* helpers. This
patch adds back D-Link DWL-650 Rev. P1 using the same product ID
string match as the pcmcia-cs/cardmgr configuration used before.

Signed-off-by: Jouni Malinen <jkmaline@cc.hut.fi>


Index: wireless-2.6/drivers/net/wireless/hostap/hostap_cs.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/hostap/hostap_cs.c
+++ wireless-2.6/drivers/net/wireless/hostap/hostap_cs.c
@@ -848,6 +848,11 @@ static struct pcmcia_device_id hostap_cs
 		"Intersil", "PRISM 2_5 PCMCIA ADAPTER",	"ISL37300P",
 		"Eval-RevA",
 		0x4b801a17, 0x6345a0bf, 0xc9049a39, 0xc23adc0e),
+	/* D-Link DWL-650 Rev. P1; manfid 0x000b, 0x7110 */
+	PCMCIA_DEVICE_PROD_ID1234(
+		"D-Link", "DWL-650 Wireless PC Card RevP", "ISL37101P-10",
+		"A3",
+		0x1a424a1c, 0x6ea57632, 0xdd97a26b, 0x56b21f52),
 	PCMCIA_DEVICE_PROD_ID123(
 		"Addtron", "AWP-100 Wireless PCMCIA", "Version 01.02",
 		0xe6ec52ce, 0x08649af2, 0x4b74baa0),


-- 
Jouni Malinen                                            PGP id EFC895FA
