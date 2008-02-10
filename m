Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.185]:34552 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481AbYBJVsf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Feb 2008 16:48:35 -0500
Received: by fk-out-0910.google.com with SMTP id z23so4237858fkz.5
        for <linux-wireless@vger.kernel.org>; Sun, 10 Feb 2008 13:48:34 -0800 (PST)
To: linville@tuxdriver.com
Subject: [PATCH 03/14] rt2x00: Remove MGMT ring initialization
Date: Sun, 10 Feb 2008 22:47:46 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200802102246.04515.IvDoorn@gmail.com>
In-Reply-To: <200802102246.04515.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200802102247.46548.IvDoorn@gmail.com> (sfid-20080210_214839_785987_563DA455)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove the last remnants of the MGMT ring initialization
from rt61pci.ko

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt61pci.c |    2 --
 drivers/net/wireless/rt2x00/rt61pci.h |    2 +-
 2 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index da0491b..41ea0c4 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -1070,7 +1070,6 @@ static int rt61pci_init_queues(struct rt2x00_dev *rt2x00dev)
 	rt2x00_set_field32(&reg, TX_DMA_DST_CSR_DEST_AC1, 2);
 	rt2x00_set_field32(&reg, TX_DMA_DST_CSR_DEST_AC2, 2);
 	rt2x00_set_field32(&reg, TX_DMA_DST_CSR_DEST_AC3, 2);
-	rt2x00_set_field32(&reg, TX_DMA_DST_CSR_DEST_MGMT, 0);
 	rt2x00pci_register_write(rt2x00dev, TX_DMA_DST_CSR, reg);
 
 	rt2x00pci_register_read(rt2x00dev, LOAD_TX_RING_CSR, &reg);
@@ -1078,7 +1077,6 @@ static int rt61pci_init_queues(struct rt2x00_dev *rt2x00dev)
 	rt2x00_set_field32(&reg, LOAD_TX_RING_CSR_LOAD_TXD_AC1, 1);
 	rt2x00_set_field32(&reg, LOAD_TX_RING_CSR_LOAD_TXD_AC2, 1);
 	rt2x00_set_field32(&reg, LOAD_TX_RING_CSR_LOAD_TXD_AC3, 1);
-	rt2x00_set_field32(&reg, LOAD_TX_RING_CSR_LOAD_TXD_MGMT, 0);
 	rt2x00pci_register_write(rt2x00dev, LOAD_TX_RING_CSR, reg);
 
 	rt2x00pci_register_read(rt2x00dev, RX_CNTL_CSR, &reg);
diff --git a/drivers/net/wireless/rt2x00/rt61pci.h b/drivers/net/wireless/rt2x00/rt61pci.h
index d291c0f..2f9a889 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.h
+++ b/drivers/net/wireless/rt2x00/rt61pci.h
@@ -880,7 +880,7 @@ struct hw_pairwise_ta_entry {
 #define TX_CNTL_CSR_ABORT_TX_MGMT	FIELD32(0x00100000)
 
 /*
- * LOAD_TX_RING_CSR: Load RX de
+ * LOAD_TX_RING_CSR: Load RX desriptor
  */
 #define LOAD_TX_RING_CSR		0x3434
 #define LOAD_TX_RING_CSR_LOAD_TXD_AC0	FIELD32(0x00000001)
-- 
1.5.4

