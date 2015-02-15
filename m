Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:47089 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754603AbbBOMDD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Feb 2015 07:03:03 -0500
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
To: Kalle Valo <kvalo@qca.qualcomm.com>
Subject: [PATCH 3/9] wil6210: enable fix for HW bug in 802.11->803.3 transform
Date: Sun, 15 Feb 2015 14:02:32 +0200
Message-Id: <1424001758-29529-4-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20150215_130318_103228_BA82A284)
In-Reply-To: <1424001758-29529-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1424001758-29529-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In the old hardware, bug existed that caused DA and SA for every
Rx packet to be swapped in the AP mode.
New hardware has fix for this bug. Enable this fix in the
hardware.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/main.c    |  4 ++++
 drivers/net/wireless/ath/wil6210/txrx.c    | 31 ------------------------------
 drivers/net/wireless/ath/wil6210/wil6210.h |  7 +++++++
 3 files changed, 11 insertions(+), 31 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 95755a5..db74e81 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -579,6 +579,10 @@ static int wil_target_reset(struct wil6210_priv *wil)
 
 	C(RGF_USER_CLKS_CTL_0, BIT_USER_CLKS_RST_PWGD);
 
+	/* enable fix for HW bug related to the SA/DA swap in AP Rx */
+	S(RGF_DMA_OFUL_NID_0, BIT_DMA_OFUL_NID_0_RX_EXT_TR_EN |
+	  BIT_DMA_OFUL_NID_0_RX_EXT_A3_SRC);
+
 	wil_dbg_misc(wil, "Reset completed in %d ms\n", delay * RST_DELAY);
 	return 0;
 }
diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index 8439f65..779d836 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -346,27 +346,6 @@ static void wil_rx_add_radiotap_header(struct wil6210_priv *wil,
 	}
 }
 
-/*
- * Fast swap in place between 2 registers
- */
-static void wil_swap_u16(u16 *a, u16 *b)
-{
-	*a ^= *b;
-	*b ^= *a;
-	*a ^= *b;
-}
-
-static void wil_swap_ethaddr(void *data)
-{
-	struct ethhdr *eth = data;
-	u16 *s = (u16 *)eth->h_source;
-	u16 *d = (u16 *)eth->h_dest;
-
-	wil_swap_u16(s++, d++);
-	wil_swap_u16(s++, d++);
-	wil_swap_u16(s, d);
-}
-
 /**
  * reap 1 frame from @swhead
  *
@@ -386,7 +365,6 @@ static struct sk_buff *wil_vring_reap_rx(struct wil6210_priv *wil,
 	unsigned int sz = mtu_max + ETH_HLEN;
 	u16 dmalen;
 	u8 ftype;
-	u8 ds_bits;
 	int cid;
 	struct wil_net_stats *stats;
 
@@ -474,15 +452,6 @@ static struct sk_buff *wil_vring_reap_rx(struct wil6210_priv *wil,
 		 */
 	}
 
-	ds_bits = wil_rxdesc_ds_bits(d);
-	if (ds_bits == 1) {
-		/*
-		 * HW bug - in ToDS mode, i.e. Rx on AP side,
-		 * addresses get swapped
-		 */
-		wil_swap_ethaddr(skb->data);
-	}
-
 	return skb;
 }
 
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 97422e7..85f0011 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -181,6 +181,13 @@ struct RGF_BL {
 	#define BIT_DMA_ITR_CNT_CRL_CLR		BIT(3)
 	#define BIT_DMA_ITR_CNT_CRL_REACH_TRSH	BIT(4)
 
+/* Offload control (Sparrow B0+) */
+#define RGF_DMA_OFUL_NID_0		(0x881cd4)
+	#define BIT_DMA_OFUL_NID_0_RX_EXT_TR_EN		BIT(0)
+	#define BIT_DMA_OFUL_NID_0_TX_EXT_TR_EN		BIT(1)
+	#define BIT_DMA_OFUL_NID_0_RX_EXT_A3_SRC	BIT(2)
+	#define BIT_DMA_OFUL_NID_0_TX_EXT_A3_SRC	BIT(3)
+
 /* New (sparrow v2+) interrupt moderation control */
 #define RGF_DMA_ITR_TX_DESQ_NO_MOD		(0x881d40)
 #define RGF_DMA_ITR_TX_CNT_TRSH			(0x881d34)
-- 
2.1.0

