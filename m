Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:64300 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830Ab2F2FEt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jun 2012 01:04:49 -0400
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	Bala Shanmugam <bkamatch@qca.qualcomm.com>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: [PATCH] ath9k: Fix clearing of BTCOEX flags
Date: Fri, 29 Jun 2012 10:34:39 +0530
Message-ID: <1340946279-2549-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20120629_070452_748914_C519DC22)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

BTCOEX flags are set/cleared by atomic operations.
We got to do the same in ath9k_btcoex_timer_resume,
while clearing those BTCOEX flags.

Acked-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/gpio.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/gpio.c b/drivers/net/wireless/ath/ath9k/gpio.c
index 9ae6a4d..5eac4d1 100644
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

