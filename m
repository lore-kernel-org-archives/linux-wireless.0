Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix3.szarvasnet.hu ([87.101.127.16]:35677 "EHLO
	phoenix3.szarvasnet.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754627AbZFOQMF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Jun 2009 12:12:05 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: John Linwille <linville@tuxdriver.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Jouni Malinen <jmalinen@atheros.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH] ath9k: prevent sleeping while we are waiting for CAB
Date: Mon, 15 Jun 2009 17:49:10 +0200
Message-Id: <1245080951-24804-2-git-send-email-juhosg@openwrt.org>
In-Reply-To: <1245080951-24804-1-git-send-email-juhosg@openwrt.org>
References: <1245080951-24804-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We have to remain awake if the SC_OP_WAIT_FOR_CAB flag is set.

Changes-licensed-under: ISC
Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 9cd523f..b7dae21 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -681,6 +681,7 @@ static inline void ath9k_ps_restore(struct ath_softc *sc)
 	if (atomic_dec_and_test(&sc->ps_usecount))
 		if ((sc->hw->conf.flags & IEEE80211_CONF_PS) &&
 		    !(sc->sc_flags & (SC_OP_WAIT_FOR_BEACON |
+				      SC_OP_WAIT_FOR_CAB |
 				      SC_OP_WAIT_FOR_PSPOLL_DATA |
 				      SC_OP_WAIT_FOR_TX_ACK)))
 			ath9k_hw_setpower(sc->sc_ah,
-- 
1.5.3.2

