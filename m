Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:58170 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755982AbZGOAO3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jul 2009 20:14:29 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Derek Smithies <derek@indranet.co.nz>,
	Chittajit Mitra <Chittajit.Mitra@Atheros.com>
Subject: [PATCH 10/21] ath9k: remove ATH9K_MODE_11B
Date: Tue, 14 Jul 2009 20:14:02 -0400
Message-Id: <1247616853-11221-11-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1247616853-11221-1-git-send-email-lrodriguez@atheros.com>
References: <1247616853-11221-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This saves us 2733 bytes.

   text    data     bss     dec     hex filename
 252265    3628    1584  257477   3edc5 ath9k-has-b-rate.ko
 249905    3628    1584  255117   3e48d ath9k.ko

Cc: Derek Smithies <derek@indranet.co.nz>
Cc: Chittajit Mitra <Chittajit.Mitra@Atheros.com>
Siged-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |    1 -
 drivers/net/wireless/ath/ath9k/hw.h |    1 -
 drivers/net/wireless/ath/ath9k/rc.c |   23 -----------------------
 3 files changed, 0 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index cffb078..a115c8c 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -3305,7 +3305,6 @@ void ath9k_hw_fill_cap_info(struct ath_hw *ah)
 	}
 
 	if (eeval & AR5416_OPFLAGS_11G) {
-		set_bit(ATH9K_MODE_11B, pCap->wireless_modes);
 		set_bit(ATH9K_MODE_11G, pCap->wireless_modes);
 		if (ah->config.ht_enable) {
 			if (!(eeval & AR5416_OPFLAGS_N_2G_HT20))
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 9d0b31a..5e40223 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -113,7 +113,6 @@
 
 enum wireless_mode {
 	ATH9K_MODE_11A = 0,
-	ATH9K_MODE_11B = 2,
 	ATH9K_MODE_11G = 3,
 	ATH9K_MODE_11NA_HT20 = 6,
 	ATH9K_MODE_11NG_HT20 = 7,
diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
index b0e3702..112a0ec 100644
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -380,27 +380,6 @@ static const struct ath_rate_table ar5416_11g_ratetable = {
 	0,   /* Phy rates allowed initially */
 };
 
-static const struct ath_rate_table ar5416_11b_ratetable = {
-	4,
-	{
-		{ VALID, VALID, WLAN_RC_PHY_CCK, 1000, /* 1 Mb */
-			900, 0x1b,  0x00, (0x80|2),
-			0, 0, 1, 0, 0 },
-		{ VALID, VALID, WLAN_RC_PHY_CCK, 2000, /* 2 Mb */
-			1800, 0x1a, 0x04, (0x80|4),
-			1, 1, 1, 1, 0 },
-		{ VALID, VALID, WLAN_RC_PHY_CCK, 5500, /* 5.5 Mb */
-			4300, 0x19, 0x04, (0x80|11),
-			1, 2, 2, 2, 0 },
-		{ VALID, VALID, WLAN_RC_PHY_CCK, 11000, /* 11 Mb */
-			7100, 0x18, 0x04, (0x80|22),
-			1, 4, 100, 3, 0 },
-	},
-	100, /* probe interval */
-	100, /* rssi reduce interval */
-	0,   /* Phy rates allowed initially */
-};
-
 static inline int8_t median(int8_t a, int8_t b, int8_t c)
 {
 	if (a >= b) {
@@ -1702,8 +1681,6 @@ static struct rate_control_ops ath_rate_ops = {
 
 void ath_rate_attach(struct ath_softc *sc)
 {
-	sc->hw_rate_table[ATH9K_MODE_11B] =
-		&ar5416_11b_ratetable;
 	sc->hw_rate_table[ATH9K_MODE_11A] =
 		&ar5416_11a_ratetable;
 	sc->hw_rate_table[ATH9K_MODE_11G] =
-- 
1.6.0.6

