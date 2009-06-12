Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:38998 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757067AbZFLLQP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Jun 2009 07:16:15 -0400
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH 08/33] wl12xx: fix rx descriptor use
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 12 Jun 2009 14:15:08 +0300
Message-ID: <20090612111507.8877.773.stgit@tikku>
In-Reply-To: <20090612110225.8877.92418.stgit@tikku>
References: <20090612110225.8877.92418.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@nokia.com>

Rx descriptor was incorrectly allocated from stack, use struct wl12xx
instead. Needed for DMA transfers.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---

 drivers/net/wireless/wl12xx/main.c   |   14 ++++++++++++++
 drivers/net/wireless/wl12xx/rx.c     |   11 ++++++-----
 drivers/net/wireless/wl12xx/wl12xx.h |    1 +
 3 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 6d27cd6..3c6cd77 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1261,6 +1261,13 @@ static int __devinit wl12xx_probe(struct spi_device *spi)
 	wl->tx_mgmt_frm_rate = DEFAULT_HW_GEN_TX_RATE;
 	wl->tx_mgmt_frm_mod = DEFAULT_HW_GEN_MODULATION_TYPE;
 
+	wl->rx_descriptor = kmalloc(sizeof(*wl->rx_descriptor), GFP_KERNEL);
+	if (!wl->rx_descriptor) {
+		wl12xx_error("could not allocate memory for rx descriptor");
+		ret = -ENOMEM;
+		goto out_free;
+	}
+
 	/* This is the only SPI value that we need to set here, the rest
 	 * comes from the board-peripherals file */
 	spi->bits_per_word = 32;
@@ -1313,6 +1320,9 @@ static int __devinit wl12xx_probe(struct spi_device *spi)
 	free_irq(wl->irq, wl);
 
  out_free:
+	kfree(wl->rx_descriptor);
+	wl->rx_descriptor = NULL;
+
 	ieee80211_free_hw(hw);
 
 	return ret;
@@ -1333,6 +1343,10 @@ static int __devexit wl12xx_remove(struct spi_device *spi)
 	wl->fw = NULL;
 	kfree(wl->nvs);
 	wl->nvs = NULL;
+
+	kfree(wl->rx_descriptor);
+	wl->rx_descriptor = NULL;
+
 	ieee80211_free_hw(wl->hw);
 
 	return 0;
diff --git a/drivers/net/wireless/wl12xx/rx.c b/drivers/net/wireless/wl12xx/rx.c
index 5fd916a..7ac26ef 100644
--- a/drivers/net/wireless/wl12xx/rx.c
+++ b/drivers/net/wireless/wl12xx/rx.c
@@ -39,8 +39,7 @@ static void wl12xx_rx_header(struct wl12xx *wl,
 	if (wl->rx_current_buffer)
 		rx_packet_ring_addr += wl->data_path->rx_packet_ring_chunk_size;
 
-	wl12xx_spi_mem_read(wl, rx_packet_ring_addr, desc,
-			    sizeof(struct wl12xx_rx_descriptor));
+	wl12xx_spi_mem_read(wl, rx_packet_ring_addr, desc, sizeof(*desc));
 }
 
 static void wl12xx_rx_status(struct wl12xx *wl,
@@ -175,16 +174,18 @@ static void wl12xx_rx_ack(struct wl12xx *wl)
 
 void wl12xx_rx(struct wl12xx *wl)
 {
-	struct wl12xx_rx_descriptor rx_desc;
+	struct wl12xx_rx_descriptor *rx_desc;
 
 	if (wl->state != WL12XX_STATE_ON)
 		return;
 
+	rx_desc = wl->rx_descriptor;
+
 	/* We first read the frame's header */
-	wl12xx_rx_header(wl, &rx_desc);
+	wl12xx_rx_header(wl, rx_desc);
 
 	/* Now we can read the body */
-	wl12xx_rx_body(wl, &rx_desc);
+	wl12xx_rx_body(wl, rx_desc);
 
 	/* Finally, we need to ACK the RX */
 	wl12xx_rx_ack(wl);
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index b811020..b874214 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -387,6 +387,7 @@ struct wl12xx {
 	u32 buffer_32;
 	u32 buffer_cmd;
 	u8 buffer_busyword[WL12XX_BUSY_WORD_LEN];
+	struct wl12xx_rx_descriptor *rx_descriptor;
 };
 
 int wl12xx_plt_start(struct wl12xx *wl);

