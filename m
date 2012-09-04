Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:19683 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757126Ab2IDOEB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Sep 2012 10:04:01 -0400
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 2/8] ath9k: Fix BTCOEX timer triggering comparision
Date: Tue, 4 Sep 2012 19:33:33 +0530
Message-ID: <1346767419-12359-2-git-send-email-mohammed@qca.qualcomm.com> (sfid-20120904_160405_661349_5BBF331F)
In-Reply-To: <1346767419-12359-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1346767419-12359-1-git-send-email-mohammed@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

Its more correct to convert btcoex_period to 'us' while
comparing with btcoex_no_stomp which is in 'us'.
Did not find any functionality issues being fixed,
as the generic hardware timer triggers are usually
refreshed with the newer duty cycle.

Cc: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    2 +-
 drivers/net/wireless/ath/ath9k/gpio.c  |    7 ++++++-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 7373e4b..2bb89b1 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -473,7 +473,7 @@ struct ath_btcoex {
 	unsigned long op_flags;
 	int bt_stomp_type; /* Types of BT stomping */
 	u32 btcoex_no_stomp; /* in usec */
-	u32 btcoex_period; /* in usec */
+	u32 btcoex_period; /* in msec */
 	u32 btscan_no_stomp; /* in usec */
 	u32 duty_cycle;
 	u32 bt_wait_time;
diff --git a/drivers/net/wireless/ath/ath9k/gpio.c b/drivers/net/wireless/ath/ath9k/gpio.c
index bacdb8f..273eb67 100644
--- a/drivers/net/wireless/ath/ath9k/gpio.c
+++ b/drivers/net/wireless/ath/ath9k/gpio.c
@@ -228,7 +228,12 @@ static void ath_btcoex_period_timer(unsigned long data)
 	ath9k_hw_btcoex_enable(ah);
 	spin_unlock_bh(&btcoex->btcoex_lock);
 
-	if (btcoex->btcoex_period != btcoex->btcoex_no_stomp) {
+	/*
+	 * btcoex_period is in msec while (btocex/btscan_)no_stomp are in usec,
+	 * ensure that we properly convert btcoex_period to usec
+	 * for any comparision with (btcoex/btscan_)no_stomp.
+	 */
+	if (btcoex->btcoex_period * 1000 != btcoex->btcoex_no_stomp) {
 		if (btcoex->hw_timer_enabled)
 			ath9k_gen_timer_stop(ah, btcoex->no_stomp_timer);
 
-- 
1.7.0.4

