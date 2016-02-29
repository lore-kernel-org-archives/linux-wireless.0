Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49079 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753562AbcB2WGE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 17:06:04 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 101/113] rtl8xxxu: Report media status using the correct H2C command for 8723bu
Date: Mon, 29 Feb 2016 17:05:39 -0500
Message-Id: <1456783551-28315-102-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160229_230639_623237_9814865A)
In-Reply-To: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Implement support for nextgen devices reporting connectition to the
firmware.

The H2C API for reporting connection to the firmware is different
between the two device generations. Use the fileops structure to
determine which one to call.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 46 ++++++++++++++++++++----
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h |  8 +++++
 2 files changed, 47 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index a3546a0..f9d5b23 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -6655,6 +6655,39 @@ static void rtl8723bu_update_rate_mask(struct rtl8xxxu_priv *priv,
 	rtl8723a_h2c_cmd(priv, &h2c, sizeof(h2c.b_macid_cfg));
 }
 
+static void rtl8723au_report_connect(struct rtl8xxxu_priv *priv,
+				     u8 macid, bool connect)
+{
+	struct h2c_cmd h2c;
+
+	memset(&h2c, 0, sizeof(struct h2c_cmd));
+
+	h2c.joinbss.cmd = H2C_JOIN_BSS_REPORT;
+
+	if (connect)
+		h2c.joinbss.data = H2C_JOIN_BSS_CONNECT;
+	else
+		h2c.joinbss.data = H2C_JOIN_BSS_DISCONNECT;
+
+	rtl8723a_h2c_cmd(priv, &h2c, sizeof(h2c.joinbss));
+}
+
+static void rtl8723bu_report_connect(struct rtl8xxxu_priv *priv,
+				     u8 macid, bool connect)
+{
+	struct h2c_cmd h2c;
+
+	memset(&h2c, 0, sizeof(struct h2c_cmd));
+
+	h2c.media_status_rpt.cmd = H2C_8723B_MEDIA_STATUS_RPT;
+	if (connect)
+		h2c.media_status_rpt.parm |= BIT(0);
+	else
+		h2c.media_status_rpt.parm &= ~BIT(0);
+
+	rtl8723a_h2c_cmd(priv, &h2c, sizeof(h2c.media_status_rpt));
+}
+
 static void rtl8xxxu_set_basic_rates(struct rtl8xxxu_priv *priv, u32 rate_cfg)
 {
 	u32 val32;
@@ -6687,11 +6720,8 @@ rtl8xxxu_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	u8 val8;
 
 	if (changed & BSS_CHANGED_ASSOC) {
-		struct h2c_cmd h2c;
-
 		dev_dbg(dev, "Changed ASSOC: %i!\n", bss_conf->assoc);
 
-		memset(&h2c, 0, sizeof(struct h2c_cmd));
 		rtl8xxxu_set_linktype(priv, vif->type);
 
 		if (bss_conf->assoc) {
@@ -6731,16 +6761,14 @@ rtl8xxxu_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			rtl8xxxu_write16(priv, REG_BCN_PSR_RPT,
 					 0xc000 | bss_conf->aid);
 
-			h2c.joinbss.data = H2C_JOIN_BSS_CONNECT;
+			priv->fops->report_connect(priv, 0, true);
 		} else {
 			val8 = rtl8xxxu_read8(priv, REG_BEACON_CTRL);
 			val8 |= BEACON_DISABLE_TSF_UPDATE;
 			rtl8xxxu_write8(priv, REG_BEACON_CTRL, val8);
 
-			h2c.joinbss.data = H2C_JOIN_BSS_DISCONNECT;
+			priv->fops->report_connect(priv, 0, false);
 		}
-		h2c.joinbss.cmd = H2C_JOIN_BSS_REPORT;
-		rtl8723a_h2c_cmd(priv, &h2c, sizeof(h2c.joinbss));
 	}
 
 	if (changed & BSS_CHANGED_ERP_PREAMBLE) {
@@ -8239,6 +8267,7 @@ static struct rtl8xxxu_fileops rtl8723au_fops = {
 	.enable_rf = rtl8723a_enable_rf,
 	.set_tx_power = rtl8723a_set_tx_power,
 	.update_rate_mask = rtl8723au_update_rate_mask,
+	.report_connect = rtl8723au_report_connect,
 	.writeN_block_size = 1024,
 	.mbox_ext_reg = REG_HMBOX_EXT_0,
 	.mbox_ext_width = 2,
@@ -8264,6 +8293,7 @@ static struct rtl8xxxu_fileops rtl8723bu_fops = {
 	.enable_rf = rtl8723b_enable_rf,
 	.set_tx_power = rtl8723b_set_tx_power,
 	.update_rate_mask = rtl8723bu_update_rate_mask,
+	.report_connect = rtl8723bu_report_connect,
 	.writeN_block_size = 1024,
 	.mbox_ext_reg = REG_HMBOX_EXT0_8723B,
 	.mbox_ext_width = 4,
@@ -8288,6 +8318,7 @@ static struct rtl8xxxu_fileops rtl8192cu_fops = {
 	.enable_rf = rtl8723a_enable_rf,
 	.set_tx_power = rtl8723a_set_tx_power,
 	.update_rate_mask = rtl8723au_update_rate_mask,
+	.report_connect = rtl8723au_report_connect,
 	.writeN_block_size = 128,
 	.mbox_ext_reg = REG_HMBOX_EXT_0,
 	.mbox_ext_width = 2,
@@ -8311,6 +8342,7 @@ static struct rtl8xxxu_fileops rtl8192eu_fops = {
 	.enable_rf = rtl8723b_enable_rf,
 	.set_tx_power = rtl8723b_set_tx_power,
 	.update_rate_mask = rtl8723au_update_rate_mask,
+	.report_connect = rtl8723au_report_connect,
 	.writeN_block_size = 128,
 	.mbox_ext_reg = REG_HMBOX_EXT0_8723B,
 	.mbox_ext_width = 4,
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index eea62f1..2191b6b 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -958,6 +958,12 @@ struct h2c_cmd {
 		} __packed ramask;
 		struct {
 			u8 cmd;
+			u8 parm;
+			u8 macid;
+			u8 macid_end;
+		} __packed media_status_rpt;
+		struct {
+			u8 cmd;
 			u8 macid;
 			/*
 			 * [0:4] - RAID
@@ -1254,6 +1260,8 @@ struct rtl8xxxu_fileops {
 			      bool ht40);
 	void (*update_rate_mask) (struct rtl8xxxu_priv *priv,
 				  u32 ramask, int sgi);
+	void (*report_connect) (struct rtl8xxxu_priv *priv,
+				u8 macid, bool connect);
 	int writeN_block_size;
 	u16 mbox_ext_reg;
 	char mbox_ext_width;
-- 
2.5.0

