Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix3.szarvasnet.hu ([87.101.127.16]:35628 "EHLO
	phoenix3.szarvasnet.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752838AbZGWIeO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jul 2009 04:34:14 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: John Linville <linville@tuxdriver.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Jouni Malinen <jmalinen@atheros.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 1/2] ath9k: wake up the chip for PS config changes
Date: Thu, 23 Jul 2009 10:34:11 +0200
Message-Id: <1248338052-10435-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If we are in NETWORK_SLEEP state, calling of 'ath9k_hw_setrxabort' in
'ath9k_config' will fail with the following error:

ath9k: timeout (100000 us) on reg 0x806c: 0xdeadbeef & 0x01f00000 != 0x00000000
ath9k: RX failed to go idle in 10 ms RXSM=0xdeadbeef

Fix it by waking up the chip, and set 'ps_restore_mode' directly instead
of calling the 'ath9k_hw_setpower' routine..

The problem is reported by Luis:
http://article.gmane.org/gmane.linux.kernel.wireless.general/34363

Changes-licensed-under: ISC
Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/hw.c   |    4 +---
 drivers/net/wireless/ath/ath9k/main.c |    6 ++++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 605803a..53dfc6d 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2783,10 +2783,8 @@ void ath9k_ps_wakeup(struct ath_softc *sc)
 	if (++sc->ps_usecount != 1)
 		goto unlock;
 
-	if (sc->sc_ah->power_mode != ATH9K_PM_AWAKE) {
-		sc->sc_ah->restore_mode = sc->sc_ah->power_mode;
+	if (sc->sc_ah->power_mode != ATH9K_PM_AWAKE)
 		ath9k_hw_setpower_nolock(sc->sc_ah, ATH9K_PM_AWAKE);
-	}
 
  unlock:
 	spin_unlock_irqrestore(&sc->sc_pm_lock, flags);
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 3436295..826e9c8 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -2281,6 +2281,7 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 	}
 
 	if (changed & IEEE80211_CONF_CHANGE_PS) {
+		ath9k_ps_wakeup(sc);
 		if (conf->flags & IEEE80211_CONF_PS) {
 			if (!(ah->caps.hw_caps &
 			      ATH9K_HW_CAP_AUTOSLEEP)) {
@@ -2291,9 +2292,9 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 				}
 				ath9k_hw_setrxabort(sc->sc_ah, 1);
 			}
-			ath9k_hw_setpower(sc->sc_ah, ATH9K_PM_NETWORK_SLEEP);
+			sc->sc_ah->restore_mode = ATH9K_PM_NETWORK_SLEEP;
 		} else {
-			ath9k_hw_setpower(sc->sc_ah, ATH9K_PM_AWAKE);
+			sc->sc_ah->restore_mode = ATH9K_PM_AWAKE;
 			if (!(ah->caps.hw_caps &
 			      ATH9K_HW_CAP_AUTOSLEEP)) {
 				ath9k_hw_setrxabort(sc->sc_ah, 0);
@@ -2308,6 +2309,7 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 				}
 			}
 		}
+		ath9k_ps_restore(sc);
 	}
 
 	if (changed & IEEE80211_CONF_CHANGE_CHANNEL) {
-- 
1.5.3.2

