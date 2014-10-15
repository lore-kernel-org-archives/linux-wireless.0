Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:51210 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755536AbaJOB6t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Oct 2014 21:58:49 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH] ath9k: Reduce max roc duration
Date: Wed, 15 Oct 2014 07:29:47 +0530
Message-Id: <1413338387-30475-1-git-send-email-sujith@msujith.org> (sfid-20141015_035902_047554_5EC60013)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

MCC is currently used in CUS227, an Allplay
device. Since audio streaming will be affected
with long offchannel periods, reduce the max.
offchannel duration to 200ms.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 156a944..8857d9c 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -789,7 +789,7 @@ static void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 		hw->wiphy->n_iface_combinations = ARRAY_SIZE(if_comb_multi);
 		hw->wiphy->max_scan_ssids = 255;
 		hw->wiphy->max_scan_ie_len = IEEE80211_MAX_DATA_LEN;
-		hw->wiphy->max_remain_on_channel_duration = 10000;
+		hw->wiphy->max_remain_on_channel_duration = 200;
 		hw->chanctx_data_size = sizeof(void *);
 		hw->extra_beacon_tailroom =
 			sizeof(struct ieee80211_p2p_noa_attr) + 9;
-- 
2.1.2

