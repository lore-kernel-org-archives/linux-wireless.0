Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55162 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757147AbcDGSTe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Apr 2016 14:19:34 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net
Subject: [PATCH 01/18] rtl8xxxu: Add MAC init table for 8192eu
Date: Thu,  7 Apr 2016 14:19:16 -0400
Message-Id: <1460053173-8494-2-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160407_201943_323545_4BBBD31B)
In-Reply-To: <1460053173-8494-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1460053173-8494-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

The 8192eu requires a different MAC init table. Add the missing table
and specify the table to use in the fileops structure.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 45 ++++++++++++++++++++----
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h |  1 +
 2 files changed, 40 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 333addd..97e0d17 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -184,6 +184,36 @@ static struct rtl8xxxu_reg8val rtl8723b_mac_init_table[] = {
 	{0xffff, 0xff},
 };
 
+static struct rtl8xxxu_reg8val rtl8192e_mac_init_table[] = {
+	{0x011, 0xeb}, {0x012, 0x07}, {0x014, 0x75}, {0x303, 0xa7},
+	{0x428, 0x0a}, {0x429, 0x10}, {0x430, 0x00}, {0x431, 0x00},
+	{0x432, 0x00}, {0x433, 0x01}, {0x434, 0x04}, {0x435, 0x05},
+	{0x436, 0x07}, {0x437, 0x08}, {0x43c, 0x04}, {0x43d, 0x05},
+	{0x43e, 0x07}, {0x43f, 0x08}, {0x440, 0x5d}, {0x441, 0x01},
+	{0x442, 0x00}, {0x444, 0x10}, {0x445, 0x00}, {0x446, 0x00},
+	{0x447, 0x00}, {0x448, 0x00}, {0x449, 0xf0}, {0x44a, 0x0f},
+	{0x44b, 0x3e}, {0x44c, 0x10}, {0x44d, 0x00}, {0x44e, 0x00},
+	{0x44f, 0x00}, {0x450, 0x00}, {0x451, 0xf0}, {0x452, 0x0f},
+	{0x453, 0x00}, {0x456, 0x5e}, {0x460, 0x66}, {0x461, 0x66},
+	{0x4c8, 0xff}, {0x4c9, 0x08}, {0x4cc, 0xff}, {0x4cd, 0xff},
+	{0x4ce, 0x01}, {0x500, 0x26}, {0x501, 0xa2}, {0x502, 0x2f},
+	{0x503, 0x00}, {0x504, 0x28}, {0x505, 0xa3}, {0x506, 0x5e},
+	{0x507, 0x00}, {0x508, 0x2b}, {0x509, 0xa4}, {0x50a, 0x5e},
+	{0x50b, 0x00}, {0x50c, 0x4f}, {0x50d, 0xa4}, {0x50e, 0x00},
+	{0x50f, 0x00}, {0x512, 0x1c}, {0x514, 0x0a}, {0x516, 0x0a},
+	{0x525, 0x4f}, {0x540, 0x12}, {0x541, 0x64}, {0x550, 0x10},
+	{0x551, 0x10}, {0x559, 0x02}, {0x55c, 0x50}, {0x55d, 0xff},
+	{0x605, 0x30}, {0x608, 0x0e}, {0x609, 0x2a}, {0x620, 0xff},
+	{0x621, 0xff}, {0x622, 0xff}, {0x623, 0xff}, {0x624, 0xff},
+	{0x625, 0xff}, {0x626, 0xff}, {0x627, 0xff}, {0x638, 0x50},
+	{0x63c, 0x0a}, {0x63d, 0x0a}, {0x63e, 0x0e}, {0x63f, 0x0e},
+	{0x640, 0x40}, {0x642, 0x40}, {0x643, 0x00}, {0x652, 0xc8},
+	{0x66e, 0x05}, {0x700, 0x21}, {0x701, 0x43}, {0x702, 0x65},
+	{0x703, 0x87}, {0x708, 0x21}, {0x709, 0x43}, {0x70a, 0x65},
+	{0x70b, 0x87},
+	{0xffff, 0xff},
+};
+
 static struct rtl8xxxu_reg32val rtl8723a_phy_1t_init_table[] = {
 	{0x800, 0x80040000}, {0x804, 0x00000003},
 	{0x808, 0x0000fc00}, {0x80c, 0x0000000a},
@@ -3087,8 +3117,9 @@ static void rtl8723bu_phy_init_antenna_selection(struct rtl8xxxu_priv *priv)
 }
 
 static int
-rtl8xxxu_init_mac(struct rtl8xxxu_priv *priv, struct rtl8xxxu_reg8val *array)
+rtl8xxxu_init_mac(struct rtl8xxxu_priv *priv)
 {
+	struct rtl8xxxu_reg8val *array = priv->fops->mactable;
 	int i, ret;
 	u16 reg;
 	u8 val;
@@ -3103,7 +3134,8 @@ rtl8xxxu_init_mac(struct rtl8xxxu_priv *priv, struct rtl8xxxu_reg8val *array)
 		ret = rtl8xxxu_write8(priv, reg, val);
 		if (ret != 1) {
 			dev_warn(&priv->udev->dev,
-				 "Failed to initialize MAC\n");
+				 "Failed to initialize MAC "
+				 "(reg: %04x, val %02x)\n", reg, val);
 			return -EAGAIN;
 		}
 	}
@@ -6369,10 +6401,7 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 	if (priv->fops->phy_init_antenna_selection)
 		priv->fops->phy_init_antenna_selection(priv);
 
-	if (priv->rtl_chip == RTL8723B)
-		ret = rtl8xxxu_init_mac(priv, rtl8723b_mac_init_table);
-	else
-		ret = rtl8xxxu_init_mac(priv, rtl8723a_mac_init_table);
+	ret = rtl8xxxu_init_mac(priv);
 
 	dev_dbg(dev, "%s: init_mac %i\n", __func__, ret);
 	if (ret)
@@ -8452,6 +8481,7 @@ static struct rtl8xxxu_fileops rtl8723au_fops = {
 	.adda_1t_path_on = 0x0bdb25a0,
 	.adda_2t_path_on_a = 0x04db25a4,
 	.adda_2t_path_on_b = 0x0b1b25a4,
+	.mactable = rtl8723a_mac_init_table,
 };
 
 static struct rtl8xxxu_fileops rtl8723bu_fops = {
@@ -8481,6 +8511,7 @@ static struct rtl8xxxu_fileops rtl8723bu_fops = {
 	.adda_1t_path_on = 0x01c00014,
 	.adda_2t_path_on_a = 0x01c00014,
 	.adda_2t_path_on_b = 0x01c00014,
+	.mactable = rtl8723b_mac_init_table,
 };
 
 #ifdef CONFIG_RTL8XXXU_UNTESTED
@@ -8508,6 +8539,7 @@ static struct rtl8xxxu_fileops rtl8192cu_fops = {
 	.adda_1t_path_on = 0x0bdb25a0,
 	.adda_2t_path_on_a = 0x04db25a4,
 	.adda_2t_path_on_b = 0x0b1b25a4,
+	.mactable = rtl8723a_mac_init_table,
 };
 
 #endif
@@ -8536,6 +8568,7 @@ static struct rtl8xxxu_fileops rtl8192eu_fops = {
 	.adda_1t_path_on = 0x0fc01616,
 	.adda_2t_path_on_a = 0x0fc01616,
 	.adda_2t_path_on_b = 0x0fc01616,
+	.mactable = rtl8192e_mac_init_table,
 };
 
 static struct usb_device_id dev_table[] = {
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index 455e112..94fc217 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -1308,4 +1308,5 @@ struct rtl8xxxu_fileops {
 	u32 adda_1t_path_on;
 	u32 adda_2t_path_on_a;
 	u32 adda_2t_path_on_b;
+	struct rtl8xxxu_reg8val *mactable;
 };
-- 
2.5.5

