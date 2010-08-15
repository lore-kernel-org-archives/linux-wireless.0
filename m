Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:2196 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932351Ab0HORNU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Aug 2010 13:13:20 -0400
From: Bob Copeland <me@bobcopeland.com>
To: linville@tuxdriver.com, jirislaby@gmail.com, mickflemm@gmail.com,
	lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 6/6] ath5k: don't enable probe request rx for STAs
Date: Sun, 15 Aug 2010 13:03:15 -0400
Message-Id: <1281891795-14718-7-git-send-email-me@bobcopeland.com>
In-Reply-To: <1281891795-14718-1-git-send-email-me@bobcopeland.com>
References: <1281891795-14718-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

AR5K_RX_FILTER_PROBEREQ enables reception of probe requests,
but the filter flag FIF_BCN_PRBRESP_PROMISC is actually about
receiving beacons and probe _responses_, so we shouldn't
turn on the filter when scanning.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath/ath5k/base.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index e60b148..6d46ae7 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -3227,9 +3227,9 @@ static void ath5k_configure_filter(struct ieee80211_hw *hw,
 		rfilt |= AR5K_RX_FILTER_PHYERR;
 
 	/* FIF_BCN_PRBRESP_PROMISC really means to enable beacons
-	* and probes for any BSSID, this needs testing */
+	* and probes for any BSSID */
 	if (*new_flags & FIF_BCN_PRBRESP_PROMISC)
-		rfilt |= AR5K_RX_FILTER_BEACON | AR5K_RX_FILTER_PROBEREQ;
+		rfilt |= AR5K_RX_FILTER_BEACON;
 
 	/* FIF_CONTROL doc says that if FIF_PROMISC_IN_BSS is not
 	 * set we should only pass on control frames for this
-- 
1.7.1.1


