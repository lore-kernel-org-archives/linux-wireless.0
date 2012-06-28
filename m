Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:30684 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473Ab2F1MTX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jun 2012 08:19:23 -0400
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	Bala Shanmugam <bkamatch@qca.qualcomm.com>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>,
	Sujith Manoharan <c_manoha@qca.qualcomm.com>
Subject: [RFC] ath9k: Fix clearing of BTCOEX flags
Date: Thu, 28 Jun 2012 17:49:12 +0530
Message-ID: <1340885952-5317-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20120628_141927_462275_7FE8DA00)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

BTCOEX flags are set/cleared by atomic operations.
We got to do the same in ath9k_btcoex_timer_resume,
while clearing those BTCOEX flags.

Cc: Sujith Manoharan <c_manoha@qca.qualcomm.com>
Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/gpio.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/gpio.c b/drivers/net/wireless/ath/ath9k/gpio.c
index 26032cb..bd342cd 100644
--- a/drivers/net/wireless/ath/ath9k/gpio.c
+++ b/drivers/net/wireless/ath/ath9k/gpio.c
@@ -305,7 +305,8 @@ void ath9k_btcoex_timer_resume(struct ath_softc *sc)
 
 	btcoex->bt_priority_cnt = 0;
 	btcoex->bt_priority_time = jiffies;
-	btcoex->op_flags &= ~(BT_OP_PRIORITY_DETECTED | BT_OP_SCAN);
+	clear_bit(BT_OP_PRIORITY_DETECTED, &btcoex->op_flags);
+	clear_bit(BT_OP_SCAN, &btcoex->op_flags);
 
 	mod_timer(&btcoex->period_timer, jiffies);
 }
-- 
1.7.0.4

