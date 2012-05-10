Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:61669 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757971Ab2EJJPT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 05:15:19 -0400
Received: by mail-wg0-f44.google.com with SMTP id dr13so1110716wgb.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 May 2012 02:15:18 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 22/78] wlcore/wl18xx: add hw op for setting Tx HW checksum
Date: Thu, 10 May 2012 12:13:27 +0300
Message-Id: <1336641263-5761-23-git-send-email-arik@wizery.com> (sfid-20120510_112409_561197_B1569637)
In-Reply-To: <1336641263-5761-1-git-send-email-arik@wizery.com>
References: <1336641263-5761-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some chip families are capable of checksumming certain classes of Tx
packets in HW. Indicate this fact in the netdev features and perform the
HW checksum by protocol type for the 18xx family.

Fix the location of the skb network header when we move it so we can
rely on it when setting the checksum.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wl12xx/main.c   |    8 ++++++++
 drivers/net/wireless/ti/wl18xx/acx.c    |   26 ++++++++++++++++++++++++++
 drivers/net/wireless/ti/wl18xx/acx.h    |   16 ++++++++++++++++
 drivers/net/wireless/ti/wl18xx/main.c   |   31 +++++++++++++++++++++++++++++++
 drivers/net/wireless/ti/wlcore/acx.h    |    1 +
 drivers/net/wireless/ti/wlcore/hw_ops.h |   11 +++++++++++
 drivers/net/wireless/ti/wlcore/tx.c     |    3 ++-
 drivers/net/wireless/ti/wlcore/tx.h     |   11 ++++++++++-
 drivers/net/wireless/ti/wlcore/wlcore.h |    3 +++
 9 files changed, 108 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index d7dd3de..8141447 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -1288,6 +1288,13 @@ static void wl12xx_get_mac(struct wl1271 *wl)
 		wl12xx_get_fuse_mac(wl);
 }
 
+static void wl12xx_set_tx_desc_csum(struct wl1271 *wl,
+				    struct wl1271_tx_hw_descr *desc,
+				    struct sk_buff *skb)
+{
+	desc->wl12xx_reserved = 0;
+}
+
 static struct wlcore_ops wl12xx_ops = {
 	.identify_chip		= wl12xx_identify_chip,
 	.identify_fw		= wl12xx_identify_fw,
@@ -1306,6 +1313,7 @@ static struct wlcore_ops wl12xx_ops = {
 	.sta_get_ap_rate_mask	= wl12xx_sta_get_ap_rate_mask,
 	.get_pg_ver		= wl12xx_get_pg_ver,
 	.get_mac		= wl12xx_get_mac,
+	.set_tx_desc_csum	= wl12xx_set_tx_desc_csum,
 };
 
 static struct ieee80211_sta_ht_cap wl12xx_ht_cap = {
diff --git a/drivers/net/wireless/ti/wl18xx/acx.c b/drivers/net/wireless/ti/wl18xx/acx.c
index aed8d0d..3379db2 100644
--- a/drivers/net/wireless/ti/wl18xx/acx.c
+++ b/drivers/net/wireless/ti/wl18xx/acx.c
@@ -55,3 +55,29 @@ out:
 
 	return ret;
 }
+
+int wl18xx_acx_set_checksum_state(struct wl1271 *wl)
+{
+	struct wl18xx_acx_checksum_state *acx;
+	int ret;
+
+	wl1271_debug(DEBUG_ACX, "acx checksum state");
+
+	acx = kzalloc(sizeof(*acx), GFP_KERNEL);
+	if (!acx) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	acx->checksum_state = CHECKSUM_OFFLOAD_ENABLED;
+
+	ret = wl1271_cmd_configure(wl, ACX_CHECKSUM_CONFIG, acx, sizeof(*acx));
+	if (ret < 0) {
+		wl1271_warning("failed to set Tx checksum state: %d", ret);
+		goto out;
+	}
+
+out:
+	kfree(acx);
+	return ret;
+}
diff --git a/drivers/net/wireless/ti/wl18xx/acx.h b/drivers/net/wireless/ti/wl18xx/acx.h
index c8eebd8..544db6e 100644
--- a/drivers/net/wireless/ti/wl18xx/acx.h
+++ b/drivers/net/wireless/ti/wl18xx/acx.h
@@ -45,8 +45,24 @@ struct wl18xx_acx_host_config_bitmap {
 
 } __packed;
 
+enum {
+	CHECKSUM_OFFLOAD_DISABLED = 0,
+	CHECKSUM_OFFLOAD_ENABLED  = 1,
+	CHECKSUM_OFFLOAD_FAKE_RX  = 2,
+	CHECKSUM_OFFLOAD_INVALID  = 0xFF
+};
+
+struct wl18xx_acx_checksum_state {
+	struct acx_header header;
+
+	 /* enum acx_checksum_state */
+	u8 checksum_state;
+	u8 pad[3];
+} __packed;
+
 int wl18xx_acx_host_if_cfg_bitmap(struct wl1271 *wl, u32 host_cfg_bitmap,
 				  u32 sdio_blk_size, u32 extra_mem_blks,
 				  u32 len_field_size);
+int wl18xx_acx_set_checksum_state(struct wl1271 *wl);
 
 #endif /* __WL12XX_ACX_H__ */
diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index 1e0719c..c47f52c 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -21,6 +21,7 @@
 
 #include <linux/module.h>
 #include <linux/platform_device.h>
+#include <linux/ip.h>
 
 #include "../wlcore/wlcore.h"
 #include "../wlcore/debug.h"
@@ -501,9 +502,38 @@ static int wl18xx_hw_init(struct wl1271 *wl)
 	if (ret < 0)
 		return ret;
 
+	ret = wl18xx_acx_set_checksum_state(wl);
+	if (ret != 0)
+		return ret;
+
 	return ret;
 }
 
+static void wl18xx_set_tx_desc_csum(struct wl1271 *wl,
+				    struct wl1271_tx_hw_descr *desc,
+				    struct sk_buff *skb)
+{
+	u32 ip_hdr_offset;
+	struct iphdr *ip_hdr;
+
+	if (skb->ip_summed != CHECKSUM_PARTIAL) {
+		desc->wl18xx_checksum_data = 0;
+		return;
+	}
+
+	ip_hdr_offset = skb_network_header(skb) - skb_mac_header(skb);
+	if (WARN_ON(ip_hdr_offset >= (1<<7))) {
+		desc->wl18xx_checksum_data = 0;
+		return;
+	}
+
+	desc->wl18xx_checksum_data = ip_hdr_offset << 1;
+
+	/* FW is interested only in the LSB of the protocol  TCP=0 UDP=1 */
+	ip_hdr = (void *)skb_network_header(skb);
+	desc->wl18xx_checksum_data |= (ip_hdr->protocol & 0x01);
+}
+
 static struct wlcore_ops wl18xx_ops = {
 	.identify_chip	= wl18xx_identify_chip,
 	.boot		= wl18xx_boot,
@@ -517,6 +547,7 @@ static struct wlcore_ops wl18xx_ops = {
 	.tx_immediate_compl = wl18xx_tx_immediate_completion,
 	.tx_delayed_compl = NULL,
 	.hw_init	= wl18xx_hw_init,
+	.set_tx_desc_csum = wl18xx_set_tx_desc_csum,
 };
 
 int __devinit wl18xx_probe(struct platform_device *pdev)
diff --git a/drivers/net/wireless/ti/wlcore/acx.h b/drivers/net/wireless/ti/wlcore/acx.h
index 7a8dfba..e513b1b 100644
--- a/drivers/net/wireless/ti/wlcore/acx.h
+++ b/drivers/net/wireless/ti/wlcore/acx.h
@@ -1245,6 +1245,7 @@ enum {
 	ACX_CONFIG_HANGOVER              = 0x0042,
 	ACX_FEATURE_CFG                  = 0x0043,
 	ACX_PROTECTION_CFG               = 0x0044,
+	ACX_CHECKSUM_CONFIG              = 0x0045,
 };
 
 
diff --git a/drivers/net/wireless/ti/wlcore/hw_ops.h b/drivers/net/wireless/ti/wlcore/hw_ops.h
index 9384b4d..4573249 100644
--- a/drivers/net/wireless/ti/wlcore/hw_ops.h
+++ b/drivers/net/wireless/ti/wlcore/hw_ops.h
@@ -119,4 +119,15 @@ static inline int wlcore_identify_fw(struct wl1271 *wl)
 	return 0;
 }
 
+static inline void
+wlcore_hw_set_tx_desc_csum(struct wl1271 *wl,
+			   struct wl1271_tx_hw_descr *desc,
+			   struct sk_buff *skb)
+{
+	if (!wl->ops->set_tx_desc_csum)
+		BUG_ON(1);
+
+	wl->ops->set_tx_desc_csum(wl, desc, skb);
+}
+
 #endif
diff --git a/drivers/net/wireless/ti/wlcore/tx.c b/drivers/net/wireless/ti/wlcore/tx.c
index b4e02ef..44e4e7b 100644
--- a/drivers/net/wireless/ti/wlcore/tx.c
+++ b/drivers/net/wireless/ti/wlcore/tx.c
@@ -270,6 +270,7 @@ static void wl1271_tx_fill_hdr(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 	if (extra) {
 		int hdrlen = ieee80211_hdrlen(frame_control);
 		memmove(frame_start, hdr, hdrlen);
+		skb_set_network_header(skb, skb_network_offset(skb) + extra);
 	}
 
 	/* configure packet life time */
@@ -332,9 +333,9 @@ static void wl1271_tx_fill_hdr(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 	    ieee80211_has_protected(frame_control))
 		tx_attr |= TX_HW_ATTR_HOST_ENCRYPT;
 
-	desc->reserved = 0;
 	desc->tx_attr = cpu_to_le16(tx_attr);
 
+	wlcore_hw_set_tx_desc_csum(wl, desc, skb);
 	wlcore_hw_set_tx_desc_data_len(wl, desc, skb);
 }
 
diff --git a/drivers/net/wireless/ti/wlcore/tx.h b/drivers/net/wireless/ti/wlcore/tx.h
index 2207274..e24c436 100644
--- a/drivers/net/wireless/ti/wlcore/tx.h
+++ b/drivers/net/wireless/ti/wlcore/tx.h
@@ -130,7 +130,16 @@ struct wl1271_tx_hw_descr {
 	u8 tid;
 	/* host link ID (HLID) */
 	u8 hlid;
-	u8 reserved;
+
+	union {
+		u8 wl12xx_reserved;
+
+		/*
+		 * bit 0   -> 0 = udp, 1 = tcp
+		 * bit 1:7 -> IP header offset
+		 */
+		u8 wl18xx_checksum_data;
+	} __packed;
 } __packed;
 
 enum wl1271_tx_hw_res_status {
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index 0b3f0b5..c062d30 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -61,6 +61,9 @@ struct wlcore_ops {
 				    struct wl12xx_vif *wlvif);
 	s8 (*get_pg_ver)(struct wl1271 *wl);
 	void (*get_mac)(struct wl1271 *wl);
+	void (*set_tx_desc_csum)(struct wl1271 *wl,
+				 struct wl1271_tx_hw_descr *desc,
+				 struct sk_buff *skb);
 };
 
 enum wlcore_partitions {
-- 
1.7.9.5

