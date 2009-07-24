Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix3.szarvasnet.hu ([87.101.127.16]:41813 "EHLO
	phoenix3.szarvasnet.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752469AbZGXP1Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jul 2009 11:27:25 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: John Linville <linville@tuxdriver.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Jouni Malinen <jmalinen@atheros.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 2/2] ath9k: get rid of unnecessary setpower calls
Date: Fri, 24 Jul 2009 17:27:22 +0200
Message-Id: <1248449242-27629-2-git-send-email-juhosg@openwrt.org>
In-Reply-To: <1248449242-27629-1-git-send-email-juhosg@openwrt.org>
References: <1248449242-27629-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We are using setpower routines regardless of the current power mode.
Don't bother the hardware, if it is not necessary.

Changes-licensed-under: ISC
Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/hw.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index f80b8ff..20a2807 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -475,6 +475,8 @@ static struct ath_hw *ath9k_hw_newstate(u16 devid, struct ath_softc *sc,
 
 	ah->gbeacon_rate = 0;
 
+	ah->power_mode = ATH9K_PM_UNDEFINED;
+
 	return ah;
 }
 
@@ -2739,6 +2741,9 @@ static bool ath9k_hw_setpower_nolock(struct ath_hw *ah,
 		"UNDEFINED"
 	};
 
+	if (ah->power_mode == mode)
+		return status;
+
 	DPRINTF(ah->ah_sc, ATH_DBG_RESET, "%s -> %s\n",
 		modes[ah->power_mode], modes[mode]);
 
@@ -2783,8 +2788,7 @@ void ath9k_ps_wakeup(struct ath_softc *sc)
 	if (++sc->ps_usecount != 1)
 		goto unlock;
 
-	if (sc->sc_ah->power_mode != ATH9K_PM_AWAKE)
-		ath9k_hw_setpower_nolock(sc->sc_ah, ATH9K_PM_AWAKE);
+	ath9k_hw_setpower_nolock(sc->sc_ah, ATH9K_PM_AWAKE);
 
  unlock:
 	spin_unlock_irqrestore(&sc->sc_pm_lock, flags);
-- 
1.5.3.2

