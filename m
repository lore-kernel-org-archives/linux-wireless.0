Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45086 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932832Ab2EQTvN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 May 2012 15:51:13 -0400
Received: by pbbrp8 with SMTP id rp8so2953306pbb.19
        for <linux-wireless@vger.kernel.org>; Thu, 17 May 2012 12:51:13 -0700 (PDT)
From: Stanislav Yakovlev <stas.yakovlev@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Stanislav Yakovlev <stas.yakovlev@gmail.com>
Subject: [PATCH] net/wireless: ipw2200: introduce ipw_read_eeprom function
Date: Thu, 17 May 2012 15:56:35 -0400
Message-Id: <1337284595-3084-1-git-send-email-stas.yakovlev@gmail.com> (sfid-20120517_215117_626189_2E0425F9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We separate reading of device's eeprom content from writing it back
to the device's sram.

Signed-off-by: Stanislav Yakovlev <stas.yakovlev@gmail.com>
---
 drivers/net/wireless/ipw2x00/ipw2200.c |   23 +++++++++++++++++------
 1 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ipw2x00/ipw2200.c b/drivers/net/wireless/ipw2x00/ipw2200.c
index 0036737..254b892 100644
--- a/drivers/net/wireless/ipw2x00/ipw2200.c
+++ b/drivers/net/wireless/ipw2x00/ipw2200.c
@@ -2701,6 +2701,20 @@ static void eeprom_parse_mac(struct ipw_priv *priv, u8 * mac)
 	memcpy(mac, &priv->eeprom[EEPROM_MAC_ADDRESS], 6);
 }
 
+static void ipw_read_eeprom(struct ipw_priv *priv)
+{
+	int i;
+	__le16 *eeprom = (__le16 *) priv->eeprom;
+
+	IPW_DEBUG_TRACE(">>\n");
+
+	/* read entire contents of eeprom into private buffer */
+	for (i = 0; i < 128; i++)
+		eeprom[i] = cpu_to_le16(eeprom_read_u16(priv, (u8) i));
+
+	IPW_DEBUG_TRACE("<<\n");
+}
+
 /*
  * Either the device driver (i.e. the host) or the firmware can
  * load eeprom data into the designated region in SRAM.  If neither
@@ -2712,14 +2726,9 @@ static void eeprom_parse_mac(struct ipw_priv *priv, u8 * mac)
 static void ipw_eeprom_init_sram(struct ipw_priv *priv)
 {
 	int i;
-	__le16 *eeprom = (__le16 *) priv->eeprom;
 
 	IPW_DEBUG_TRACE(">>\n");
 
-	/* read entire contents of eeprom into private buffer */
-	for (i = 0; i < 128; i++)
-		eeprom[i] = cpu_to_le16(eeprom_read_u16(priv, (u8) i));
-
 	/*
 	   If the data looks correct, then copy it to our private
 	   copy.  Otherwise let the firmware know to perform the operation
@@ -3643,8 +3652,10 @@ static int ipw_load(struct ipw_priv *priv)
 	/* ack fw init done interrupt */
 	ipw_write32(priv, IPW_INTA_RW, IPW_INTA_BIT_FW_INITIALIZATION_DONE);
 
-	/* read eeprom data and initialize the eeprom region of sram */
+	/* read eeprom data */
 	priv->eeprom_delay = 1;
+	ipw_read_eeprom(priv);
+	/* initialize the eeprom region of sram */
 	ipw_eeprom_init_sram(priv);
 
 	/* enable interrupts */
-- 
1.7.2.5

