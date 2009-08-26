Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:45803 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751644AbZHZPrM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Aug 2009 11:47:12 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 26 Aug 2009 08:47:15 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Luis.Rodriguez@atheros.com>,
	<Jouni.Malinen@atheros.com>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH 5/8] ath9k: Determine btcoex scheme type based on chip version
Date: Wed, 26 Aug 2009 21:08:47 +0530
Message-ID: <1251301130-10912-6-git-send-email-vasanth@atheros.com>
In-Reply-To: <1251301130-10912-5-git-send-email-vasanth@atheros.com>
References: <1251301130-10912-1-git-send-email-vasanth@atheros.com>
 <1251301130-10912-2-git-send-email-vasanth@atheros.com>
 <1251301130-10912-3-git-send-email-vasanth@atheros.com>
 <1251301130-10912-4-git-send-email-vasanth@atheros.com>
 <1251301130-10912-5-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/btcoex.h |    7 +++++++
 drivers/net/wireless/ath/ath9k/hw.c     |   12 ++++++++++--
 drivers/net/wireless/ath/ath9k/main.c   |    4 +++-
 3 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/btcoex.h b/drivers/net/wireless/ath/ath9k/btcoex.h
index c80492b..cdfa80d 100644
--- a/drivers/net/wireless/ath/ath9k/btcoex.h
+++ b/drivers/net/wireless/ath/ath9k/btcoex.h
@@ -20,7 +20,14 @@
 #define ATH_WLANACTIVE_GPIO	5
 #define ATH_BTACTIVE_GPIO	6
 
+enum ath_btcoex_scheme {
+	ATH_BTCOEX_CFG_NONE,
+	ATH_BTCOEX_CFG_2WIRE,
+	ATH_BTCOEX_CFG_3WIRE,
+};
+
 struct ath_btcoex_info {
+	enum ath_btcoex_scheme btcoex_scheme;
 	u8 wlanactive_gpio;
 	u8 btactive_gpio;
 };
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 3bb6abd..7b4bc8b 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -3489,6 +3489,7 @@ void ath9k_hw_fill_cap_info(struct ath_hw *ah)
 {
 	struct ath9k_hw_capabilities *pCap = &ah->caps;
 	struct ath_regulatory *regulatory = ath9k_hw_regulatory(ah);
+	struct ath_btcoex_info *btcoex_info = &ah->ah_sc->btcoex_info;
 
 	u16 capField = 0, eeval;
 
@@ -3666,8 +3667,15 @@ void ath9k_hw_fill_cap_info(struct ath_hw *ah)
 
 	if (AR_SREV_9280_10_OR_LATER(ah) && btcoex_enable) {
 		pCap->hw_caps |= ATH9K_HW_CAP_BT_COEX;
-		ah->ah_sc->btcoex_info.btactive_gpio = ATH_BTACTIVE_GPIO;
-		ah->ah_sc->btcoex_info.wlanactive_gpio = ATH_WLANACTIVE_GPIO;
+		btcoex_info->btactive_gpio = ATH_BTACTIVE_GPIO;
+		btcoex_info->wlanactive_gpio = ATH_WLANACTIVE_GPIO;
+
+		if (AR_SREV_9285(ah))
+			btcoex_info->btcoex_scheme = ATH_BTCOEX_CFG_3WIRE;
+		else
+			btcoex_info->btcoex_scheme = ATH_BTCOEX_CFG_2WIRE;
+	} else {
+		btcoex_info->btcoex_scheme = ATH_BTCOEX_CFG_NONE;
 	}
 }
 
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 878d3be..8a2f000 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1509,7 +1509,8 @@ static int ath_init_softc(u16 devid, struct ath_softc *sc)
 			ARRAY_SIZE(ath9k_5ghz_chantable);
 	}
 
-	if (ah->caps.hw_caps & ATH9K_HW_CAP_BT_COEX)
+	if ((ah->caps.hw_caps & ATH9K_HW_CAP_BT_COEX) &&
+	    (sc->btcoex_info.btcoex_scheme == ATH_BTCOEX_CFG_2WIRE))
 		ath9k_hw_btcoex_init(ah);
 
 	return 0;
@@ -1993,6 +1994,7 @@ static int ath9k_start(struct ieee80211_hw *hw)
 	ieee80211_queue_delayed_work(sc->hw, &sc->tx_complete_work, 0);
 
 	if ((sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_BT_COEX) &&
+	    (sc->btcoex_info.btcoex_scheme == ATH_BTCOEX_CFG_2WIRE) &&
 	    !(sc->sc_flags & SC_OP_BTCOEX_ENABLED))
 		ath9k_hw_btcoex_enable(sc->sc_ah);
 
-- 
1.5.5.1

