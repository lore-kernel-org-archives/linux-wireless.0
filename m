Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.8]:37857 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754786Ab2C0OvR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Mar 2012 10:51:17 -0400
From: Jakub Kicinski <kubakici@wp.pl>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Jakub Kicinski <kubakici@wp.pl>
Subject: [PATCH 2/4] rt2x00: move disabling of DMA before loading firmware
Date: Tue, 27 Mar 2012 16:51:05 +0200
Message-Id: <1332859867-27921-3-git-send-email-kubakici@wp.pl> (sfid-20120327_165126_707870_239E72F6)
In-Reply-To: <1332859867-27921-1-git-send-email-kubakici@wp.pl>
References: <1332859867-27921-1-git-send-email-kubakici@wp.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Legacy driver disables DMA before not after loading firmware.

Signed-off-by: Jakub Kicinski <kubakici@wp.pl>
---
2011_0406_RT5390_RT5392_Linux_STA_V2.5.0.3_DPO
rtmp_init_inf.c:186
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   17 ++++++++---------
 1 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 4722030..c872ba6 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -411,6 +411,14 @@ int rt2800_load_firmware(struct rt2x00_dev *rt2x00dev,
 	}
 
 	/*
+	 * Disable DMA, will be reenabled later when enabling the radio.
+	 */
+	rt2800_register_read(rt2x00dev, WPDMA_GLO_CFG, &reg);
+	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_ENABLE_TX_DMA, 0);
+	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_ENABLE_RX_DMA, 0);
+	rt2800_register_write(rt2x00dev, WPDMA_GLO_CFG, reg);
+
+	/*
 	 * Write firmware to the device.
 	 */
 	rt2800_drv_write_firmware(rt2x00dev, data, len);
@@ -431,15 +439,6 @@ int rt2800_load_firmware(struct rt2x00_dev *rt2x00dev,
 	}
 
 	/*
-	 * Disable DMA, will be reenabled later when enabling
-	 * the radio.
-	 */
-	rt2800_register_read(rt2x00dev, WPDMA_GLO_CFG, &reg);
-	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_ENABLE_TX_DMA, 0);
-	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_ENABLE_RX_DMA, 0);
-	rt2800_register_write(rt2x00dev, WPDMA_GLO_CFG, reg);
-
-	/*
 	 * Initialize firmware.
 	 */
 	rt2800_register_write(rt2x00dev, H2M_BBP_AGENT, 0);
-- 
1.7.7.6

