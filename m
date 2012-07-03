Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:40599 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933338Ab2GCRPD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jul 2012 13:15:03 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	qca-developer-program@qualcomm.com, ath9k-devel@lists.ath9k.org,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 18/20] ath9k: enable PLL workaround for AR9550
Date: Tue,  3 Jul 2012 19:13:32 +0200
Message-Id: <1341335614-15419-19-git-send-email-juhosg@openwrt.org> (sfid-20120703_192130_944806_87A0B72D)
In-Reply-To: <1341335614-15419-1-git-send-email-juhosg@openwrt.org>
References: <1341335614-15419-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Acked-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/main.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index e4e73f0..dff5ed2 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -169,7 +169,8 @@ static void ath_restart_work(struct ath_softc *sc)
 
 	ieee80211_queue_delayed_work(sc->hw, &sc->tx_complete_work, 0);
 
-	if (AR_SREV_9485(sc->sc_ah) || AR_SREV_9340(sc->sc_ah))
+	if (AR_SREV_9340(sc->sc_ah) || AR_SREV_9485(sc->sc_ah) ||
+	    AR_SREV_9550(sc->sc_ah))
 		ieee80211_queue_delayed_work(sc->hw, &sc->hw_pll_work,
 				     msecs_to_jiffies(ATH_PLL_WORK_INTERVAL));
 
-- 
1.7.2.1

