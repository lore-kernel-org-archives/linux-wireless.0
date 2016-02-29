Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37695 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753526AbcB2WGE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 17:06:04 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 100/113] rtl8xxxu: Implement basic 8723b specific update_rate_mask() function
Date: Mon, 29 Feb 2016 17:05:38 -0500
Message-Id: <1456783551-28315-101-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160229_232952_436765_02D4A49E)
In-Reply-To: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Support for setting bandwidth and VHT parameters is still missing

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 38 ++++++++++++++++++++++--
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h | 16 +++++++++-
 2 files changed, 50 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 924b8cc..a3546a0 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -6609,11 +6609,13 @@ static void rtl8xxxu_sw_scan_complete(struct ieee80211_hw *hw,
 	rtl8xxxu_write8(priv, REG_BEACON_CTRL, val8);
 }
 
-static void rtl8xxxu_update_rate_mask(struct rtl8xxxu_priv *priv,
-				      u32 ramask, int sgi)
+static void rtl8723au_update_rate_mask(struct rtl8xxxu_priv *priv,
+				       u32 ramask, int sgi)
 {
 	struct h2c_cmd h2c;
 
+	memset(&h2c, 0, sizeof(struct h2c_cmd));
+
 	h2c.ramask.cmd = H2C_SET_RATE_MASK;
 	h2c.ramask.mask_lo = cpu_to_le16(ramask & 0xffff);
 	h2c.ramask.mask_hi = cpu_to_le16(ramask >> 16);
@@ -6627,6 +6629,32 @@ static void rtl8xxxu_update_rate_mask(struct rtl8xxxu_priv *priv,
 	rtl8723a_h2c_cmd(priv, &h2c, sizeof(h2c.ramask));
 }
 
+static void rtl8723bu_update_rate_mask(struct rtl8xxxu_priv *priv,
+				       u32 ramask, int sgi)
+{
+	struct h2c_cmd h2c;
+	u8 bw = 0;
+
+	memset(&h2c, 0, sizeof(struct h2c_cmd));
+
+	h2c.b_macid_cfg.cmd = H2C_8723B_MACID_CFG_RAID;
+	h2c.b_macid_cfg.ramask0 = ramask & 0xff;
+	h2c.b_macid_cfg.ramask1 = (ramask >> 8) & 0xff;
+	h2c.b_macid_cfg.ramask2 = (ramask >> 16) & 0xff;
+	h2c.b_macid_cfg.ramask3 = (ramask >> 24) & 0xff;
+
+	h2c.ramask.arg = 0x80;
+	h2c.b_macid_cfg.data1 = 0;
+	if (sgi)
+		h2c.b_macid_cfg.data1 |= BIT(7);
+
+	h2c.b_macid_cfg.data2 = bw;
+
+	dev_dbg(&priv->udev->dev, "%s: rate mask %08x, arg %02x, size %zi\n",
+		__func__, ramask, h2c.ramask.arg, sizeof(h2c.b_macid_cfg));
+	rtl8723a_h2c_cmd(priv, &h2c, sizeof(h2c.b_macid_cfg));
+}
+
 static void rtl8xxxu_set_basic_rates(struct rtl8xxxu_priv *priv, u32 rate_cfg)
 {
 	u32 val32;
@@ -6693,7 +6721,7 @@ rtl8xxxu_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 				sgi = 1;
 			rcu_read_unlock();
 
-			rtl8xxxu_update_rate_mask(priv, ramask, sgi);
+			priv->fops->update_rate_mask(priv, ramask, sgi);
 
 			rtl8xxxu_write8(priv, REG_BCN_MAX_ERR, 0xff);
 
@@ -8210,6 +8238,7 @@ static struct rtl8xxxu_fileops rtl8723au_fops = {
 	.parse_rx_desc = rtl8723au_parse_rx_desc,
 	.enable_rf = rtl8723a_enable_rf,
 	.set_tx_power = rtl8723a_set_tx_power,
+	.update_rate_mask = rtl8723au_update_rate_mask,
 	.writeN_block_size = 1024,
 	.mbox_ext_reg = REG_HMBOX_EXT_0,
 	.mbox_ext_width = 2,
@@ -8234,6 +8263,7 @@ static struct rtl8xxxu_fileops rtl8723bu_fops = {
 	.init_statistics = rtl8723bu_init_statistics,
 	.enable_rf = rtl8723b_enable_rf,
 	.set_tx_power = rtl8723b_set_tx_power,
+	.update_rate_mask = rtl8723bu_update_rate_mask,
 	.writeN_block_size = 1024,
 	.mbox_ext_reg = REG_HMBOX_EXT0_8723B,
 	.mbox_ext_width = 4,
@@ -8257,6 +8287,7 @@ static struct rtl8xxxu_fileops rtl8192cu_fops = {
 	.parse_rx_desc = rtl8723au_parse_rx_desc,
 	.enable_rf = rtl8723a_enable_rf,
 	.set_tx_power = rtl8723a_set_tx_power,
+	.update_rate_mask = rtl8723au_update_rate_mask,
 	.writeN_block_size = 128,
 	.mbox_ext_reg = REG_HMBOX_EXT_0,
 	.mbox_ext_width = 2,
@@ -8279,6 +8310,7 @@ static struct rtl8xxxu_fileops rtl8192eu_fops = {
 	.parse_rx_desc = rtl8723bu_parse_rx_desc,
 	.enable_rf = rtl8723b_enable_rf,
 	.set_tx_power = rtl8723b_set_tx_power,
+	.update_rate_mask = rtl8723au_update_rate_mask,
 	.writeN_block_size = 128,
 	.mbox_ext_reg = REG_HMBOX_EXT0_8723B,
 	.mbox_ext_width = 4,
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index 37657fe..eea62f1 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -958,12 +958,24 @@ struct h2c_cmd {
 		} __packed ramask;
 		struct {
 			u8 cmd;
+			u8 macid;
+			/*
+			 * [0:4] - RAID
+			 * [7]   - SGI
+			 */
 			u8 data1;
+			/*
+			 * [0:1] - Bandwidth
+			 * [3]   - No Update
+			 * [4:5] - VHT enable
+			 * [6]   - DISPT
+			 * [7]   - DISRA
+			 */
 			u8 data2;
+			u8 ramask0;
 			u8 ramask1;
 			u8 ramask2;
 			u8 ramask3;
-			u8 ramask4;
 		} __packed b_macid_cfg;
 		struct {
 			u8 cmd;
@@ -1240,6 +1252,8 @@ struct rtl8xxxu_fileops {
 	void (*enable_rf) (struct rtl8xxxu_priv *priv);
 	void (*set_tx_power) (struct rtl8xxxu_priv *priv, int channel,
 			      bool ht40);
+	void (*update_rate_mask) (struct rtl8xxxu_priv *priv,
+				  u32 ramask, int sgi);
 	int writeN_block_size;
 	u16 mbox_ext_reg;
 	char mbox_ext_width;
-- 
2.5.0

