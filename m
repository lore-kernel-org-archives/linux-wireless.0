Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:21406 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431AbXKZIfD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2007 03:35:03 -0500
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: Dan Williams <dcbw@redhat.com>
Subject: [PATCH] libertas: let more than one MAC event through
Date: Mon, 26 Nov 2007 09:35:44 +0100
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200711260935.44469.hs4233@mail.mn-solutions.de> (sfid-20071126_083513_988659_9D542DA3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

lbs_mac_event_disconnected() was called once and then never again
upon a hardware MAC event.

The reason was that the driver didn't clean the correct bit in the interrupt
cause register of the chip.

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

Index: wireless-2.6/drivers/net/wireless/libertas/if_cs.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/libertas/if_cs.c	2007-11-26 10:18:05.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/libertas/if_cs.c	2007-11-26 10:18:32.000000000 +0100
@@ -170,7 +170,8 @@ static int if_cs_poll_while_fw_download(
 #define IF_CS_H_IC_TX_OVER		0x0001
 #define IF_CS_H_IC_RX_OVER		0x0002
 #define IF_CS_H_IC_DNLD_OVER		0x0004
-#define IF_CS_H_IC_HOST_EVENT		0x0008
+#define IF_CS_H_IC_POWER_DOWN		0x0008
+#define IF_CS_H_IC_HOST_EVENT		0x0010
 #define IF_CS_H_IC_MASK			0x001f
 
 #define IF_CS_H_INT_MASK		0x00000004
