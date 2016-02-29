Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37689 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752707AbcB2WFx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 17:05:53 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 006/113] rtl8xxxu: Add rtl8xxxu_auto_llt_table()
Date: Mon, 29 Feb 2016 17:04:04 -0500
Message-Id: <1456783551-28315-7-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160229_230601_254031_07C99C53)
In-Reply-To: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Newer chips can auto load the LLT table, it is no longer necessary to
build it manually in the driver.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c   | 33 +++++++++++++++++++++-
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h   |  1 +
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h  |  3 ++
 3 files changed, 36 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 5f30ae9..2f31c2a 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -2774,6 +2774,34 @@ exit:
 	return ret;
 }
 
+static int rtl8xxxu_auto_llt_table(struct rtl8xxxu_priv *priv, u8 last_tx_page)
+{
+	u32 val32;
+	int ret = 0;
+	int i;
+
+	val32 = rtl8xxxu_read32(priv, REG_AUTO_LLT);
+	pr_info("AUTO_LLT = %08x\n", val32);
+	val32 |= AUTO_LLT_INIT_LLT;
+	rtl8xxxu_write32(priv, REG_AUTO_LLT, val32);
+
+	for (i = 500; i; i--) {
+		val32 = rtl8xxxu_read32(priv, REG_AUTO_LLT);
+		if (!(val32 & AUTO_LLT_INIT_LLT))
+			break;
+		usleep_range(2, 4);
+	}
+
+	if (i) {
+		ret = -EBUSY;
+		dev_warn(&priv->udev->dev, "LLT table init failed\n");
+	}
+	else
+		dev_warn(&priv->udev->dev, "LLT table init success\n");
+
+	return ret;
+}
+
 static int rtl8xxxu_init_queue_priority(struct rtl8xxxu_priv *priv)
 {
 	u16 val16, hi, lo;
@@ -4287,7 +4315,7 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 
 	dev_dbg(dev, "%s: macpower %i\n", __func__, macpower);
 	if (!macpower) {
-		ret = rtl8xxxu_init_llt_table(priv, TX_TOTAL_PAGE_NUM);
+		ret = priv->fops->llt_init(priv, TX_TOTAL_PAGE_NUM);
 		if (ret) {
 			dev_warn(dev, "%s: LLT table init failed\n", __func__);
 			goto exit;
@@ -6079,6 +6107,7 @@ static struct rtl8xxxu_fileops rtl8723au_fops = {
 	.parse_efuse = rtl8723au_parse_efuse,
 	.load_firmware = rtl8723au_load_firmware,
 	.power_on = rtl8723au_power_on,
+	.llt_init = rtl8xxxu_init_llt_table,
 	.writeN_block_size = 1024,
 };
 
@@ -6088,6 +6117,7 @@ static struct rtl8xxxu_fileops rtl8192cu_fops = {
 	.parse_efuse = rtl8192cu_parse_efuse,
 	.load_firmware = rtl8192cu_load_firmware,
 	.power_on = rtl8192cu_power_on,
+	.llt_init = rtl8xxxu_init_llt_table,
 	.writeN_block_size = 128,
 };
 
@@ -6097,6 +6127,7 @@ static struct rtl8xxxu_fileops rtl8192eu_fops = {
 	.parse_efuse = rtl8192eu_parse_efuse,
 	.load_firmware = rtl8192eu_load_firmware,
 	.power_on = rtl8192eu_power_on,
+	.llt_init = rtl8xxxu_auto_llt_table,
 	.writeN_block_size = 128,
 };
 
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index 0d4ff80..56c4e0a 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -718,5 +718,6 @@ struct rtl8xxxu_fileops {
 	int (*parse_efuse) (struct rtl8xxxu_priv *priv);
 	int (*load_firmware) (struct rtl8xxxu_priv *priv);
 	int (*power_on) (struct rtl8xxxu_priv *priv);
+	int (*llt_init) (struct rtl8xxxu_priv *priv, u8 last_tx_page);
 	int writeN_block_size;
 };
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
index 02c7d6c..b83bd34 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
@@ -372,6 +372,9 @@
 #define  RQPN_NPQ_SHIFT			0
 #define  RQPN_EPQ_SHIFT			16
 
+#define REG_AUTO_LLT			0x0224
+#define  AUTO_LLT_INIT_LLT		BIT(16)
+
 /* 0x0280 ~ 0x02FF	RXDMA Configuration */
 #define REG_RXDMA_AGG_PG_TH		0x0280
 #define REG_RXPKT_NUM			0x0284
-- 
2.5.0

