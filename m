Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:59431 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622Ab3F0Q7S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Jun 2013 12:59:18 -0400
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCHv5 16/18] ath5k: report 5/10 MHz channels
Date: Thu, 27 Jun 2013 18:58:58 +0200
Message-Id: <1372352340-20663-18-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130627_185924_899249_0E129C6C)
In-Reply-To: <1372352340-20663-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1372352340-20663-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
---
 drivers/net/wireless/ath/ath5k/base.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index ce67ab7..260a6fc 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -1400,6 +1400,16 @@ ath5k_receive_frame(struct ath5k_hw *ah, struct sk_buff *skb,
 
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
 
 	if (rxs->rate_idx >= 0 && rs->rs_rate ==
 	    ah->sbands[ah->curchan->band].bitrates[rxs->rate_idx].hw_value_short)
-- 
1.7.10.4

