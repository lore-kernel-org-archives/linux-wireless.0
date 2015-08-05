Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f180.google.com ([209.85.214.180]:35729 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391AbbHEQSu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Aug 2015 12:18:50 -0400
Received: by obbop1 with SMTP id op1so35421120obb.2
        for <linux-wireless@vger.kernel.org>; Wed, 05 Aug 2015 09:18:50 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, timlee <timlee@realtek.com>,
	shaofu <shaofu@realtek.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH V2 NEXT 1/7] rtlwifi: rtl8821ae: Remove unsupported 5G channels
Date: Wed,  5 Aug 2015 11:18:34 -0500
Message-Id: <1438791520-13216-2-git-send-email-Larry.Finger@lwfinger.net> (sfid-20150805_181853_280313_23E1AE19)
In-Reply-To: <1438791520-13216-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1438791520-13216-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: timlee <timlee@realtek.com>

The 5G channel list contains channels that are not supported.

Signed-off-by: timlee <timlee@realtek.com>
Signed-off-by: shaofu <shaofu@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
V2 - unchanged
---
 drivers/net/wireless/rtlwifi/rtl8821ae/hw.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8821ae/hw.c b/drivers/net/wireless/rtlwifi/rtl8821ae/hw.c
index b7f18e21..53d67a9 100644
--- a/drivers/net/wireless/rtlwifi/rtl8821ae/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8821ae/hw.c
@@ -2856,13 +2856,13 @@ static void _rtl8821ae_read_txpower_info_from_hwpg(struct ieee80211_hw *hw,
 	struct txpower_info_2g pwrinfo24g;
 	struct txpower_info_5g pwrinfo5g;
 	u8 channel5g[CHANNEL_MAX_NUMBER_5G] = {
-		36, 38, 40, 42, 44, 46, 48, 50, 52, 54,
-		56, 58, 60, 62, 64, 100, 102, 104, 106,
-		108, 110, 112, 114, 116, 118, 120, 122,
-		124, 126, 128, 130, 132, 134, 136, 138,
-		140, 142, 144, 149, 151, 153, 155, 157,
-		159, 161, 163, 165, 167, 168, 169, 171,
-		173, 175, 177};
+		36, 38, 40, 42, 44, 46, 48,		/* Band 1 */
+		52, 54, 56, 58, 60, 62, 64,		/* Band 2 */
+		100, 102, 104, 106, 108, 110, 112,	/* Band 3 */
+		116, 118, 120, 122, 124, 126, 128,	/* Band 3 */
+		132, 134, 136, 138, 140, 142, 144,	/* Band 3 */
+		149, 151, 153, 155, 157, 159, 161,	/* Band 4 */
+		165, 167, 169, 171, 173, 175, 177};	/* Band 4 */
 	u8 channel5g_80m[CHANNEL_MAX_NUMBER_5G_80M] = {
 		42, 58, 106, 122, 138, 155, 171};
 	u8 rf_path, index;
-- 
2.1.4

