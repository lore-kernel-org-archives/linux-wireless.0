Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:41610 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999AbZGXHzx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jul 2009 03:55:53 -0400
From: Alexander Beregalov <a.beregalov@gmail.com>
To: linux-next@vger.kernel.org, chunkeey@web.de,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org
Cc: Alexander Beregalov <a.beregalov@gmail.com>
Subject: [PATCH] ar9170: fix build error when !CONFIG_AR9170_LEDS
Date: Fri, 24 Jul 2009 11:55:44 +0400
Message-Id: <1248422144-6150-1-git-send-email-a.beregalov@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix this build error when CONFIG_AR9170_LEDS is not set
drivers/net/wireless/ath/ar9170/main.c:1296: error: 'struct ar9170' has
no member named 'led_work'

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---
 drivers/net/wireless/ath/ar9170/main.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ar9170/main.c b/drivers/net/wireless/ath/ar9170/main.c
index c7287a8..85a1452 100644
--- a/drivers/net/wireless/ath/ar9170/main.c
+++ b/drivers/net/wireless/ath/ar9170/main.c
@@ -1293,7 +1293,9 @@ static void ar9170_op_stop(struct ieee80211_hw *hw)
 	flush_workqueue(ar->hw->workqueue);
 
 	cancel_delayed_work_sync(&ar->tx_janitor);
+#ifdef CONFIG_AR9170_LEDS
 	cancel_delayed_work_sync(&ar->led_work);
+#endif
 	cancel_work_sync(&ar->filter_config_work);
 	cancel_work_sync(&ar->beacon_work);
 	mutex_lock(&ar->mutex);
-- 
1.6.3.3

