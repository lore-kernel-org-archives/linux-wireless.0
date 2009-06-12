Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:63733 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757399AbZFLLOd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Jun 2009 07:14:33 -0400
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH 02/33] wl12xx: reserver buffer for read32()/write32() in
	struct wl12xx
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 12 Jun 2009 14:14:28 +0300
Message-ID: <20090612111428.8877.33418.stgit@tikku>
In-Reply-To: <20090612110225.8877.92418.stgit@tikku>
References: <20090612110225.8877.92418.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@nokia.com>

The buffer is needed for DMA safe transfers.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---

 drivers/net/wireless/wl12xx/spi.h    |    9 ++++-----
 drivers/net/wireless/wl12xx/wl12xx.h |    2 ++
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/spi.h b/drivers/net/wireless/wl12xx/spi.h
index fd3227e..f3f1895 100644
--- a/drivers/net/wireless/wl12xx/spi.h
+++ b/drivers/net/wireless/wl12xx/spi.h
@@ -94,16 +94,15 @@ void wl12xx_set_partition(struct wl12xx *wl,
 
 static inline u32 wl12xx_read32(struct wl12xx *wl, int addr)
 {
-	u32 response;
+	wl12xx_spi_read(wl, addr, &wl->buffer_32, sizeof(wl->buffer_32));
 
-	wl12xx_spi_read(wl, addr, &response, sizeof(u32));
-
-	return response;
+	return wl->buffer_32;
 }
 
 static inline void wl12xx_write32(struct wl12xx *wl, int addr, u32 val)
 {
-	wl12xx_spi_write(wl, addr, &val, sizeof(u32));
+	wl->buffer_32 = val;
+	wl12xx_spi_write(wl, addr, &wl->buffer_32, sizeof(wl->buffer_32));
 }
 
 #endif /* __WL12XX_SPI_H__ */
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index 4864143..f252a11 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -382,6 +382,8 @@ struct wl12xx {
 
 	struct wl12xx_stats stats;
 	struct wl12xx_debugfs debugfs;
+
+	u32 buffer_32;
 };
 
 int wl12xx_plt_start(struct wl12xx *wl);

