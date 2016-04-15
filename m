Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.hostpark.net ([212.243.197.30]:34574 "EHLO
	mail.hostpark.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783AbcDOGuz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Apr 2016 02:50:55 -0400
From: =?UTF-8?q?David=20M=C3=BCller?= <d.mueller@elsoft.ch>
To: linux-wireless@vger.kernel.org
Cc: Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH v2] rtlwifi: rtl8821ae: Make sure loop counter is signed on all architectures
Date: Fri, 15 Apr 2016 08:50:25 +0200
Message-Id: <1460703025-2177-1-git-send-email-d.mueller@elsoft.ch> (sfid-20160415_085058_373926_4FBEA3CC)
In-Reply-To: <570FBA62.6080606@lwfinger.net>
References: <570FBA62.6080606@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The for-loop condition does not work correctly on architectures where
"char" is unsigned. Fix it by using an "int", which may also result in
more efficient code.

v2: Remove unneeded initialization.

Signed-off-by: David Müller <d.mueller@elsoft.ch>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
index 74165b3..1abd243 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
@@ -959,7 +959,7 @@ static void _rtl8821ae_phy_store_txpower_by_rate_base(struct ieee80211_hw *hw)
 static void _phy_convert_txpower_dbm_to_relative_value(u32 *data, u8 start,
 						u8 end, u8 base_val)
 {
-	char i = 0;
+	int i;
 	u8 temp_value = 0;
 	u32 temp_data = 0;
 
-- 
2.7.4

