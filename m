Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59118 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1033933AbdAFNKE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 6 Jan 2017 08:10:04 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
        Mathias Kresin <dev@kresin.me>
Subject: [PATCH 1/9] rt2800usb: remove watchdog
Date: Fri,  6 Jan 2017 14:05:10 +0100
Message-Id: <1483707918-31480-2-git-send-email-sgruszka@redhat.com> (sfid-20170106_141123_076829_2DC8401C)
In-Reply-To: <1483707918-31480-1-git-send-email-sgruszka@redhat.com>
References: <1483707918-31480-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On rt2800usb, if we do not get TX status from HW, we assume frames were
posted and after entry->last_action timeout, we forcibly provide TX
status to mac80211. So it's not possible to detect hardware TX hung
based on the timeout. Additionally TXRQ_PCNT tells on number of frames
in the Packet Buffer (buffer between bus interface and chip MAC
subsystem), which can be non zero on normal conditions. To check HW hung
we will need provide some different mechanism, for now remove watchdog
as current implementation is wrong and not useful.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2800usb.c | 42 --------------------------
 1 file changed, 42 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800usb.c b/drivers/net/wireless/ralink/rt2x00/rt2800usb.c
index f38c440..8ec22c0 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800usb.c
@@ -436,47 +436,6 @@ static int rt2800usb_set_device_state(struct rt2x00_dev *rt2x00dev,
 }
 
 /*
- * Watchdog handlers
- */
-static void rt2800usb_watchdog(struct rt2x00_dev *rt2x00dev)
-{
-	unsigned int i;
-	u32 reg;
-
-	rt2x00usb_register_read(rt2x00dev, TXRXQ_PCNT, &reg);
-	if (rt2x00_get_field32(reg, TXRXQ_PCNT_TX0Q)) {
-		rt2x00_warn(rt2x00dev, "TX HW queue 0 timed out, invoke forced kick\n");
-
-		rt2x00usb_register_write(rt2x00dev, PBF_CFG, 0xf40012);
-
-		for (i = 0; i < 10; i++) {
-			udelay(10);
-			if (!rt2x00_get_field32(reg, TXRXQ_PCNT_TX0Q))
-				break;
-		}
-
-		rt2x00usb_register_write(rt2x00dev, PBF_CFG, 0xf40006);
-	}
-
-	rt2x00usb_register_read(rt2x00dev, TXRXQ_PCNT, &reg);
-	if (rt2x00_get_field32(reg, TXRXQ_PCNT_TX1Q)) {
-		rt2x00_warn(rt2x00dev, "TX HW queue 1 timed out, invoke forced kick\n");
-
-		rt2x00usb_register_write(rt2x00dev, PBF_CFG, 0xf4000a);
-
-		for (i = 0; i < 10; i++) {
-			udelay(10);
-			if (!rt2x00_get_field32(reg, TXRXQ_PCNT_TX1Q))
-				break;
-		}
-
-		rt2x00usb_register_write(rt2x00dev, PBF_CFG, 0xf40006);
-	}
-
-	rt2x00usb_watchdog(rt2x00dev);
-}
-
-/*
  * TX descriptor initialization
  */
 static __le32 *rt2800usb_get_txwi(struct queue_entry *entry)
@@ -877,7 +836,6 @@ static const struct rt2x00lib_ops rt2800usb_rt2x00_ops = {
 	.link_tuner		= rt2800_link_tuner,
 	.gain_calibration	= rt2800_gain_calibration,
 	.vco_calibration	= rt2800_vco_calibration,
-	.watchdog		= rt2800usb_watchdog,
 	.start_queue		= rt2800usb_start_queue,
 	.kick_queue		= rt2x00usb_kick_queue,
 	.stop_queue		= rt2800usb_stop_queue,
-- 
2.7.4
