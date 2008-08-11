Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:39693 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751498AbYHKLDg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Aug 2008 07:03:36 -0400
Message-Id: <20080811110251.354377372@localhost> (sfid-20080811_130338_204726_DA331CD2)
References: <20080811110146.877112595@localhost>
Date: Mon, 11 Aug 2008 14:01:49 +0300
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 3/5] ath9k: Fix TX status reporting
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>


Index: wireless-testing/drivers/net/wireless/ath9k/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/ath9k/main.c
+++ wireless-testing/drivers/net/wireless/ath9k/main.c
@@ -1085,8 +1085,16 @@ void ath_tx_complete(struct ath_softc *s
 		tx_info->flags |= IEEE80211_TX_STAT_AMPDU_NO_BACK;
 		tx_status->flags &= ~ATH_TX_BAR;
 	}
-	if (tx_status->flags)
-		tx_info->status.excessive_retries = 1;
+
+	if (tx_status->flags & (ATH_TX_ERROR | ATH_TX_XRETRY)) {
+		if (!(tx_info->flags & IEEE80211_TX_CTL_NO_ACK)) {
+			/* Frame was not ACKed, but an ACK was expected */
+			tx_info->status.excessive_retries = 1;
+		}
+	} else {
+		/* Frame was ACKed */
+		tx_info->flags |= IEEE80211_TX_STAT_ACK;
+	}
 
 	tx_info->status.retry_count = tx_status->retries;
 

--

-- 
Jouni Malinen                                            PGP id EFC895FA
