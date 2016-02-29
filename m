Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57947 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752728AbcB2WFx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 17:05:53 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 018/113] rtl8xxxu: Add rtl8723bu_phy_init_antenna_selection()
Date: Mon, 29 Feb 2016 17:04:16 -0500
Message-Id: <1456783551-28315-19-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160229_231059_968588_A6CDCB5B)
In-Reply-To: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

So far this is just for 8723BU. It includes writing to a number of
registers I have seen no description for so far.

0x0064
0x0930
0x0944

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 36 ++++++++++++++++++++++++
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h |  1 +
 2 files changed, 37 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 2979a5e..13d3b5e 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -2670,6 +2670,38 @@ static void rtl8xxxu_firmware_self_reset(struct rtl8xxxu_priv *priv)
 	}
 }
 
+static void rtl8723bu_phy_init_antenna_selection(struct rtl8xxxu_priv *priv)
+{
+	u32 val32;
+
+	val32 = rtl8xxxu_read32(priv, 0x64);
+	val32 &= ~(BIT(20) | BIT(24));
+	rtl8xxxu_write32(priv, 0x64, val32);
+
+	val32 = rtl8xxxu_read32(priv, REG_GPIO_MUXCFG);
+	val32 &= ~BIT(4);
+	val32 |= BIT(3);
+	rtl8xxxu_write32(priv, REG_GPIO_MUXCFG, val32);
+
+	val32 = rtl8xxxu_read32(priv, REG_LEDCFG0);
+	val32 &= ~BIT(23);
+	val32 |= BIT(24);
+	rtl8xxxu_write32(priv, REG_LEDCFG0, val32);
+
+	val32 = rtl8xxxu_read32(priv, 0x0944);
+	val32 |= (BIT(0) | BIT(1));
+	rtl8xxxu_write32(priv, 0x0944, val32);
+
+	val32 = rtl8xxxu_read32(priv, 0x0930);
+	val32 &= 0xffffff00;
+	val32 |= 0x77;
+	rtl8xxxu_write32(priv, 0x0930, val32);
+
+	val32 = rtl8xxxu_read32(priv, REG_PWR_DATA);
+	val32 |= BIT(11);
+	rtl8xxxu_write32(priv, REG_PWR_DATA, val32);
+}
+
 static int
 rtl8xxxu_init_mac(struct rtl8xxxu_priv *priv, struct rtl8xxxu_reg8val *array)
 {
@@ -4621,6 +4653,9 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 		rtl8xxxu_write32(priv, REG_HIMR1, 0x00);
 	}
 
+	if (priv->fops->phy_init_antenna_selection)
+		priv->fops->phy_init_antenna_selection(priv);
+
 	ret = rtl8xxxu_init_mac(priv, rtl8723a_mac_init_table);
 	dev_dbg(dev, "%s: init_mac %i\n", __func__, ret);
 	if (ret)
@@ -6380,6 +6415,7 @@ static struct rtl8xxxu_fileops rtl8723bu_fops = {
 	.load_firmware = rtl8723bu_load_firmware,
 	.power_on = rtl8723au_power_on,
 	.llt_init = rtl8xxxu_auto_llt_table,
+	.phy_init_antenna_selection = rtl8723bu_phy_init_antenna_selection,
 	.writeN_block_size = 1024,
 };
 
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index 326fda5..43300bd 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -764,5 +764,6 @@ struct rtl8xxxu_fileops {
 	int (*load_firmware) (struct rtl8xxxu_priv *priv);
 	int (*power_on) (struct rtl8xxxu_priv *priv);
 	int (*llt_init) (struct rtl8xxxu_priv *priv, u8 last_tx_page);
+	void (*phy_init_antenna_selection) (struct rtl8xxxu_priv *priv);
 	int writeN_block_size;
 };
-- 
2.5.0

