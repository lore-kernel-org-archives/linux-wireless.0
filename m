Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35418 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755386AbcIUBTb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Sep 2016 21:19:31 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
        Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 2/4] rtl8xxxu: Clean up llt_init() API
Date: Tue, 20 Sep 2016 21:19:27 -0400
Message-Id: <1474420769-20086-3-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160921_031935_457498_6E7B6408)
In-Reply-To: <1474420769-20086-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1474420769-20086-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Remove last_tx_page argument from the llt_init() function. The
rtl8xxxu_fileops structure contains the correct TX_TOTAL_PAGE_NUM
value for the device, and rtl8xxxu_auto_llt_table() doesn't need to
know the value in the first place.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h      | 6 +++---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 9 ++++++---
 2 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index 1f54b89..a10a57c 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -1318,7 +1318,7 @@ struct rtl8xxxu_fileops {
 	int (*power_on) (struct rtl8xxxu_priv *priv);
 	void (*power_off) (struct rtl8xxxu_priv *priv);
 	void (*reset_8051) (struct rtl8xxxu_priv *priv);
-	int (*llt_init) (struct rtl8xxxu_priv *priv, u8 last_tx_page);
+	int (*llt_init) (struct rtl8xxxu_priv *priv);
 	void (*init_phy_bb) (struct rtl8xxxu_priv *priv);
 	int (*init_phy_rf) (struct rtl8xxxu_priv *priv);
 	void (*phy_init_antenna_selection) (struct rtl8xxxu_priv *priv);
@@ -1400,14 +1400,14 @@ int rtl8xxxu_load_firmware(struct rtl8xxxu_priv *priv, char *fw_name);
 void rtl8xxxu_firmware_self_reset(struct rtl8xxxu_priv *priv);
 void rtl8xxxu_power_off(struct rtl8xxxu_priv *priv);
 void rtl8xxxu_reset_8051(struct rtl8xxxu_priv *priv);
-int rtl8xxxu_auto_llt_table(struct rtl8xxxu_priv *priv, u8 last_tx_page);
+int rtl8xxxu_auto_llt_table(struct rtl8xxxu_priv *priv);
 void rtl8xxxu_gen2_prepare_calibrate(struct rtl8xxxu_priv *priv, u8 start);
 int rtl8xxxu_flush_fifo(struct rtl8xxxu_priv *priv);
 int rtl8xxxu_gen2_h2c_cmd(struct rtl8xxxu_priv *priv,
 			  struct h2c_cmd *h2c, int len);
 int rtl8xxxu_active_to_lps(struct rtl8xxxu_priv *priv);
 void rtl8xxxu_disabled_to_emu(struct rtl8xxxu_priv *priv);
-int rtl8xxxu_init_llt_table(struct rtl8xxxu_priv *priv, u8 last_tx_page);
+int rtl8xxxu_init_llt_table(struct rtl8xxxu_priv *priv);
 void rtl8xxxu_gen1_phy_iq_calibrate(struct rtl8xxxu_priv *priv);
 void rtl8xxxu_gen1_init_phy_bb(struct rtl8xxxu_priv *priv);
 void rtl8xxxu_gen1_set_tx_power(struct rtl8xxxu_priv *priv,
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index 98fcd7b..c628b90 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -2472,10 +2472,13 @@ static int rtl8xxxu_llt_write(struct rtl8xxxu_priv *priv, u8 address, u8 data)
 	return ret;
 }
 
-int rtl8xxxu_init_llt_table(struct rtl8xxxu_priv *priv, u8 last_tx_page)
+int rtl8xxxu_init_llt_table(struct rtl8xxxu_priv *priv)
 {
 	int ret;
 	int i;
+	u8 last_tx_page;
+
+	last_tx_page = priv->fops->total_page_num;
 
 	for (i = 0; i < last_tx_page; i++) {
 		ret = rtl8xxxu_llt_write(priv, i, i + 1);
@@ -2503,7 +2506,7 @@ exit:
 	return ret;
 }
 
-int rtl8xxxu_auto_llt_table(struct rtl8xxxu_priv *priv, u8 last_tx_page)
+int rtl8xxxu_auto_llt_table(struct rtl8xxxu_priv *priv)
 {
 	u32 val32;
 	int ret = 0;
@@ -3988,7 +3991,7 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 
 	dev_dbg(dev, "%s: macpower %i\n", __func__, macpower);
 	if (!macpower) {
-		ret = priv->fops->llt_init(priv, TX_TOTAL_PAGE_NUM);
+		ret = priv->fops->llt_init(priv);
 		if (ret) {
 			dev_warn(dev, "%s: LLT table init failed\n", __func__);
 			goto exit;
-- 
2.7.4
