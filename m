Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40958 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932237AbdBHNNL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Feb 2017 08:13:11 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [PATCH 1/3] rt61pci: use entry directly
Date: Wed,  8 Feb 2017 13:51:29 +0100
Message-Id: <1486558291-1615-2-git-send-email-sgruszka@redhat.com> (sfid-20170208_141353_707149_069B9165)
In-Reply-To: <1486558291-1615-1-git-send-email-sgruszka@redhat.com>
References: <1486558291-1615-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/ralink/rt2x00/rt61pci.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt61pci.c b/drivers/net/wireless/ralink/rt2x00/rt61pci.c
index 5306a3b..8adb5f3 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt61pci.c
@@ -1903,8 +1903,7 @@ static void rt61pci_write_tx_desc(struct queue_entry *entry,
 
 	rt2x00_desc_read(txd, 5, &word);
 	rt2x00_set_field32(&word, TXD_W5_PID_TYPE, entry->queue->qid);
-	rt2x00_set_field32(&word, TXD_W5_PID_SUBTYPE,
-			   skbdesc->entry->entry_idx);
+	rt2x00_set_field32(&word, TXD_W5_PID_SUBTYPE, entry->entry_idx);
 	rt2x00_set_field32(&word, TXD_W5_TX_POWER,
 			   TXPOWER_TO_DEV(entry->queue->rt2x00dev->tx_power));
 	rt2x00_set_field32(&word, TXD_W5_WAITING_DMA_DONE_INT, 1);
-- 
1.8.3.1
