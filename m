Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:41625 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754271Ab2FOBFG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jun 2012 21:05:06 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com,
	c_manoha@qca.qualcomm.com, thomas@net.t-labs.tu-berlin.de
Subject: [PATCH v2 3.5 1/2] ath9k: fix a tx rate duration calculation bug
Date: Fri, 15 Jun 2012 03:04:52 +0200
Message-Id: <1339722293-28613-1-git-send-email-nbd@openwrt.org> (sfid-20120615_030511_786110_309A605D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The rate pointer variable for a rate series is used in a loop before it is
initialized. This went unnoticed because it was used earlier for the RTS/CTS
rate. This bug can lead to the wrong PHY type being passed to the
duration calculation function.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Cc: stable@kernel.org
---
 drivers/net/wireless/ath/ath9k/xmit.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index d59dd01..efb7f00 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1001,13 +1001,13 @@ static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf,
 		}
 
 		/* legacy rates */
+		rate = &sc->sbands[tx_info->band].bitrates[rates[i].idx];
 		if ((tx_info->band == IEEE80211_BAND_2GHZ) &&
 		    !(rate->flags & IEEE80211_RATE_ERP_G))
 			phy = WLAN_RC_PHY_CCK;
 		else
 			phy = WLAN_RC_PHY_OFDM;
 
-		rate = &sc->sbands[tx_info->band].bitrates[rates[i].idx];
 		info->rates[i].Rate = rate->hw_value;
 		if (rate->hw_value_short) {
 			if (rates[i].flags & IEEE80211_TX_RC_USE_SHORT_PREAMBLE)
-- 
1.7.3.2

