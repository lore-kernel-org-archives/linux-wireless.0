Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog137.obsmtp.com ([74.125.149.18]:59877 "EHLO
	psmtp.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933016Ab2DKTx5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Apr 2012 15:53:57 -0400
Received: by laap9 with SMTP id p9so1209598laa.24
        for <linux-wireless@vger.kernel.org>; Wed, 11 Apr 2012 12:53:53 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: arik@wizery.com, coelho@ti.com
Subject: [PATCH 05/24] wlcore/wl12xx: add hw op for setting frame length in tx_hw_desc
Date: Wed, 11 Apr 2012 22:53:21 +0300
Message-Id: <1334174020-18957-6-git-send-email-coelho@ti.com> (sfid-20120411_215410_606616_89C46E34)
In-Reply-To: <1334174020-18957-1-git-send-email-coelho@ti.com>
References: <1334174020-18957-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

Each chip family indicates the length of a frame to the HW differently.
This includes different padding, alignment and other fields in the HW Tx
descriptor.

Put all wl12xx specific code in a hw op.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wl12xx/main.c   |   36 +++++++++++++++++++++++++++++++
 drivers/net/wireless/ti/wlcore/hw_ops.h |   11 +++++++++
 drivers/net/wireless/ti/wlcore/tx.c     |   36 +++---------------------------
 drivers/net/wireless/ti/wlcore/wlcore.h |    3 ++
 4 files changed, 54 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index c8f3148..eafa020 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -609,6 +609,41 @@ wl12xx_set_tx_desc_blocks(struct wl1271 *wl, struct wl1271_tx_hw_descr *desc,
 	}
 }
 
+static void
+wl12xx_set_tx_desc_data_len(struct wl1271 *wl, struct wl1271_tx_hw_descr *desc,
+			    struct sk_buff *skb)
+{
+	u32 aligned_len = wlcore_calc_packet_alignment(wl, skb->len);
+
+	if (wl->chip.id == CHIP_ID_1283_PG20) {
+		desc->wl128x_mem.extra_bytes = aligned_len - skb->len;
+		desc->length = cpu_to_le16(aligned_len >> 2);
+
+		wl1271_debug(DEBUG_TX,
+			     "tx_fill_hdr: hlid: %d len: %d life: %d mem: %d extra: %d",
+			     desc->hlid,
+			     le16_to_cpu(desc->length),
+			     le16_to_cpu(desc->life_time),
+			     desc->wl128x_mem.total_mem_blocks,
+			     desc->wl128x_mem.extra_bytes);
+	} else {
+		/* calculate number of padding bytes */
+		int pad = aligned_len - skb->len;
+		desc->tx_attr |=
+			cpu_to_le16(pad << TX_HW_ATTR_OFST_LAST_WORD_PAD);
+
+		/* Store the aligned length in terms of words */
+		desc->length = cpu_to_le16(aligned_len >> 2);
+
+		wl1271_debug(DEBUG_TX,
+			     "tx_fill_hdr: pad: %d hlid: %d len: %d life: %d mem: %d",
+			     pad, desc->hlid,
+			     le16_to_cpu(desc->length),
+			     le16_to_cpu(desc->life_time),
+			     desc->wl127x_mem.total_mem_blocks);
+	}
+}
+
 static bool wl12xx_mac_in_fuse(struct wl1271 *wl)
 {
 	bool supported = false;
@@ -679,6 +714,7 @@ static struct wlcore_ops wl12xx_ops = {
 	.ack_event		= wl12xx_ack_event,
 	.calc_tx_blocks		= wl12xx_calc_tx_blocks,
 	.set_tx_desc_blocks	= wl12xx_set_tx_desc_blocks,
+	.set_tx_desc_data_len	= wl12xx_set_tx_desc_data_len,
 	.get_pg_ver		= wl12xx_get_pg_ver,
 	.get_mac		= wl12xx_get_mac,
 };
diff --git a/drivers/net/wireless/ti/wlcore/hw_ops.h b/drivers/net/wireless/ti/wlcore/hw_ops.h
index 3e02b34..8a56e8d 100644
--- a/drivers/net/wireless/ti/wlcore/hw_ops.h
+++ b/drivers/net/wireless/ti/wlcore/hw_ops.h
@@ -43,5 +43,16 @@ wlcore_hw_set_tx_desc_blocks(struct wl1271 *wl, struct wl1271_tx_hw_descr *desc,
 	return wl->ops->set_tx_desc_blocks(wl, desc, blks, spare_blks);
 }
 
+static inline void
+wlcore_hw_set_tx_desc_data_len(struct wl1271 *wl,
+			       struct wl1271_tx_hw_descr *desc,
+			       struct sk_buff *skb)
+{
+	if (!wl->ops->set_tx_desc_data_len)
+		BUG_ON(1);
+
+	wl->ops->set_tx_desc_data_len(wl, desc, skb);
+}
+
 #endif
 
diff --git a/drivers/net/wireless/ti/wlcore/tx.c b/drivers/net/wireless/ti/wlcore/tx.c
index d834758..be8fcfd 100644
--- a/drivers/net/wireless/ti/wlcore/tx.c
+++ b/drivers/net/wireless/ti/wlcore/tx.c
@@ -251,7 +251,7 @@ static void wl1271_tx_fill_hdr(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 {
 	struct timespec ts;
 	struct wl1271_tx_hw_descr *desc;
-	int aligned_len, ac, rate_idx;
+	int ac, rate_idx;
 	s64 hosttime;
 	u16 tx_attr = 0;
 	__le16 frame_control;
@@ -324,44 +324,16 @@ static void wl1271_tx_fill_hdr(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 	}
 
 	tx_attr |= rate_idx << TX_HW_ATTR_OFST_RATE_POLICY;
-	desc->reserved = 0;
-
-	aligned_len = wlcore_calc_packet_alignment(wl, skb->len);
-
-	if (wl->chip.id == CHIP_ID_1283_PG20) {
-		desc->wl128x_mem.extra_bytes = aligned_len - skb->len;
-		desc->length = cpu_to_le16(aligned_len >> 2);
-
-		wl1271_debug(DEBUG_TX, "tx_fill_hdr: hlid: %d "
-			     "tx_attr: 0x%x len: %d life: %d mem: %d",
-			     desc->hlid, tx_attr,
-			     le16_to_cpu(desc->length),
-			     le16_to_cpu(desc->life_time),
-			     desc->wl128x_mem.total_mem_blocks);
-	} else {
-		int pad;
-
-		/* Store the aligned length in terms of words */
-		desc->length = cpu_to_le16(aligned_len >> 2);
-
-		/* calculate number of padding bytes */
-		pad = aligned_len - skb->len;
-		tx_attr |= pad << TX_HW_ATTR_OFST_LAST_WORD_PAD;
-
-		wl1271_debug(DEBUG_TX, "tx_fill_hdr: pad: %d hlid: %d "
-			     "tx_attr: 0x%x len: %d life: %d mem: %d", pad,
-			     desc->hlid, tx_attr,
-			     le16_to_cpu(desc->length),
-			     le16_to_cpu(desc->life_time),
-			     desc->wl127x_mem.total_mem_blocks);
-	}
 
 	/* for WEP shared auth - no fw encryption is needed */
 	if (ieee80211_is_auth(frame_control) &&
 	    ieee80211_has_protected(frame_control))
 		tx_attr |= TX_HW_ATTR_HOST_ENCRYPT;
 
+	desc->reserved = 0;
 	desc->tx_attr = cpu_to_le16(tx_attr);
+
+	wlcore_hw_set_tx_desc_data_len(wl, desc, skb);
 }
 
 /* caller must hold wl->mutex */
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index f0ce69d..fa636e2 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -41,6 +41,9 @@ struct wlcore_ops {
 	void (*set_tx_desc_blocks)(struct wl1271 *wl,
 				   struct wl1271_tx_hw_descr *desc,
 				   u32 blks, u32 spare_blks);
+	void (*set_tx_desc_data_len)(struct wl1271 *wl,
+				     struct wl1271_tx_hw_descr *desc,
+				     struct sk_buff *skb);
 	s8 (*get_pg_ver)(struct wl1271 *wl);
 	void (*get_mac)(struct wl1271 *wl);
 };
-- 
1.7.5.4

