Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:52950 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751059AbZHMEEO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2009 00:04:14 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2009 21:04:16 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19075.37077.961425.728031@gargle.gargle.HOWL>
Date: Thu, 13 Aug 2009 09:34:37 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 4/4] ath9k: Set HW state properly
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes a bug in ath9k_stop() where the HW
was not put into FULL_SLEEP state. Not doing so will
cause issues in suspend-resume and the HW will not respond
to chip resets.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/main.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 4a6f2d2..f452c20 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -2140,6 +2140,7 @@ static void ath9k_stop(struct ieee80211_hw *hw)
 	/* disable HAL and put h/w to sleep */
 	ath9k_hw_disable(sc->sc_ah);
 	ath9k_hw_configpcipowersave(sc->sc_ah, 1);
+	ath9k_hw_setpower(sc->sc_ah, ATH9K_PM_FULL_SLEEP);
 
 	sc->sc_flags |= SC_OP_INVALID;
 
-- 
1.6.4

