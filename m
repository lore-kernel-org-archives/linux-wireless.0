Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:45660 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249Ab1HZFuH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Aug 2011 01:50:07 -0400
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <rodrigue@qca.qualcomm.com>,
	<senthilb@qca.qualcomm.com>, <rmanohar@qca.qualcomm.com>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: [PATCH] ath9k: minor cleanup in ani
Date: Fri, 26 Aug 2011 11:19:57 +0530
Message-ID: <1314337797-5439-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20110826_075012_903041_3E3ADD1C)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

removed a function declaration, removed a variable, renamed a variable

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ani.c |    2 +-
 drivers/net/wireless/ath/ath9k/ani.h |    5 +----
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ani.c b/drivers/net/wireless/ath/ath9k/ani.c
index bfb6481..d969a11 100644
--- a/drivers/net/wireless/ath/ath9k/ani.c
+++ b/drivers/net/wireless/ath/ath9k/ani.c
@@ -643,7 +643,7 @@ static bool ath9k_hw_ani_read_counters(struct ath_hw *ah)
 	listenTime = ath_hw_get_listen_time(common);
 
 	if (listenTime <= 0) {
-		ah->stats.ast_ani_lneg++;
+		ah->stats.ast_ani_lneg_or_lzero++;
 		ath9k_ani_restart(ah);
 		return false;
 	}
diff --git a/drivers/net/wireless/ath/ath9k/ani.h b/drivers/net/wireless/ath/ath9k/ani.h
index dbab5b9..a547005 100644
--- a/drivers/net/wireless/ath/ath9k/ani.h
+++ b/drivers/net/wireless/ath/ath9k/ani.h
@@ -148,8 +148,7 @@ struct ar5416Stats {
 	u32 ast_ani_ofdmerrs;
 	u32 ast_ani_cckerrs;
 	u32 ast_ani_reset;
-	u32 ast_ani_lzero;
-	u32 ast_ani_lneg;
+	u32 ast_ani_lneg_or_lzero;
 	u32 avgbrssi;
 	struct ath9k_mib_stats ast_mibstats;
 };
@@ -159,7 +158,5 @@ void ath9k_enable_mib_counters(struct ath_hw *ah);
 void ath9k_hw_disable_mib_counters(struct ath_hw *ah);
 void ath9k_hw_ani_setup(struct ath_hw *ah);
 void ath9k_hw_ani_init(struct ath_hw *ah);
-int ath9k_hw_get_ani_channel_idx(struct ath_hw *ah,
-				 struct ath9k_channel *chan);
 
 #endif /* ANI_H */
-- 
1.7.0.4

