Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:56176 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752792AbZKGUTH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Nov 2009 15:19:07 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, devel@linuxdriverproject.org,
	mcgrof@gmail.com, "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 10/29] ath9k_hw: move ath_extend_tsf() to hw code to share as ath9k_hw_extend_tsf()
Date: Sat,  7 Nov 2009 15:18:47 -0500
Message-Id: <1257625146-17971-11-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1257625146-17971-1-git-send-email-lrodriguez@atheros.com>
References: <1257625146-17971-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This will be shared between ath9k and ath9k_htc.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c   |   15 +++++++++++++++
 drivers/net/wireless/ath/ath9k/hw.h   |    1 +
 drivers/net/wireless/ath/ath9k/recv.c |   16 +---------------
 3 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 111ff04..b25eedf 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -3710,6 +3710,21 @@ void ath9k_hw_set_tsfadjust(struct ath_hw *ah, u32 setting)
 }
 EXPORT_SYMBOL(ath9k_hw_set_tsfadjust);
 
+/*
+ *  Extend 15-bit time stamp from rx descriptor to
+ *  a full 64-bit TSF using the current h/w TSF.
+*/
+u64 ath9k_hw_extend_tsf(struct ath_hw *ah, u32 rstamp)
+{
+	u64 tsf;
+
+	tsf = ath9k_hw_gettsf64(ah);
+	if ((tsf & 0x7fff) < rstamp)
+		tsf -= 0x8000;
+	return (tsf & ~0x7fff) | rstamp;
+}
+EXPORT_SYMBOL(ath9k_hw_extend_tsf);
+
 bool ath9k_hw_setslottime(struct ath_hw *ah, u32 us)
 {
 	if (us < ATH9K_SLOT_TIME_9 || us > ath9k_hw_mac_to_usec(ah, 0xffff)) {
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index c7b0c4d..6d3e314 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -689,6 +689,7 @@ u64 ath9k_hw_gettsf64(struct ath_hw *ah);
 void ath9k_hw_settsf64(struct ath_hw *ah, u64 tsf64);
 void ath9k_hw_reset_tsf(struct ath_hw *ah);
 void ath9k_hw_set_tsfadjust(struct ath_hw *ah, u32 setting);
+u64 ath9k_hw_extend_tsf(struct ath_hw *ah, u32 rstamp);
 bool ath9k_hw_setslottime(struct ath_hw *ah, u32 us);
 void ath9k_hw_set11nmac2040(struct ath_hw *ah);
 void ath9k_hw_beaconinit(struct ath_hw *ah, u32 next_beacon, u32 beacon_period);
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index fd45f77..b27ea89 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -87,20 +87,6 @@ static void ath_setdefantenna(struct ath_softc *sc, u32 antenna)
 }
 
 /*
- *  Extend 15-bit time stamp from rx descriptor to
- *  a full 64-bit TSF using the current h/w TSF.
-*/
-static u64 ath_extend_tsf(struct ath_softc *sc, u32 rstamp)
-{
-	u64 tsf;
-
-	tsf = ath9k_hw_gettsf64(sc->sc_ah);
-	if ((tsf & 0x7fff) < rstamp)
-		tsf -= 0x8000;
-	return (tsf & ~0x7fff) | rstamp;
-}
-
-/*
  * For Decrypt or Demic errors, we only mark packet status here and always push
  * up the frame up to let mac80211 handle the actual error case, be it no
  * decryption key or real decryption error. This let us keep statistics there.
@@ -223,7 +209,7 @@ static int ath_rx_prepare(struct ieee80211_hw *hw,
 	if (ieee80211_is_beacon(fc))
 		sc->sc_ah->stats.avgbrssi = rx_stats->rs_rssi;
 
-	rx_status->mactime = ath_extend_tsf(sc, rx_stats->rs_tstamp);
+	rx_status->mactime = ath9k_hw_extend_tsf(sc->sc_ah, rx_stats->rs_tstamp);
 	rx_status->band = hw->conf.channel->band;
 	rx_status->freq = hw->conf.channel->center_freq;
 	rx_status->noise = sc->ani.noise_floor;
-- 
1.6.5.2.143.g8cc62

