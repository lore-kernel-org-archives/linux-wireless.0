Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:53226 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771AbZC1AqT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Mar 2009 20:46:19 -0400
From: Christian Lamparter <chunkeey@web.de>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] ar9170: fix hang on stop
Date: Sat, 28 Mar 2009 01:46:14 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200903280146.14903.chunkeey@web.de> (sfid-20090328_014623_005708_BD67BF74)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes a locking problem which freezes the network core.

The deadlock goes as follows:
- ar9170_op_stop - is called
1. change the state to IDLE
2. > take the MUTEX <
3. cancel_SYNC all pending work, which means
    "block until a work_struct's callback has terminated"
=>  if filter_config_work was queued it tries to get the MUTEX,
       before checking the device state...	

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
John,

I guess you have to queue this for the next wireless-2.6 ;)
By the way, I guess you should add the p54spi fixes as well.

Regards,
	Chr
---
diff --git a/drivers/net/wireless/ar9170/main.c b/drivers/net/wireless/ar9170/main.c
index 5996ff9..5f55754 100644
--- a/drivers/net/wireless/ar9170/main.c
+++ b/drivers/net/wireless/ar9170/main.c
@@ -742,8 +742,9 @@ static void ar9170_op_stop(struct ieee80211_hw *hw)
 	if (IS_STARTED(ar))
 		ar->state = AR9170_IDLE;
 
-	mutex_lock(&ar->mutex);
+	flush_workqueue(ar->hw->workqueue);
 
+	mutex_lock(&ar->mutex);
 	cancel_delayed_work_sync(&ar->tx_status_janitor);
 	cancel_work_sync(&ar->filter_config_work);
 	cancel_work_sync(&ar->beacon_work);
@@ -1123,10 +1124,10 @@ static void ar9170_set_filters(struct work_struct *work)
 					 filter_config_work);
 	int err;
 
-	mutex_lock(&ar->mutex);
 	if (unlikely(!IS_STARTED(ar)))
-		goto unlock;
+		return ;
 
+	mutex_lock(&ar->mutex);
 	if (ar->filter_changed & AR9170_FILTER_CHANGED_PROMISC) {
 		err = ar9170_set_operating_mode(ar);
 		if (err)
