Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:48786 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751828AbbBMGle (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Feb 2015 01:41:34 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id t1D6eE8d012587
	for <linux-wireless@vger.kernel.org>; Thu, 12 Feb 2015 22:41:34 -0800
Received: from sc-owa03.marvell.com ([199.233.58.149])
	by mx0b-0016f401.pphosted.com with ESMTP id 1sfwqx69ky-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 12 Feb 2015 22:41:34 -0800
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>, <gaoqs@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Marc Yang <yangyang@marvell.com>
Subject: [PATCH] mwifiex: DMA alignment for RX packets
Date: Fri, 13 Feb 2015 17:41:08 +0530
Message-ID: <1423829468-9460-1-git-send-email-patila@marvell.com> (sfid-20150213_074138_391531_9E17C0F5)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds support for DMA alignment of sk_buffs
allocated for RX.
Patch also adds support to modify skb allocation flags.

Signed-off-by: Marc Yang <yangyang@marvell.com>
Signed-off-by: Qingshui Gao <gaoqs@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
Signed-off-by: Avinash Patil <patila@marvell.com>
---
 drivers/net/wireless/mwifiex/decl.h |  1 +
 drivers/net/wireless/mwifiex/main.h |  4 ++++
 drivers/net/wireless/mwifiex/pcie.c |  6 ++++--
 drivers/net/wireless/mwifiex/sdio.c |  5 +++--
 drivers/net/wireless/mwifiex/util.c | 23 +++++++++++++++++++++++
 5 files changed, 35 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/decl.h b/drivers/net/wireless/mwifiex/decl.h
index b364a2c..e7324da 100644
--- a/drivers/net/wireless/mwifiex/decl.h
+++ b/drivers/net/wireless/mwifiex/decl.h
@@ -33,6 +33,7 @@
 #define MWIFIEX_MAX_BSS_NUM         (3)
 
 #define MWIFIEX_DMA_ALIGN_SZ	    64
+#define MWIFIEX_RX_HEADROOM	    64
 #define MAX_TXPD_SZ		    32
 #define INTF_HDR_ALIGN		     4
 
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 2089a30..16be45e 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -140,6 +140,9 @@ enum {
 
 #define MWIFIEX_DRV_INFO_SIZE_MAX 0x40000
 
+/* Address alignment */
+#define MWIFIEX_ALIGN_ADDR(p, a) (((long)(p) + (a) - 1) & ~((a) - 1))
+
 struct mwifiex_dbg {
 	u32 num_cmd_host_to_card_failure;
 	u32 num_cmd_sleep_cfm_host_to_card_failure;
@@ -1418,6 +1421,7 @@ u8 mwifiex_adjust_data_rate(struct mwifiex_private *priv,
 			    u8 rx_rate, u8 ht_info);
 
 void mwifiex_dump_drv_info(struct mwifiex_adapter *adapter);
+void *mwifiex_alloc_rx_buf(int rx_len, gfp_t flags);
 
 #ifdef CONFIG_DEBUG_FS
 void mwifiex_debugfs_init(void);
diff --git a/drivers/net/wireless/mwifiex/pcie.c b/drivers/net/wireless/mwifiex/pcie.c
index 0640bd6..4b463c3 100644
--- a/drivers/net/wireless/mwifiex/pcie.c
+++ b/drivers/net/wireless/mwifiex/pcie.c
@@ -498,7 +498,8 @@ static int mwifiex_init_rxq_ring(struct mwifiex_adapter *adapter)
 
 	for (i = 0; i < MWIFIEX_MAX_TXRX_BD; i++) {
 		/* Allocate skb here so that firmware can DMA data from it */
-		skb = dev_alloc_skb(MWIFIEX_RX_DATA_BUF_SIZE);
+		skb = mwifiex_alloc_rx_buf(MWIFIEX_RX_DATA_BUF_SIZE,
+					   GFP_KERNEL | GFP_DMA);
 		if (!skb) {
 			dev_err(adapter->dev,
 				"Unable to allocate skb for RX ring.\n");
@@ -1297,7 +1298,8 @@ static int mwifiex_pcie_process_recv_data(struct mwifiex_adapter *adapter)
 			}
 		}
 
-		skb_tmp = dev_alloc_skb(MWIFIEX_RX_DATA_BUF_SIZE);
+		skb_tmp = mwifiex_alloc_rx_buf(MWIFIEX_RX_DATA_BUF_SIZE,
+					       GFP_KERNEL | GFP_DMA);
 		if (!skb_tmp) {
 			dev_err(adapter->dev,
 				"Unable to allocate skb.\n");
diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
index 78a9e86..57d85ab 100644
--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -1357,7 +1357,7 @@ static int mwifiex_process_int_status(struct mwifiex_adapter *adapter)
 			return -1;
 		rx_len = (u16) (rx_blocks * MWIFIEX_SDIO_BLOCK_SIZE);
 
-		skb = dev_alloc_skb(rx_len);
+		skb = mwifiex_alloc_rx_buf(rx_len, GFP_KERNEL | GFP_DMA);
 		if (!skb)
 			return -1;
 
@@ -1454,7 +1454,8 @@ static int mwifiex_process_int_status(struct mwifiex_adapter *adapter)
 			}
 			rx_len = (u16) (rx_blocks * MWIFIEX_SDIO_BLOCK_SIZE);
 
-			skb = dev_alloc_skb(rx_len);
+			skb = mwifiex_alloc_rx_buf(rx_len,
+						   GFP_KERNEL | GFP_DMA);
 
 			if (!skb) {
 				dev_err(adapter->dev, "%s: failed to alloc skb",
diff --git a/drivers/net/wireless/mwifiex/util.c b/drivers/net/wireless/mwifiex/util.c
index 47e215b..2148a57 100644
--- a/drivers/net/wireless/mwifiex/util.c
+++ b/drivers/net/wireless/mwifiex/util.c
@@ -631,3 +631,26 @@ void mwifiex_hist_data_reset(struct mwifiex_private *priv)
 	for (ix = 0; ix < MWIFIEX_MAX_SIG_STRENGTH; ix++)
 		atomic_set(&phist_data->sig_str[ix], 0);
 }
+
+void *mwifiex_alloc_rx_buf(int rx_len, gfp_t flags)
+{
+	struct sk_buff *skb;
+	int buf_len, pad;
+
+	buf_len = rx_len + MWIFIEX_RX_HEADROOM + MWIFIEX_DMA_ALIGN_SZ;
+
+	skb = __dev_alloc_skb(buf_len, flags);
+
+	if (!skb)
+		return NULL;
+
+	skb_reserve(skb, MWIFIEX_RX_HEADROOM);
+
+	pad = MWIFIEX_ALIGN_ADDR(skb->data, MWIFIEX_DMA_ALIGN_SZ) -
+	      (long)skb->data;
+
+	skb_reserve(skb, pad);
+
+	return skb;
+}
+EXPORT_SYMBOL_GPL(mwifiex_alloc_rx_buf);
-- 
1.8.1.4

