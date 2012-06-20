Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:1351 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752320Ab2FTGJl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2012 02:09:41 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH] ath9k_htc: configure bssid on ASSOC/IBSS change
Date: Wed, 20 Jun 2012 11:40:57 +0530
Message-ID: <1340172657-8699-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20120620_081004_869168_6C80DA43)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After the change "mac80211: remove spurious BSSID change flag",
BSS_CHANGED_BSSID will not be passed on association or IBSS
status changes. So it could be better to program bssid on ASSOC
or IBSS change notification. Not doing so, is affecting the
packet transmission.

Reported-by: Michael Leun <lkml20120218@newton.leun.net>
Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_main.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 2b8f61c..abbd6ef 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1496,6 +1496,7 @@ static void ath9k_htc_bss_info_changed(struct ieee80211_hw *hw,
 			priv->num_sta_assoc_vif++ : priv->num_sta_assoc_vif--;
 
 		if (priv->ah->opmode == NL80211_IFTYPE_STATION) {
+			ath9k_htc_choose_set_bssid(priv);
 			if (bss_conf->assoc && (priv->num_sta_assoc_vif == 1))
 				ath9k_htc_start_ani(priv);
 			else if (priv->num_sta_assoc_vif == 0)
@@ -1503,13 +1504,11 @@ static void ath9k_htc_bss_info_changed(struct ieee80211_hw *hw,
 		}
 	}
 
-	if (changed & BSS_CHANGED_BSSID) {
+	if (changed & BSS_CHANGED_IBSS) {
 		if (priv->ah->opmode == NL80211_IFTYPE_ADHOC) {
 			common->curaid = bss_conf->aid;
 			memcpy(common->curbssid, bss_conf->bssid, ETH_ALEN);
 			ath9k_htc_set_bssid(priv);
-		} else if (priv->ah->opmode == NL80211_IFTYPE_STATION) {
-			ath9k_htc_choose_set_bssid(priv);
 		}
 	}
 
-- 
1.7.11

