Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:31625 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750851AbZG0S5f (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jul 2009 14:57:35 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2009 11:57:36 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Christian Lamparter <chunkeey@web.de>
Subject: [PATCH] ar9170: remove unneeded flush_workqueue()
Date: Mon, 27 Jul 2009 11:57:34 -0700
Message-ID: <1248721054-15966-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

cancel_delayed_work_sync() and cancel_work_sync() are already being
used therefore already waiting for all pending work by the driver
to have been completed, no need to flush the mac80211 workqueue.

Cc: Christian Lamparter <chunkeey@web.de>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ar9170/main.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ar9170/main.c b/drivers/net/wireless/ath/ar9170/main.c
index c7287a8..cd8d340 100644
--- a/drivers/net/wireless/ath/ar9170/main.c
+++ b/drivers/net/wireless/ath/ar9170/main.c
@@ -1290,12 +1290,11 @@ static void ar9170_op_stop(struct ieee80211_hw *hw)
 	if (IS_STARTED(ar))
 		ar->state = AR9170_IDLE;
 
-	flush_workqueue(ar->hw->workqueue);
-
 	cancel_delayed_work_sync(&ar->tx_janitor);
 	cancel_delayed_work_sync(&ar->led_work);
 	cancel_work_sync(&ar->filter_config_work);
 	cancel_work_sync(&ar->beacon_work);
+
 	mutex_lock(&ar->mutex);
 
 	if (IS_ACCEPTING_CMD(ar)) {
-- 
1.6.0.4

