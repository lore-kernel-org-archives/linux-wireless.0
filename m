Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cathcart.site5.com ([74.54.107.137]:45865 "EHLO
	cathcart.site5.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476AbZBCHeL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Feb 2009 02:34:11 -0500
Message-ID: <4987EC71.6070808@compulab.co.il> (sfid-20090203_083416_399104_3631FD92)
Date: Tue, 03 Feb 2009 09:04:17 +0200
From: Mike Rapoport <mike@compulab.co.il>
MIME-Version: 1.0
To: libertas-dev@lists.infradead.org
CC: linux-wireless@vger.kernel.org
Subject: [PATCH] libertas: add abilty to set DMA buffers alignmnet for SPI
 interface in compile time
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Different SPI controllers pose different alignment requirements on DMAable
buffers. It's possible to alter the SPI controller driver to use it's own
properly aligned buffers for DMA and copy the data it gets from the client
into these buffers. However, this approach also impacts overall performance.
Adding ability to set DMA buffers alignment for SPI interface in compile
time prevents unnecessary memcpy calls.

Signed-off-by: Mike Rapoport <mike@compulab.co.il>
---
 drivers/net/wireless/Kconfig           |   10 ++++++++++
 drivers/net/wireless/libertas/if_spi.c |   27 ++++++++++++++++-----------
 2 files changed, 26 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index fe819a7..3bbb7b2 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -157,6 +157,16 @@ config LIBERTAS_SPI
 	---help---
 	  A driver for Marvell Libertas 8686 SPI devices.

+config LIBERTAS_SPI_DMA_ALIGN
+	int "DMA buffers alignment for SPI interface"
+	depends on LIBERTAS_SPI
+	default 4 if !ARCH_PXA
+	default 8 if ARCH_PXA
+	---help---
+	  Different SPI controllers pose different alignment
+	  requirements on DMAable buffers. Allow proper setting of
+	  this value in compile-time.
+
 config LIBERTAS_DEBUG
 	bool "Enable full debugging output in the Libertas module."
 	depends on LIBERTAS
diff --git a/drivers/net/wireless/libertas/if_spi.c b/drivers/net/wireless/libertas/if_spi.c
index 07311e7..3499948 100644
--- a/drivers/net/wireless/libertas/if_spi.c
+++ b/drivers/net/wireless/libertas/if_spi.c
@@ -33,10 +33,12 @@
 #include "dev.h"
 #include "if_spi.h"

+#define DMA_ALIGN CONFIG_LIBERTAS_SPI_DMA_ALIGN
+
 struct if_spi_packet {
-	struct list_head		list;
-	u16				blen;
-	u8				buffer[0] __attribute__((aligned(4)));
+	struct list_head	list;
+	u16			blen;
+	u8			buffer[0] __attribute__((aligned(DMA_ALIGN)));
 };

 struct if_spi_card {
@@ -73,7 +75,7 @@ struct if_spi_card {
 	struct semaphore		spi_ready;
 	struct semaphore		spi_thread_terminated;

-	u8				cmd_buffer[IF_SPI_CMD_BUF_SIZE];
+	u8				cmd_buffer[IF_SPI_CMD_BUF_SIZE] __attribute__((aligned(DMA_ALIGN)));

 	/* A buffer of incoming packets from libertas core.
 	 * Since we can't sleep in hw_host_to_card, we have to buffer
@@ -665,10 +667,13 @@ static int if_spi_c2h_cmd(struct if_spi_card *card)
 	BUILD_BUG_ON(IF_SPI_CMD_BUF_SIZE < LBS_CMD_BUFFER_SIZE);
 	BUILD_BUG_ON(IF_SPI_CMD_BUF_SIZE < LBS_UPLD_SIZE);

-	/* It's just annoying if the buffer size isn't a multiple of 4, because
-	 * then we might have len <  IF_SPI_CMD_BUF_SIZE but
-	 * ALIGN(len, 4) > IF_SPI_CMD_BUF_SIZE */
-	BUILD_BUG_ON(IF_SPI_CMD_BUF_SIZE % 4 != 0);
+	/*
+	 * It's just annoying if the buffer size isn't a multiple of
+	 * DMA_ALIGN, because then we might have
+	 * len < IF_SPI_CMD_BUF_SIZE but
+	 * ALIGN(len, DMA_ALIGN) > IF_SPI_CMD_BUF_SIZE
+	 */
+	BUILD_BUG_ON(IF_SPI_CMD_BUF_SIZE % DMA_ALIGN != 0);

 	lbs_deb_enter(LBS_DEB_SPI);

@@ -691,7 +696,7 @@ static int if_spi_c2h_cmd(struct if_spi_card *card)

 	/* Read the data from the WLAN module into our command buffer */
 	err = spu_read(card, IF_SPI_CMD_RDWRPORT_REG,
-				card->cmd_buffer, ALIGN(len, 4));
+				card->cmd_buffer, ALIGN(len, DMA_ALIGN));
 	if (err)
 		goto out;

@@ -747,7 +752,7 @@ static int if_spi_c2h_data(struct if_spi_card *card)
 	data = skb_put(skb, len);

 	/* Read the data from the WLAN module into our skb... */
-	err = spu_read(card, IF_SPI_DATA_RDWRPORT_REG, data, ALIGN(len, 4));
+	err = spu_read(card, IF_SPI_DATA_RDWRPORT_REG, data, ALIGN(len, DMA_ALIGN));
 	if (err)
 		goto free_skb;

@@ -940,7 +945,7 @@ static int if_spi_host_to_card(struct lbs_private *priv,
 		err = -EINVAL;
 		goto out;
 	}
-	blen = ALIGN(nb, 4);
+	blen = ALIGN(nb, DMA_ALIGN);
 	packet = kzalloc(sizeof(struct if_spi_packet) + blen, GFP_ATOMIC);
 	if (!packet) {
 		err = -ENOMEM;
-- 
1.5.6.4


-- 
Sincerely yours,
Mike.

