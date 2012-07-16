Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:52376 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752133Ab2GPRtT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jul 2012 13:49:19 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, ath5k-devel@lists.ath5k.org
Subject: [PATCH] ath5k: fix txop limit handling
Date: Mon, 16 Jul 2012 19:49:07 +0200
Message-Id: <1342460947-29207-1-git-send-email-nbd@openwrt.org> (sfid-20120716_194922_812170_8C4D1B93)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Same as the recent ath9k fix

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath5k/mac80211-ops.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/mac80211-ops.c b/drivers/net/wireless/ath/ath5k/mac80211-ops.c
index 22b80af..260e7dc 100644
--- a/drivers/net/wireless/ath/ath5k/mac80211-ops.c
+++ b/drivers/net/wireless/ath/ath5k/mac80211-ops.c
@@ -594,7 +594,7 @@ ath5k_conf_tx(struct ieee80211_hw *hw, struct ieee80211_vif *vif, u16 queue,
 	qi.tqi_aifs = params->aifs;
 	qi.tqi_cw_min = params->cw_min;
 	qi.tqi_cw_max = params->cw_max;
-	qi.tqi_burst_time = params->txop;
+	qi.tqi_burst_time = params->txop * 32;
 
 	ATH5K_DBG(ah, ATH5K_DEBUG_ANY,
 		  "Configure tx [queue %d],  "
-- 
1.7.7.5 (Apple Git-26)

