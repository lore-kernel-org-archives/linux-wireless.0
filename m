Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:49708 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757047Ab2GKR70 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jul 2012 13:59:26 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH 02/12] ath9k: validate rx antenna settings
Date: Wed, 11 Jul 2012 19:59:05 +0200
Message-Id: <1342029555-31618-2-git-send-email-nbd@openwrt.org> (sfid-20120711_195933_337623_E808EDBA)
In-Reply-To: <1342029555-31618-1-git-send-email-nbd@openwrt.org>
References: <1342029555-31618-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Many chips are not able to deal with non-consecutive rx antenna selections
and respond with calibration errors, reset errors, etc.
When an antenna is selected as a tx antenna, also flag it for rx to avoid
chip issues.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/main.c |   19 ++++++++++++++++++-
 1 files changed, 18 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 248e5b2..49f293a 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1912,12 +1912,29 @@ static u32 fill_chainmask(u32 cap, u32 new)
 	return filled;
 }
 
+static bool validate_antenna_mask(struct ath_hw *ah, u32 val)
+{
+	switch (val & ah->caps.rx_chainmask) {
+	case 0x1:
+	case 0x3:
+	case 0x7:
+		return true;
+	case 0x2:
+		return (ah->caps.rx_chainmask == 1);
+	default:
+		return false;
+	}
+}
+
 static int ath9k_set_antenna(struct ieee80211_hw *hw, u32 tx_ant, u32 rx_ant)
 {
 	struct ath_softc *sc = hw->priv;
 	struct ath_hw *ah = sc->sc_ah;
 
-	if (!rx_ant || !tx_ant)
+	if (ah->caps.rx_chainmask != 1)
+		rx_ant |= tx_ant;
+
+	if (!validate_antenna_mask(ah, rx_ant) || !tx_ant)
 		return -EINVAL;
 
 	sc->ant_rx = rx_ant;
-- 
1.7.3.2

