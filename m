Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:31844 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932424Ab2CNJK7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Mar 2012 05:10:59 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20320.24711.242360.534814@gargle.gargle.HOWL> (sfid-20120314_101102_132784_F28DD46B)
Date: Wed, 14 Mar 2012 14:40:31 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH 2/6] ath9k: Remove unused variables
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    2 --
 drivers/net/wireless/ath/ath9k/main.c  |    4 ----
 2 files changed, 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 3d8e51c..fa5eb30 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -624,8 +624,6 @@ struct ath_softc {
 	struct ieee80211_hw *hw;
 	struct device *dev;
 
-	int chan_idx;
-	int chan_is_ht;
 	struct survey_info *cur_survey;
 	struct survey_info survey[ATH9K_NUM_CHANNELS];
 
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index db38a4e..fe1d796 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -995,12 +995,8 @@ static int ath9k_start(struct ieee80211_hw *hw)
 		curchan->center_freq);
 
 	ath9k_ps_wakeup(sc);
-
 	mutex_lock(&sc->mutex);
 
-	/* setup initial channel */
-	sc->chan_idx = curchan->hw_value;
-
 	init_channel = ath9k_cmn_get_curchannel(hw, ah);
 
 	/* Reset SERDES registers */
-- 
1.7.9.4

