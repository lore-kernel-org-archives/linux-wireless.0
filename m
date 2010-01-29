Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:60068 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752172Ab0A2L06 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jan 2010 06:26:58 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 29 Jan 2010 03:26:58 -0800
Date: Fri, 29 Jan 2010 16:56:51 +0530
From: Vivek Natarajan <vnatarajan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] ath9k: Handle full sleep in ps_restore.
Message-ID: <20100129112651.GA1862@user-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

IDLE PS (Full Sleep) doesn't work when ifconfig up
is done during Idle unassociated state.
Fix this by restoring FULL SLEEP in ps_restore if CONF_IDLE
is set.

Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    1 +
 drivers/net/wireless/ath/ath9k/main.c  |    8 ++++++--
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index bdbcc70..3f8a7e7 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -480,6 +480,7 @@ struct ath_softc {
 	u8 nbcnvifs;
 	u16 nvifs;
 	bool ps_enabled;
+	bool ps_idle;
 	unsigned long ps_usecount;
 	enum ath9k_int imask;
 
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 99c4dda..4bb25ab 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -143,8 +143,10 @@ void ath9k_ps_restore(struct ath_softc *sc)
 	if (--sc->ps_usecount != 0)
 		goto unlock;
 
-	if (sc->ps_enabled &&
-	    !(sc->ps_flags & (PS_WAIT_FOR_BEACON |
+	if (sc->ps_idle)
+		ath9k_hw_setpower(sc->sc_ah, ATH9K_PM_FULL_SLEEP);
+	else if (sc->ps_enabled &&
+		 !(sc->ps_flags & (PS_WAIT_FOR_BEACON |
 			      PS_WAIT_FOR_CAB |
 			      PS_WAIT_FOR_PSPOLL_DATA |
 			      PS_WAIT_FOR_TX_ACK)))
@@ -1528,6 +1530,7 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 		spin_unlock_bh(&sc->wiphy_lock);
 
 		if (enable_radio) {
+			sc->ps_idle = false;
 			ath_radio_enable(sc, hw);
 			ath_print(common, ATH_DBG_CONFIG,
 				  "not-idle: enabling radio\n");
@@ -1635,6 +1638,7 @@ skip_chan_change:
 
 	if (disable_radio) {
 		ath_print(common, ATH_DBG_CONFIG, "idle: disabling radio\n");
+		sc->ps_idle = true;
 		ath_radio_disable(sc, hw);
 	}
 
-- 
1.6.6.1

