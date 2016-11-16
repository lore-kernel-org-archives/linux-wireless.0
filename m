Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56328 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750998AbcKPL5a (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 Nov 2016 06:57:30 -0500
Date: Wed, 16 Nov 2016 12:53:20 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
        Mathias Kresin <dev@kresin.me>
Subject: [PATCH v2 04/10] rt2800: do not overwrite
 WPDMA_GLO_CFG_WP_DMA_BURST_SIZE
Message-ID: <20161116115319.GA26475@redhat.com> (sfid-20161116_125733_889446_1D9D55B1)
References: <1478095865-8651-1-git-send-email-sgruszka@redhat.com>
 <1478095865-8651-5-git-send-email-sgruszka@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1478095865-8651-5-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We already initlized WPDMA_GLO_CFG_WP_DMA_BURST_SIZE to 3 on
rt2800_init_registers() for USB devices. For PCI devices we will use
HW default setting, which is 2, so patch does not change behaviour
on PCI devices.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
v1 -> v2 Changelog fixes

 drivers/net/wireless/ralink/rt2x00/rt2800lib.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

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
1.7.1
