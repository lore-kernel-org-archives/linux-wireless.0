Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f194.google.com ([209.85.214.194]:34781 "EHLO
	mail-ob0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715AbcBKQxa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Feb 2016 11:53:30 -0500
Received: by mail-ob0-f194.google.com with SMTP id x5so6137825obg.1
        for <linux-wireless@vger.kernel.org>; Thu, 11 Feb 2016 08:53:29 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 2/4] rtlwifi: rtl8192de: Convert driver to use common 5G channels
Date: Thu, 11 Feb 2016 10:53:10 -0600
Message-Id: <1455209592-12882-3-git-send-email-Larry.Finger@lwfinger.net> (sfid-20160211_175338_905912_00E33CD1)
In-Reply-To: <1455209592-12882-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1455209592-12882-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This driver defines its owh copy of the 5G channels. Change it to use
the common definitions.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Kalle,

This material is for kernel 4.6.

Larry

 .../net/wireless/realtek/rtlwifi/rtl8192de/phy.c   | 23 ++++------------------
 1 file changed, 4 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
index bb06fe8..7810fe8 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
@@ -924,19 +924,11 @@ static void _rtl92d_ccxpower_index_check(struct ieee80211_hw *hw,
 
 static u8 _rtl92c_phy_get_rightchnlplace(u8 chnl)
 {
-	u8 channel_5g[59] = {
-		1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14,
-		36, 38, 40, 42, 44, 46, 48, 50, 52, 54, 56, 58,
-		60, 62, 64, 100, 102, 104, 106, 108, 110, 112,
-		114, 116, 118, 120, 122, 124, 126, 128,
-		130, 132, 134, 136, 138, 140, 149, 151,
-		153, 155, 157, 159, 161, 163, 165
-	};
 	u8 place = chnl;
 
 	if (chnl > 14) {
-		for (place = 14; place < sizeof(channel_5g); place++) {
-			if (channel_5g[place] == chnl) {
+		for (place = 14; place < sizeof(channel5g); place++) {
+			if (channel5g[place] == chnl) {
 				place++;
 				break;
 			}
@@ -2471,16 +2463,9 @@ static bool _rtl92d_is_legal_5g_channel(struct ieee80211_hw *hw, u8 channel)
 {
 
 	int i;
-	u8 channel_5g[45] = {
-		36, 38, 40, 42, 44, 46, 48, 50, 52, 54, 56, 58,
-		60, 62, 64, 100, 102, 104, 106, 108, 110, 112,
-		114, 116, 118, 120, 122, 124, 126, 128, 130, 132,
-		134, 136, 138, 140, 149, 151, 153, 155, 157, 159,
-		161, 163, 165
-	};
 
-	for (i = 0; i < sizeof(channel_5g); i++)
-		if (channel == channel_5g[i])
+	for (i = 0; i < sizeof(channel5g); i++)
+		if (channel == channel5g[i])
 			return true;
 	return false;
 }
-- 
2.1.4

