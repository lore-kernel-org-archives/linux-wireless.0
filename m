Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45468 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754095AbcKBOM0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 Nov 2016 10:12:26 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 02/10] rt2800usb: do not wipe out USB_DMA_CFG settings
Date: Wed,  2 Nov 2016 15:10:57 +0100
Message-Id: <1478095865-8651-3-git-send-email-sgruszka@redhat.com> (sfid-20161102_151243_645625_0EF1B177)
In-Reply-To: <1478095865-8651-1-git-send-email-sgruszka@redhat.com>
References: <1478095865-8651-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We should not reset USB_DMA_CFG on rt2800usb_init_registers() as this
function is called indirectly from rt2800_enable_radio(). If we
do so, we wipe out USB_DMA_CFG settings from rt2800usb_enable_radio().

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2800usb.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800usb.c b/drivers/net/wireless/ralink/rt2x00/rt2800usb.c
index 4b0bb6b..9f61293 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800usb.c
@@ -341,8 +341,6 @@ static int rt2800usb_init_registers(struct rt2x00_dev *rt2x00dev)
 	rt2x00_set_field32(&reg, MAC_SYS_CTRL_RESET_BBP, 1);
 	rt2x00usb_register_write(rt2x00dev, MAC_SYS_CTRL, reg);
 
-	rt2x00usb_register_write(rt2x00dev, USB_DMA_CFG, 0x00000000);
-
 	rt2x00usb_vendor_request_sw(rt2x00dev, USB_DEVICE_MODE, 0,
 				    USB_MODE_RESET, REGISTER_TIMEOUT);
 
@@ -353,12 +351,11 @@ static int rt2800usb_init_registers(struct rt2x00_dev *rt2x00dev)
 
 static int rt2800usb_enable_radio(struct rt2x00_dev *rt2x00dev)
 {
-	u32 reg;
+	u32 reg = 0;
 
 	if (unlikely(rt2800_wait_wpdma_ready(rt2x00dev)))
 		return -EIO;
 
-	rt2x00usb_register_read(rt2x00dev, USB_DMA_CFG, &reg);
 	rt2x00_set_field32(&reg, USB_DMA_CFG_PHY_CLEAR, 0);
 	rt2x00_set_field32(&reg, USB_DMA_CFG_RX_BULK_AGG_EN, 0);
 	rt2x00_set_field32(&reg, USB_DMA_CFG_RX_BULK_AGG_TIMEOUT, 128);
-- 
1.7.1
