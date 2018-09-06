Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:49942 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728650AbeIFNxq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Sep 2018 09:53:46 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        linux-mediatek@lists.infradead.org
Subject: [PATCH 05/42] mt76: move mt76_qsel definition in dma.h
Date: Thu,  6 Sep 2018 11:18:21 +0200
Message-Id: <1536225538-16454-6-git-send-email-sgruszka@redhat.com> (sfid-20180906_111927_900667_9EFCC3E7)
In-Reply-To: <1536225538-16454-1-git-send-email-sgruszka@redhat.com>
References: <1536225538-16454-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>

Move mt76_qsel definition in dma.h in order to be reused in mt76x0
driver. Moreover remove empty mt76x2_dma.h header file

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/dma.h           |  7 ++++++
 drivers/net/wireless/mediatek/mt76/mt76x2_dma.c    |  2 +-
 drivers/net/wireless/mediatek/mt76/mt76x2_dma.h    | 29 ----------------------
 drivers/net/wireless/mediatek/mt76/mt76x2_mcu.c    |  2 +-
 drivers/net/wireless/mediatek/mt76/mt76x2_tx.c     |  2 +-
 .../net/wireless/mediatek/mt76/mt76x2_tx_common.c  |  2 +-
 drivers/net/wireless/mediatek/mt76/mt76x2u.h       |  2 +-
 7 files changed, 12 insertions(+), 34 deletions(-)
 delete mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2_dma.h

diff --git a/drivers/net/wireless/mediatek/mt76/dma.h b/drivers/net/wireless/mediatek/mt76/dma.h
index 828e52ae70e8..aa2faf19bf05 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.h
+++ b/drivers/net/wireless/mediatek/mt76/dma.h
@@ -75,6 +75,13 @@ enum dma_msg_port {
 	DISCARD,
 };
 
+enum mt76_qsel {
+	MT_QSEL_MGMT,
+	MT_QSEL_HCCA,
+	MT_QSEL_EDCA,
+	MT_QSEL_EDCA_2,
+};
+
 enum mt76_mcu_evt_type {
 	EVT_CMD_DONE,
 	EVT_CMD_ERROR,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_dma.c b/drivers/net/wireless/mediatek/mt76/mt76x2_dma.c
index 98ecc8b68723..44ca660775fd 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_dma.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_dma.c
@@ -15,7 +15,7 @@
  */
 
 #include "mt76x2.h"
-#include "mt76x2_dma.h"
+#include "dma.h"
 
 int
 mt76x2_tx_queue_mcu(struct mt76x2_dev *dev, enum mt76_txq_id qid,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_dma.h b/drivers/net/wireless/mediatek/mt76/mt76x2_dma.h
deleted file mode 100644
index da294558c268..000000000000
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_dma.h
+++ /dev/null
@@ -1,29 +0,0 @@
-/*
- * Copyright (C) 2016 Felix Fietkau <nbd@nbd.name>
- *
- * Permission to use, copy, modify, and/or distribute this software for any
- * purpose with or without fee is hereby granted, provided that the above
- * copyright notice and this permission notice appear in all copies.
- *
- * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
- * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
- * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
- * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
- * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
- * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
- * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
- */
-
-#ifndef __MT76x2_DMA_H
-#define __MT76x2_DMA_H
-
-#include "dma.h"
-
-enum mt76x2_qsel {
-	MT_QSEL_MGMT,
-	MT_QSEL_HCCA,
-	MT_QSEL_EDCA,
-	MT_QSEL_EDCA_2,
-};
-
-#endif
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76x2_mcu.c
index 743da57760dc..c90803334ef0 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_mcu.c
@@ -20,8 +20,8 @@
 
 #include "mt76x2.h"
 #include "mt76x2_mcu.h"
-#include "mt76x2_dma.h"
 #include "mt76x2_eeprom.h"
+#include "dma.h"
 
 static struct sk_buff *mt76x2_mcu_msg_alloc(const void *data, int len)
 {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_tx.c b/drivers/net/wireless/mediatek/mt76/mt76x2_tx.c
index 41bae90e5f6a..41d660991839 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_tx.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_tx.c
@@ -15,8 +15,8 @@
  */
 
 #include "mt76x2.h"
-#include "mt76x2_dma.h"
 #include "mt76x02_util.h"
+#include "dma.h"
 
 struct beacon_bc_data {
 	struct mt76x2_dev *dev;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_tx_common.c b/drivers/net/wireless/mediatek/mt76/mt76x2_tx_common.c
index c3c06e036832..dbb3071bed1b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_tx_common.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_tx_common.c
@@ -16,7 +16,7 @@
  */
 
 #include "mt76x2.h"
-#include "mt76x2_dma.h"
+#include "dma.h"
 
 void mt76x2_tx(struct ieee80211_hw *hw, struct ieee80211_tx_control *control,
 	       struct sk_buff *skb)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2u.h b/drivers/net/wireless/mediatek/mt76/mt76x2u.h
index 6946123820e8..180779bebaa2 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2u.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2u.h
@@ -20,8 +20,8 @@
 #include <linux/device.h>
 
 #include "mt76x2.h"
-#include "mt76x2_dma.h"
 #include "mt76x2_mcu.h"
+#include "dma.h"
 
 #define MT7612U_EEPROM_SIZE		512
 
-- 
2.7.5
