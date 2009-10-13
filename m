Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:51736 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933840AbZJMJuz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2009 05:50:55 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Subject: [PATCH 15/22] wl1271: Checking of rx descriptor status fixed
Date: Tue, 13 Oct 2009 12:47:52 +0300
Message-Id: <1255427279-1224-16-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1255427279-1224-1-git-send-email-luciano.coelho@nokia.com>
References: <1255427279-1224-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>

Fixed checking of status of the received packet. On wl1251 status is in the
flags field of the descriptor, on wl1271 there is a separate status field.

Signed-off-by: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Reviewed-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_rx.c |   11 +++--------
 1 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_rx.c b/drivers/net/wireless/wl12xx/wl1271_rx.c
index 1dd8458..1ea3f41 100644
--- a/drivers/net/wireless/wl12xx/wl1271_rx.c
+++ b/drivers/net/wireless/wl12xx/wl1271_rx.c
@@ -142,15 +142,10 @@ static void wl1271_rx_status(struct wl1271 *wl,
 	if (desc->flags & WL1271_RX_DESC_ENCRYPT_MASK) {
 		status->flag |= RX_FLAG_IV_STRIPPED | RX_FLAG_MMIC_STRIPPED;
 
-		if (likely(!(desc->flags & WL1271_RX_DESC_DECRYPT_FAIL)))
+		if (likely(!(desc->status & WL1271_RX_DESC_DECRYPT_FAIL)))
 			status->flag |= RX_FLAG_DECRYPTED;
-		/* FIXME: Flag should be also set when using 5 GHz band.
-		 * At the moment chip reports MIC failed on all packets,
-		 * so flag is silently discarded.
-		 */
-		if (unlikely(desc->flags & WL1271_RX_DESC_MIC_FAIL))
-			if (status->band != IEEE80211_BAND_5GHZ)
-				status->flag |= RX_FLAG_MMIC_ERROR;
+		if (unlikely(desc->status & WL1271_RX_DESC_MIC_FAIL))
+			status->flag |= RX_FLAG_MMIC_ERROR;
 	}
 }
 
-- 
1.5.6.5

