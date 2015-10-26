Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:33256 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971AbbJZJWI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Oct 2015 05:22:08 -0400
Received: by pacfa8 with SMTP id fa8so4148200pac.0
        for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2015 02:22:07 -0700 (PDT)
From: manikanta.pubbisetty@gmail.com
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Manikanta Pubbisetty <manikanta.pubbisetty@gmail.com>
Subject: [PATCH] ath10k: update antenna configuration after setting in fw
Date: Mon, 26 Oct 2015 14:52:10 +0530
Message-Id: <1445851330-18736-1-git-send-email-manikanta.pubbisetty@gmail.com> (sfid-20151026_102222_992561_ACFC2CE5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Manikanta Pubbisetty <manikanta.pubbisetty@gmail.com>

Updating tx/rx antenna configuration in ath10k is done even before
it is set in target. If setting of the tx/rx antenna config fails then
we will maintain incorrect configuration in ath10k and APIs like
get_antenna will provide incorrect information.

This patch updates the antenna configuration in ath10k after it is set
successfully in target.

Signed-off-by: Manikanta Pubbisetty <manikanta.pubbisetty@gmail.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 484c1a1..8d0ce37 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3771,9 +3771,6 @@ static int __ath10k_set_antenna(struct ath10k *ar, u32 tx_ant, u32 rx_ant)
 	ath10k_check_chain_mask(ar, tx_ant, "tx");
 	ath10k_check_chain_mask(ar, rx_ant, "rx");
 
-	ar->cfg_tx_chainmask = tx_ant;
-	ar->cfg_rx_chainmask = rx_ant;
-
 	if ((ar->state != ATH10K_STATE_ON) &&
 	    (ar->state != ATH10K_STATE_RESTARTED))
 		return 0;
@@ -3794,6 +3791,9 @@ static int __ath10k_set_antenna(struct ath10k *ar, u32 tx_ant, u32 rx_ant)
 		return ret;
 	}
 
+	ar->cfg_tx_chainmask = tx_ant;
+	ar->cfg_rx_chainmask = rx_ant;
+
 	return 0;
 }
 
-- 
1.9.1

