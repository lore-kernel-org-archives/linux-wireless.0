Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:17610 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750947Ab1FNPna (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jun 2011 11:43:30 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 14 Jun 2011 08:42:55 -0700
From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
To: <linux-wireless@vger.kernel.org>
CC: <lrodriguez@atheros.com>,
	Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
Subject: [RFC] ath9k: remove a redundant call to pcipowersave
Date: Tue, 14 Jun 2011 21:12:59 +0530
Message-ID: <1308066179-8195-1-git-send-email-mshajakhan@atheros.com> (sfid-20110614_174333_508734_205B030E)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>

during suspend/resume ath9k_stop will always call ath_radio_disable
which will inturn call ath9k_hw_configpcipowersave, so need to call
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

