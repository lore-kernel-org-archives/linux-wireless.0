Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33474 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753453AbcB2WGC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 17:06:02 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 046/113] rtl8xxxu: Do not ignore wlan activity on 8723bu
Date: Mon, 29 Feb 2016 17:04:44 -0500
Message-Id: <1456783551-28315-47-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160229_232954_164514_42B5FA62)
In-Reply-To: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

The 8723bu is a WiFi/BT combo part. When initializing it for WiFi,
make sure to tell it not to ignore WiFi activity.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 5 +++++
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h | 4 ++++
 2 files changed, 9 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 7dcf387..24c3157 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -5704,6 +5704,11 @@ static void rtl8723bu_init_bt(struct rtl8xxxu_priv *priv)
 	 */
 	rtl8xxxu_write32(priv, REG_S0S1_PATH_SWITCH, 0x00);
 
+	memset(&h2c, 0, sizeof(struct h2c_cmd));
+	h2c.ignore_wlan.cmd = H2C_8723B_BT_IGNORE_WLANACT;
+	h2c.ignore_wlan.data = 0;
+	rtl8723a_h2c_cmd(priv, &h2c, sizeof(h2c.ignore_wlan));
+
 	/*
 	 * Software control, antenna at WiFi side
 	 */
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index c4c0b28..5a6b223 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -754,6 +754,10 @@ struct h2c_cmd {
 		} __packed bt_wlan_calibration;
 		struct {
 			u8 cmd;
+			u8 data;
+		} __packed ignore_wlan;
+		struct {
+			u8 cmd;
 			u8 ant_inverse;
 			u8 int_switch_type;
 		} __packed ant_sel_rsv;
-- 
2.5.0

