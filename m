Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:48081 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752546AbaG0VnM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Jul 2014 17:43:12 -0400
Received: by mail-we0-f174.google.com with SMTP id x48so6569441wes.5
        for <linux-wireless@vger.kernel.org>; Sun, 27 Jul 2014 14:43:10 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: [PATCHv3 5/6] ath9k_htc: extend ath9k_htc_set_coverage_class signature
Date: Sun, 27 Jul 2014 23:43:08 +0200
Message-Id: <1406497388-25911-1-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20140727_234315_212123_36A5B3AB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Synchronize set_coverage_class routine signature with mac80211 function
pointer. Function pointer prototype has been changed to activate ath9k ACK
timeout estimation algorithm (dynack).

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 5627917..994fff1 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1722,7 +1722,7 @@ static int ath9k_htc_set_rts_threshold(struct ieee80211_hw *hw, u32 value)
 }
 
 static void ath9k_htc_set_coverage_class(struct ieee80211_hw *hw,
-					 u8 coverage_class)
+					 s16 coverage_class)
 {
 	struct ath9k_htc_priv *priv = hw->priv;
 
-- 
1.9.1

