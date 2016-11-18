Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39382 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752563AbcKRJsR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Nov 2016 04:48:17 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
        Mathias Kresin <dev@kresin.me>
Subject: [PATCH v2 4/9] rt2800: do not overwrite WPDMA_GLO_CFG_WP_DMA_BURST_SIZE
Date: Fri, 18 Nov 2016 10:43:56 +0100
Message-Id: <1479462241-9299-5-git-send-email-sgruszka@redhat.com> (sfid-20161118_104819_705703_C3FCA959)
In-Reply-To: <1479462241-9299-1-git-send-email-sgruszka@redhat.com>
References: <1479462241-9299-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We already initlized WPDMA_GLO_CFG_WP_DMA_BURST_SIZE to 3 on
rt2800_init_registers() for USB devices. For PCI devices we will use
HW default setting, which is 2, so patch does not change behaviour
on PCI devices.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index feceb13..9ecdc4c 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -6756,7 +6756,6 @@ int rt2800_enable_radio(struct rt2x00_dev *rt2x00dev)
 	rt2800_register_read(rt2x00dev, WPDMA_GLO_CFG, &reg);
 	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_ENABLE_TX_DMA, 1);
 	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_ENABLE_RX_DMA, 1);
-	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_WP_DMA_BURST_SIZE, 2);
 	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_TX_WRITEBACK_DONE, 1);
 	rt2800_register_write(rt2x00dev, WPDMA_GLO_CFG, reg);
 
-- 
1.8.3.1
