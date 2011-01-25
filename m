Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:2713 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753021Ab1AYEcE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Jan 2011 23:32:04 -0500
From: Bob Copeland <me@bobcopeland.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, mickflemm@gmail.com,
	Bruno Randolf <br1@einfach.org>, jirislaby@gmail.com,
	lrodriguez@atheros.com, Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 2/2] ath5k: correct endianness of frame duration
Date: Mon, 24 Jan 2011 23:31:44 -0500
Message-Id: <1295929904-11806-2-git-send-email-me@bobcopeland.com>
In-Reply-To: <1295929904-11806-1-git-send-email-me@bobcopeland.com>
References: <1295929904-11806-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The ath5k version of ieee80211_generic_frame_duration() returns
an __le16 for standard modes but a cpu-endian int for turbo/half/
quarter rates.  Make it always return cpu-endian values.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath/ath5k/pcu.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/pcu.c b/drivers/net/wireless/ath/ath5k/pcu.c
index e5f2b96..a702817 100644
--- a/drivers/net/wireless/ath/ath5k/pcu.c
+++ b/drivers/net/wireless/ath/ath5k/pcu.c
@@ -86,7 +86,7 @@ int ath5k_hw_get_frame_duration(struct ath5k_hw *ah,
 	if (!ah->ah_bwmode) {
 		dur = ieee80211_generic_frame_duration(sc->hw,
 						NULL, len, rate);
-		return dur;
+		return le16_to_cpu(dur);
 	}
 
 	bitrate = rate->bitrate;
@@ -265,8 +265,6 @@ static inline void ath5k_hw_write_rate_duration(struct ath5k_hw *ah)
 		 * what rate we should choose to TX ACKs. */
 		tx_time = ath5k_hw_get_frame_duration(ah, 10, rate);
 
-		tx_time = le16_to_cpu(tx_time);
-
 		ath5k_hw_reg_write(ah, tx_time, reg);
 
 		if (!(rate->flags & IEEE80211_RATE_SHORT_PREAMBLE))
-- 
1.7.1.1


