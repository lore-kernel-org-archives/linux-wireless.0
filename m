Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44601 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791AbcAOBX7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jan 2016 20:23:59 -0500
From: miaoqing@codeaurora.org
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
	kvalo@qca.qualcomm.com, Miaoqing Pan <miaoqing@codeaurora.org>
Subject: [PATCH 1/5] ath9k: avoid ANI restart if no trigger
Date: Fri, 15 Jan 2016 09:23:25 +0800
Message-Id: <1452821009-1156-2-git-send-email-miaoqing@codeaurora.org> (sfid-20160115_022401_712635_1D3D3170)
In-Reply-To: <1452821009-1156-1-git-send-email-miaoqing@codeaurora.org>
References: <1452821009-1156-1-git-send-email-miaoqing@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Miaoqing Pan <miaoqing@codeaurora.org>

ath9k_ani_restart() is always be invoked even if the trigger
condition is false.

Signed-off-by: Miaoqing Pan <miaoqing@codeaurora.org>
---
 drivers/net/wireless/ath/ath9k/ani.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/ani.c b/drivers/net/wireless/ath/ath9k/ani.c
index 25e45e4..0f74d59 100644
--- a/drivers/net/wireless/ath/ath9k/ani.c
+++ b/drivers/net/wireless/ath/ath9k/ani.c
@@ -444,14 +444,16 @@ void ath9k_hw_ani_monitor(struct ath_hw *ah, struct ath9k_channel *chan)
 		    ofdmPhyErrRate < ah->config.ofdm_trig_low) {
 			ath9k_hw_ani_lower_immunity(ah);
 			aniState->ofdmsTurn = !aniState->ofdmsTurn;
+			ath9k_ani_restart(ah);
 		} else if (ofdmPhyErrRate > ah->config.ofdm_trig_high) {
 			ath9k_hw_ani_ofdm_err_trigger(ah);
 			aniState->ofdmsTurn = false;
+			ath9k_ani_restart(ah);
 		} else if (cckPhyErrRate > ah->config.cck_trig_high) {
 			ath9k_hw_ani_cck_err_trigger(ah);
 			aniState->ofdmsTurn = true;
+			ath9k_ani_restart(ah);
 		}
-		ath9k_ani_restart(ah);
 	}
 }
 EXPORT_SYMBOL(ath9k_hw_ani_monitor);
-- 
1.9.1

