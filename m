Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:61669 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757975Ab2EJJPO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 05:15:14 -0400
Received: by mail-wg0-f44.google.com with SMTP id dr13so1110716wgb.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 May 2012 02:15:14 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 20/78] wl18xx: implement immediate Tx completion
Date: Thu, 10 May 2012 12:13:25 +0300
Message-Id: <1336641263-5761-21-git-send-email-arik@wizery.com> (sfid-20120510_112507_713777_D4F54C04)
In-Reply-To: <1336641263-5761-1-git-send-email-arik@wizery.com>
References: <1336641263-5761-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Implement immediate Tx completion for the 18xx family. Move 18xx
specific Tx code to new tx.c/h files and create helper header files
for definitions.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wl18xx/Makefile |    2 +-
 drivers/net/wireless/ti/wl18xx/main.c   |   11 ++-
 drivers/net/wireless/ti/wl18xx/tx.c     |  126 +++++++++++++++++++++++++++++++
 drivers/net/wireless/ti/wl18xx/tx.h     |   36 +++++++++
 drivers/net/wireless/ti/wl18xx/wl18xx.h |    3 +
 drivers/net/wireless/ti/wlcore/tx.c     |    4 +-
 drivers/net/wireless/ti/wlcore/tx.h     |    1 +
 7 files changed, 178 insertions(+), 5 deletions(-)
 create mode 100644 drivers/net/wireless/ti/wl18xx/tx.c
 create mode 100644 drivers/net/wireless/ti/wl18xx/tx.h

diff --git a/drivers/net/wireless/ti/wl18xx/Makefile b/drivers/net/wireless/ti/wl18xx/Makefile
index d187037..dd3b4c1 100644
--- a/drivers/net/wireless/ti/wl18xx/Makefile
+++ b/drivers/net/wireless/ti/wl18xx/Makefile
@@ -1,3 +1,3 @@
-wl18xx-objs	= main.o
+wl18xx-objs	= main.o tx.o
 
 obj-$(CONFIG_WL18XX)		+= wl18xx.o
diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index 40ed53c..ae71131 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -33,11 +33,9 @@
 
 #include "reg.h"
 #include "conf.h"
+#include "tx.h"
 #include "wl18xx.h"
 
-#define WL18XX_TX_HW_BLOCK_SPARE        1
-#define WL18XX_TX_HW_GEM_BLOCK_SPARE    2
-#define WL18XX_TX_HW_BLOCK_SIZE         268
 
 static const u8 wl18xx_rate_to_idx_2ghz[] = {
 	/* MCS rates are used only with 11n */
@@ -470,6 +468,11 @@ static u32 wl18xx_get_rx_packet_len(struct wl1271 *wl, void *rx_data,
 	return data_len - sizeof(*desc);
 }
 
+static void wl18xx_tx_immediate_completion(struct wl1271 *wl)
+{
+	wl18xx_tx_immediate_complete(wl);
+}
+
 static struct wlcore_ops wl18xx_ops = {
 	.identify_chip	= wl18xx_identify_chip,
 	.boot		= wl18xx_boot,
@@ -480,6 +483,8 @@ static struct wlcore_ops wl18xx_ops = {
 	.set_tx_desc_data_len = wl18xx_set_tx_desc_data_len,
 	.get_rx_buf_align = wl18xx_get_rx_buf_align,
 	.get_rx_packet_len = wl18xx_get_rx_packet_len,
+	.tx_immediate_compl = wl18xx_tx_immediate_completion,
+	.tx_delayed_compl = NULL,
 };
 
 int __devinit wl18xx_probe(struct platform_device *pdev)
diff --git a/drivers/net/wireless/ti/wl18xx/tx.c b/drivers/net/wireless/ti/wl18xx/tx.c
new file mode 100644
index 0000000..4e12f56
--- /dev/null
+++ b/drivers/net/wireless/ti/wl18xx/tx.c
@@ -0,0 +1,126 @@
+/*
+ * This file is part of wl18xx
+ *
+ * Copyright (C) 2011 Texas Instruments Inc.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#include "../wlcore/wlcore.h"
+#include "../wlcore/cmd.h"
+#include "../wlcore/debug.h"
+#include "../wlcore/acx.h"
+#include "../wlcore/tx.h"
+
+#include "wl18xx.h"
+#include "tx.h"
+
+static void wl18xx_tx_complete_packet(struct wl1271 *wl, u8 tx_stat_byte)
+{
+	struct ieee80211_tx_info *info;
+	struct sk_buff *skb;
+	int id = tx_stat_byte & WL18XX_TX_STATUS_DESC_ID_MASK;
+	bool tx_success;
+
+	/* check for id legality */
+	if (unlikely(id >= wl->num_tx_desc || wl->tx_frames[id] == NULL)) {
+		wl1271_warning("illegal id in tx completion: %d", id);
+		return;
+	}
+
+	/* a zero bit indicates Tx success */
+	tx_success = !(tx_stat_byte & BIT(WL18XX_TX_STATUS_STAT_BIT_IDX));
+
+
+	skb = wl->tx_frames[id];
+	info = IEEE80211_SKB_CB(skb);
+
+	if (wl12xx_is_dummy_packet(wl, skb)) {
+		wl1271_free_tx_id(wl, id);
+		return;
+	}
+
+	/* update the TX status info */
+	if (tx_success && !(info->flags & IEEE80211_TX_CTL_NO_ACK))
+		info->flags |= IEEE80211_TX_STAT_ACK;
+
+	/* no real data about Tx completion */
+	info->status.rates[0].idx = -1;
+	info->status.rates[0].count = 0;
+	info->status.rates[0].flags = 0;
+	info->status.ack_signal = -1;
+
+	if (!tx_success)
+		wl->stats.retry_count++;
+
+	/*
+	 * TODO: update sequence number for encryption? seems to be
+	 * unsupported for now. needed for recovery with encryption.
+	 */
+
+	/* remove private header from packet */
+	skb_pull(skb, sizeof(struct wl1271_tx_hw_descr));
+
+	/* remove TKIP header space if present */
+	if (info->control.hw_key &&
+	    info->control.hw_key->cipher == WLAN_CIPHER_SUITE_TKIP) {
+		int hdrlen = ieee80211_get_hdrlen_from_skb(skb);
+		memmove(skb->data + WL1271_EXTRA_SPACE_TKIP, skb->data, hdrlen);
+		skb_pull(skb, WL1271_EXTRA_SPACE_TKIP);
+	}
+
+	wl1271_debug(DEBUG_TX, "tx status id %u skb 0x%p success %d",
+		     id, skb, tx_success);
+
+	/* return the packet to the stack */
+	skb_queue_tail(&wl->deferred_tx_queue, skb);
+	queue_work(wl->freezable_wq, &wl->netstack_work);
+	wl1271_free_tx_id(wl, id);
+}
+
+void wl18xx_tx_immediate_complete(struct wl1271 *wl)
+{
+	struct wl18xx_fw_status_priv *status_priv =
+		(struct wl18xx_fw_status_priv *)wl->fw_status->priv;
+	struct wl18xx_priv *priv = wl->priv;
+	u8 i;
+
+	/* nothing to do here */
+	if (priv->last_fw_rls_idx == status_priv->fw_release_idx)
+		return;
+
+	/* freed Tx descriptors */
+	wl1271_debug(DEBUG_TX, "last released desc = %d, current idx = %d",
+		     priv->last_fw_rls_idx, status_priv->fw_release_idx);
+
+	if (status_priv->fw_release_idx >= WL18XX_FW_MAX_TX_STATUS_DESC) {
+		wl1271_error("invalid desc release index %d",
+			     status_priv->fw_release_idx);
+		WARN_ON(1);
+		return;
+	}
+
+	for (i = priv->last_fw_rls_idx;
+	     i != status_priv->fw_release_idx;
+	     i = (i + 1) % WL18XX_FW_MAX_TX_STATUS_DESC) {
+		wl18xx_tx_complete_packet(wl,
+			status_priv->released_tx_desc[i]);
+
+		wl->tx_results_count++;
+	}
+
+	priv->last_fw_rls_idx = status_priv->fw_release_idx;
+}
diff --git a/drivers/net/wireless/ti/wl18xx/tx.h b/drivers/net/wireless/ti/wl18xx/tx.h
new file mode 100644
index 0000000..a91eb10
--- /dev/null
+++ b/drivers/net/wireless/ti/wl18xx/tx.h
@@ -0,0 +1,36 @@
+/*
+ * This file is part of wl18xx
+ *
+ * Copyright (C) 2011 Texas Instruments. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#ifndef __WL18XX_TX_H__
+#define __WL18XX_TX_H__
+
+#include "../wlcore/wlcore.h"
+
+#define WL18XX_TX_HW_BLOCK_SPARE        1
+#define WL18XX_TX_HW_GEM_BLOCK_SPARE    2
+#define WL18XX_TX_HW_BLOCK_SIZE         268
+
+#define WL18XX_TX_STATUS_DESC_ID_MASK    0x7F
+#define WL18XX_TX_STATUS_STAT_BIT_IDX    7
+
+void wl18xx_tx_immediate_complete(struct wl1271 *wl);
+
+#endif /* __WL12XX_TX_H__ */
diff --git a/drivers/net/wireless/ti/wl18xx/wl18xx.h b/drivers/net/wireless/ti/wl18xx/wl18xx.h
index 68ef5ba..d24f9c0 100644
--- a/drivers/net/wireless/ti/wl18xx/wl18xx.h
+++ b/drivers/net/wireless/ti/wl18xx/wl18xx.h
@@ -28,6 +28,9 @@
 struct wl18xx_priv {
 	/* buffer for sending commands to FW */
 	u8 cmd_buf[WL18XX_CMD_MAX_SIZE];
+
+	/* Index of last released Tx desc in FW */
+	u8 last_fw_rls_idx;
 };
 
 #define WL18XX_FW_MAX_TX_STATUS_DESC 33
diff --git a/drivers/net/wireless/ti/wlcore/tx.c b/drivers/net/wireless/ti/wlcore/tx.c
index 6893bc2..b4e02ef 100644
--- a/drivers/net/wireless/ti/wlcore/tx.c
+++ b/drivers/net/wireless/ti/wlcore/tx.c
@@ -72,7 +72,7 @@ static int wl1271_alloc_tx_id(struct wl1271 *wl, struct sk_buff *skb)
 	return id;
 }
 
-static void wl1271_free_tx_id(struct wl1271 *wl, int id)
+void wl1271_free_tx_id(struct wl1271 *wl, int id)
 {
 	if (__test_and_clear_bit(id, wl->tx_frames_map)) {
 		if (unlikely(wl->tx_frames_cnt == wl->num_tx_desc))
@@ -82,6 +82,7 @@ static void wl1271_free_tx_id(struct wl1271 *wl, int id)
 		wl->tx_frames_cnt--;
 	}
 }
+EXPORT_SYMBOL(wl1271_free_tx_id);
 
 static void wl1271_tx_ap_update_inconnection_sta(struct wl1271 *wl,
 						 struct sk_buff *skb)
@@ -127,6 +128,7 @@ bool wl12xx_is_dummy_packet(struct wl1271 *wl, struct sk_buff *skb)
 {
 	return wl->dummy_packet == skb;
 }
+EXPORT_SYMBOL(wl12xx_is_dummy_packet);
 
 u8 wl12xx_tx_get_hlid_ap(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 			 struct sk_buff *skb)
diff --git a/drivers/net/wireless/ti/wlcore/tx.h b/drivers/net/wireless/ti/wlcore/tx.h
index e440c31..2207274 100644
--- a/drivers/net/wireless/ti/wlcore/tx.h
+++ b/drivers/net/wireless/ti/wlcore/tx.h
@@ -237,6 +237,7 @@ bool wl12xx_is_dummy_packet(struct wl1271 *wl, struct sk_buff *skb);
 void wl12xx_rearm_rx_streaming(struct wl1271 *wl, unsigned long *active_hlids);
 unsigned int wlcore_calc_packet_alignment(struct wl1271 *wl,
 					  unsigned int packet_length);
+void wl1271_free_tx_id(struct wl1271 *wl, int id);
 
 /* from main.c */
 void wl1271_free_sta(struct wl1271 *wl, struct wl12xx_vif *wlvif, u8 hlid);
-- 
1.7.9.5

