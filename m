Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2500 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754664Ab2AXNJd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jan 2012 08:09:33 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 2/4] rt2800: disable DMA after firmware load
Date: Tue, 24 Jan 2012 14:09:07 +0100
Message-Id: <1327410549-4714-2-git-send-email-sgruszka@redhat.com> (sfid-20120124_140937_346486_0AD2A592)
In-Reply-To: <1327410549-4714-1-git-send-email-sgruszka@redhat.com>
References: <1327410549-4714-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We can receive frames just after firmware load with current code, so
disable DMA just after firmware is loaded, not before.

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   21 +++++++++------------
 1 files changed, 9 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 3e194b7..165535c 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -412,18 +412,6 @@ int rt2800_load_firmware(struct rt2x00_dev *rt2x00dev,
 	}
 
 	/*
-	 * Disable DMA, will be reenabled later when enabling
-	 * the radio.
-	 */
-	rt2800_register_read(rt2x00dev, WPDMA_GLO_CFG, &reg);
-	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_ENABLE_TX_DMA, 0);
-	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_TX_DMA_BUSY, 0);
-	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_ENABLE_RX_DMA, 0);
-	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_RX_DMA_BUSY, 0);
-	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_TX_WRITEBACK_DONE, 1);
-	rt2800_register_write(rt2x00dev, WPDMA_GLO_CFG, reg);
-
-	/*
 	 * Write firmware to the device.
 	 */
 	rt2800_drv_write_firmware(rt2x00dev, data, len);
@@ -444,6 +432,15 @@ int rt2800_load_firmware(struct rt2x00_dev *rt2x00dev,
 	}
 
 	/*
+	 * Disable DMA, will be reenabled later when enabling
+	 * the radio.
+	 */
+	rt2800_register_read(rt2x00dev, WPDMA_GLO_CFG, &reg);
+	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_ENABLE_TX_DMA, 0);
+	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_ENABLE_RX_DMA, 0);
+	rt2800_register_write(rt2x00dev, WPDMA_GLO_CFG, reg);
+
+	/*
 	 * Initialize firmware.
 	 */
 	rt2800_register_write(rt2x00dev, H2M_BBP_AGENT, 0);
-- 
1.7.1

