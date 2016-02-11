Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f196.google.com ([209.85.214.196]:33733 "EHLO
	mail-ob0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715AbcBKQx2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Feb 2016 11:53:28 -0500
Received: by mail-ob0-f196.google.com with SMTP id o4so6163306obb.0
        for <linux-wireless@vger.kernel.org>; Thu, 11 Feb 2016 08:53:27 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 1/4] rtlwifi: Prepare for reworking 5G channels
Date: Thu, 11 Feb 2016 10:53:09 -0600
Message-Id: <1455209592-12882-2-git-send-email-Larry.Finger@lwfinger.net> (sfid-20160211_175342_574190_2F5C8331)
In-Reply-To: <1455209592-12882-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1455209592-12882-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There are 3 drivers in this family that have 5G radios. Each of them
defines local copies of the available channels. This patch adds the
two arrays to the core driver.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Kalle,

This material is for kernel 4.6.

Larry

 drivers/net/wireless/realtek/rtlwifi/core.c | 16 ++++++++++++++++
 drivers/net/wireless/realtek/rtlwifi/wifi.h |  9 ++++-----
 2 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/core.c b/drivers/net/wireless/realtek/rtlwifi/core.c
index 4ae421e..02eba0e 100644
--- a/drivers/net/wireless/realtek/rtlwifi/core.c
+++ b/drivers/net/wireless/realtek/rtlwifi/core.c
@@ -35,6 +35,22 @@
 #include <linux/export.h>
 #include <net/cfg80211.h>
 
+u8 channel5g[CHANNEL_MAX_NUMBER_5G] = {
+	36, 38, 40, 42, 44, 46, 48,		/* Band 1 */
+	52, 54, 56, 58, 60, 62, 64,		/* Band 2 */
+	100, 102, 104, 106, 108, 110, 112,	/* Band 3 */
+	116, 118, 120, 122, 124, 126, 128,	/* Band 3 */
+	132, 134, 136, 138, 140, 142, 144,	/* Band 3 */
+	149, 151, 153, 155, 157, 159, 161,	/* Band 4 */
+	165, 167, 169, 171, 173, 175, 177	/* Band 4 */
+};
+EXPORT_SYMBOL(channel5g);
+
+u8 channel5g_80m[CHANNEL_MAX_NUMBER_5G_80M] = {
+	42, 58, 106, 122, 138, 155, 171
+};
+EXPORT_SYMBOL(channel5g_80m);
+
 void rtl_addr_delay(u32 addr)
 {
 	if (addr == 0xfe)
diff --git a/drivers/net/wireless/realtek/rtlwifi/wifi.h b/drivers/net/wireless/realtek/rtlwifi/wifi.h
index 4544752..e603819 100644
--- a/drivers/net/wireless/realtek/rtlwifi/wifi.h
+++ b/drivers/net/wireless/realtek/rtlwifi/wifi.h
@@ -122,11 +122,6 @@
 					    */
 #define CHANNEL_MAX_NUMBER_5G_80M	7
 #define CHANNEL_GROUP_MAX	(3 + 9)	/*  ch1~3, 4~9, 10~14 = three groups */
-#define CHANNEL_MAX_NUMBER_5G		54 /* Please refer to
-					    *"phy_GetChnlGroup8812A" and
-					    * "Hal_ReadTxPowerInfo8812A"
-					    */
-#define CHANNEL_MAX_NUMBER_5G_80M	7
 #define MAX_PG_GROUP			13
 #define	CHANNEL_GROUP_MAX_2G		3
 #define	CHANNEL_GROUP_IDX_5GL		3
@@ -2904,6 +2899,10 @@ value to host byte ordering.*/
 #define	STBC_VHT_TEST_TX_ENABLE			BIT(2)
 #define	STBC_VHT_CAP_TX				BIT(3)
 
+extern u8 channel5g[CHANNEL_MAX_NUMBER_5G];
+
+extern u8 channel5g_80m[CHANNEL_MAX_NUMBER_5G_80M];
+
 static inline u8 rtl_read_byte(struct rtl_priv *rtlpriv, u32 addr)
 {
 	return rtlpriv->io.read8_sync(rtlpriv, addr);
-- 
2.1.4

