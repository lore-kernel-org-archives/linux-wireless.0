Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:42775 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759467Ab3EOOwk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 May 2013 10:52:40 -0400
Subject: [PATCH 26/29] ath10k: add txrx.h
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath10k-devel@qca.qualcomm.com
Date: Wed, 15 May 2013 17:46:30 +0300
Message-ID: <20130515144630.4492.89013.stgit@localhost6.localdomain6> (sfid-20130515_165317_043461_B778C48D)
In-Reply-To: <20130515143356.4492.43033.stgit@localhost6.localdomain6>
References: <20130515143356.4492.43033.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/txrx.h |   39 ++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)
 create mode 100644 drivers/net/wireless/ath/ath10k/txrx.h

diff --git a/drivers/net/wireless/ath/ath10k/txrx.h b/drivers/net/wireless/ath/ath10k/txrx.h
new file mode 100644
index 0000000..e78632a
--- /dev/null
+++ b/drivers/net/wireless/ath/ath10k/txrx.h
@@ -0,0 +1,39 @@
+/*
+ * Copyright (c) 2005-2011 Atheros Communications Inc.
+ * Copyright (c) 2011-2013 Qualcomm Atheros, Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+#ifndef _TXRX_H_
+#define _TXRX_H_
+
+#include "htt.h"
+
+void ath10k_txrx_tx_unref(struct ath10k_htt *htt, struct sk_buff *txdesc);
+void ath10k_txrx_tx_completed(struct ath10k_htt *htt,
+			      const struct htt_tx_done *tx_done);
+void ath10k_process_rx(struct ath10k *ar, struct htt_rx_info *info);
+
+struct ath10k_peer *ath10k_peer_find(struct ath10k *ar, int vdev_id,
+				     const u8 *addr);
+int ath10k_wait_for_peer_created(struct ath10k *ar, int vdev_id,
+				 const u8 *addr);
+int ath10k_wait_for_peer_deleted(struct ath10k *ar, int vdev_id,
+				 const u8 *addr);
+
+void ath10k_peer_map_event(struct ath10k_htt *htt,
+			   struct htt_peer_map_event *ev);
+void ath10k_peer_unmap_event(struct ath10k_htt *htt,
+			     struct htt_peer_unmap_event *ev);
+
+#endif

