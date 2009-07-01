Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:63613 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125AbZGADg5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Jun 2009 23:36:57 -0400
Date: Tue, 30 Jun 2009 22:37:08 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>, ccmcphe@verizon.net
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Message-ID: <4a4ad9e4.vPnta8trzUXc4YPz%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Clyde McPherson <ccmcphe@verizon.net>

Added support for the Broadcom 4318E chipset on PCMCIA/CF cards. The 
4318E can do 802.11A/B/G, only B and G mode are supported in b43.

Signed-off-by: Clyde McPherson <ccmcphe@verizon.net>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: wireless-testing/drivers/ssb/pcmcia.c
===================================================================
--- wireless-testing.orig/drivers/ssb/pcmcia.c
+++ wireless-testing/drivers/ssb/pcmcia.c
@@ -678,7 +678,8 @@ int ssb_pcmcia_get_invariants(struct ssb
 			sprom->board_rev = tuple.TupleData[1];
 			break;
 		case SSB_PCMCIA_CIS_PA:
-			GOTO_ERROR_ON(tuple.TupleDataLen != 9,
+			GOTO_ERROR_ON((tuple.TupleDataLen != 9) &&
+				      (tuple.TupleDataLen != 10),
 				      "pa tpl size");
 			sprom->pa0b0 = tuple.TupleData[1] |
 				 ((u16)tuple.TupleData[2] << 8);
@@ -718,7 +719,8 @@ int ssb_pcmcia_get_invariants(struct ssb
 			sprom->antenna_gain.ghz5.a3 = tuple.TupleData[1];
 			break;
 		case SSB_PCMCIA_CIS_BFLAGS:
-			GOTO_ERROR_ON(tuple.TupleDataLen != 3,
+			GOTO_ERROR_ON((tuple.TupleDataLen != 3) &&
+				      (tuple.TupleDataLen != 5),
 				      "bfl tpl size");
 			sprom->boardflags_lo = tuple.TupleData[1] |
 					 ((u16)tuple.TupleData[2] << 8);
