Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:30106 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753503AbZA0F3T (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jan 2009 00:29:19 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 26 Jan 2009 21:29:19 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18814.39627.812389.908725@gargle.gargle.HOWL> (sfid-20090127_062939_176910_CD3956E3)
Date: Tue, 27 Jan 2009 10:55:31 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH] ath9k: Handle chainmask for A9280
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The default chainmask for AR9280 is 3, so handle that when setting
the supported MCS rates. Also, check for the HW supported chainmask
when choosing single/dual stream.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/main.c |    1 +
 drivers/net/wireless/ath9k/rc.c   |    2 +-
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index 15a7f90..d92da13 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -876,6 +876,7 @@ static void setup_ht_cap(struct ath_softc *sc,
 	case 1:
 		ht_info->mcs.rx_mask[0] = 0xff;
 		break;
+	case 3:
 	case 5:
 	case 7:
 	default:
diff --git a/drivers/net/wireless/ath9k/rc.c b/drivers/net/wireless/ath9k/rc.c
index 8e1528d..eb557ad 100644
--- a/drivers/net/wireless/ath9k/rc.c
+++ b/drivers/net/wireless/ath9k/rc.c
@@ -1359,7 +1359,7 @@ static void ath_rc_init(struct ath_softc *sc,
 
 	if (sta->ht_cap.ht_supported) {
 		ath_rc_priv->ht_cap = WLAN_RC_HT_FLAG;
-		if (sc->sc_tx_chainmask != 1)
+		if (sc->sc_ah->ah_caps.tx_chainmask != 1)
 			ath_rc_priv->ht_cap |= WLAN_RC_DS_FLAG;
 		if (sta->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40)
 			ath_rc_priv->ht_cap |= WLAN_RC_40_FLAG;
-- 
1.6.1

