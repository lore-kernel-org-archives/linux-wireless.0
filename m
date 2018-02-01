Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:48057 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753214AbeBASD3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Feb 2018 13:03:29 -0500
From: Colin King <colin.king@canonical.com>
To: Jiri Slaby <jirislaby@gmail.com>,
        Nick Kossifidis <mickflemm@gmail.com>,
        "Luis R . Rodriguez" <mcgrof@do-not-panic.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ath5k: remove duplicated re-assignment to pointer 'tq'
Date: Thu,  1 Feb 2018 18:03:27 +0000
Message-Id: <20180201180327.23435-1-colin.king@canonical.com> (sfid-20180201_190449_271905_7714A7C5)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

Pointer tq is initialized with &ah->ah_txq[queue] and then a few
lines later is re-assigned the same value, hence this duplicate
assignment is redundant and can be removed.

Cleans up clang warning:
drivers/net/wireless/ath/ath5k/qcu.c:326:25: warning: Value stored
to 'tq' during its initialization is never read

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/ath/ath5k/qcu.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/qcu.c b/drivers/net/wireless/ath/ath5k/qcu.c
index beda11ce34a7..147947f632f7 100644
--- a/drivers/net/wireless/ath/ath5k/qcu.c
+++ b/drivers/net/wireless/ath/ath5k/qcu.c
@@ -327,8 +327,6 @@ ath5k_hw_reset_tx_queue(struct ath5k_hw *ah, unsigned int queue)
 
 	AR5K_ASSERT_ENTRY(queue, ah->ah_capabilities.cap_queues.q_tx_num);
 
-	tq = &ah->ah_txq[queue];
-
 	/* Skip if queue inactive or if we are on AR5210
 	 * that doesn't have QCU/DCU */
 	if ((ah->ah_version == AR5K_AR5210) ||
-- 
2.15.1
