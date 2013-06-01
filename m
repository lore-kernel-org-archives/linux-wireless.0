Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:35574 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755517Ab3FAL01 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Jun 2013 07:26:27 -0400
Subject: [PATCH v2 18/29] ath10k: add mac.h
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath10k-devel@qca.qualcomm.com
Date: Sat, 01 Jun 2013 14:26:24 +0300
Message-ID: <20130601112623.32443.66622.stgit@localhost6.localdomain6> (sfid-20130601_132634_615899_53BC6281)
In-Reply-To: <20130601111820.32443.46794.stgit@localhost6.localdomain6>
References: <20130601111820.32443.46794.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/mac.h |   61 +++++++++++++++++++++++++++++++++
 1 file changed, 61 insertions(+)
 create mode 100644 drivers/net/wireless/ath/ath10k/mac.h

diff --git a/drivers/net/wireless/ath/ath10k/mac.h b/drivers/net/wireless/ath/ath10k/mac.h
new file mode 100644
index 0000000..27fc92e
--- /dev/null
+++ b/drivers/net/wireless/ath/ath10k/mac.h
@@ -0,0 +1,61 @@
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
+
+#ifndef _MAC_H_
+#define _MAC_H_
+
+#include <net/mac80211.h>
+#include "core.h"
+
+struct ath10k_generic_iter {
+	struct ath10k *ar;
+	int ret;
+};
+
+struct ath10k *ath10k_mac_create(void);
+void ath10k_mac_destroy(struct ath10k *ar);
+int ath10k_mac_register(struct ath10k *ar);
+void ath10k_mac_unregister(struct ath10k *ar);
+struct ath10k_vif *ath10k_get_arvif(struct ath10k *ar, u32 vdev_id);
+void ath10k_reset_scan(unsigned long ptr);
+void ath10k_offchan_tx_purge(struct ath10k *ar);
+void ath10k_offchan_tx_work(struct work_struct *work);
+
+static inline struct ath10k_vif *ath10k_vif_to_arvif(struct ieee80211_vif *vif)
+{
+	return (struct ath10k_vif *)vif->drv_priv;
+}
+
+static inline void ath10k_tx_h_seq_no(struct sk_buff *skb)
+{
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+	struct ieee80211_vif *vif = info->control.vif;
+	struct ath10k_vif *arvif = ath10k_vif_to_arvif(vif);
+
+	if (info->flags  & IEEE80211_TX_CTL_ASSIGN_SEQ) {
+		if (arvif->tx_seq_no == 0)
+			arvif->tx_seq_no = 0x1000;
+
+		if (info->flags & IEEE80211_TX_CTL_FIRST_FRAGMENT)
+			arvif->tx_seq_no += 0x10;
+		hdr->seq_ctrl &= cpu_to_le16(IEEE80211_SCTL_FRAG);
+		hdr->seq_ctrl |= cpu_to_le16(arvif->tx_seq_no);
+	}
+}
+
+#endif /* _MAC_H_ */

