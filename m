Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:59876 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752000AbcHBLD0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Aug 2016 07:03:26 -0400
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org
Subject: [PATCH 4.8] ath9k: fix using sta->drv_priv before initializing it
Date: Tue,  2 Aug 2016 13:03:22 +0200
Message-Id: <20160802110322.38359-1-nbd@nbd.name> (sfid-20160802_130329_559529_E5210A8C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A station pointer can be passed to the driver on tx, before it has been
marked as associated. Since ath9k_sta_state was initializing the entry
too late, it resulted in some spurious crashes.

Fixes: df3c6eb34da5 ("ath9k: Use sta_state() callback")
Cc: stable@vger.kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/ath/ath9k/main.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 7594650..a659e81 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1563,13 +1563,13 @@ static int ath9k_sta_state(struct ieee80211_hw *hw,
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	int ret = 0;
 
-	if (old_state == IEEE80211_STA_AUTH &&
-	    new_state == IEEE80211_STA_ASSOC) {
+	if (old_state == IEEE80211_STA_NOTEXIST &&
+	    new_state == IEEE80211_STA_NONE) {
 		ret = ath9k_sta_add(hw, vif, sta);
 		ath_dbg(common, CONFIG,
 			"Add station: %pM\n", sta->addr);
-	} else if (old_state == IEEE80211_STA_ASSOC &&
-		   new_state == IEEE80211_STA_AUTH) {
+	} else if (old_state == IEEE80211_STA_NONE &&
+		   new_state == IEEE80211_STA_NOTEXIST) {
 		ret = ath9k_sta_remove(hw, vif, sta);
 		ath_dbg(common, CONFIG,
 			"Remove station: %pM\n", sta->addr);
-- 
2.8.4

