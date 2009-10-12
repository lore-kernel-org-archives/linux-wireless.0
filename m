Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:47739 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755577AbZJLMKx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Oct 2009 08:10:53 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 06/16] wl1271: Remove RX workaround
Date: Mon, 12 Oct 2009 15:08:47 +0300
Message-Id: <1255349337-9776-7-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1255349337-9776-1-git-send-email-luciano.coelho@nokia.com>
References: <1255349337-9776-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

Remove RX workaround which is not needed with newer firmware revisions. This
will reduce one SPI register transaction per RX packet.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_reg.h |    1 -
 drivers/net/wireless/wl12xx/wl1271_rx.c  |    4 ----
 2 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_reg.h b/drivers/net/wireless/wl12xx/wl1271_reg.h
index f8ed4a4..bd12615 100644
--- a/drivers/net/wireless/wl12xx/wl1271_reg.h
+++ b/drivers/net/wireless/wl12xx/wl1271_reg.h
@@ -213,7 +213,6 @@
 ==============================================*/
 #define ACX_REG_INTERRUPT_ACK          (REGISTERS_BASE + 0x04F0)
 
-#define RX_DRIVER_DUMMY_WRITE_ADDRESS  (REGISTERS_BASE + 0x0534)
 #define RX_DRIVER_COUNTER_ADDRESS      (REGISTERS_BASE + 0x0538)
 
 /* Device Configuration registers*/
diff --git a/drivers/net/wireless/wl12xx/wl1271_rx.c b/drivers/net/wireless/wl12xx/wl1271_rx.c
index 5d8d401..1d98653 100644
--- a/drivers/net/wireless/wl12xx/wl1271_rx.c
+++ b/drivers/net/wireless/wl12xx/wl1271_rx.c
@@ -187,8 +187,4 @@ void wl1271_rx(struct wl1271 *wl, struct wl1271_fw_status *status)
 	}
 
 	wl1271_reg_write32(wl, RX_DRIVER_COUNTER_ADDRESS, wl->rx_counter);
-
-	/* This is a workaround for some problems in the chip */
-	wl1271_reg_write32(wl, RX_DRIVER_DUMMY_WRITE_ADDRESS, 0x1);
-
 }
-- 
1.5.6.5

