Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix3.szarvasnet.hu ([87.101.127.16]:52079 "EHLO
	phoenix3.szarvasnet.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752523AbZFSKRq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Jun 2009 06:17:46 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: John Linville <linville@tuxdriver.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Jouni Malinen <jmalinen@atheros.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 1/2] ath9k: remove unnecessary clearing of SC_OP_WAIT_{BEACON,CAB} flags
Date: Fri, 19 Jun 2009 12:17:47 +0200
Message-Id: <1245406668-4715-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All SC_OP_WAIT_* flags will be cleared in 'ath9k_conf' when PS mode
is disabled, so we don't have to clear it here.

Changes-licensed-under: ISC
Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/recv.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index f20e843..a681f88 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -528,14 +528,6 @@ static void ath_rx_ps_beacon(struct ath_softc *sc, struct sk_buff *skb)
 		ath_beacon_config(sc, NULL);
 	}
 
-	if (!(sc->hw->conf.flags & IEEE80211_CONF_PS)) {
-		/* We are not in PS mode anymore; remain awake */
-		DPRINTF(sc, ATH_DBG_PS, "Not in PS mode anymore, remain "
-			"awake\n");
-		sc->sc_flags &= ~(SC_OP_WAIT_FOR_BEACON | SC_OP_WAIT_FOR_CAB);
-		return;
-	}
-
 	if (ath_beacon_dtim_pending_cab(skb)) {
 		/*
 		 * Remain awake waiting for buffered broadcast/multicast
-- 
1.5.3.2

