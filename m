Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:47499 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753836Ab0IHXbA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Sep 2010 19:31:00 -0400
Received: by pzk34 with SMTP id 34so250147pzk.19
        for <linux-wireless@vger.kernel.org>; Wed, 08 Sep 2010 16:31:00 -0700 (PDT)
From: Steve deRosier <steve@cozybit.com>
To: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Cc: johannes@sipsolutions.net, javier@cozybit.com,
	Jason Spence <jspence@lightconsulting.com>,
	Steve deRosier <steve@cozybit.com>
Subject: [PATCH 1/2] libertas_tf: Removed some casts and fixed the printf format field specifiers to match.
Date: Wed,  8 Sep 2010 16:30:46 -0700
Message-Id: <1283988647-44747-1-git-send-email-steve@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jason Spence <jspence@lightconsulting.com>

Printf format fixes, one spelling fix and a note about reporting noise.

Signed-off-by: Jason Spence <jspence@lightconsulting.com>
Signed-off-by: Steve deRosier <steve@cozybit.com>
---
 drivers/net/wireless/libertas_tf/if_sdio.c |   58 ++++++++++++++--------------
 1 files changed, 29 insertions(+), 29 deletions(-)

diff --git a/drivers/net/wireless/libertas_tf/if_sdio.c b/drivers/net/wireless/libertas_tf/if_sdio.c
index 09c028f..d1624e3 100644
--- a/drivers/net/wireless/libertas_tf/if_sdio.c
+++ b/drivers/net/wireless/libertas_tf/if_sdio.c
@@ -205,8 +205,8 @@ static int if_sdio_handle_cmd(struct if_sdio_card *card,
 	lbtf_deb_enter(LBTF_DEB_SDIO);
 
 	if (size > LBS_CMD_BUFFER_SIZE) {
-		lbtf_deb_sdio("response packet too large (%d bytes)\n",
-			(int)size);
+		lbtf_deb_sdio("response packet too large (%u bytes)\n",
+			size);
 		ret = -E2BIG;
 		goto out;
 	}
@@ -235,8 +235,8 @@ static int if_sdio_handle_data(struct if_sdio_card *card,
 	lbtf_deb_enter(LBTF_DEB_INT);
 
 	if (size > MRVDRV_ETH_RX_PACKET_BUFFER_SIZE) {
-		lbtf_deb_sdio("response packet too large (%d bytes)\n",
-			(int)size);
+		lbtf_deb_sdio("response packet too large (%u bytes)\n",
+			size);
 		ret = -E2BIG;
 		goto out;
 	}
@@ -280,8 +280,8 @@ static int if_sdio_handle_event(struct if_sdio_card *card,
 		event >>= 3;
 	} else {
 		if (size < 4) {
-			lbtf_deb_sdio("event packet too small (%d bytes)\n",
-				(int)size);
+			lbtf_deb_sdio("event packet too small (%u bytes)\n",
+				size);
 			ret = -EINVAL;
 			goto out;
 		}
@@ -351,8 +351,8 @@ static int if_sdio_card_to_host(struct if_sdio_card *card)
 		goto out;
 
 	if (size < 4) {
-		lbtf_deb_sdio("invalid packet size (%d bytes) from firmware\n",
-			(int)size);
+		lbtf_deb_sdio("invalid packet size (%hu bytes) from firmware\n",
+			size);
 		ret = -EINVAL;
 		goto out;
 	}
@@ -375,19 +375,19 @@ static int if_sdio_card_to_host(struct if_sdio_card *card)
 	chunk = card->buffer[0] | (card->buffer[1] << 8);
 	type = card->buffer[2] | (card->buffer[3] << 8);
 
-	lbtf_deb_int("packet of type %d and size %d bytes\n",
-		(int)type, (int)chunk);
+	lbtf_deb_int("packet of type %hu and size %hu bytes\n",
+		type, chunk);
 
 	if (chunk > size) {
-		lbtf_deb_sdio("packet fragment (%d > %d)\n",
-			(int)chunk, (int)size);
+		lbtf_deb_sdio("packet fragment (%hu > %hu)\n",
+			chunk, size);
 		ret = -EINVAL;
 		goto out;
 	}
 
 	if (chunk < size) {
-		lbtf_deb_sdio("packet fragment (%d < %d)\n",
-			(int)chunk, (int)size);
+		lbtf_deb_sdio("packet fragment (%hu < %hu)\n",
+			chunk, size);
 	}
 
 	switch (type) {
@@ -407,8 +407,8 @@ static int if_sdio_card_to_host(struct if_sdio_card *card)
 			goto out;
 		break;
 	default:
-		lbtf_deb_sdio("invalid type (%d) from firmware\n",
-				(int)type);
+		lbtf_deb_sdio("invalid type (%hu) from firmware\n",
+				type);
 		ret = -EINVAL;
 		goto out;
 	}
@@ -525,7 +525,7 @@ static int if_sdio_prog_helper(struct if_sdio_card *card)
 		 */
 		mdelay(2);
 
-		chunk_size = min(size, (size_t)60);
+		chunk_size = min(size, 60U);
 
 		*((__le32*)chunk_buffer) = cpu_to_le32(chunk_size);
 		memcpy(chunk_buffer + 4, firmware, chunk_size);
@@ -991,22 +991,22 @@ int if_sdio_update_hw_spec(struct if_sdio_card *card)
 			chunk = card->buffer[0] | (card->buffer[1] << 8);
 			type = card->buffer[2] | (card->buffer[3] << 8);
 
-			lbtf_deb_sdio("packet of type %d and size %d bytes\n",
-				(int)type, (int)chunk);
+			lbtf_deb_sdio("packet of type %hu and size %hu bytes\n",
+				type, chunk);
 
 			lbtf_deb_hex(LBTF_DEB_SDIO, "SDIO Rx: ", card->buffer,
 						 min_t(unsigned int, size, 100));
 
 			if (chunk > size) {
-				lbtf_deb_sdio("packet fragment (%d > %d)\n",
-					(int)chunk, (int)size);
+				lbtf_deb_sdio("packet fragment (%hu > %hu)\n",
+					chunk, size);
 				ret = -EINVAL;
 				goto out;
 			}
 
 			if (chunk < size) {
-				lbtf_deb_sdio("packet fragment (%d < %d)\n",
-					(int)chunk, (int)size);
+				lbtf_deb_sdio("packet fragment (%hu < %hu)\n",
+					chunk, size);
 			}
 
 			switch (type) {
@@ -1022,8 +1022,8 @@ int if_sdio_update_hw_spec(struct if_sdio_card *card)
 				lbtf_deb_sdio("Got MVMS_EVENT");
 				continue;
 			default:
-				lbtf_deb_sdio("invalid type (%d) from firmware\n",
-						(int)type);
+				lbtf_deb_sdio("invalid type (%hu) from firmware\n",
+						type);
 				ret = -EINVAL;
 				goto out;
 			}
@@ -1085,7 +1085,7 @@ static void if_sdio_interrupt(struct sdio_func *func)
 	card = sdio_get_drvdata(func);
 
 	cause = sdio_readb(card->func, IF_SDIO_H_INT_STATUS, &ret);
-	lbtf_deb_int("interrupt: 0x%X\n", (unsigned)cause);
+	lbtf_deb_int("interrupt: 0x%hhX\n", cause);
 	lbtf_deb_int("interrupt ret: 0x%X\n", ret);
 	if (ret)
 		goto out;
@@ -1158,7 +1158,7 @@ static int if_sdio_probe(struct sdio_func *func,
 		card->scratch_reg = IF_SDIO_SCRATCH_OLD;
 		break;
 	case IF_SDIO_MODEL_8686:
-		lbtf_deb_sdio("Found Marvel 8686");
+		lbtf_deb_sdio("Found Marvell 8686");
 		card->scratch_reg = IF_SDIO_SCRATCH;
 		break;
 	case IF_SDIO_MODEL_8688:
@@ -1241,9 +1241,9 @@ static int if_sdio_probe(struct sdio_func *func,
 	sdio_set_drvdata(func, card);
 
 	lbtf_deb_sdio("class = 0x%X, vendor = 0x%X, "
-			"device = 0x%X, model = 0x%X, ioport = 0x%X\n",
+			"device = 0x%X, model = 0x%X, ioport = 0x%luX\n",
 			func->class, func->vendor, func->device,
-			model, (unsigned)card->ioport);
+			model, card->ioport);
 
 	/* Upload firmware */
 	lbtf_deb_sdio("Going to upload fw...");
-- 
1.7.0

