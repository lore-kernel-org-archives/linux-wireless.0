Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:51169 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758015Ab2EJJPV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 05:15:21 -0400
Received: by wibhr2 with SMTP id hr2so244170wib.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 May 2012 02:15:20 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 23/78] wlcore/wl18xx: add hw op for Rx HW checksum
Date: Thu, 10 May 2012 12:13:28 +0300
Message-Id: <1336641263-5761-24-git-send-email-arik@wizery.com> (sfid-20120510_112434_269065_04BA5B07)
In-Reply-To: <1336641263-5761-1-git-send-email-arik@wizery.com>
References: <1336641263-5761-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some chip families can checksum certain classes of Rx packets in FW.
Implement the Rx-checksum feature as a HW-op. For the 18xx chip-family,
set Rx-checsum according to indication from FW.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wl12xx/main.c   |    1 +
 drivers/net/wireless/ti/wl18xx/main.c   |   11 +++++++++++
 drivers/net/wireless/ti/wlcore/hw_ops.h |    9 +++++++++
 drivers/net/wireless/ti/wlcore/rx.c     |    1 +
 drivers/net/wireless/ti/wlcore/wlcore.h |    4 ++++
 5 files changed, 26 insertions(+)

diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index 8141447..a333653 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -1314,6 +1314,7 @@ static struct wlcore_ops wl12xx_ops = {
 	.get_pg_ver		= wl12xx_get_pg_ver,
 	.get_mac		= wl12xx_get_mac,
 	.set_tx_desc_csum	= wl12xx_set_tx_desc_csum,
+	.set_rx_csum		= NULL,
 };
 
 static struct ieee80211_sta_ht_cap wl12xx_ht_cap = {
diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index c47f52c..90fccb7 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -39,6 +39,8 @@
 #include "wl18xx.h"
 
 
+#define WL18XX_RX_CHECKSUM_MASK      0x40
+
 static const u8 wl18xx_rate_to_idx_2ghz[] = {
 	/* MCS rates are used only with 11n */
 	15,                            /* WL18XX_CONF_HW_RXTX_RATE_MCS15 */
@@ -534,6 +536,14 @@ static void wl18xx_set_tx_desc_csum(struct wl1271 *wl,
 	desc->wl18xx_checksum_data |= (ip_hdr->protocol & 0x01);
 }
 
+static void wl18xx_set_rx_csum(struct wl1271 *wl,
+			       struct wl1271_rx_descriptor *desc,
+			       struct sk_buff *skb)
+{
+	if (desc->status & WL18XX_RX_CHECKSUM_MASK)
+		skb->ip_summed = CHECKSUM_UNNECESSARY;
+}
+
 static struct wlcore_ops wl18xx_ops = {
 	.identify_chip	= wl18xx_identify_chip,
 	.boot		= wl18xx_boot,
@@ -548,6 +558,7 @@ static struct wlcore_ops wl18xx_ops = {
 	.tx_delayed_compl = NULL,
 	.hw_init	= wl18xx_hw_init,
 	.set_tx_desc_csum = wl18xx_set_tx_desc_csum,
+	.set_rx_csum = wl18xx_set_rx_csum,
 };
 
 int __devinit wl18xx_probe(struct platform_device *pdev)
diff --git a/drivers/net/wireless/ti/wlcore/hw_ops.h b/drivers/net/wireless/ti/wlcore/hw_ops.h
index 4573249..80f3d75 100644
--- a/drivers/net/wireless/ti/wlcore/hw_ops.h
+++ b/drivers/net/wireless/ti/wlcore/hw_ops.h
@@ -130,4 +130,13 @@ wlcore_hw_set_tx_desc_csum(struct wl1271 *wl,
 	wl->ops->set_tx_desc_csum(wl, desc, skb);
 }
 
+static inline void
+wlcore_hw_set_rx_csum(struct wl1271 *wl,
+		      struct wl1271_rx_descriptor *desc,
+		      struct sk_buff *skb)
+{
+	if (wl->ops->set_rx_csum)
+		wl->ops->set_rx_csum(wl, desc, skb);
+}
+
 #endif
diff --git a/drivers/net/wireless/ti/wlcore/rx.c b/drivers/net/wireless/ti/wlcore/rx.c
index 1f1d948..e2c5df6 100644
--- a/drivers/net/wireless/ti/wlcore/rx.c
+++ b/drivers/net/wireless/ti/wlcore/rx.c
@@ -186,6 +186,7 @@ static int wl1271_rx_handle_data(struct wl1271 *wl, u8 *data, u32 length,
 		is_data = 1;
 
 	wl1271_rx_status(wl, desc, IEEE80211_SKB_RXCB(skb), beacon);
+	wlcore_hw_set_rx_csum(wl, desc, skb);
 
 	seq_num = (le16_to_cpu(hdr->seq_ctrl) & IEEE80211_SCTL_SEQ) >> 4;
 	wl1271_debug(DEBUG_RX, "rx skb 0x%p: %d B %s seq %d hlid %d", skb,
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index c062d30..2922d8a 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -33,6 +33,7 @@
 /* forward declaration */
 struct wl1271_tx_hw_descr;
 enum wl_rx_buf_align;
+struct wl1271_rx_descriptor;
 
 struct wlcore_ops {
 	int (*identify_chip)(struct wl1271 *wl);
@@ -64,6 +65,9 @@ struct wlcore_ops {
 	void (*set_tx_desc_csum)(struct wl1271 *wl,
 				 struct wl1271_tx_hw_descr *desc,
 				 struct sk_buff *skb);
+	void (*set_rx_csum)(struct wl1271 *wl,
+			    struct wl1271_rx_descriptor *desc,
+			    struct sk_buff *skb);
 };
 
 enum wlcore_partitions {
-- 
1.7.9.5

