Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:61316 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750979AbZAWFyQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 00:54:16 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 22 Jan 2009 21:54:16 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18809.23227.828738.639237@gargle.gargle.HOWL> (sfid-20090123_065425_215957_AD9B87B6)
Date: Fri, 23 Jan 2009 11:20:51 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 2/3] ath9k: Fix bug in rate control capability registration
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dual stream capability must be registered only when the
hardware supports it.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/rc.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath9k/rc.c b/drivers/net/wireless/ath9k/rc.c
index 46172b5..8e1528d 100644
--- a/drivers/net/wireless/ath9k/rc.c
+++ b/drivers/net/wireless/ath9k/rc.c
@@ -1358,7 +1358,9 @@ static void ath_rc_init(struct ath_softc *sc,
 	}
 
 	if (sta->ht_cap.ht_supported) {
-		ath_rc_priv->ht_cap = (WLAN_RC_HT_FLAG | WLAN_RC_DS_FLAG);
+		ath_rc_priv->ht_cap = WLAN_RC_HT_FLAG;
+		if (sc->sc_tx_chainmask != 1)
+			ath_rc_priv->ht_cap |= WLAN_RC_DS_FLAG;
 		if (sta->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40)
 			ath_rc_priv->ht_cap |= WLAN_RC_40_FLAG;
 		if (sta->ht_cap.cap & IEEE80211_HT_CAP_SGI_40)
-- 
1.6.1

