Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40408 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755287Ab0G1UpT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jul 2010 16:45:19 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] ar9170: add get_survey callback in order to get channel noise
Date: Wed, 28 Jul 2010 16:30:40 -0400
Message-Id: <1280349040-25102-1-git-send-email-linville@tuxdriver.com>
In-Reply-To: <201007282157.57068.chunkeey@googlemail.com>
References: <201007282157.57068.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: John W. Linville <linville@tuxdriver.com>
Acked-by: Christian Lamparter <chunkeey@googlemail.com>
---
 drivers/net/wireless/ath/ar9170/main.c |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ar9170/main.c b/drivers/net/wireless/ath/ar9170/main.c
index 5e2c514..e089d9f 100644
--- a/drivers/net/wireless/ath/ar9170/main.c
+++ b/drivers/net/wireless/ath/ar9170/main.c
@@ -1905,6 +1905,22 @@ static int ar9170_get_stats(struct ieee80211_hw *hw,
 	return 0;
 }
 
+static int ar9170_get_survey(struct ieee80211_hw *hw, int idx,
+				struct survey_info *survey)
+{
+	struct ar9170 *ar = hw->priv;
+	struct ieee80211_conf *conf = &hw->conf;
+
+	if (idx != 0)
+		return -ENOENT;
+
+	survey->channel = conf->channel;
+	survey->filled = SURVEY_INFO_NOISE_DBM;
+	survey->noise = ar->noise[0];
+
+	return 0;
+}
+
 static int ar9170_conf_tx(struct ieee80211_hw *hw, u16 queue,
 			  const struct ieee80211_tx_queue_params *param)
 {
@@ -1957,6 +1973,7 @@ static const struct ieee80211_ops ar9170_ops = {
 	.get_tsf		= ar9170_op_get_tsf,
 	.set_key		= ar9170_set_key,
 	.get_stats		= ar9170_get_stats,
+	.get_survey		= ar9170_get_survey,
 	.ampdu_action		= ar9170_ampdu_action,
 };
 
-- 
1.7.1.1

