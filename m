Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:12451 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759026Ab2FUSaZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jun 2012 14:30:25 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 1/3] ath9k_hw: fix buffer overflow smatch warning
Date: Fri, 22 Jun 2012 00:01:30 +0530
Message-ID: <1340303492-30947-2-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20120621_203028_861179_C8708E09)
In-Reply-To: <1340303492-30947-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1340303492-30947-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

drivers/net/wireless/ath/ath9k/btcoex.c:93
  ath9k_hw_init_btcoex_hw() error: buffer overflow
  'ah->hw_gen_timers.gen_timer_index' 32 <= 2009813776

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/btcoex.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/btcoex.c b/drivers/net/wireless/ath/ath9k/btcoex.c
index acd4373..f06477a 100644
--- a/drivers/net/wireless/ath/ath9k/btcoex.c
+++ b/drivers/net/wireless/ath/ath9k/btcoex.c
@@ -89,7 +89,7 @@ void ath9k_hw_init_btcoex_hw(struct ath_hw *ah, int qnum)
 		AR_BT_DISABLE_BT_ANT;
 
 	for (i = 0; i < 32; i++) {
-		idx = (debruijn32 << i) >> 27;
+		idx = ((debruijn32 << i) >> 27) % 32;
 		ah->hw_gen_timers.gen_timer_index[idx] = i;
 	}
 }
-- 
1.7.11

