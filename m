Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:40143 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933303Ab2GCRON (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jul 2012 13:14:13 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	qca-developer-program@qualcomm.com, ath9k-devel@lists.ath9k.org,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 19/20] ath9k: set 4ADDRESS bit in RX filter for AR9550
Date: Tue,  3 Jul 2012 19:13:33 +0200
Message-Id: <1341335614-15419-20-git-send-email-juhosg@openwrt.org> (sfid-20120703_191421_704644_FC674A02)
In-Reply-To: <1341335614-15419-1-git-send-email-juhosg@openwrt.org>
References: <1341335614-15419-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Acked-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/mac.h  |    1 +
 drivers/net/wireless/ath/ath9k/recv.c |    3 +++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/mac.h b/drivers/net/wireless/ath/ath9k/mac.h
index 21c9556..0eba36d 100644
--- a/drivers/net/wireless/ath/ath9k/mac.h
+++ b/drivers/net/wireless/ath/ath9k/mac.h
@@ -646,6 +646,7 @@ enum ath9k_rx_filter {
 	ATH9K_RX_FILTER_PHYRADAR = 0x00002000,
 	ATH9K_RX_FILTER_MCAST_BCAST_ALL = 0x00008000,
 	ATH9K_RX_FILTER_CONTROL_WRAPPER = 0x00080000,
+	ATH9K_RX_FILTER_4ADDRESS = 0x00100000,
 };
 
 #define ATH9K_RATESERIES_RTS_CTS  0x0001
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 6a7dd26..11f3703 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -430,6 +430,9 @@ u32 ath_calcrxfilter(struct ath_softc *sc)
 		rfilt |= ATH9K_RX_FILTER_MCAST_BCAST_ALL;
 	}
 
+	if (AR_SREV_9550(sc->sc_ah))
+		rfilt |= ATH9K_RX_FILTER_4ADDRESS;
+
 	return rfilt;
 
 }
-- 
1.7.2.1

