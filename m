Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:63922 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757462AbZFLLQZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Jun 2009 07:16:25 -0400
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH 10/33] wl12xx: add wl12xx_spi_reg_read() and
	wl12xx_spi_reg_write() functions
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 12 Jun 2009 14:15:22 +0300
Message-ID: <20090612111521.8877.50373.stgit@tikku>
In-Reply-To: <20090612110225.8877.92418.stgit@tikku>
References: <20090612110225.8877.92418.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@nokia.com>

In some cases we need to read more than 32 bits from the register area.
These functions were added to support that, like the existing
wl12xx_spi_mem_read() and wl12xx_spi_mem_write() already do for large blocks
in the memory area.

Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---

 drivers/net/wireless/wl12xx/spi.c |   18 ++++++++++++++++++
 drivers/net/wireless/wl12xx/spi.h |    2 ++
 2 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/spi.c b/drivers/net/wireless/wl12xx/spi.c
index bcdcfbc..0d2b13a 100644
--- a/drivers/net/wireless/wl12xx/spi.c
+++ b/drivers/net/wireless/wl12xx/spi.c
@@ -348,6 +348,24 @@ void wl12xx_spi_mem_write(struct wl12xx *wl, int addr, void *buf,
 	wl12xx_spi_write(wl, physical, buf, len);
 }
 
+void wl12xx_spi_reg_read(struct wl12xx *wl, int addr, void *buf, size_t len)
+{
+	int physical;
+
+	physical = wl12xx_translate_reg_addr(wl, addr);
+
+	wl12xx_spi_read(wl, physical, buf, len);
+}
+
+void wl12xx_spi_reg_write(struct wl12xx *wl, int addr, void *buf, size_t len)
+{
+	int physical;
+
+	physical = wl12xx_translate_reg_addr(wl, addr);
+
+	wl12xx_spi_write(wl, physical, buf, len);
+}
+
 u32 wl12xx_mem_read32(struct wl12xx *wl, int addr)
 {
 	return wl12xx_read32(wl, wl12xx_translate_mem_addr(wl, addr));
diff --git a/drivers/net/wireless/wl12xx/spi.h b/drivers/net/wireless/wl12xx/spi.h
index 1a19557..0996e48 100644
--- a/drivers/net/wireless/wl12xx/spi.h
+++ b/drivers/net/wireless/wl12xx/spi.h
@@ -81,6 +81,8 @@ u32 wl12xx_mem_read32(struct wl12xx *wl, int addr);
 void wl12xx_mem_write32(struct wl12xx *wl, int addr, u32 val);
 
 /* Registers IO */
+void wl12xx_spi_reg_read(struct wl12xx *wl, int addr, void *buf, size_t len);
+void wl12xx_spi_reg_write(struct wl12xx *wl, int addr, void *buf,size_t len);
 u32 wl12xx_reg_read32(struct wl12xx *wl, int addr);
 void wl12xx_reg_write32(struct wl12xx *wl, int addr, u32 val);
 

