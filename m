Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:33442 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933008Ab2DKTxz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Apr 2012 15:53:55 -0400
Received: by lahi5 with SMTP id i5so1594261lah.39
        for <linux-wireless@vger.kernel.org>; Wed, 11 Apr 2012 12:53:52 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: arik@wizery.com, coelho@ti.com
Subject: [PATCH 04/24] wlcore/wl12xx: add hw op for setting blocks in hw_tx_desc
Date: Wed, 11 Apr 2012 22:53:20 +0300
Message-Id: <1334174020-18957-5-git-send-email-coelho@ti.com> (sfid-20120411_215455_994152_2C4B0F58)
In-Reply-To: <1334174020-18957-1-git-send-email-coelho@ti.com>
References: <1334174020-18957-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

Each chip family has a slightly different Tx descriptor. Set the
descriptor values according to family.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wl12xx/main.c   |   27 ++++++++++++++++++++-------
 drivers/net/wireless/ti/wlcore/hw_ops.h |   10 ++++++++++
 drivers/net/wireless/ti/wlcore/tx.c     |    9 ++-------
 drivers/net/wireless/ti/wlcore/wlcore.h |    5 +++++
 4 files changed, 37 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index e1bdeae..c8f3148 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -597,6 +597,18 @@ static u32 wl12xx_calc_tx_blocks(struct wl1271 *wl, u32 len, u32 spare_blks)
 	return (align_len + blk_size - 1) / blk_size + spare_blks;
 }
 
+static void
+wl12xx_set_tx_desc_blocks(struct wl1271 *wl, struct wl1271_tx_hw_descr *desc,
+			  u32 blks, u32 spare_blks)
+{
+	if (wl->chip.id == CHIP_ID_1283_PG20) {
+		desc->wl128x_mem.total_mem_blocks = blks;
+	} else {
+		desc->wl127x_mem.extra_blocks = spare_blks;
+		desc->wl127x_mem.total_mem_blocks = blks;
+	}
+}
+
 static bool wl12xx_mac_in_fuse(struct wl1271 *wl)
 {
 	bool supported = false;
@@ -661,13 +673,14 @@ static void wl12xx_get_mac(struct wl1271 *wl)
 }
 
 static struct wlcore_ops wl12xx_ops = {
-	.identify_chip	= wl12xx_identify_chip,
-	.boot		= wl12xx_boot,
-	.trigger_cmd	= wl12xx_trigger_cmd,
-	.ack_event	= wl12xx_ack_event,
-	.calc_tx_blocks = wl12xx_calc_tx_blocks,
-	.get_pg_ver	= wl12xx_get_pg_ver,
-	.get_mac	= wl12xx_get_mac,
+	.identify_chip		= wl12xx_identify_chip,
+	.boot			= wl12xx_boot,
+	.trigger_cmd		= wl12xx_trigger_cmd,
+	.ack_event		= wl12xx_ack_event,
+	.calc_tx_blocks		= wl12xx_calc_tx_blocks,
+	.set_tx_desc_blocks	= wl12xx_set_tx_desc_blocks,
+	.get_pg_ver		= wl12xx_get_pg_ver,
+	.get_mac		= wl12xx_get_mac,
 };
 
 struct wl12xx_priv {
diff --git a/drivers/net/wireless/ti/wlcore/hw_ops.h b/drivers/net/wireless/ti/wlcore/hw_ops.h
index 904897c..3e02b34 100644
--- a/drivers/net/wireless/ti/wlcore/hw_ops.h
+++ b/drivers/net/wireless/ti/wlcore/hw_ops.h
@@ -33,5 +33,15 @@ wlcore_hw_calc_tx_blocks(struct wl1271 *wl, u32 len, u32 spare_blks)
 	return wl->ops->calc_tx_blocks(wl, len, spare_blks);
 }
 
+static inline void
+wlcore_hw_set_tx_desc_blocks(struct wl1271 *wl, struct wl1271_tx_hw_descr *desc,
+			     u32 blks, u32 spare_blks)
+{
+	if (!wl->ops->set_tx_desc_blocks)
+		BUG_ON(1);
+
+	return wl->ops->set_tx_desc_blocks(wl, desc, blks, spare_blks);
+}
+
 #endif
 
diff --git a/drivers/net/wireless/ti/wlcore/tx.c b/drivers/net/wireless/ti/wlcore/tx.c
index 3891f96..d834758 100644
--- a/drivers/net/wireless/ti/wlcore/tx.c
+++ b/drivers/net/wireless/ti/wlcore/tx.c
@@ -213,13 +213,8 @@ static int wl1271_tx_allocate(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 		desc = (struct wl1271_tx_hw_descr *)skb_push(
 			skb, total_len - skb->len);
 
-		/* HW descriptor fields change between wl127x and wl128x */
-		if (wl->chip.id == CHIP_ID_1283_PG20) {
-			desc->wl128x_mem.total_mem_blocks = total_blocks;
-		} else {
-			desc->wl127x_mem.extra_blocks = spare_blocks;
-			desc->wl127x_mem.total_mem_blocks = total_blocks;
-		}
+		wlcore_hw_set_tx_desc_blocks(wl, desc, total_blocks,
+					     spare_blocks);
 
 		desc->id = id;
 
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index e3d5d73..f0ce69d 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -27,6 +27,8 @@
 #include "wl12xx.h"
 #include "event.h"
 
+struct wl1271_tx_hw_descr;
+
 /* The maximum number of Tx descriptors in all chip families */
 #define WLCORE_MAX_TX_DESCRIPTORS 32
 
@@ -36,6 +38,9 @@ struct wlcore_ops {
 	void (*trigger_cmd)(struct wl1271 *wl);
 	void (*ack_event)(struct wl1271 *wl);
 	u32 (*calc_tx_blocks)(struct wl1271 *wl, u32 len, u32 spare_blks);
+	void (*set_tx_desc_blocks)(struct wl1271 *wl,
+				   struct wl1271_tx_hw_descr *desc,
+				   u32 blks, u32 spare_blks);
 	s8 (*get_pg_ver)(struct wl1271 *wl);
 	void (*get_mac)(struct wl1271 *wl);
 };
-- 
1.7.5.4

