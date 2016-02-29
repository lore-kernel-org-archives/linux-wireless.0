Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37698 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752976AbcB2WFz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 17:05:55 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 057/113] rtl8xxxu: Handle XTAL_K value in efuse specific location
Date: Mon, 29 Feb 2016 17:04:55 -0500
Message-Id: <1456783551-28315-58-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160229_231017_514644_DC886C0C)
In-Reply-To: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Retrieve the XTAL_K value in the parse_efuse() functions as it's
location various on a per device basis. For parts that do not provide
an XTAL_K value, skip setting it.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 15 ++++++++++++---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h |  2 ++
 2 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index d97e66c..968ed95 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -2314,6 +2314,10 @@ static int rtl8723au_parse_efuse(struct rtl8xxxu_priv *priv)
 	       efuse->ht20_max_power_offset,
 	       sizeof(priv->ht20_max_power_offset));
 
+	if (priv->efuse_wifi.efuse8723.version >= 0x01) {
+		priv->has_xtalk = 1;
+		priv->xtalk = priv->efuse_wifi.efuse8723.xtal_k & 0x3f;
+	}
 	dev_info(&priv->udev->dev, "Vendor: %.7s\n",
 		 efuse->vendor_name);
 	dev_info(&priv->udev->dev, "Product: %.41s\n",
@@ -2340,6 +2344,9 @@ static int rtl8723bu_parse_efuse(struct rtl8xxxu_priv *priv)
 	memcpy(priv->ht40_1s_tx_power_index_B, efuse->ht40_1s_tx_power_index_B,
 	       sizeof(priv->ht40_1s_tx_power_index_B));
 
+	priv->has_xtalk = 1;
+	priv->xtalk = priv->efuse_wifi.efuse8723bu.xtal_k & 0x3f;
+
 	dev_info(&priv->udev->dev, "Vendor: %.7s\n", efuse->vendor_name);
 	dev_info(&priv->udev->dev, "Product: %.41s\n", efuse->device_name);
 
@@ -2444,6 +2451,9 @@ static int rtl8192eu_parse_efuse(struct rtl8xxxu_priv *priv)
 
 	ether_addr_copy(priv->mac_addr, efuse->mac_addr);
 
+	priv->has_xtalk = 1;
+	priv->xtalk = priv->efuse_wifi.efuse8192eu.xtal_k & 0x3f;
+
 	dev_info(&priv->udev->dev, "Vendor: %.7s\n", efuse->vendor_name);
 	dev_info(&priv->udev->dev, "Product: %.11s\n", efuse->device_name);
 	dev_info(&priv->udev->dev, "Serial: %.11s\n", efuse->serial);
@@ -3122,11 +3132,10 @@ static int rtl8xxxu_init_phy_bb(struct rtl8xxxu_priv *priv)
 	else
 		rtl8xxxu_init_phy_regs(priv, rtl8xxx_agc_standard_table);
 
-	if ((priv->rtlchip == 0x8723a || priv->rtlchip == 0x8723b) &&
-	    priv->efuse_wifi.efuse8723.version >= 0x01) {
+	if (priv->has_xtalk) {
 		val32 = rtl8xxxu_read32(priv, REG_MAC_PHY_CTRL);
 
-		val8 = priv->efuse_wifi.efuse8723.xtal_k & 0x3f;
+		val8 = priv->xtalk;
 		val32 &= 0xff000fff;
 		val32 |= ((val8 | (val8 << 6)) << 12);
 
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index ea0b28a..2250e1b 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -1063,6 +1063,8 @@ struct rtl8xxxu_priv {
 	u32 ep_tx_high_queue:1;
 	u32 ep_tx_normal_queue:1;
 	u32 ep_tx_low_queue:1;
+	u32 has_xtalk:1;
+	u8 xtalk;
 	unsigned int pipe_interrupt;
 	unsigned int pipe_in;
 	unsigned int pipe_out[TXDESC_QUEUE_MAX];
-- 
2.5.0

