Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:32450 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271AbcA1SLN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jan 2016 13:11:13 -0500
Cc: Hamad Kadmany <QCA_hkadmany@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
	Maya Erez <qca_merez@qca.qualcomm.com>
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 4/4] wil6210: TX vring optimization
Date: Thu, 28 Jan 2016 19:24:05 +0200
Message-Id: <1454001845-28414-5-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20160128_191115_687214_9F8F4948)
In-Reply-To: <1454001845-28414-1-git-send-email-qca_merez@qca.qualcomm.com>
References: <1454001845-28414-1-git-send-email-qca_merez@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hamad Kadmany <qca_hkadmany@qca.qualcomm.com>

Tx vring needs to be enlarged to get better
performance for traffic over 2Gbps.

Signed-off-by: Hamad Kadmany <qca_hkadmany@qca.qualcomm.com>
Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/debugfs.c | 6 +++---
 drivers/net/wireless/ath/wil6210/wil6210.h | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index a1d10b8..3bbe73b 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2012-2015 Qualcomm Atheros, Inc.
+ * Copyright (c) 2012-2016 Qualcomm Atheros, Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
@@ -68,13 +68,13 @@ static void wil_print_vring(struct seq_file *s, struct wil6210_priv *wil,
 		seq_puts(s, "???\n");
 	}
 
-	if (vring->va && (vring->size < 1025)) {
+	if (vring->va && (vring->size <= (1 << WIL_RING_SIZE_ORDER_MAX))) {
 		uint i;
 
 		for (i = 0; i < vring->size; i++) {
 			volatile struct vring_tx_desc *d = &vring->va[i].tx;
 
-			if ((i % 64) == 0 && (i != 0))
+			if ((i % 128) == 0 && (i != 0))
 				seq_puts(s, "\n");
 			seq_printf(s, "%c", (d->dma.status & BIT(0)) ?
 					_s : (vring->ctx[i].skb ? _h : 'h'));
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 9502965..8427d68 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -51,7 +51,7 @@ static inline u32 WIL_GET_BITS(u32 x, int b0, int b1)
 
 #define WIL_TX_Q_LEN_DEFAULT		(4000)
 #define WIL_RX_RING_SIZE_ORDER_DEFAULT	(10)
-#define WIL_TX_RING_SIZE_ORDER_DEFAULT	(10)
+#define WIL_TX_RING_SIZE_ORDER_DEFAULT	(12)
 #define WIL_BCAST_RING_SIZE_ORDER_DEFAULT	(7)
 #define WIL_BCAST_MCS0_LIMIT		(1024) /* limit for MCS0 frame size */
 /* limit ring size in range [32..32k] */
-- 
1.8.5.2

