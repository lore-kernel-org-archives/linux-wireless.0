Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:24687 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753199AbXJHJfc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Oct 2007 05:35:32 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	Dan Williams <dcbw@redhat.com>
Subject: [PATCH] libertas: fix warning about adhoc_rates_b
Date: Mon, 8 Oct 2007 11:35:39 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200710081135.39640.hs4233@mail.mn-solutions.de> (sfid-20071008_103539_206330_DA8C2125)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Patch d2b5c42a113ab03cf32acb99b408041264915e97 made libertas 
advertise g rades, so remove the now unused b rates.

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

Index: libertas-2.6/drivers/net/wireless/libertas/join.c
===================================================================
--- libertas-2.6.orig/drivers/net/wireless/libertas/join.c	
2007-10-08 12:12:59.000000000 +0200
+++ libertas-2.6/drivers/net/wireless/libertas/join.c	2007-10-08 
12:13:08.000000000 +0200
@@ -17,9 +17,6 @@
 #include "dev.h"
 #include "assoc.h"
 
-/* Supported rates for ad-hoc B mode */
-static u8 adhoc_rates_b[5] = { 0x02, 0x04, 0x0b, 0x16, 0x00 };
-
 /* The firmware needs certain bits masked out of the 
beacon-derviced capability
  * field when associating/joining to BSSs.
  */
