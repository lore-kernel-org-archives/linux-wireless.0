Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37692 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752789AbcB2WFy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 17:05:54 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 031/113] rtl8xxxu: rtl8xxxu_h2c_cmd(): Add size argument
Date: Mon, 29 Feb 2016 17:04:29 -0500
Message-Id: <1456783551-28315-32-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160229_232954_272716_F4BC966C)
In-Reply-To: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

The firmware command API differs slightly between new and old
devices. The new generation requires the size since there is no
extension bit encoded into the command number.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 13 +++++++------
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h |  1 -
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index d100a99..3139890 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -1471,7 +1471,8 @@ static int rtl8xxxu_write_rfreg(struct rtl8xxxu_priv *priv,
 	return retval;
 }
 
-static int rtl8723a_h2c_cmd(struct rtl8xxxu_priv *priv, struct h2c_cmd *h2c)
+static int rtl8723a_h2c_cmd(struct rtl8xxxu_priv *priv,
+			    struct h2c_cmd *h2c, int len)
 {
 	struct device *dev = &priv->udev->dev;
 	int mbox_nr, retry, retval = 0;
@@ -1504,7 +1505,7 @@ static int rtl8723a_h2c_cmd(struct rtl8xxxu_priv *priv, struct h2c_cmd *h2c)
 	/*
 	 * Need to swap as it's being swapped again by rtl8xxxu_write16/32()
 	 */
-	if (h2c->cmd.cmd & H2C_EXT) {
+	if (len > sizeof(u32)) {
 		if (priv->fops->mbox_ext_width == 4) {
 			rtl8xxxu_write32(priv, mbox_ext_reg,
 					 le32_to_cpu(h2c->raw_wide.ext));
@@ -5110,9 +5111,9 @@ static void rtl8xxxu_update_rate_mask(struct rtl8xxxu_priv *priv,
 	if (sgi)
 		h2c.ramask.arg |= 0x20;
 
-	dev_dbg(&priv->udev->dev, "%s: rate mask %08x, arg %02x\n", __func__,
-		ramask, h2c.ramask.arg);
-	rtl8723a_h2c_cmd(priv, &h2c);
+	dev_dbg(&priv->udev->dev, "%s: rate mask %08x, arg %02x, size %li\n",
+		__func__, ramask, h2c.ramask.arg, sizeof(h2c.ramask));
+	rtl8723a_h2c_cmd(priv, &h2c, sizeof(h2c.ramask));
 }
 
 static void rtl8xxxu_set_basic_rates(struct rtl8xxxu_priv *priv, u32 rate_cfg)
@@ -5200,7 +5201,7 @@ rtl8xxxu_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			h2c.joinbss.data = H2C_JOIN_BSS_DISCONNECT;
 		}
 		h2c.joinbss.cmd = H2C_JOIN_BSS_REPORT;
-		rtl8723a_h2c_cmd(priv, &h2c);
+		rtl8723a_h2c_cmd(priv, &h2c, sizeof(h2c.joinbss));
 	}
 
 	if (changed & BSS_CHANGED_ERP_PREAMBLE) {
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index 198b1d8..47898ff 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -720,7 +720,6 @@ struct h2c_cmd {
 		struct {
 			u8 cmd;
 			u8 data;
-			u8 pad[4];
 		} __packed joinbss;
 		struct {
 			u8 cmd;
-- 
2.5.0

