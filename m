Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:55425 "EHLO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751194Ab3CHTAB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Mar 2013 14:00:01 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Bing Zhao <bzhao@marvell.com>,
	Ashok Nagarajan <asnagarajan@chromium.org>,
	Paul Stewart <pstew@chromium.org>
Subject: [PATCH] mwifiex: Trigger a card reset on reaching tx_timeout threshold
Date: Fri,  8 Mar 2013 10:58:45 -0800
Message-Id: <1362769125-15183-1-git-send-email-bzhao@marvell.com> (sfid-20130308_200007_053198_375F1AF8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ashok Nagarajan <asnagarajan@chromium.org>

tx_timeout doesn't always lead to a cmd_timeout. There are
occurrences where cmd_timeout never gets triggered for a long
time and we encounter a kernel crash. In this patch, we track
the consecutive timeouts (tx_timeout_cnt). When tx_timeout_cnt
exceeds the threshold, trigger a card reset thereby avoiding a
kernel crash.

Signed-off-by: Ashok Nagarajan <asnagarajan@chromium.org>
Signed-off-by: Paul Stewart <pstew@chromium.org>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/main.c |   15 ++++++++++++---
 drivers/net/wireless/mwifiex/main.h |    5 +++++
 drivers/net/wireless/mwifiex/txrx.c |    2 ++
 3 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index 9c802ed..121443a 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -588,10 +588,19 @@ mwifiex_tx_timeout(struct net_device *dev)
 {
 	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
 
-	dev_err(priv->adapter->dev, "%lu : Tx timeout, bss_type-num = %d-%d\n",
-		jiffies, priv->bss_type, priv->bss_num);
-	mwifiex_set_trans_start(dev);
 	priv->num_tx_timeout++;
+	priv->tx_timeout_cnt++;
+	dev_err(priv->adapter->dev,
+		"%lu : Tx timeout(#%d), bss_type-num = %d-%d\n",
+		jiffies, priv->tx_timeout_cnt, priv->bss_type, priv->bss_num);
+	mwifiex_set_trans_start(dev);
+
+	if (priv->tx_timeout_cnt > TX_TIMEOUT_THRESHOLD &&
+	    priv->adapter->if_ops.card_reset) {
+		dev_err(priv->adapter->dev,
+			"tx_timeout_cnt exceeds threshold. Triggering card reset!\n");
+		priv->adapter->if_ops.card_reset(priv->adapter);
+	}
 }
 
 /*
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 560cf73..9206575 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -130,6 +130,9 @@ enum {
 #define MWIFIEX_USB_TYPE_DATA			0xBEADC0DE
 #define MWIFIEX_USB_TYPE_EVENT			0xBEEFFACE
 
+/* Threshold for tx_timeout_cnt before we trigger a card reset */
+#define TX_TIMEOUT_THRESHOLD	6
+
 struct mwifiex_dbg {
 	u32 num_cmd_host_to_card_failure;
 	u32 num_cmd_sleep_cfm_host_to_card_failure;
@@ -394,6 +397,8 @@ struct mwifiex_private {
 	u8 curr_addr[ETH_ALEN];
 	u8 media_connected;
 	u32 num_tx_timeout;
+	/* track consecutive timeout */
+	u8 tx_timeout_cnt;
 	struct net_device *netdev;
 	struct net_device_stats stats;
 	u16 curr_pkt_filter;
diff --git a/drivers/net/wireless/mwifiex/txrx.c b/drivers/net/wireless/mwifiex/txrx.c
index 296faec..8f923d0 100644
--- a/drivers/net/wireless/mwifiex/txrx.c
+++ b/drivers/net/wireless/mwifiex/txrx.c
@@ -169,6 +169,8 @@ int mwifiex_write_data_complete(struct mwifiex_adapter *adapter,
 	if (!status) {
 		priv->stats.tx_packets++;
 		priv->stats.tx_bytes += skb->len;
+		if (priv->tx_timeout_cnt)
+			priv->tx_timeout_cnt = 0;
 	} else {
 		priv->stats.tx_errors++;
 	}
-- 
1.7.0.2

