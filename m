Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.hostpark.net ([212.243.197.30]:49773 "EHLO
	mail.hostpark.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755008AbcDNM4G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Apr 2016 08:56:06 -0400
From: =?UTF-8?q?David=20M=C3=BCller?= <d.mueller@elsoft.ch>
To: linux-wireless@vger.kernel.org
Cc: Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH] rtlwifi: rtl8821ae: Make sure loop counter is signed on all architectures
Date: Thu, 14 Apr 2016 14:48:43 +0200
Message-Id: <1460638123-2913-1-git-send-email-d.mueller@elsoft.ch> (sfid-20160414_145617_015065_6D235103)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The for-loop condition does not work correctly on architectures where "char"
is unsigned. Fix it by using an "int", which may also result in more
efficient code.

Signed-off-by: David Müller <d.mueller@elsoft.ch>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
index 74165b3..fcd84d1 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
@@ -959,7 +959,7 @@ static void _rtl8821ae_phy_store_txpower_by_rate_base(struct ieee80211_hw *hw)
 static void _phy_convert_txpower_dbm_to_relative_value(u32 *data, u8 start,
 						u8 end, u8 base_val)
 {
-	char i = 0;
+	int i = 0;
 	u8 temp_value = 0;
 	u32 temp_data = 0;
 
-- 
2.7.4

