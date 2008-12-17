Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:53763 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751358AbYLQLai (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Dec 2008 06:30:38 -0500
Date: Wed, 17 Dec 2008 13:30:31 +0200
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] ath9k: Fix a NULL pointer dereference in ath_rate_get
Message-ID: <20081217113031.GA18060@jm.kir.nu> (sfid-20081217_123042_383830_2EACC437)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It looks like mac80211 may try to send unicast frames to a STA that
does not have a STA entry. We need to make sure that that is caught in
the rate control code before dereferencing STA data.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>
---
 drivers/net/wireless/ath9k/rc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- wireless-testing.orig/drivers/net/wireless/ath9k/rc.c	2008-12-17 12:37:50.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath9k/rc.c	2008-12-17 13:00:38.000000000 +0200
@@ -1498,7 +1498,8 @@ static void ath_get_rate(void *priv, str
 	__le16 fc = hdr->frame_control;
 
 	/* lowest rate for management and multicast/broadcast frames */
-	if (!ieee80211_is_data(fc) || is_multicast_ether_addr(hdr->addr1)) {
+	if (!ieee80211_is_data(fc) || is_multicast_ether_addr(hdr->addr1) ||
+	    !sta) {
 		tx_info->control.rates[0].idx = rate_lowest_index(sband, sta);
 		tx_info->control.rates[0].count =
 			is_multicast_ether_addr(hdr->addr1) ? 1 : ATH_MGT_TXMAXTRY;

-- 
Jouni Malinen                                            PGP id EFC895FA
