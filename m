Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:53251 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751390Ab1JHUDJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Oct 2011 16:03:09 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH 2/2] ath9k: only send FCS-fail packets to mac80211 if requested
Date: Sat,  8 Oct 2011 22:02:59 +0200
Message-Id: <1318104179-90126-2-git-send-email-nbd@openwrt.org> (sfid-20111008_220312_305349_E4B3D972)
In-Reply-To: <1318104179-90126-1-git-send-email-nbd@openwrt.org>
References: <1318104179-90126-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Prevents lots of broken frames from showing up on monitor interfaces
by default.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/recv.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index c7306dc..bc71c0e 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -811,6 +811,7 @@ static bool ath9k_rx_accept(struct ath_common *common,
 			    struct ath_rx_status *rx_stats,
 			    bool *decrypt_error)
 {
+	struct ath_softc *sc = (struct ath_softc *) common->priv;
 	bool is_mc, is_valid_tkip, strip_mic, mic_error;
 	struct ath_hw *ah = common->ah;
 	__le16 fc;
@@ -875,7 +876,7 @@ static bool ath9k_rx_accept(struct ath_common *common,
 		status_mask = ATH9K_RXERR_DECRYPT | ATH9K_RXERR_MIC |
 			      ATH9K_RXERR_KEYMISS;
 
-		if (ah->is_monitoring)
+		if (ah->is_monitoring && (sc->rx.rxfilter & FIF_FCSFAIL))
 			status_mask |= ATH9K_RXERR_CRC;
 
 		if (rx_stats->rs_status & ~status_mask)
-- 
1.7.3.2

