Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix3.szarvasnet.hu ([87.101.127.16]:35740 "EHLO
	phoenix3.szarvasnet.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756874AbZFOQMF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Jun 2009 12:12:05 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: John Linwille <linville@tuxdriver.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Jouni Malinen <jmalinen@atheros.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH] ath9k: process rx packet if we are waiting for CAB
Date: Mon, 15 Jun 2009 17:49:11 +0200
Message-Id: <1245080951-24804-3-git-send-email-juhosg@openwrt.org>
In-Reply-To: <1245080951-24804-1-git-send-email-juhosg@openwrt.org>
References: <1245080951-24804-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If we are in PS mode, we have to process the received frame if
the SC_OP_WAIT_FOR_CAB bit is set.

Changes-licensed-under: ISC
Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/recv.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 5014a19..f99f3a7 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -817,6 +817,7 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 		}
 
 		if (unlikely(sc->sc_flags & (SC_OP_WAIT_FOR_BEACON |
+					     SC_OP_WAIT_FOR_CAB |
 					     SC_OP_WAIT_FOR_PSPOLL_DATA)))
 			ath_rx_ps(sc, skb);
 
-- 
1.5.3.2

