Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:36091 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751765AbcK2DFX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Nov 2016 22:05:23 -0500
Received: by mail-pf0-f194.google.com with SMTP id c4so7373634pfb.3
        for <linux-wireless@vger.kernel.org>; Mon, 28 Nov 2016 19:05:22 -0800 (PST)
Date: Tue, 29 Nov 2016 13:01:46 +1000
From: Barry Day <briselec@gmail.com>
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux-wireless@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH] rtl8xxxu: Fix fail to reconnect to AP
Message-ID: <20161129030137.GA7917@box64.home.org> (sfid-20161129_040526_757230_FAB58C84)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Removed the report_connect functions as the h2c commands used are
not required for a soft-mac driver and they prevent reconnecting to an
AP for a couple of the chipsets.

Signed-off-by: Barry Day <briselec@gmail.com>
---
 rtl8xxxu.h       |  6 ------
 rtl8xxxu_8192c.c |  1 -
 rtl8xxxu_8192e.c |  1 -
 rtl8xxxu_8723a.c |  1 -
 rtl8xxxu_8723b.c |  1 -
 rtl8xxxu_core.c  | 36 ------------------------------------
 6 files changed, 46 deletions(-)

diff --git a/rtl8xxxu.h b/rtl8xxxu.h
index df551b2..3b1f62d 100644
--- a/rtl8xxxu.h
+++ b/rtl8xxxu.h
@@ -1335,8 +1335,6 @@ struct rtl8xxxu_fileops {
 			      bool ht40);
 	void (*update_rate_mask) (struct rtl8xxxu_priv *priv,
 				  u32 ramask, int sgi);
-	void (*report_connect) (struct rtl8xxxu_priv *priv,
-				u8 macid, bool connect);
 	void (*fill_txdesc) (struct ieee80211_hw *hw, struct ieee80211_hdr *hdr,
 			     struct ieee80211_tx_info *tx_info,
 			     struct rtl8xxxu_txdesc32 *tx_desc, bool sgi,
@@ -1422,10 +1420,6 @@ void rtl8xxxu_update_rate_mask(struct rtl8xxxu_priv *priv,
 			       u32 ramask, int sgi);
 void rtl8xxxu_gen2_update_rate_mask(struct rtl8xxxu_priv *priv,
 				    u32 ramask, int sgi);
-void rtl8xxxu_gen1_report_connect(struct rtl8xxxu_priv *priv,
-				  u8 macid, bool connect);
-void rtl8xxxu_gen2_report_connect(struct rtl8xxxu_priv *priv,
-				  u8 macid, bool connect);
 void rtl8xxxu_gen1_init_aggregation(struct rtl8xxxu_priv *priv);
 void rtl8xxxu_gen1_enable_rf(struct rtl8xxxu_priv *priv);
 void rtl8xxxu_gen1_disable_rf(struct rtl8xxxu_priv *priv);
diff --git a/rtl8xxxu_8192c.c b/rtl8xxxu_8192c.c
index f9e2050..d5c37e0 100644
--- a/rtl8xxxu_8192c.c
+++ b/rtl8xxxu_8192c.c
@@ -566,7 +566,6 @@ struct rtl8xxxu_fileops rtl8192cu_fops = {
 	.usb_quirks = rtl8xxxu_gen1_usb_quirks,
 	.set_tx_power = rtl8xxxu_gen1_set_tx_power,
 	.update_rate_mask = rtl8xxxu_update_rate_mask,
-	.report_connect = rtl8xxxu_gen1_report_connect,
 	.fill_txdesc = rtl8xxxu_fill_txdesc_v1,
 	.writeN_block_size = 128,
 	.rx_agg_buf_size = 16000,
diff --git a/rtl8xxxu_8192e.c b/rtl8xxxu_8192e.c
index a1178c5..401aac4 100644
--- a/rtl8xxxu_8192e.c
+++ b/rtl8xxxu_8192e.c
@@ -1648,7 +1648,6 @@ struct rtl8xxxu_fileops rtl8192eu_fops = {
 	.usb_quirks = rtl8xxxu_gen2_usb_quirks,
 	.set_tx_power = rtl8192e_set_tx_power,
 	.update_rate_mask = rtl8xxxu_gen2_update_rate_mask,
-	.report_connect = rtl8xxxu_gen2_report_connect,
 	.fill_txdesc = rtl8xxxu_fill_txdesc_v2,
 	.writeN_block_size = 128,
 	.tx_desc_size = sizeof(struct rtl8xxxu_txdesc40),
diff --git a/rtl8xxxu_8723a.c b/rtl8xxxu_8723a.c
index aef3730..9c13db5 100644
--- a/rtl8xxxu_8723a.c
+++ b/rtl8xxxu_8723a.c
@@ -383,7 +383,6 @@ struct rtl8xxxu_fileops rtl8723au_fops = {
 	.usb_quirks = rtl8xxxu_gen1_usb_quirks,
 	.set_tx_power = rtl8xxxu_gen1_set_tx_power,
 	.update_rate_mask = rtl8xxxu_update_rate_mask,
-	.report_connect = rtl8xxxu_gen1_report_connect,
 	.fill_txdesc = rtl8xxxu_fill_txdesc_v1,
 	.writeN_block_size = 1024,
 	.rx_agg_buf_size = 16000,
diff --git a/rtl8xxxu_8723b.c b/rtl8xxxu_8723b.c
index 02b8ddd..30dc66e 100644
--- a/rtl8xxxu_8723b.c
+++ b/rtl8xxxu_8723b.c
@@ -1665,7 +1665,6 @@ struct rtl8xxxu_fileops rtl8723bu_fops = {
 	.usb_quirks = rtl8xxxu_gen2_usb_quirks,
 	.set_tx_power = rtl8723b_set_tx_power,
 	.update_rate_mask = rtl8xxxu_gen2_update_rate_mask,
-	.report_connect = rtl8xxxu_gen2_report_connect,
 	.fill_txdesc = rtl8xxxu_fill_txdesc_v2,
 	.writeN_block_size = 1024,
 	.tx_desc_size = sizeof(struct rtl8xxxu_txdesc40),
diff --git a/rtl8xxxu_core.c b/rtl8xxxu_core.c
index a9137ab..03e88d2 100644
--- a/rtl8xxxu_core.c
+++ b/rtl8xxxu_core.c
@@ -4352,39 +4352,6 @@ void rtl8xxxu_gen2_update_rate_mask(struct rtl8xxxu_priv *priv,
 	rtl8xxxu_gen2_h2c_cmd(priv, &h2c, sizeof(h2c.b_macid_cfg));
 }
 
-void rtl8xxxu_gen1_report_connect(struct rtl8xxxu_priv *priv,
-				  u8 macid, bool connect)
-{
-	struct h2c_cmd h2c;
-
-	memset(&h2c, 0, sizeof(struct h2c_cmd));
-
-	h2c.joinbss.cmd = H2C_JOIN_BSS_REPORT;
-
-	if (connect)
-		h2c.joinbss.data = H2C_JOIN_BSS_CONNECT;
-	else
-		h2c.joinbss.data = H2C_JOIN_BSS_DISCONNECT;
-
-	rtl8xxxu_gen1_h2c_cmd(priv, &h2c, sizeof(h2c.joinbss));
-}
-
-void rtl8xxxu_gen2_report_connect(struct rtl8xxxu_priv *priv,
-				  u8 macid, bool connect)
-{
-	struct h2c_cmd h2c;
-
-	memset(&h2c, 0, sizeof(struct h2c_cmd));
-
-	h2c.media_status_rpt.cmd = H2C_8723B_MEDIA_STATUS_RPT;
-	if (connect)
-		h2c.media_status_rpt.parm |= BIT(0);
-	else
-		h2c.media_status_rpt.parm &= ~BIT(0);
-
-	rtl8xxxu_gen2_h2c_cmd(priv, &h2c, sizeof(h2c.media_status_rpt));
-}
-
 void rtl8xxxu_gen1_init_aggregation(struct rtl8xxxu_priv *priv)
 {
 	u8 agg_ctrl, usb_spec, page_thresh, timeout;
@@ -4525,13 +4492,10 @@ rtl8xxxu_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			rtl8xxxu_write16(priv, REG_BCN_PSR_RPT,
 					 0xc000 | bss_conf->aid);
 
-			priv->fops->report_connect(priv, 0, true);
 		} else {
 			val8 = rtl8xxxu_read8(priv, REG_BEACON_CTRL);
 			val8 |= BEACON_DISABLE_TSF_UPDATE;
 			rtl8xxxu_write8(priv, REG_BEACON_CTRL, val8);
-
-			priv->fops->report_connect(priv, 0, false);
 		}
 	}
 
-- 
2.9.2
