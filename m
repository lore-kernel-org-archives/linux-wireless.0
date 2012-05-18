Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:62223 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755179Ab2EREqu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 May 2012 00:46:50 -0400
Received: by wibhm6 with SMTP id hm6so515117wib.1
        for <linux-wireless@vger.kernel.org>; Thu, 17 May 2012 21:46:49 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 2/5] wlcore/wl12xx/wl18xx: handle spare blocks spacial cases per arch
Date: Fri, 18 May 2012 07:46:37 +0300
Message-Id: <1337316400-23875-3-git-send-email-arik@wizery.com> (sfid-20120518_064654_614993_43F3FE1F)
In-Reply-To: <1337316400-23875-1-git-send-email-arik@wizery.com>
References: <1337316400-23875-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add a HW op for getting spare blocks.

12xx cards require 2 spare blocks for GEM encrypted SKBs, regardless
of VIFs or keys programmed into the FW.

18xx cards require 2 spare blocks when there are any connected TKIP or
GEM VIFs. For now always return 2 spare blocks, as this works with all
networks. The special case TKIP/GEM functionality is added at a later
patch.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wl12xx/main.c     |   11 +++++++++--
 drivers/net/wireless/ti/wl18xx/main.c     |   11 ++++++++---
 drivers/net/wireless/ti/wl18xx/tx.h       |    3 ++-
 drivers/net/wireless/ti/wlcore/debugfs.c  |    1 -
 drivers/net/wireless/ti/wlcore/hw_ops.h   |    9 +++++++++
 drivers/net/wireless/ti/wlcore/main.c     |   11 -----------
 drivers/net/wireless/ti/wlcore/tx.c       |   20 ++++++++++----------
 drivers/net/wireless/ti/wlcore/wlcore.h   |    5 +----
 drivers/net/wireless/ti/wlcore/wlcore_i.h |    3 ---
 9 files changed, 39 insertions(+), 35 deletions(-)

diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index 982cb20..94ca51a 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -1367,6 +1367,14 @@ out:
 	return ret;
 }
 
+static int wl12xx_get_spare_blocks(struct wl1271 *wl, bool is_gem)
+{
+	if (is_gem)
+		return WL12XX_TX_HW_BLOCK_GEM_SPARE;
+
+	return WL12XX_TX_HW_BLOCK_SPARE_DEFAULT;
+}
+
 static struct wlcore_ops wl12xx_ops = {
 	.identify_chip		= wl12xx_identify_chip,
 	.identify_fw		= wl12xx_identify_fw,
@@ -1390,6 +1398,7 @@ static struct wlcore_ops wl12xx_ops = {
 	.set_rx_csum		= NULL,
 	.ap_get_mimo_wide_rate_mask = NULL,
 	.debugfs_init		= wl12xx_debugfs_add_files,
+	.get_spare_blocks	= wl12xx_get_spare_blocks,
 };
 
 static struct ieee80211_sta_ht_cap wl12xx_ht_cap = {
@@ -1425,8 +1434,6 @@ static int __devinit wl12xx_probe(struct platform_device *pdev)
 	wl->rtable = wl12xx_rtable;
 	wl->num_tx_desc = 16;
 	wl->num_rx_desc = 8;
-	wl->normal_tx_spare = WL12XX_TX_HW_BLOCK_SPARE_DEFAULT;
-	wl->gem_tx_spare = WL12XX_TX_HW_BLOCK_GEM_SPARE;
 	wl->band_rate_to_idx = wl12xx_band_rate_to_idx;
 	wl->hw_tx_rate_tbl_size = WL12XX_CONF_HW_RXTX_RATE_MAX;
 	wl->hw_min_ht_rate = WL12XX_CONF_HW_RXTX_RATE_MCS0;
diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index 80377aa..5b51410 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -877,7 +877,7 @@ static int wl18xx_hw_init(struct wl1271 *wl)
 
 	ret = wl18xx_acx_host_if_cfg_bitmap(wl, host_cfg_bitmap,
 					    sdio_align_size,
-					    WL18XX_TX_HW_BLOCK_SPARE,
+					    WL18XX_TX_HW_EXTRA_BLOCK_SPARE,
 					    WL18XX_HOST_IF_LEN_SIZE_FIELD);
 	if (ret < 0)
 		return ret;
@@ -1037,6 +1037,12 @@ static int wl18xx_handle_static_data(struct wl1271 *wl,
 	return 0;
 }
 
+static int wl18xx_get_spare_blocks(struct wl1271 *wl, bool is_gem)
+{
+	/* TODO: dynamically change to extra only when we have GEM or TKIP */
+	return WL18XX_TX_HW_EXTRA_BLOCK_SPARE;
+}
+
 static struct wlcore_ops wl18xx_ops = {
 	.identify_chip	= wl18xx_identify_chip,
 	.boot		= wl18xx_boot,
@@ -1059,6 +1065,7 @@ static struct wlcore_ops wl18xx_ops = {
 	.get_mac	= wl18xx_get_mac,
 	.debugfs_init	= wl18xx_debugfs_add_files,
 	.handle_static_data	= wl18xx_handle_static_data,
+	.get_spare_blocks = wl18xx_get_spare_blocks,
 };
 
 /* HT cap appropriate for wide channels */
@@ -1132,8 +1139,6 @@ static int __devinit wl18xx_probe(struct platform_device *pdev)
 	wl->rtable = wl18xx_rtable;
 	wl->num_tx_desc = 32;
 	wl->num_rx_desc = 16;
-	wl->normal_tx_spare = WL18XX_TX_HW_BLOCK_SPARE;
-	wl->gem_tx_spare = WL18XX_TX_HW_GEM_BLOCK_SPARE;
 	wl->band_rate_to_idx = wl18xx_band_rate_to_idx;
 	wl->hw_tx_rate_tbl_size = WL18XX_CONF_HW_RXTX_RATE_MAX;
 	wl->hw_min_ht_rate = WL18XX_CONF_HW_RXTX_RATE_MCS0;
diff --git a/drivers/net/wireless/ti/wl18xx/tx.h b/drivers/net/wireless/ti/wl18xx/tx.h
index 2417262..8aecaf0 100644
--- a/drivers/net/wireless/ti/wl18xx/tx.h
+++ b/drivers/net/wireless/ti/wl18xx/tx.h
@@ -25,7 +25,8 @@
 #include "../wlcore/wlcore.h"
 
 #define WL18XX_TX_HW_BLOCK_SPARE        1
-#define WL18XX_TX_HW_GEM_BLOCK_SPARE    2
+/* for special cases - namely, TKIP and GEM */
+#define WL18XX_TX_HW_EXTRA_BLOCK_SPARE  2
 #define WL18XX_TX_HW_BLOCK_SIZE         268
 
 #define WL18XX_TX_STATUS_DESC_ID_MASK    0x7F
diff --git a/drivers/net/wireless/ti/wlcore/debugfs.c b/drivers/net/wireless/ti/wlcore/debugfs.c
index fc44262..fcd6063 100644
--- a/drivers/net/wireless/ti/wlcore/debugfs.c
+++ b/drivers/net/wireless/ti/wlcore/debugfs.c
@@ -507,7 +507,6 @@ static ssize_t vifs_state_read(struct file *file, char __user *user_buf,
 		VIF_STATE_PRINT_INT(last_rssi_event);
 		VIF_STATE_PRINT_INT(ba_support);
 		VIF_STATE_PRINT_INT(ba_allowed);
-		VIF_STATE_PRINT_INT(is_gem);
 		VIF_STATE_PRINT_LLHEX(tx_security_seq);
 		VIF_STATE_PRINT_INT(tx_security_last_seq_lsb);
 	}
diff --git a/drivers/net/wireless/ti/wlcore/hw_ops.h b/drivers/net/wireless/ti/wlcore/hw_ops.h
index c590b6f..2cb3521 100644
--- a/drivers/net/wireless/ti/wlcore/hw_ops.h
+++ b/drivers/net/wireless/ti/wlcore/hw_ops.h
@@ -167,4 +167,13 @@ wlcore_handle_static_data(struct wl1271 *wl, void *static_data)
 	return 0;
 }
 
+static inline int
+wlcore_hw_get_spare_blocks(struct wl1271 *wl, bool is_gem)
+{
+	if (!wl->ops->get_spare_blocks)
+		BUG_ON(1);
+
+	return wl->ops->get_spare_blocks(wl, is_gem);
+}
+
 #endif
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index d6e6509..efa3b55 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -2801,17 +2801,6 @@ static int wl1271_set_key(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 	int ret;
 	bool is_ap = (wlvif->bss_type == BSS_TYPE_AP_BSS);
 
-	/*
-	 * A role set to GEM cipher requires different Tx settings (namely
-	 * spare blocks). Note when we are in this mode so the HW can adjust.
-	 */
-	if (key_type == KEY_GEM) {
-		if (action == KEY_ADD_OR_REPLACE)
-			wlvif->is_gem = true;
-		else if (action == KEY_REMOVE)
-			wlvif->is_gem = false;
-	}
-
 	if (is_ap) {
 		struct wl1271_station *wl_sta;
 		u8 hlid;
diff --git a/drivers/net/wireless/ti/wlcore/tx.c b/drivers/net/wireless/ti/wlcore/tx.c
index 6b68e29..0949ab1 100644
--- a/drivers/net/wireless/ti/wlcore/tx.c
+++ b/drivers/net/wireless/ti/wlcore/tx.c
@@ -187,28 +187,24 @@ EXPORT_SYMBOL(wlcore_calc_packet_alignment);
 
 static int wl1271_tx_allocate(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 			      struct sk_buff *skb, u32 extra, u32 buf_offset,
-			      u8 hlid)
+			      u8 hlid, bool is_gem)
 {
 	struct wl1271_tx_hw_descr *desc;
 	u32 total_len = skb->len + sizeof(struct wl1271_tx_hw_descr) + extra;
 	u32 total_blocks;
 	int id, ret = -EBUSY, ac;
-	u32 spare_blocks = wl->normal_tx_spare;
-	bool is_dummy = false;
+	u32 spare_blocks;
 
 	if (buf_offset + total_len > WL1271_AGGR_BUFFER_SIZE)
 		return -EAGAIN;
 
+	spare_blocks = wlcore_hw_get_spare_blocks(wl, is_gem);
+
 	/* allocate free identifier for the packet */
 	id = wl1271_alloc_tx_id(wl, skb);
 	if (id < 0)
 		return id;
 
-	if (unlikely(wl12xx_is_dummy_packet(wl, skb)))
-		is_dummy = true;
-	else if (wlvif->is_gem)
-		spare_blocks = wl->gem_tx_spare;
-
 	total_blocks = wlcore_hw_calc_tx_blocks(wl, total_len, spare_blocks);
 
 	if (total_blocks <= wl->tx_blocks_available) {
@@ -230,7 +226,7 @@ static int wl1271_tx_allocate(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 		ac = wl1271_tx_get_queue(skb_get_queue_mapping(skb));
 		wl->tx_allocated_pkts[ac]++;
 
-		if (!is_dummy && wlvif &&
+		if (!wl12xx_is_dummy_packet(wl, skb) && wlvif &&
 		    wlvif->bss_type == BSS_TYPE_AP_BSS &&
 		    test_bit(hlid, wlvif->ap.sta_hlid_map))
 			wl->links[hlid].allocated_pkts++;
@@ -349,6 +345,7 @@ static int wl1271_prepare_tx_frame(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 	u32 total_len;
 	u8 hlid;
 	bool is_dummy;
+	bool is_gem = false;
 
 	if (!skb)
 		return -EINVAL;
@@ -377,6 +374,8 @@ static int wl1271_prepare_tx_frame(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 				return ret;
 			wlvif->default_key = idx;
 		}
+
+		is_gem = (cipher == WL1271_CIPHER_SUITE_GEM);
 	}
 	hlid = wl12xx_tx_get_hlid(wl, wlvif, skb);
 	if (hlid == WL12XX_INVALID_LINK_ID) {
@@ -384,7 +383,8 @@ static int wl1271_prepare_tx_frame(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 		return -EINVAL;
 	}
 
-	ret = wl1271_tx_allocate(wl, wlvif, skb, extra, buf_offset, hlid);
+	ret = wl1271_tx_allocate(wl, wlvif, skb, extra, buf_offset, hlid,
+				 is_gem);
 	if (ret < 0)
 		return ret;
 
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index 5a35a33..84a1b05 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -75,6 +75,7 @@ struct wlcore_ops {
 	int (*debugfs_init)(struct wl1271 *wl, struct dentry *rootdir);
 	int (*handle_static_data)(struct wl1271 *wl,
 				  struct wl1271_static_data *static_data);
+	int (*get_spare_blocks)(struct wl1271 *wl, bool is_gem);
 };
 
 enum wlcore_partitions {
@@ -355,10 +356,6 @@ struct wl1271 {
 	/* number of RX descriptors the HW supports. */
 	u32 num_rx_desc;
 
-	/* spare Tx blocks for normal/GEM operating modes */
-	u32 normal_tx_spare;
-	u32 gem_tx_spare;
-
 	/* translate HW Tx rates to standard rate-indices */
 	const u8 **band_rate_to_idx;
 
diff --git a/drivers/net/wireless/ti/wlcore/wlcore_i.h b/drivers/net/wireless/ti/wlcore/wlcore_i.h
index 83c9869..8260b1e 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore_i.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore_i.h
@@ -417,9 +417,6 @@ struct wl12xx_vif {
 	struct work_struct rx_streaming_disable_work;
 	struct timer_list rx_streaming_timer;
 
-	/* does the current role use GEM for encryption (AP or STA) */
-	bool is_gem;
-
 	/*
 	 * This struct must be last!
 	 * data that has to be saved acrossed reconfigs (e.g. recovery)
-- 
1.7.9.5

