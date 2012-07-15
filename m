Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:40171 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752482Ab2GORxq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Jul 2012 13:53:46 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH v3 02/12] ath9k: validate rx antenna settings
Date: Sun, 15 Jul 2012 19:53:30 +0200
Message-Id: <1342374820-92409-2-git-send-email-nbd@openwrt.org> (sfid-20120715_195356_636790_0233CE89)
In-Reply-To: <1342374820-92409-1-git-send-email-nbd@openwrt.org>
References: <1342374820-92409-1-git-send-email-nbd@openwrt.org>
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
index 01a5f18..cb9a8c9 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1923,12 +1923,29 @@ static u32 fill_chainmask(u32 cap, u32 new)
 	return filled;
 }
 
+static bool validate_antenna_mask(struct ath_hw *ah, u32 val)
+{
+	switch (val & 0x7) {
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
1.7.7.5 (Apple Git-26)

