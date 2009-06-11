Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.227]:59086 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761407AbZFKXWo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jun 2009 19:22:44 -0400
Received: by rv-out-0506.google.com with SMTP id f9so538970rvb.1
        for <linux-wireless@vger.kernel.org>; Thu, 11 Jun 2009 16:22:47 -0700 (PDT)
From: Andrey Yurovsky <andrey@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: dcbw@redhat.com, libertas-dev@lists.infradead.org,
	Andrey Yurovsky <andrey@cozybit.com>,
	Javier Cardona <javier@cozybit.com>
Subject: [PATCH] libertas: Fix IEEE PS mode in GSPI driver
Date: Thu, 11 Jun 2009 16:23:45 -0700
Message-Id: <1244762625-29618-1-git-send-email-andrey@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The card firmware does not set the Command Download Ready interrupt bit when
IEEE PS mode is enabled, preventing the driver from sending commands (such as
the command to exit IEEE PS mode) since there is no indication that the card is
ready to accept commands.  

This patch changes the driver to use the TX Download Ready bit, which is 
normally set along with Command Download Ready and does get set in IEEE PS 
mode.  It also moves the card event interrupt acknowledgement to the
interrupt handler and acknowledges all interrupts that we handle as well.

Signed-off-by: Andrey Yurovsky <andrey@cozybit.com>
Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 drivers/net/wireless/libertas/if_spi.c |   48 ++++++++++++++++++--------------
 1 files changed, 27 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/libertas/if_spi.c b/drivers/net/wireless/libertas/if_spi.c
index f8c2898..c32c08d 100644
--- a/drivers/net/wireless/libertas/if_spi.c
+++ b/drivers/net/wireless/libertas/if_spi.c
@@ -820,10 +820,6 @@ static void if_spi_e2h(struct if_spi_card *card)
 	if (err)
 		goto out;
 
-	/* re-enable the card event interrupt */
-	spu_write_u16(card, IF_SPI_HOST_INT_STATUS_REG,
-			~IF_SPI_HICU_CARD_EVENT);
-
 	/* generate a card interrupt */
 	spu_write_u16(card, IF_SPI_CARD_INT_CAUSE_REG, IF_SPI_CIC_HOST_EVENT);
 
@@ -867,23 +863,23 @@ static int lbs_spi_thread(void *data)
 			goto err;
 		}
 
-		if (hiStatus & IF_SPI_HIST_CMD_UPLOAD_RDY)
+		if (hiStatus & IF_SPI_HIST_CMD_UPLOAD_RDY) {
+			spu_write_u16(card, IF_SPI_HOST_INT_STATUS_REG,
+					~(IF_SPI_HIST_CMD_UPLOAD_RDY));
 			err = if_spi_c2h_cmd(card);
 			if (err)
 				goto err;
-		if (hiStatus & IF_SPI_HIST_RX_UPLOAD_RDY)
+		}
+		if (hiStatus & IF_SPI_HIST_RX_UPLOAD_RDY) {
+			spu_write_u16(card, IF_SPI_HOST_INT_STATUS_REG,
+					~(IF_SPI_HIST_RX_UPLOAD_RDY));
 			err = if_spi_c2h_data(card);
 			if (err)
 				goto err;
-		if (hiStatus & IF_SPI_HIST_CMD_DOWNLOAD_RDY) {
-			/* This means two things. First of all,
-			 * if there was a previous command sent, the card has
-			 * successfully received it.
-			 * Secondly, it is now ready to download another
-			 * command.
-			 */
-			lbs_host_to_card_done(card->priv);
+		}
 
+		if (hiStatus & IF_SPI_HIST_TX_DOWNLOAD_RDY ||
+		    hiStatus & IF_SPI_HIST_CMD_DOWNLOAD_RDY) {
 			/* Do we have any command packets from the host to
 			 * send? */
 			packet = NULL;
@@ -895,10 +891,12 @@ static int lbs_spi_thread(void *data)
 			}
 			spin_unlock_irqrestore(&card->buffer_lock, flags);
 
-			if (packet)
-				if_spi_h2c(card, packet, MVMS_CMD);
-		}
-		if (hiStatus & IF_SPI_HIST_TX_DOWNLOAD_RDY) {
+			if (packet) {
+				spu_write_u16(card, IF_SPI_HOST_INT_STATUS_REG,
+					~(IF_SPI_HIST_CMD_DOWNLOAD_RDY));
+				if_spi_h2c(card, packet, MVMS_CMD);
+			}
+
 			/* Do we have any data packets from the host to
 			 * send? */
 			packet = NULL;
@@ -910,12 +908,20 @@ static int lbs_spi_thread(void *data)
 			}
 			spin_unlock_irqrestore(&card->buffer_lock, flags);
 
-			if (packet)
+			if (packet) {
+				spu_write_u16(card, IF_SPI_HOST_INT_STATUS_REG,
+						~(IF_SPI_HIST_TX_DOWNLOAD_RDY));
 				if_spi_h2c(card, packet, MVMS_DAT);
+			}
+
+			lbs_host_to_card_done(card->priv);
 		}
-		if (hiStatus & IF_SPI_HIST_CARD_EVENT)
-			if_spi_e2h(card);
 
+		if (hiStatus & IF_SPI_HIST_CARD_EVENT) {
+			spu_write_u16(card, IF_SPI_HOST_INT_STATUS_REG,
+					~(IF_SPI_HIST_CARD_EVENT));
+			if_spi_e2h(card);
+		}
 err:
 		if (err)
 			lbs_pr_err("%s: got error %d\n", __func__, err);
-- 
1.5.6.3

