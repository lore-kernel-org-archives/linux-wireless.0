Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:16981 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755687Ab1ESMLN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 May 2011 08:11:13 -0400
Received: from mail.atheros.com ([10.234.20.107])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 19 May 2011 05:10:43 -0700
From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <lrodriguez@atheros.com>,
	Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
Subject: [PATCH] ath9k: make ath9k_setpower function as static
Date: Thu, 19 May 2011 17:40:46 +0530
Message-ID: <1305807046-9763-1-git-send-email-mshajakhan@atheros.com> (sfid-20110519_141136_432315_CD955230)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>

Signed-off-by: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    1 -
 drivers/net/wireless/ath/ath9k/main.c  |    2 +-
 2 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index f75068b..3500e9c 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -674,7 +674,6 @@ int ath_set_channel(struct ath_softc *sc, struct ieee80211_hw *hw,
 
 void ath_radio_enable(struct ath_softc *sc, struct ieee80211_hw *hw);
 void ath_radio_disable(struct ath_softc *sc, struct ieee80211_hw *hw);
-bool ath9k_setpower(struct ath_softc *sc, enum ath9k_power_mode mode);
 bool ath9k_uses_beacons(int type);
 
 #ifdef CONFIG_ATH9K_PCI
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index a198ee3..4cdc886 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -69,7 +69,7 @@ static bool ath9k_has_pending_frames(struct ath_softc *sc, struct ath_txq *txq)
 	return pending;
 }
 
-bool ath9k_setpower(struct ath_softc *sc, enum ath9k_power_mode mode)
+static bool ath9k_setpower(struct ath_softc *sc, enum ath9k_power_mode mode)
 {
 	unsigned long flags;
 	bool ret;
-- 
1.7.0.4

