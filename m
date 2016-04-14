Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42872 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752678AbcDNS7J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Apr 2016 14:59:09 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net
Subject: [PATCH 03/26] rtl8xxxu: Implement generic init_queue_reserved_page() function
Date: Thu, 14 Apr 2016 14:58:44 -0400
Message-Id: <1460660347-26299-4-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160414_205914_094259_703A1E22)
In-Reply-To: <1460660347-26299-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1460660347-26299-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Longer term we should switch all the chips over to use this function
instead of the random chip specific ifdef hacks.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c   | 75 ++++++++++++++++++----
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h   |  9 +++
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h  |  2 +-
 3 files changed, 71 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index c6c41ba..a9290d4 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -7439,6 +7439,60 @@ static void rtl8723bu_init_statistics(struct rtl8xxxu_priv *priv)
 	rtl8xxxu_write32(priv, REG_OFDM0_FA_RSTC, val32);
 }
 
+static void rtl8xxxu_old_init_queue_reserved_page(struct rtl8xxxu_priv *priv)
+{
+	u8 val8;
+	u32 val32;
+
+	if (priv->ep_tx_normal_queue)
+		val8 = TX_PAGE_NUM_NORM_PQ;
+	else
+		val8 = 0;
+
+	rtl8xxxu_write8(priv, REG_RQPN_NPQ, val8);
+
+	val32 = (TX_PAGE_NUM_PUBQ << RQPN_PUB_PQ_SHIFT) | RQPN_LOAD;
+
+	if (priv->ep_tx_high_queue)
+		val32 |= (TX_PAGE_NUM_HI_PQ << RQPN_HI_PQ_SHIFT);
+	if (priv->ep_tx_low_queue)
+		val32 |= (TX_PAGE_NUM_LO_PQ << RQPN_LO_PQ_SHIFT);
+
+	rtl8xxxu_write32(priv, REG_RQPN, val32);
+}
+
+static void rtl8xxxu_init_queue_reserved_page(struct rtl8xxxu_priv *priv)
+{
+	struct rtl8xxxu_fileops *fops = priv->fops;
+	u32 hq, lq, nq, eq, pubq;
+	u32 val32;
+
+	hq = 0;
+	lq = 0;
+	nq = 0;
+	eq = 0;
+	pubq = 0;
+
+	if (priv->ep_tx_high_queue)
+		hq = fops->page_num_hi;
+	if (priv->ep_tx_low_queue)
+		lq = fops->page_num_lo;
+	if (priv->ep_tx_normal_queue)
+		nq = fops->page_num_norm;
+
+	val32 = (nq << RQPN_NPQ_SHIFT) | (eq << RQPN_EPQ_SHIFT);
+	rtl8xxxu_write32(priv, REG_RQPN_NPQ, val32);
+
+	pubq = fops->total_page_num - hq - lq - nq;
+
+	val32 = RQPN_LOAD;
+	val32 |= (hq << RQPN_HI_PQ_SHIFT);
+	val32 |= (lq << RQPN_LO_PQ_SHIFT);
+	val32 |= (pubq << RQPN_PUB_PQ_SHIFT);
+
+	rtl8xxxu_write32(priv, REG_RQPN, val32);
+}
+
 static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 {
 	struct rtl8xxxu_priv *priv = hw->priv;
@@ -7469,21 +7523,10 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 	}
 
 	if (!macpower) {
-		if (priv->ep_tx_normal_queue)
-			val8 = TX_PAGE_NUM_NORM_PQ;
+		if (priv->fops->total_page_num)
+			rtl8xxxu_init_queue_reserved_page(priv);
 		else
-			val8 = 0;
-
-		rtl8xxxu_write8(priv, REG_RQPN_NPQ, val8);
-
-		val32 = (TX_PAGE_NUM_PUBQ << RQPN_NORM_PQ_SHIFT) | RQPN_LOAD;
-
-		if (priv->ep_tx_high_queue)
-			val32 |= (TX_PAGE_NUM_HI_PQ << RQPN_HI_PQ_SHIFT);
-		if (priv->ep_tx_low_queue)
-			val32 |= (TX_PAGE_NUM_LO_PQ << RQPN_LO_PQ_SHIFT);
-
-		rtl8xxxu_write32(priv, REG_RQPN, val32);
+			rtl8xxxu_old_init_queue_reserved_page(priv);
 	}
 
 	ret = rtl8xxxu_init_queue_priority(priv);
@@ -9751,6 +9794,10 @@ static struct rtl8xxxu_fileops rtl8192eu_fops = {
 	.adda_2t_path_on_a = 0x0fc01616,
 	.adda_2t_path_on_b = 0x0fc01616,
 	.mactable = rtl8192e_mac_init_table,
+	.total_page_num = TX_TOTAL_PAGE_NUM_8192E,
+	.page_num_hi = TX_PAGE_NUM_HI_PQ_8192E,
+	.page_num_lo = TX_PAGE_NUM_LO_PQ_8192E,
+	.page_num_norm = TX_PAGE_NUM_NORM_PQ_8192E,
 };
 
 static struct usb_device_id dev_table[] = {
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index 48a80fa..4545e10 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -49,6 +49,11 @@
 #define TX_PAGE_NUM_LO_PQ		0x02
 #define TX_PAGE_NUM_NORM_PQ		0x02
 
+#define TX_PAGE_NUM_PUBQ_8192E		0xe7
+#define TX_PAGE_NUM_HI_PQ_8192E		0x08
+#define TX_PAGE_NUM_LO_PQ_8192E		0x0c
+#define TX_PAGE_NUM_NORM_PQ_8192E	0x00
+
 #define RTL_FW_PAGE_SIZE		4096
 #define RTL8XXXU_FIRMWARE_POLL_MAX	1000
 
@@ -1304,4 +1309,8 @@ struct rtl8xxxu_fileops {
 	u32 adda_2t_path_on_a;
 	u32 adda_2t_path_on_b;
 	struct rtl8xxxu_reg8val *mactable;
+	u8 total_page_num;
+	u8 page_num_hi;
+	u8 page_num_lo;
+	u8 page_num_norm;
 };
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
index bb08a39..a2cff22 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
@@ -387,7 +387,7 @@
 #define REG_RQPN			0x0200
 #define  RQPN_HI_PQ_SHIFT		0
 #define  RQPN_LO_PQ_SHIFT		8
-#define  RQPN_NORM_PQ_SHIFT		16
+#define  RQPN_PUB_PQ_SHIFT		16
 #define  RQPN_LOAD			BIT(31)
 
 #define REG_FIFOPAGE			0x0204
-- 
2.5.5

