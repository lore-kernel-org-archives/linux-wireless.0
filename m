Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:39726 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751867AbYHKLDs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Aug 2008 07:03:48 -0400
Message-Id: <20080811110304.026923813@localhost> (sfid-20080811_130350_997675_92255AE0)
References: <20080811110146.877112595@localhost>
Date: Mon, 11 Aug 2008 14:01:51 +0300
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 5/5] ath9k: Fix TX control flag use for no ACK and RTS/CTS
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>


Index: wireless-testing/drivers/net/wireless/ath9k/xmit.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/ath9k/xmit.c
+++ wireless-testing/drivers/net/wireless/ath9k/xmit.c
@@ -357,9 +357,9 @@ static int ath_tx_prepare(struct ath_sof
 	txctl->flags = ATH9K_TXDESC_CLRDMASK;    /* needed for crypto errors */
 
 	if (tx_info->flags & IEEE80211_TX_CTL_NO_ACK)
-		tx_info->flags |= ATH9K_TXDESC_NOACK;
+		txctl->flags |= ATH9K_TXDESC_NOACK;
 	if (tx_info->flags & IEEE80211_TX_CTL_USE_RTS_CTS)
-		tx_info->flags |= ATH9K_TXDESC_RTSENA;
+		txctl->flags |= ATH9K_TXDESC_RTSENA;
 
 	/*
 	 * Setup for rate calculations.

--

-- 
Jouni Malinen                                            PGP id EFC895FA
