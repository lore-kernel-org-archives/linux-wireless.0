Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:11846 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151Ab2CIXgZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Mar 2012 18:36:25 -0500
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH] ath9k: configure bss info at assoc notification
Date: Sat, 10 Mar 2012 05:06:49 +0530
Message-ID: <1331336209-4917-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20120310_003629_611610_B4B1F370)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The proper place to configure bss info is at assoc notification. So that
ath9k continues to work if the supirous bssid notification will be
removed in future.

Cc: Johannes Berg <johannes@sipsolutions.net>
Reported-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index cc2535c..33403a9 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1973,7 +1973,7 @@ static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
 	ath9k_ps_wakeup(sc);
 	mutex_lock(&sc->mutex);
 
-	if (changed & BSS_CHANGED_BSSID) {
+	if (changed & BSS_CHANGED_ASSOC) {
 		ath9k_config_bss(sc, vif);
 
 		ath_dbg(common, CONFIG, "BSSID: %pM aid: 0x%x\n",
-- 
1.7.9.3

