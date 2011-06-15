Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:26124 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754715Ab1FOPwr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jun 2011 11:52:47 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 15 Jun 2011 08:52:12 -0700
From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <lrodriguez@atheros.com>,
	Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
Subject: [PATCH] ath9k: remove a redundant call to pcipowersave
Date: Wed, 15 Jun 2011 21:22:16 +0530
Message-ID: <1308153136-5628-1-git-send-email-mshajakhan@atheros.com> (sfid-20110615_175250_272077_FE231269)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>

during suspend/resume ath9k_stop will always call ath_radio_disable
which will inturn call ath9k_hw_configpcipowersave, so no need to call
it explicitly in ath9k_stop

Signed-off-by: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/main.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 7f94533..e7f8ef2 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1259,7 +1259,6 @@ static void ath9k_stop(struct ieee80211_hw *hw)
 
 	/* disable HAL and put h/w to sleep */
 	ath9k_hw_disable(ah);
-	ath9k_hw_configpcipowersave(ah, 1, 1);
 
 	spin_unlock_bh(&sc->sc_pcu_lock);
 
-- 
1.7.0.4

