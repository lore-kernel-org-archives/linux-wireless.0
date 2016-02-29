Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39669 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752741AbcB2WFx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 17:05:53 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 021/113] rtl8xxxu: Handle 32 bit mailbox extension regs found on 8723bu/8192eu/8812
Date: Mon, 29 Feb 2016 17:04:19 -0500
Message-Id: <1456783551-28315-22-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160229_231102_394199_FC2A48FB)
In-Reply-To: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Gen1 chips use a 16 bit mailbox extension register, for upto 48 bit
mailbox commands. The newer generation chips use a 32 bit mailbox
extension register instead, for upto 64 bit mailbox commands.

Handle writing the larger mailboxes.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 29 +++++++++++++++++++-----
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h |  8 ++++++-
 2 files changed, 30 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 3c5b42c..6976cec 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -1482,7 +1482,8 @@ static int rtl8723a_h2c_cmd(struct rtl8xxxu_priv *priv, struct h2c_cmd *h2c)
 
 	mbox_nr = priv->next_mbox;
 	mbox_reg = REG_HMBOX_0 + (mbox_nr * 4);
-	mbox_ext_reg = REG_HMBOX_EXT_0 + (mbox_nr * 2);
+	mbox_ext_reg = priv->fops->mbox_ext_reg +
+		(mbox_nr * priv->fops->mbox_ext_width);
 
 	/*
 	 * MBOX ready?
@@ -1504,11 +1505,19 @@ static int rtl8723a_h2c_cmd(struct rtl8xxxu_priv *priv, struct h2c_cmd *h2c)
 	 * Need to swap as it's being swapped again by rtl8xxxu_write16/32()
 	 */
 	if (h2c->cmd.cmd & H2C_EXT) {
-		rtl8xxxu_write16(priv, mbox_ext_reg,
-				 le16_to_cpu(h2c->raw.ext));
-		if (rtl8xxxu_debug & RTL8XXXU_DEBUG_H2C)
-			dev_info(dev, "H2C_EXT %04x\n",
-				 le16_to_cpu(h2c->raw.ext));
+		if (priv->fops->mbox_ext_width == 4) {
+			rtl8xxxu_write32(priv, mbox_ext_reg,
+					 le32_to_cpu(h2c->raw_wide.ext));
+			if (rtl8xxxu_debug & RTL8XXXU_DEBUG_H2C)
+				dev_info(dev, "H2C_EXT %08x\n",
+					 le32_to_cpu(h2c->raw_wide.ext));
+		} else {
+			rtl8xxxu_write16(priv, mbox_ext_reg,
+					 le16_to_cpu(h2c->raw.ext));
+			if (rtl8xxxu_debug & RTL8XXXU_DEBUG_H2C)
+				dev_info(dev, "H2C_EXT %04x\n",
+					 le16_to_cpu(h2c->raw.ext));
+		}
 	}
 	rtl8xxxu_write32(priv, mbox_reg, le32_to_cpu(h2c->raw.data));
 	if (rtl8xxxu_debug & RTL8XXXU_DEBUG_H2C)
@@ -6516,6 +6525,8 @@ static struct rtl8xxxu_fileops rtl8723au_fops = {
 	.power_on = rtl8723au_power_on,
 	.llt_init = rtl8xxxu_init_llt_table,
 	.writeN_block_size = 1024,
+	.mbox_ext_reg = REG_HMBOX_EXT_0,
+	.mbox_ext_width = 2,
 };
 
 static struct rtl8xxxu_fileops rtl8723bu_fops = {
@@ -6525,6 +6536,8 @@ static struct rtl8xxxu_fileops rtl8723bu_fops = {
 	.llt_init = rtl8xxxu_auto_llt_table,
 	.phy_init_antenna_selection = rtl8723bu_phy_init_antenna_selection,
 	.writeN_block_size = 1024,
+	.mbox_ext_reg = REG_HMBOX_EXT0_8723B,
+	.mbox_ext_width = 4,
 };
 
 #ifdef CONFIG_RTL8XXXU_UNTESTED
@@ -6535,6 +6548,8 @@ static struct rtl8xxxu_fileops rtl8192cu_fops = {
 	.power_on = rtl8192cu_power_on,
 	.llt_init = rtl8xxxu_init_llt_table,
 	.writeN_block_size = 128,
+	.mbox_ext_reg = REG_HMBOX_EXT_0,
+	.mbox_ext_width = 2,
 };
 
 #endif
@@ -6545,6 +6560,8 @@ static struct rtl8xxxu_fileops rtl8192eu_fops = {
 	.power_on = rtl8192eu_power_on,
 	.llt_init = rtl8xxxu_auto_llt_table,
 	.writeN_block_size = 128,
+	.mbox_ext_reg = REG_HMBOX_EXT0_8723B,
+	.mbox_ext_width = 4,
 };
 
 static struct usb_device_id dev_table[] = {
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index 43300bd..7aed304 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -628,13 +628,17 @@ struct h2c_cmd {
 	union {
 		struct {
 			u8 cmd;
-			u8 data[5];
+			u8 data[7];
 		} __packed cmd;
 		struct {
 			__le32 data;
 			__le16 ext;
 		} __packed raw;
 		struct {
+			__le32 data;
+			__le32 ext;
+		} __packed raw_wide;
+		struct {
 			u8 cmd;
 			u8 data;
 			u8 pad[4];
@@ -766,4 +770,6 @@ struct rtl8xxxu_fileops {
 	int (*llt_init) (struct rtl8xxxu_priv *priv, u8 last_tx_page);
 	void (*phy_init_antenna_selection) (struct rtl8xxxu_priv *priv);
 	int writeN_block_size;
+	u16 mbox_ext_reg;
+	char mbox_ext_width;
 };
-- 
2.5.0

