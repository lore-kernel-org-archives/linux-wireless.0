Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f42.google.com ([74.125.83.42]:37290 "EHLO
	mail-gw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769Ab0LJF5o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Dec 2010 00:57:44 -0500
Received: by gwb20 with SMTP id 20so2744863gwb.1
        for <linux-wireless@vger.kernel.org>; Thu, 09 Dec 2010 21:57:44 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19713.49458.228893.842608@gargle.gargle.HOWL>
Date: Fri, 10 Dec 2010 11:27:06 +0530
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, Sujith.Manoharan@atheros.com
Subject: [PATCH] ath9k: Use power save wrappers for TSF get/set
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

The HW has to be awake when accessing registers.

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/main.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 3e0c8a1..890b825 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1944,7 +1944,9 @@ static u64 ath9k_get_tsf(struct ieee80211_hw *hw)
 	struct ath_softc *sc = aphy->sc;
 
 	mutex_lock(&sc->mutex);
+	ath9k_ps_wakeup(sc);
 	tsf = ath9k_hw_gettsf64(sc->sc_ah);
+	ath9k_ps_restore(sc);
 	mutex_unlock(&sc->mutex);
 
 	return tsf;
@@ -1956,7 +1958,9 @@ static void ath9k_set_tsf(struct ieee80211_hw *hw, u64 tsf)
 	struct ath_softc *sc = aphy->sc;
 
 	mutex_lock(&sc->mutex);
+	ath9k_ps_wakeup(sc);
 	ath9k_hw_settsf64(sc->sc_ah, tsf);
+	ath9k_ps_restore(sc);
 	mutex_unlock(&sc->mutex);
 }
 
-- 
1.7.3.3

