Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39933 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752958AbcB2WFz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 17:05:55 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 052/113] rtl8xxxu: Issue BT_INFO command
Date: Mon, 29 Feb 2016 17:04:50 -0500
Message-Id: <1456783551-28315-53-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160229_231013_615699_D18EF0CC)
In-Reply-To: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Issue a BT_INFO command to verify the status of BT/WiFi settings.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 18 +++++++++++-------
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h |  4 ++++
 2 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 8535883..bb2ad9b 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -5727,20 +5727,25 @@ static void rtl8723bu_init_bt(struct rtl8xxxu_priv *priv)
 	 */
 	rtl8xxxu_write32(priv, REG_S0S1_PATH_SWITCH, 0x00);
 
-	memset(&h2c, 0, sizeof(struct h2c_cmd));
-	h2c.ignore_wlan.cmd = H2C_8723B_BT_IGNORE_WLANACT;
-	h2c.ignore_wlan.data = 0;
-	rtl8723a_h2c_cmd(priv, &h2c, sizeof(h2c.ignore_wlan));
-
 	/*
 	 * Software control, antenna at WiFi side
 	 */
 	rtl8723bu_set_ps_tdma(priv, 0x08, 0x00, 0x00, 0x00, 0x00);
 
+	memset(&h2c, 0, sizeof(struct h2c_cmd));
+	h2c.bt_info.cmd = H2C_8723B_BT_INFO;
+	h2c.bt_info.data = BIT(0);
+	rtl8723a_h2c_cmd(priv, &h2c, sizeof(h2c.bt_info));
+
 	rtl8xxxu_write32(priv, REG_BT_COEX_TABLE1, 0x55555555);
 	rtl8xxxu_write32(priv, REG_BT_COEX_TABLE2, 0x5a5a5a5a);
 	rtl8xxxu_write32(priv, REG_BT_COEX_TABLE3, 0x00ffffff);
 	rtl8xxxu_write32(priv, REG_BT_COEX_TABLE4, 0x00000003);
+
+	memset(&h2c, 0, sizeof(struct h2c_cmd));
+	h2c.ignore_wlan.cmd = H2C_8723B_BT_IGNORE_WLANACT;
+	h2c.ignore_wlan.data = 0;
+	rtl8723a_h2c_cmd(priv, &h2c, sizeof(h2c.ignore_wlan));
 }
 
 static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
@@ -6847,8 +6852,7 @@ static void rtl8723bu_handle_c2h(struct rtl8xxxu_priv *priv,
 
 	len = skb->len - 2;
 
-	dev_info(dev, "%s: C2H ID %02x seq %02x, len %02x source %02x\n",
-		 __func__,
+	dev_info(dev, "C2H ID %02x seq %02x, len %02x source %02x\n",
 		 c2h->id, c2h->seq, len, c2h->bt_info.response_source);
 
 	switch(c2h->id) {
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index 3e4e355..ea0b28a 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -881,6 +881,10 @@ struct h2c_cmd {
 		} __packed b_type_dma;
 		struct {
 			u8 cmd;
+			u8 data;
+		} __packed bt_info;
+		struct {
+			u8 cmd;
 			u8 operreq;
 			u8 opcode;
 			u8 data;
-- 
2.5.0

