Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:36180 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759278Ab3EOOTh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 May 2013 10:19:37 -0400
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCHv2 17/18] ath5k: report 5/10 MHz channels
Date: Wed, 15 May 2013 16:19:08 +0200
Message-Id: <1368627549-22518-18-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130515_161942_670835_CB77941F)
In-Reply-To: <1368627549-22518-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1368627549-22518-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
---
 drivers/net/wireless/ath/ath5k/base.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index a4e0b4e..2a2ec99 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -1424,6 +1424,16 @@ ath5k_receive_frame(struct ath5k_hw *ah, struct sk_buff *skb,
 
 	rxs->rate_idx = ath5k_hw_to_driver_rix(ah, rs->rs_rate);
 	rxs->flag |= ath5k_rx_decrypted(ah, skb, rs);
+	switch (ah->ah_bwmode) {
+	case AR5K_BWMODE_5MHZ:
+		rxs->flag |= RX_FLAG_5MHZ;
+		break;
+	case AR5K_BWMODE_10MHZ:
+		rxs->flag |= RX_FLAG_10MHZ;
+		break;
+	default:
+		break;
+	}
 
 	ath5k_get_bitrates(ah->ah_bwmode, &ah->sbands[ah->curchan->band],
 			   &bitrates, &n_bitrates);
-- 
1.7.10.4

