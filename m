Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:64714 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756096AbZFLLQV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Jun 2009 07:16:21 -0400
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH 07/33] wl12xx: use wl12xx_mem_read32() to read the rx counter
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 12 Jun 2009 14:15:00 +0300
Message-ID: <20090612111500.8877.4147.stgit@tikku>
In-Reply-To: <20090612110225.8877.92418.stgit@tikku>
References: <20090612110225.8877.92418.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@nokia.com>

As a side effect the transfer is now DMA safe.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---

 drivers/net/wireless/wl12xx/wl1251.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1251.c b/drivers/net/wireless/wl12xx/wl1251.c
index 1a352cf..e484a23 100644
--- a/drivers/net/wireless/wl12xx/wl1251.c
+++ b/drivers/net/wireless/wl12xx/wl1251.c
@@ -415,8 +415,8 @@ static void wl1251_irq_work(struct work_struct *work)
 	wl12xx_debug(DEBUG_IRQ, "intr: 0x%x", intr);
 
 	if (wl->data_path) {
-		wl12xx_spi_mem_read(wl, wl->data_path->rx_control_addr,
-				    &wl->rx_counter, sizeof(u32));
+		wl->rx_counter =
+			wl12xx_mem_read32(wl, wl->data_path->rx_control_addr);
 
 		/* We handle a frmware bug here */
 		switch ((wl->rx_counter - wl->rx_handled) & 0xf) {

