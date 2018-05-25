Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gateway33.websitewelcome.com ([192.185.145.9]:36652 "EHLO
        gateway33.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1030216AbeEYVWM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 May 2018 17:22:12 -0400
Received: from cm15.websitewelcome.com (cm15.websitewelcome.com [100.42.49.9])
        by gateway33.websitewelcome.com (Postfix) with ESMTP id 0E54C3550
        for <linux-wireless@vger.kernel.org>; Fri, 25 May 2018 16:22:12 -0500 (CDT)
Date: Fri, 25 May 2018 16:22:07 -0500
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To: QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] ath9k: mark expected switch fall-throughs
Message-ID: <20180525212207.GA10681@embeddedor.com> (sfid-20180525_232442_973597_6A142BE6)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In preparation to enabling -Wimplicit-fallthrough, mark switch cases
where we are expecting to fall through.

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/net/wireless/ath/ath9k/ar5008_phy.c | 2 ++
 drivers/net/wireless/ath/ath9k/ar9002_phy.c | 1 +
 drivers/net/wireless/ath/ath9k/main.c       | 1 +
 3 files changed, 4 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/ar5008_phy.c b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
index 7922550..ef2dd68 100644
--- a/drivers/net/wireless/ath/ath9k/ar5008_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
@@ -583,12 +583,14 @@ static void ar5008_hw_init_chain_masks(struct ath_hw *ah)
 	case 0x5:
 		REG_SET_BIT(ah, AR_PHY_ANALOG_SWAP,
 			    AR_PHY_SWAP_ALT_CHAIN);
+		/* fall through */
 	case 0x3:
 		if (ah->hw_version.macVersion == AR_SREV_REVISION_5416_10) {
 			REG_WRITE(ah, AR_PHY_RX_CHAINMASK, 0x7);
 			REG_WRITE(ah, AR_PHY_CAL_CHAINMASK, 0x7);
 			break;
 		}
+		/* else: fall through */
 	case 0x1:
 	case 0x2:
 	case 0x7:
diff --git a/drivers/net/wireless/ath/ath9k/ar9002_phy.c b/drivers/net/wireless/ath/ath9k/ar9002_phy.c
index 61a9b85..7132918 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_phy.c
@@ -119,6 +119,7 @@ static int ar9002_hw_set_channel(struct ath_hw *ah, struct ath9k_channel *chan)
 				aModeRefSel = 2;
 			if (aModeRefSel)
 				break;
+			/* else: fall through */
 		case 1:
 		default:
 			aModeRefSel = 0;
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index a3be8ad..11d84f4 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1928,6 +1928,7 @@ static int ath9k_ampdu_action(struct ieee80211_hw *hw,
 	case IEEE80211_AMPDU_TX_STOP_FLUSH:
 	case IEEE80211_AMPDU_TX_STOP_FLUSH_CONT:
 		flush = true;
+		/* fall through */
 	case IEEE80211_AMPDU_TX_STOP_CONT:
 		ath9k_ps_wakeup(sc);
 		ath_tx_aggr_stop(sc, sta, tid);
-- 
2.7.4
