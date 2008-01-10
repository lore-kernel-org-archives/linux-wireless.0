Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:46214 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757919AbYAJDQ7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jan 2008 22:16:59 -0500
Received: from dv.roinet.com (static-72-92-88-10.phlapa.fios.verizon.net [72.92.88.10])
	by relay.cesmail.net (Postfix) with ESMTP id EB741618FE1
	for <linux-wireless@vger.kernel.org>; Wed,  9 Jan 2008 22:16:58 -0500 (EST)
From: Pavel Roskin <proski@gnu.org>
Subject: [PATCH] hostap_cs: don't match revisions in presense of the MAC chip
	name
To: linux-wireless@vger.kernel.org
Date: Wed, 09 Jan 2008 22:16:58 -0500
Message-ID: <20080110031658.23599.83982.stgit@dv.roinet.com> (sfid-20080110_031718_775753_8480BD3F)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If the third PCMCIA ID string specifies the MAC chip, the fourth ID
string doesn't need to be matched.  Even if it's different, it will be
compatible with the driver.

This ensures that other different revisions of the card will be
supported.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

 drivers/net/wireless/hostap/hostap_cs.c |   15 ++++++---------
 1 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/hostap/hostap_cs.c b/drivers/net/wireless/hostap/hostap_cs.c
index 877d3bd..0759380 100644
--- a/drivers/net/wireless/hostap/hostap_cs.c
+++ b/drivers/net/wireless/hostap/hostap_cs.c
@@ -845,15 +845,13 @@ static struct pcmcia_device_id hostap_cs_ids[] = {
 					 0x4b801a17),
 	PCMCIA_MFC_DEVICE_PROD_ID12(0, "SanDisk", "ConnectPlus",
 				    0x7a954bd9, 0x74be00c6),
-	PCMCIA_DEVICE_PROD_ID1234(
+	PCMCIA_DEVICE_PROD_ID123(
 		"Intersil", "PRISM 2_5 PCMCIA ADAPTER",	"ISL37300P",
-		"Eval-RevA",
-		0x4b801a17, 0x6345a0bf, 0xc9049a39, 0xc23adc0e),
+		0x4b801a17, 0x6345a0bf, 0xc9049a39),
 	/* D-Link DWL-650 Rev. P1; manfid 0x000b, 0x7110 */
-	PCMCIA_DEVICE_PROD_ID1234(
+	PCMCIA_DEVICE_PROD_ID123(
 		"D-Link", "DWL-650 Wireless PC Card RevP", "ISL37101P-10",
-		"A3",
-		0x1a424a1c, 0x6ea57632, 0xdd97a26b, 0x56b21f52),
+		0x1a424a1c, 0x6ea57632, 0xdd97a26b),
 	PCMCIA_DEVICE_PROD_ID123(
 		"Addtron", "AWP-100 Wireless PCMCIA", "Version 01.02",
 		0xe6ec52ce, 0x08649af2, 0x4b74baa0),
@@ -890,10 +888,9 @@ static struct pcmcia_device_id hostap_cs_ids[] = {
 	PCMCIA_DEVICE_PROD_ID123(
 		"corega", "WL PCCL-11", "ISL37300P",
 		0xa21501a, 0x59868926, 0xc9049a39),
-	PCMCIA_DEVICE_PROD_ID1234(
+	PCMCIA_DEVICE_PROD_ID123(
 		"The Linksys Group, Inc.", "Wireless Network CF Card", "ISL37300P",
-		"RevA",
-		0xa5f472c2, 0x9c05598d, 0xc9049a39, 0x57a66194),
+		0xa5f472c2, 0x9c05598d, 0xc9049a39),
 	PCMCIA_DEVICE_NULL
 };
 MODULE_DEVICE_TABLE(pcmcia, hostap_cs_ids);
