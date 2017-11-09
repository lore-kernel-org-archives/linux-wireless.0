Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:47271 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752725AbdKIHUl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 9 Nov 2017 02:20:41 -0500
From: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org
Cc: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Subject: [PATCH] ath10k: Re-enable TXQs for all devices
Date: Thu,  9 Nov 2017 16:19:45 +0900
Message-Id: <20171109071945.11033-1-toke@toke.dk> (sfid-20171109_082331_336588_B05971A6)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commit 4ca1807815aa6801aaced7fdefa9edacc2521767 disables the use of the
mac80211 TXQs for some devices because of a theoretical throughput
regression. We have not seen this regression for a while now, so it
should be safe to re-enable TXQs.

Signed-off-by: Toke Høiland-Jørgensen <toke@toke.dk>
---
This has been in LEDE trunk for a couple of months now with good results.

 drivers/net/wireless/ath/ath10k/mac.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 0a947eef348d..ca596ecd2d64 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -8329,15 +8329,6 @@ int ath10k_mac_register(struct ath10k *ar)
 			ath10k_warn(ar, "failed to initialise DFS pattern detector\n");
 	}
 
-	/* Current wake_tx_queue implementation imposes a significant
-	 * performance penalty in some setups. The tx scheduling code needs
-	 * more work anyway so disable the wake_tx_queue unless firmware
-	 * supports the pull-push mechanism.
-	 */
-	if (!test_bit(ATH10K_FW_FEATURE_PEER_FLOW_CONTROL,
-		      ar->running_fw->fw_file.fw_features))
-		ar->ops->wake_tx_queue = NULL;
-
 	ret = ath10k_mac_init_rd(ar);
 	if (ret) {
 		ath10k_err(ar, "failed to derive regdom: %d\n", ret);
-- 
2.15.0
