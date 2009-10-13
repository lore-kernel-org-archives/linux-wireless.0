Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:36164 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933759AbZJMJuC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2009 05:50:02 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 19/22] wl1271: Remove unnecessary rx_descriptor memory allocation
Date: Tue, 13 Oct 2009 12:47:56 +0300
Message-Id: <1255427279-1224-20-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1255427279-1224-1-git-send-email-luciano.coelho@nokia.com>
References: <1255427279-1224-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

Remove unnecessary RX descriptor memory allocation from the driver. The
allocation was a remnant of the wl1251 driver.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271.h      |    1 -
 drivers/net/wireless/wl12xx/wl1271_main.c |   13 -------------
 2 files changed, 0 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271.h b/drivers/net/wireless/wl12xx/wl1271.h
index 1e399a2..fca5968 100644
--- a/drivers/net/wireless/wl12xx/wl1271.h
+++ b/drivers/net/wireless/wl12xx/wl1271.h
@@ -429,7 +429,6 @@ struct wl1271 {
 	u32 buffer_32;
 	u32 buffer_cmd;
 	u32 buffer_busyword[WL1271_BUSY_WORD_CNT];
-	struct wl1271_rx_descriptor *rx_descriptor;
 
 	struct wl1271_fw_status *fw_status;
 	struct wl1271_tx_hw_res_if *tx_res_if;
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 7d70f41..dfa08a1 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -1893,13 +1893,6 @@ static int __devinit wl1271_probe(struct spi_device *spi)
 	wl->state = WL1271_STATE_OFF;
 	mutex_init(&wl->mutex);
 
-	wl->rx_descriptor = kmalloc(sizeof(*wl->rx_descriptor), GFP_KERNEL);
-	if (!wl->rx_descriptor) {
-		wl1271_error("could not allocate memory for rx descriptor");
-		ret = -ENOMEM;
-		goto out_free;
-	}
-
 	/* This is the only SPI value that we need to set here, the rest
 	 * comes from the board-peripherals file */
 	spi->bits_per_word = 32;
@@ -1965,9 +1958,6 @@ static int __devinit wl1271_probe(struct spi_device *spi)
 	free_irq(wl->irq, wl);
 
  out_free:
-	kfree(wl->rx_descriptor);
-	wl->rx_descriptor = NULL;
-
 	ieee80211_free_hw(hw);
 
 	return ret;
@@ -1988,9 +1978,6 @@ static int __devexit wl1271_remove(struct spi_device *spi)
 	kfree(wl->nvs);
 	wl->nvs = NULL;
 
-	kfree(wl->rx_descriptor);
-	wl->rx_descriptor = NULL;
-
 	kfree(wl->fw_status);
 	kfree(wl->tx_res_if);
 
-- 
1.5.6.5

