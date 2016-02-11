Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f194.google.com ([209.85.214.194]:35953 "EHLO
	mail-ob0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781AbcBKQxb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Feb 2016 11:53:31 -0500
Received: by mail-ob0-f194.google.com with SMTP id wg8so6134282obc.3
        for <linux-wireless@vger.kernel.org>; Thu, 11 Feb 2016 08:53:31 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 3/4] rtlwifi: rtl8192ee: Convert driver to use new 5G channel tables
Date: Thu, 11 Feb 2016 10:53:11 -0600
Message-Id: <1455209592-12882-4-git-send-email-Larry.Finger@lwfinger.net> (sfid-20160211_175338_321139_5CD7A20C)
In-Reply-To: <1455209592-12882-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1455209592-12882-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The driver defines its own set of channel tables for the 5G band. With
this change, it will use those of the core.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Kalle,

This material is for kernel 4.6.

Larry

 drivers/net/wireless/realtek/rtlwifi/rtl8192ee/hw.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/hw.c
index 5f14308..9fd3f1b 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/hw.c
@@ -2018,18 +2018,6 @@ static void _rtl92ee_read_txpower_info_from_hwpg(struct ieee80211_hw *hw,
 	struct rtl_efuse *efu = rtl_efuse(rtl_priv(hw));
 	struct txpower_info_2g pwr2g;
 	struct txpower_info_5g pwr5g;
-	u8 channel5g[CHANNEL_MAX_NUMBER_5G] = {
-		36, 38, 40, 42, 44, 46, 48, 50, 52, 54,
-		56, 58, 60, 62, 64, 100, 102, 104, 106,
-		108, 110, 112, 114, 116, 118, 120, 122,
-		124, 126, 128, 130, 132, 134, 136, 138,
-		140, 142, 144, 149, 151, 153, 155, 157,
-		159, 161, 163, 165, 167, 168, 169, 171,
-		173, 175, 177
-	};
-	u8 channel5g_80m[CHANNEL_MAX_NUMBER_5G_80M] = {
-		42, 58, 106, 122, 138, 155, 171
-	};
 	u8 rf, idx;
 	u8 i;
 
-- 
2.1.4

