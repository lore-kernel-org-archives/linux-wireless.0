Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54442 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752631AbcD1TTR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Apr 2016 15:19:17 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 09/11] rtl8xxxu: Split rtl8723a_h2c_cmd() into a gen1 and a gen2 version
Date: Thu, 28 Apr 2016 15:19:13 -0400
Message-Id: <1461871155-11826-10-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160428_213721_946935_5931746B)
In-Reply-To: <1461871155-11826-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1461871155-11826-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

The H2C API is completely different between gen1 and gen2 parts, so
there is little point trying to treat this as a generic function. All
calls to *_h2c_cmd() will always come from a gen1 or a gen2 specific
function.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h   |  3 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c | 12 +--
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  | 86 ++++++++++++++++------
 3 files changed, 72 insertions(+), 29 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index f773c0e..17f62ba 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -1390,7 +1390,8 @@ void rtl8xxxu_reset_8051(struct rtl8xxxu_priv *priv);
 int rtl8xxxu_auto_llt_table(struct rtl8xxxu_priv *priv, u8 last_tx_page);
 void rtl8xxxu_prepare_calibrate(struct rtl8xxxu_priv *priv, u8 start);
 int rtl8xxxu_flush_fifo(struct rtl8xxxu_priv *priv);
-int rtl8723a_h2c_cmd(struct rtl8xxxu_priv *priv, struct h2c_cmd *h2c, int len);
+int rtl8xxxu_gen2_h2c_cmd(struct rtl8xxxu_priv *priv,
+			  struct h2c_cmd *h2c, int len);
 int rtl8xxxu_active_to_lps(struct rtl8xxxu_priv *priv);
 void rtl8xxxu_disabled_to_emu(struct rtl8xxxu_priv *priv);
 int rtl8xxxu_init_llt_table(struct rtl8xxxu_priv *priv, u8 last_tx_page);
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c
index a711cb8..9d4bcd9 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c
@@ -322,7 +322,7 @@ static void rtl8723bu_write_btreg(struct rtl8xxxu_priv *priv, u8 reg, u8 data)
 	h2c.bt_mp_oper.operreq = 0 | (reqnum << 4);
 	h2c.bt_mp_oper.opcode = BT_MP_OP_WRITE_REG_VALUE;
 	h2c.bt_mp_oper.data = data;
-	rtl8723a_h2c_cmd(priv, &h2c, sizeof(h2c.bt_mp_oper));
+	rtl8xxxu_gen2_h2c_cmd(priv, &h2c, sizeof(h2c.bt_mp_oper));
 
 	reqnum++;
 	memset(&h2c, 0, sizeof(struct h2c_cmd));
@@ -330,7 +330,7 @@ static void rtl8723bu_write_btreg(struct rtl8xxxu_priv *priv, u8 reg, u8 data)
 	h2c.bt_mp_oper.operreq = 0 | (reqnum << 4);
 	h2c.bt_mp_oper.opcode = BT_MP_OP_WRITE_REG_VALUE;
 	h2c.bt_mp_oper.addr = reg;
-	rtl8723a_h2c_cmd(priv, &h2c, sizeof(h2c.bt_mp_oper));
+	rtl8xxxu_gen2_h2c_cmd(priv, &h2c, sizeof(h2c.bt_mp_oper));
 }
 
 static void rtl8723bu_reset_8051(struct rtl8xxxu_priv *priv)
@@ -1529,7 +1529,7 @@ static void rtl8723b_enable_rf(struct rtl8xxxu_priv *priv)
 	memset(&h2c, 0, sizeof(struct h2c_cmd));
 	h2c.bt_grant.cmd = H2C_8723B_BT_GRANT;
 	h2c.bt_grant.data = 0;
-	rtl8723a_h2c_cmd(priv, &h2c, sizeof(h2c.bt_grant));
+	rtl8xxxu_gen2_h2c_cmd(priv, &h2c, sizeof(h2c.bt_grant));
 
 	/*
 	 * WLAN action by PTA
@@ -1574,7 +1574,7 @@ static void rtl8723b_enable_rf(struct rtl8xxxu_priv *priv)
 	h2c.ant_sel_rsv.cmd = H2C_8723B_ANT_SEL_RSV;
 	h2c.ant_sel_rsv.ant_inverse = 1;
 	h2c.ant_sel_rsv.int_switch_type = 0;
-	rtl8723a_h2c_cmd(priv, &h2c, sizeof(h2c.ant_sel_rsv));
+	rtl8xxxu_gen2_h2c_cmd(priv, &h2c, sizeof(h2c.ant_sel_rsv));
 
 	/*
 	 * 0x280, 0x00, 0x200, 0x80 - not clear
@@ -1596,12 +1596,12 @@ static void rtl8723b_enable_rf(struct rtl8xxxu_priv *priv)
 	memset(&h2c, 0, sizeof(struct h2c_cmd));
 	h2c.bt_info.cmd = H2C_8723B_BT_INFO;
 	h2c.bt_info.data = BIT(0);
-	rtl8723a_h2c_cmd(priv, &h2c, sizeof(h2c.bt_info));
+	rtl8xxxu_gen2_h2c_cmd(priv, &h2c, sizeof(h2c.bt_info));
 
 	memset(&h2c, 0, sizeof(struct h2c_cmd));
 	h2c.ignore_wlan.cmd = H2C_8723B_BT_IGNORE_WLANACT;
 	h2c.ignore_wlan.data = 0;
-	rtl8723a_h2c_cmd(priv, &h2c, sizeof(h2c.ignore_wlan));
+	rtl8xxxu_gen2_h2c_cmd(priv, &h2c, sizeof(h2c.ignore_wlan));
 }
 
 static void rtl8723bu_init_aggregation(struct rtl8xxxu_priv *priv)
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index d71a0c6..7aecbe7 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -887,7 +887,8 @@ int rtl8xxxu_write_rfreg(struct rtl8xxxu_priv *priv,
 	return retval;
 }
 
-int rtl8723a_h2c_cmd(struct rtl8xxxu_priv *priv, struct h2c_cmd *h2c, int len)
+int
+rtl8xxxu_gen1_h2c_cmd(struct rtl8xxxu_priv *priv, struct h2c_cmd *h2c, int len)
 {
 	struct device *dev = &priv->udev->dev;
 	int mbox_nr, retry, retval = 0;
@@ -898,8 +899,7 @@ int rtl8723a_h2c_cmd(struct rtl8xxxu_priv *priv, struct h2c_cmd *h2c, int len)
 
 	mbox_nr = priv->next_mbox;
 	mbox_reg = REG_HMBOX_0 + (mbox_nr * 4);
-	mbox_ext_reg = priv->fops->mbox_ext_reg +
-		(mbox_nr * priv->fops->mbox_ext_width);
+	mbox_ext_reg = REG_HMBOX_EXT_0 + (mbox_nr * 2);
 
 	/*
 	 * MBOX ready?
@@ -921,19 +921,61 @@ int rtl8723a_h2c_cmd(struct rtl8xxxu_priv *priv, struct h2c_cmd *h2c, int len)
 	 * Need to swap as it's being swapped again by rtl8xxxu_write16/32()
 	 */
 	if (len > sizeof(u32)) {
-		if (priv->fops->mbox_ext_width == 4) {
-			rtl8xxxu_write32(priv, mbox_ext_reg,
-					 le32_to_cpu(h2c->raw_wide.ext));
-			if (rtl8xxxu_debug & RTL8XXXU_DEBUG_H2C)
-				dev_info(dev, "H2C_EXT %08x\n",
-					 le32_to_cpu(h2c->raw_wide.ext));
-		} else {
-			rtl8xxxu_write16(priv, mbox_ext_reg,
-					 le16_to_cpu(h2c->raw.ext));
-			if (rtl8xxxu_debug & RTL8XXXU_DEBUG_H2C)
-				dev_info(dev, "H2C_EXT %04x\n",
-					 le16_to_cpu(h2c->raw.ext));
-		}
+		rtl8xxxu_write16(priv, mbox_ext_reg, le16_to_cpu(h2c->raw.ext));
+		if (rtl8xxxu_debug & RTL8XXXU_DEBUG_H2C)
+			dev_info(dev, "H2C_EXT %04x\n",
+				 le16_to_cpu(h2c->raw.ext));
+	}
+	rtl8xxxu_write32(priv, mbox_reg, le32_to_cpu(h2c->raw.data));
+	if (rtl8xxxu_debug & RTL8XXXU_DEBUG_H2C)
+		dev_info(dev, "H2C %08x\n", le32_to_cpu(h2c->raw.data));
+
+	priv->next_mbox = (mbox_nr + 1) % H2C_MAX_MBOX;
+
+error:
+	mutex_unlock(&priv->h2c_mutex);
+	return retval;
+}
+
+int
+rtl8xxxu_gen2_h2c_cmd(struct rtl8xxxu_priv *priv, struct h2c_cmd *h2c, int len)
+{
+	struct device *dev = &priv->udev->dev;
+	int mbox_nr, retry, retval = 0;
+	int mbox_reg, mbox_ext_reg;
+	u8 val8;
+
+	mutex_lock(&priv->h2c_mutex);
+
+	mbox_nr = priv->next_mbox;
+	mbox_reg = REG_HMBOX_0 + (mbox_nr * 4);
+	mbox_ext_reg = REG_HMBOX_EXT0_8723B + (mbox_nr * 4);
+
+	/*
+	 * MBOX ready?
+	 */
+	retry = 100;
+	do {
+		val8 = rtl8xxxu_read8(priv, REG_HMTFR);
+		if (!(val8 & BIT(mbox_nr)))
+			break;
+	} while (retry--);
+
+	if (!retry) {
+		dev_info(dev, "%s: Mailbox busy\n", __func__);
+		retval = -EBUSY;
+		goto error;
+	}
+
+	/*
+	 * Need to swap as it's being swapped again by rtl8xxxu_write16/32()
+	 */
+	if (len > sizeof(u32)) {
+		rtl8xxxu_write32(priv, mbox_ext_reg,
+				 le32_to_cpu(h2c->raw_wide.ext));
+		if (rtl8xxxu_debug & RTL8XXXU_DEBUG_H2C)
+			dev_info(dev, "H2C_EXT %08x\n",
+				 le32_to_cpu(h2c->raw_wide.ext));
 	}
 	rtl8xxxu_write32(priv, mbox_reg, le32_to_cpu(h2c->raw.data));
 	if (rtl8xxxu_debug & RTL8XXXU_DEBUG_H2C)
@@ -3276,7 +3318,7 @@ void rtl8xxxu_prepare_calibrate(struct rtl8xxxu_priv *priv, u8 start)
 	h2c.bt_wlan_calibration.cmd = H2C_8723B_BT_WLAN_CALIBRATION;
 	h2c.bt_wlan_calibration.data = start;
 
-	rtl8723a_h2c_cmd(priv, &h2c, sizeof(h2c.bt_wlan_calibration));
+	rtl8xxxu_gen2_h2c_cmd(priv, &h2c, sizeof(h2c.bt_wlan_calibration));
 }
 
 void rtl8xxxu_gen1_phy_iq_calibrate(struct rtl8xxxu_priv *priv)
@@ -3792,7 +3834,7 @@ static void rtl8723bu_set_ps_tdma(struct rtl8xxxu_priv *priv,
 	h2c.b_type_dma.data3 = arg3;
 	h2c.b_type_dma.data4 = arg4;
 	h2c.b_type_dma.data5 = arg5;
-	rtl8723a_h2c_cmd(priv, &h2c, sizeof(h2c.b_type_dma));
+	rtl8xxxu_gen2_h2c_cmd(priv, &h2c, sizeof(h2c.b_type_dma));
 }
 #endif
 
@@ -4310,7 +4352,7 @@ void rtl8xxxu_update_rate_mask(struct rtl8xxxu_priv *priv, u32 ramask, int sgi)
 
 	dev_dbg(&priv->udev->dev, "%s: rate mask %08x, arg %02x, size %zi\n",
 		__func__, ramask, h2c.ramask.arg, sizeof(h2c.ramask));
-	rtl8723a_h2c_cmd(priv, &h2c, sizeof(h2c.ramask));
+	rtl8xxxu_gen1_h2c_cmd(priv, &h2c, sizeof(h2c.ramask));
 }
 
 void rtl8xxxu_gen2_update_rate_mask(struct rtl8xxxu_priv *priv,
@@ -4336,7 +4378,7 @@ void rtl8xxxu_gen2_update_rate_mask(struct rtl8xxxu_priv *priv,
 
 	dev_dbg(&priv->udev->dev, "%s: rate mask %08x, arg %02x, size %zi\n",
 		__func__, ramask, h2c.ramask.arg, sizeof(h2c.b_macid_cfg));
-	rtl8723a_h2c_cmd(priv, &h2c, sizeof(h2c.b_macid_cfg));
+	rtl8xxxu_gen2_h2c_cmd(priv, &h2c, sizeof(h2c.b_macid_cfg));
 }
 
 void rtl8xxxu_gen1_report_connect(struct rtl8xxxu_priv *priv,
@@ -4353,7 +4395,7 @@ void rtl8xxxu_gen1_report_connect(struct rtl8xxxu_priv *priv,
 	else
 		h2c.joinbss.data = H2C_JOIN_BSS_DISCONNECT;
 
-	rtl8723a_h2c_cmd(priv, &h2c, sizeof(h2c.joinbss));
+	rtl8xxxu_gen1_h2c_cmd(priv, &h2c, sizeof(h2c.joinbss));
 }
 
 void rtl8xxxu_gen2_report_connect(struct rtl8xxxu_priv *priv,
@@ -4369,7 +4411,7 @@ void rtl8xxxu_gen2_report_connect(struct rtl8xxxu_priv *priv,
 	else
 		h2c.media_status_rpt.parm &= ~BIT(0);
 
-	rtl8723a_h2c_cmd(priv, &h2c, sizeof(h2c.media_status_rpt));
+	rtl8xxxu_gen2_h2c_cmd(priv, &h2c, sizeof(h2c.media_status_rpt));
 }
 
 static void rtl8xxxu_set_basic_rates(struct rtl8xxxu_priv *priv, u32 rate_cfg)
-- 
2.5.5

