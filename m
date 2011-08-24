Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:56726 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752210Ab1HXTbc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Aug 2011 15:31:32 -0400
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <rodrigue@qca.qualcomm.com>,
	<senthilb@qca.qualcomm.com>, <rmanohar@qca.qualcomm.com>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: [PATCH] ath9k_htc: Add get_stats call back
Date: Thu, 25 Aug 2011 01:01:22 +0530
Message-ID: <1314214282-31750-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20110824_213138_217322_3EFF3AAC)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

currently this call back is used only in debugfs of mac80211

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 7212acb..0248024 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1736,6 +1736,22 @@ out:
 	return ret;
 }
 
+
+static int ath9k_htc_get_stats(struct ieee80211_hw *hw,
+			       struct ieee80211_low_level_stats *stats)
+{
+	struct ath9k_htc_priv *priv = hw->priv;
+	struct ath_hw *ah = priv->ah;
+	struct ath9k_mib_stats *mib_stats = &ah->ah_mibStats;
+
+	stats->dot11ACKFailureCount = mib_stats->ackrcv_bad;
+	stats->dot11RTSFailureCount = mib_stats->rts_bad;
+	stats->dot11FCSErrorCount = mib_stats->fcs_bad;
+	stats->dot11RTSSuccessCount = mib_stats->rts_good;
+
+	return 0;
+}
+
 struct ieee80211_ops ath9k_htc_ops = {
 	.tx                 = ath9k_htc_tx,
 	.start              = ath9k_htc_start,
@@ -1759,4 +1775,5 @@ struct ieee80211_ops ath9k_htc_ops = {
 	.rfkill_poll        = ath9k_htc_rfkill_poll_state,
 	.set_coverage_class = ath9k_htc_set_coverage_class,
 	.set_bitrate_mask   = ath9k_htc_set_bitrate_mask,
+	.get_stats	    = ath9k_htc_get_stats,
 };
-- 
1.7.0.4

