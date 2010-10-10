Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:53910 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153Ab0JJUvx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Oct 2010 16:51:53 -0400
Received: by ewy20 with SMTP id 20so340688ewy.19
        for <linux-wireless@vger.kernel.org>; Sun, 10 Oct 2010 13:51:52 -0700 (PDT)
Date: Sun, 10 Oct 2010 22:51:54 +0200 (CEST)
From: "=?ISO-8859-15?Q?Bj=F6rn_Smedman?=" <bjorn.smedman@venatech.se>
To: linville@tuxdriver.com, johannes@sipsolutions.net,
	lrodriguez@atheros.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 3/3] ath9k: built-in rate control A-MPDU fix
Message-ID: <alpine.DEB.2.00.1010102245220.31264@bigbill>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-1355142838-1286743915=:31264"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1355142838-1286743915=:31264
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT

This patch attempts to ensure that ath9k's built-in rate control algorithm 
does not rely on the value of the ampdu_len and ampdu_ack_len tx status 
fields unless the IEEE80211_TX_STAT_AMPDU flag is set.

This patch has not been tested.

Cc: <stable@kernel.org>
Signed-off-by: Björn Smedman <bjorn.smedman@venatech.se>
---
diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
index ce1cd6d..13f9e88 100644
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -1375,6 +1375,12 @@ static void ath_tx_status(void *priv, struct ieee80211_supported_band *sband,
 	if (tx_info->flags & IEEE80211_TX_STAT_TX_FILTERED)
 		return;
 
+	if (!(tx_info->flags & IEEE80211_TX_STAT_AMPDU)) {
+		tx_info->status.ampdu_ack_len =
+			(tx_info->flags & IEEE80211_TX_STAT_ACK ? 1 : 0);
+		tx_info->status.ampdu_len = 1;
+	}
+
 	/*
 	 * If an underrun error is seen assume it as an excessive retry only
 	 * if max frame trigger level has been reached (2 KB for singel stream,
--8323329-1355142838-1286743915=:31264--
