Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39940 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753138AbcB2WF4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 17:05:56 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 078/113] rtl8xxxu: Setup coex table correctly (hopefully)
Date: Mon, 29 Feb 2016 17:05:16 -0500
Message-Id: <1456783551-28315-79-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160229_230839_473845_AD2A9504)
In-Reply-To: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Use the same values as the vendor driver when setting up the BTCOEX
table for 8723bu.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 18458db..7fb9830 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -5842,6 +5842,7 @@ static void rtl8xxxu_power_off(struct rtl8xxxu_priv *priv)
 	rtl8xxxu_write8(priv, REG_RSV_CTRL, 0x0e);
 }
 
+#ifdef NEED_PS_TDMA
 static void rtl8723bu_set_ps_tdma(struct rtl8xxxu_priv *priv,
 				  u8 arg1, u8 arg2, u8 arg3, u8 arg4, u8 arg5)
 {
@@ -5856,6 +5857,7 @@ static void rtl8723bu_set_ps_tdma(struct rtl8xxxu_priv *priv,
 	h2c.b_type_dma.data5 = arg5;
 	rtl8723a_h2c_cmd(priv, &h2c, sizeof(h2c.b_type_dma));
 }
+#endif
 
 static void rtl8723bu_init_bt(struct rtl8xxxu_priv *priv)
 {
@@ -5944,18 +5946,20 @@ static void rtl8723bu_init_bt(struct rtl8xxxu_priv *priv)
 	/*
 	 * Software control, antenna at WiFi side
 	 */
+#ifdef NEED_PS_TDMA
 	rtl8723bu_set_ps_tdma(priv, 0x08, 0x00, 0x00, 0x00, 0x00);
+#endif
+
+	rtl8xxxu_write32(priv, REG_BT_COEX_TABLE1, 0x55555555);
+	rtl8xxxu_write32(priv, REG_BT_COEX_TABLE2, 0x55555555);
+	rtl8xxxu_write32(priv, REG_BT_COEX_TABLE3, 0x00ffffff);
+	rtl8xxxu_write8(priv, REG_BT_COEX_TABLE4, 0x03);
 
 	memset(&h2c, 0, sizeof(struct h2c_cmd));
 	h2c.bt_info.cmd = H2C_8723B_BT_INFO;
 	h2c.bt_info.data = BIT(0);
 	rtl8723a_h2c_cmd(priv, &h2c, sizeof(h2c.bt_info));
 
-	rtl8xxxu_write32(priv, REG_BT_COEX_TABLE1, 0x55555555);
-	rtl8xxxu_write32(priv, REG_BT_COEX_TABLE2, 0x5a5a5a5a);
-	rtl8xxxu_write32(priv, REG_BT_COEX_TABLE3, 0x00ffffff);
-	rtl8xxxu_write8(priv, REG_BT_COEX_TABLE4, 0x03);
-
 	memset(&h2c, 0, sizeof(struct h2c_cmd));
 	h2c.ignore_wlan.cmd = H2C_8723B_BT_IGNORE_WLANACT;
 	h2c.ignore_wlan.data = 0;
-- 
2.5.0

