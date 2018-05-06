Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:41036 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751180AbeEFN0A (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 6 May 2018 09:26:00 -0400
Received: by mail-lf0-f68.google.com with SMTP id o123-v6so36889215lfe.8
        for <linux-wireless@vger.kernel.org>; Sun, 06 May 2018 06:25:59 -0700 (PDT)
From: Erik Stromdahl <erik.stromdahl@gmail.com>
To: kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Cc: Erik Stromdahl <erik.stromdahl@gmail.com>
Subject: [PATCH] ath10k: fix return value check in wake_tx_q op
Date: Sun,  6 May 2018 15:25:00 +0200
Message-Id: <20180506132500.16888-1-erik.stromdahl@gmail.com> (sfid-20180506_152607_464991_2424AC96)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath10k_mac_tx_push_txq returns either a postive integer (length) on
success or a negative error code on error.

The "if (ret) break;" statement will thus always break out of the loop
immediately after ath10k_mac_tx_push_txq has returned (making the loop
pointless).

A side effect of this fix is that we will iterate the queue until
ath10k_mac_tx_push_txq returns -ENOENT. This will make sure the queue is
not added back to ar->txqs when it is empty. This could potentially
improve performance somewhat (I have seen a small improvement with SDIO
devices).

Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 3d7119ad7c7a..487a7a7380fd 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -4290,7 +4290,7 @@ static void ath10k_mac_op_wake_tx_queue(struct ieee80211_hw *hw,
 
 	while (ath10k_mac_tx_can_push(hw, f_txq) && max--) {
 		ret = ath10k_mac_tx_push_txq(hw, f_txq);
-		if (ret)
+		if (ret < 0)
 			break;
 	}
 	if (ret != -ENOENT)
-- 
2.17.0
