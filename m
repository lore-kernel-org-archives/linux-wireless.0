Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:38529 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932167AbaLJPyV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Dec 2014 10:54:21 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 4/4] ath9k: Fix no-ack frame status
Date: Wed, 10 Dec 2014 21:26:13 +0530
Message-Id: <1418226973-13779-4-git-send-email-sujith@msujith.org> (sfid-20141210_165439_319387_FC6C8A38)
In-Reply-To: <1418226973-13779-1-git-send-email-sujith@msujith.org>
References: <1418226973-13779-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Check if the frame has been completed without any
error and use IEEE80211_TX_STAT_NOACK_TRANSMITTED to
indicate successful transmission of no-ack frames.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/xmit.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 4caee66..c7ff9a8 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -2445,9 +2445,12 @@ static void ath_tx_complete(struct ath_softc *sc, struct sk_buff *skb,
 	if (sc->sc_ah->caldata)
 		set_bit(PAPRD_PACKET_SENT, &sc->sc_ah->caldata->cal_flags);
 
-	if (!(tx_flags & ATH_TX_ERROR))
-		/* Frame was ACKed */
-		tx_info->flags |= IEEE80211_TX_STAT_ACK;
+	if (!(tx_flags & ATH_TX_ERROR)) {
+		if (tx_info->flags & IEEE80211_TX_CTL_NO_ACK)
+			tx_info->flags |= IEEE80211_TX_STAT_NOACK_TRANSMITTED;
+		else
+			tx_info->flags |= IEEE80211_TX_STAT_ACK;
+	}
 
 	padpos = ieee80211_hdrlen(hdr->frame_control);
 	padsize = padpos & 3;
-- 
2.1.3

