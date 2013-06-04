Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:57178 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899Ab3FDKO0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Jun 2013 06:14:26 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 3/6] ath9k: Fix ANI levels
Date: Tue,  4 Jun 2013 15:41:32 +0530
Message-Id: <1370340695-29003-3-git-send-email-sujith@msujith.org> (sfid-20130604_121429_738953_A427FE03)
In-Reply-To: <1370340695-29003-1-git-send-email-sujith@msujith.org>
References: <1370340695-29003-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

The commit, "ath9k_hw: improve ANI processing and rx desensitizing parameters"
modified the immunity level tables for both CCK and OFDM. Fix them
so that the tables are in sync with the internal driver/codebase.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ani.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ani.c b/drivers/net/wireless/ath/ath9k/ani.c
index 1520e55..c8595f4 100644
--- a/drivers/net/wireless/ath/ath9k/ani.c
+++ b/drivers/net/wireless/ath/ath9k/ani.c
@@ -46,8 +46,8 @@ static const struct ani_ofdm_level_entry ofdm_level_table[] = {
 	{  5,  4,  1  }, /* lvl 5 */
 	{  6,  5,  1  }, /* lvl 6 */
 	{  7,  6,  1  }, /* lvl 7 */
-	{  7,  6,  0  }, /* lvl 8 */
-	{  7,  7,  0  }  /* lvl 9 */
+	{  7,  7,  1  }, /* lvl 8 */
+	{  7,  8,  0  }  /* lvl 9 */
 };
 #define ATH9K_ANI_OFDM_NUM_LEVEL \
 	ARRAY_SIZE(ofdm_level_table)
@@ -91,8 +91,8 @@ static const struct ani_cck_level_entry cck_level_table[] = {
 	{  4,  0  }, /* lvl 4 */
 	{  5,  0  }, /* lvl 5 */
 	{  6,  0  }, /* lvl 6 */
-	{  6,  0  }, /* lvl 7 (only for high rssi) */
-	{  7,  0  }  /* lvl 8 (only for high rssi) */
+	{  7,  0  }, /* lvl 7 (only for high rssi) */
+	{  8,  0  }  /* lvl 8 (only for high rssi) */
 };
 
 #define ATH9K_ANI_CCK_NUM_LEVEL \
-- 
1.8.3

