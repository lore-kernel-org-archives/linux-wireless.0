Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:29109 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753520AbYFELKB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jun 2008 07:10:01 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: libertas-dev@lists.infradead.org, Dan Williams <dcbw@redhat.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 4/3] libertas: rename some registers to clarify their meaning
Date: Thu, 5 Jun 2008 13:09:50 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200806051309.50485.hs4233@mail.mn-solutions.de> (sfid-20080605_131005_724100_D9F9888A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

----

Patch four of three?  Hmm, this comes when a developer can only count to three ...

--- linux.orig/drivers/net/wireless/libertas/if_cs.c
+++ linux/drivers/net/wireless/libertas/if_cs.c
@@ -205,8 +205,8 @@
 /*
  * Used to send or receive data packets:
  */
-#define IF_CS_HOST_WRITE		0x00000016
-#define IF_CS_HOST_WRITE_LEN		0x00000014
+#define IF_CS_WRITE			0x00000016
+#define IF_CS_WRITE_LEN			0x00000014
 #define IF_CS_READ			0x00000010
 #define IF_CS_READ_LEN			0x00000024
 
@@ -214,10 +214,10 @@
  * Used to send commands (and to send firmware block) and to
  * receive command responses:
  */
-#define IF_CS_HOST_CMD			0x0000001A
-#define IF_CS_HOST_CMD_LEN		0x00000018
-#define IF_CS_CARD_CMD			0x00000012
-#define IF_CS_CARD_CMD_LEN		0x00000030
+#define IF_CS_CMD			0x0000001A
+#define IF_CS_CMD_LEN			0x00000018
+#define IF_CS_RESP			0x00000012
+#define IF_CS_RESP_LEN			0x00000030
 
 /*
  * The card status registers shows what the card/firmware actually
@@ -255,8 +255,8 @@
  * This is used to for handshaking with the card's bootloader/helper image
  * to synchronize downloading of firmware blocks.
  */
-#define IF_CS_CARD_SQ_READ_LOW		0x00000028
-#define IF_CS_CARD_SQ_HELPER_OK		0x10
+#define IF_CS_SQ_READ_LOW		0x00000028
+#define IF_CS_SQ_HELPER_OK		0x10
 
 /*
  * The scratch register tells us ...
@@ -305,8 +305,8 @@
 
 	/* Is hardware ready? */
 	while (1) {
-		u16 val = if_cs_read16(card, IF_CS_CARD_STATUS);
-		if (val & IF_CS_BIT_COMMAND)
+		u16 status = if_cs_read16(card, IF_CS_CARD_STATUS);
+		if (status & IF_CS_BIT_COMMAND)
 			break;
 		if (++loops > 100) {
 			lbs_pr_err("card not ready for commands\n");
@@ -315,12 +315,12 @@
 		mdelay(1);
 	}
 
-	if_cs_write16(card, IF_CS_HOST_CMD_LEN, nb);
+	if_cs_write16(card, IF_CS_CMD_LEN, nb);
 
-	if_cs_write16_rep(card, IF_CS_HOST_CMD, buf, nb / 2);
+	if_cs_write16_rep(card, IF_CS_CMD, buf, nb / 2);
 	/* Are we supposed to transfer an odd amount of bytes? */
 	if (nb & 1)
-		if_cs_write8(card, IF_CS_HOST_CMD, buf[nb-1]);
+		if_cs_write8(card, IF_CS_CMD, buf[nb-1]);
 
 	/* "Assert the download over interrupt command in the Host
 	 * status register" */
@@ -352,12 +352,12 @@
 	status = if_cs_read16(card, IF_CS_CARD_STATUS);
 	BUG_ON((status & IF_CS_BIT_TX) == 0);
 
-	if_cs_write16(card, IF_CS_HOST_WRITE_LEN, nb);
+	if_cs_write16(card, IF_CS_WRITE_LEN, nb);
 
 	/* write even number of bytes, then odd byte if necessary */
-	if_cs_write16_rep(card, IF_CS_HOST_WRITE, buf, nb / 2);
+	if_cs_write16_rep(card, IF_CS_WRITE, buf, nb / 2);
 	if (nb & 1)
-		if_cs_write8(card, IF_CS_HOST_WRITE, buf[nb-1]);
+		if_cs_write8(card, IF_CS_WRITE, buf[nb-1]);
 
 	if_cs_write16(card, IF_CS_HOST_STATUS, IF_CS_BIT_TX);
 	if_cs_write16(card, IF_CS_HOST_INT_CAUSE, IF_CS_BIT_TX);
@@ -385,16 +385,16 @@
 		goto out;
 	}
 
-	*len = if_cs_read16(priv->card, IF_CS_CARD_CMD_LEN);
+	*len = if_cs_read16(priv->card, IF_CS_RESP_LEN);
 	if ((*len == 0) || (*len > LBS_CMD_BUFFER_SIZE)) {
 		lbs_pr_err("card cmd buffer has invalid # of bytes (%d)\n", *len);
 		goto out;
 	}
 
 	/* read even number of bytes, then odd byte if necessary */
-	if_cs_read16_rep(priv->card, IF_CS_CARD_CMD, data, *len/sizeof(u16));
+	if_cs_read16_rep(priv->card, IF_CS_RESP, data, *len/sizeof(u16));
 	if (*len & 1)
-		data[*len-1] = if_cs_read8(priv->card, IF_CS_CARD_CMD);
+		data[*len-1] = if_cs_read8(priv->card, IF_CS_RESP);
 
 	/* This is a workaround for a firmware that reports too much
 	 * bytes */
@@ -502,12 +502,10 @@
 	}
 
 	if (cause & IF_CS_BIT_EVENT) {
-		u16 event = if_cs_read16(priv->card, IF_CS_CARD_STATUS)
-			& IF_CS_CARD_STATUS_MASK;
+		u16 status = if_cs_read16(priv->card, IF_CS_CARD_STATUS);
 		if_cs_write16(priv->card, IF_CS_HOST_INT_CAUSE,
 			IF_CS_BIT_EVENT);
-		lbs_deb_cs("host event 0x%04x\n", event);
-		lbs_queue_event(priv, event >> 8 & 0xff);
+		lbs_queue_event(priv, (status & IF_CS_CARD_STATUS_MASK) >> 8);
 	}
 
 	/* Clear interrupt cause */
@@ -575,11 +573,11 @@
 
 		/* "write the number of bytes to be sent to the I/O Command
 		 * write length register" */
-		if_cs_write16(card, IF_CS_HOST_CMD_LEN, count);
+		if_cs_write16(card, IF_CS_CMD_LEN, count);
 
 		/* "write this to I/O Command port register as 16 bit writes */
 		if (count)
-			if_cs_write16_rep(card, IF_CS_HOST_CMD,
+			if_cs_write16_rep(card, IF_CS_CMD,
 				&fw->data[sent],
 				count >> 1);
 
@@ -637,15 +635,15 @@
 	}
 	lbs_deb_cs("fw size %td\n", fw->size);
 
-	ret = if_cs_poll_while_fw_download(card, IF_CS_CARD_SQ_READ_LOW,
-		IF_CS_CARD_SQ_HELPER_OK);
+	ret = if_cs_poll_while_fw_download(card, IF_CS_SQ_READ_LOW,
+		IF_CS_SQ_HELPER_OK);
 	if (ret < 0) {
 		lbs_pr_err("helper firmware doesn't answer\n");
 		goto err_release;
 	}
 
 	for (sent = 0; sent < fw->size; sent += len) {
-		len = if_cs_read16(card, IF_CS_CARD_SQ_READ_LOW);
+		len = if_cs_read16(card, IF_CS_SQ_READ_LOW);
 		if (len & 1) {
 			retry++;
 			lbs_pr_info("odd, need to retry this firmware block\n");
@@ -663,9 +661,9 @@
 		}
 
 
-		if_cs_write16(card, IF_CS_HOST_CMD_LEN, len);
+		if_cs_write16(card, IF_CS_CMD_LEN, len);
 
-		if_cs_write16_rep(card, IF_CS_HOST_CMD,
+		if_cs_write16_rep(card, IF_CS_CMD,
 			&fw->data[sent],
 			(len+1) >> 1);
 		if_cs_write8(card, IF_CS_HOST_STATUS, IF_CS_BIT_COMMAND);
