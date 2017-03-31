Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:35607 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933566AbdCaQsQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 31 Mar 2017 12:48:16 -0400
Received: by mail-oi0-f67.google.com with SMTP id d2so2562404oig.2
        for <linux-wireless@vger.kernel.org>; Fri, 31 Mar 2017 09:48:15 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 11/12] rtlwifi: btcoex: 23b 2ant: add comments to describe how duration adjusted
Date: Fri, 31 Mar 2017 11:47:41 -0500
Message-Id: <20170331164742.22374-12-Larry.Finger@lwfinger.net> (sfid-20170331_184819_933040_31465991)
In-Reply-To: <20170331164742.22374-1-Larry.Finger@lwfinger.net>
References: <20170331164742.22374-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

Since btcoex uses static variables to store the cumulative information
on the wifi status, some tricks are used that are a bit obscure. We add
some comments about the criteria we use to adjust wifi duration.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 .../realtek/rtlwifi/btcoexist/halbtc8723b2ant.c       | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
index ac4074c..c349675 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
@@ -1622,6 +1622,9 @@ static void btc8723b2ant_tdma_duration_adjust(struct btc_coexist *btcoexist,
 				dn = 0;
 
 			if (up >= n) {
+				/* if retry count during continuous n*2
+				 * seconds is 0, enlarge WiFi duration
+				 */
 				wait_count = 0;
 				n = 3;
 				up = 0;
@@ -1638,12 +1641,20 @@ static void btc8723b2ant_tdma_duration_adjust(struct btc_coexist *btcoexist,
 				up = 0;
 
 			if (dn == 2) {
+				/* if continuous 2 retry count(every 2
+				 * seconds) >0 and < 3, reduce WiFi duration
+				 */
 				if (wait_count <= 2)
+					/* avoid loop between the two levels */
 					m++;
 				else
 					m = 1;
 
 				if (m >= 20)
+					/* maximum of m = 20 ' will recheck if
+					 * need to adjust wifi duration in
+					 * maximum time interval 120 seconds
+					 */
 					m = 20;
 
 				n = 3 * m;
@@ -1655,12 +1666,20 @@ static void btc8723b2ant_tdma_duration_adjust(struct btc_coexist *btcoexist,
 					 "[BTCoex], Decrease wifi duration for retry_counter<3!!\n");
 			}
 		} else {
+			/* retry count > 3, once retry count > 3, to reduce
+			 *  WiFi duration
+			 */
 			if (wait_count == 1)
+				/* to avoid loop between the two levels */
 				m++;
 			else
 				m = 1;
 
 			if (m >= 20)
+				/* maximum of m = 20 ' will recheck if need to
+				 * adjust wifi duration in maximum time interval
+				 * 120 seconds
+				 */
 				m = 20;
 
 			n = 3 * m;
-- 
2.10.2
