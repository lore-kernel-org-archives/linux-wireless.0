Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:62843 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753013Ab1BKHCK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Feb 2011 02:02:10 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 10 Feb 2011 23:01:49 -0800
From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <lrodriguez@atheros.com>,
	Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
Subject: [PATCH] ath9k_htc: make use of slot time macros
Date: Fri, 11 Feb 2011 12:32:03 +0530
Message-ID: <1297407723-4069-1-git-send-email-mshajakhan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>

Instead of using raw numbers to assign slot time it would be better to
make use of predefined slot time macros

Signed-off-by: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 953036a..17db173 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1498,9 +1498,9 @@ static void ath9k_htc_bss_info_changed(struct ieee80211_hw *hw,
 
 	if (changed & BSS_CHANGED_ERP_SLOT) {
 		if (bss_conf->use_short_slot)
-			ah->slottime = 9;
+			ah->slottime = ATH9K_SLOT_TIME_9;
 		else
-			ah->slottime = 20;
+			ah->slottime = ATH9K_SLOT_TIME_20;
 
 		ath9k_hw_init_global_settings(ah);
 	}
-- 
1.7.0.4

