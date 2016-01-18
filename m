Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52570 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753263AbcARBeW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Jan 2016 20:34:22 -0500
From: miaoqing@codeaurora.org
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
	kvalo@qca.qualcomm.com, nbd@openwrt.org,
	Miaoqing Pan <miaoqing@codeaurora.org>
Subject: [PATCH v3 1/5] ath9k: avoid ANI restart if no trigger
Date: Mon, 18 Jan 2016 09:33:46 +0800
Message-Id: <1453080830-7616-2-git-send-email-miaoqing@codeaurora.org> (sfid-20160118_023425_605722_499C705E)
In-Reply-To: <1453080830-7616-1-git-send-email-miaoqing@codeaurora.org>
References: <1453080830-7616-1-git-send-email-miaoqing@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Miaoqing Pan <miaoqing@codeaurora.org>

Fixes commit 54da20d83f0e ("ath9k_hw: improve ANI processing and rx desensitizing parameters")

Call ath9k_ani_restart() only when the phy error rate reach the
ANI immunity threshold. Sync the logic with internal code base.

Signed-off-by: Miaoqing Pan <miaoqing@codeaurora.org>
---
 drivers/net/wireless/ath/ath9k/ani.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/ani.c b/drivers/net/wireless/ath/ath9k/ani.c
index 25e45e4..aa82e13 100644
--- a/drivers/net/wireless/ath/ath9k/ani.c
+++ b/drivers/net/wireless/ath/ath9k/ani.c
@@ -450,7 +450,9 @@ void ath9k_hw_ani_monitor(struct ath_hw *ah, struct ath9k_channel *chan)
 		} else if (cckPhyErrRate > ah->config.cck_trig_high) {
 			ath9k_hw_ani_cck_err_trigger(ah);
 			aniState->ofdmsTurn = true;
-		}
+		} else
+			return;
+			
 		ath9k_ani_restart(ah);
 	}
 }
-- 
1.9.1

