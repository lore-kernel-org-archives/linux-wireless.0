Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:46729 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756795AbZAPQL7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2009 11:11:59 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 16 Jan 2009 08:11:59 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18800.45320.582257.574550@gargle.gargle.HOWL> (sfid-20090116_171204_068449_31629462)
Date: Fri, 16 Jan 2009 21:38:40 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 2/9] ath9k: Update short guard interval in rate control
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The rate control algorithm needs to know if a STA allows
short guard interval, fixing this allows RC to use the correct
table.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/rc.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath9k/rc.c b/drivers/net/wireless/ath9k/rc.c
index 182884a..68bda23 100644
--- a/drivers/net/wireless/ath9k/rc.c
+++ b/drivers/net/wireless/ath9k/rc.c
@@ -1361,6 +1361,8 @@ static void ath_rc_init(struct ath_softc *sc,
 		ath_rc_priv->ht_cap = (WLAN_RC_HT_FLAG | WLAN_RC_DS_FLAG);
 		if (sta->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40)
 			ath_rc_priv->ht_cap |= WLAN_RC_40_FLAG;
+		if (sta->ht_cap.cap & IEEE80211_HT_CAP_SGI_40)
+			ath_rc_priv->ht_cap |= WLAN_RC_SGI_FLAG;
 	}
 
 	/* Initial rate table size. Will change depending
-- 
1.6.0.3

