Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:38334 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510Ab3GHO4U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jul 2013 10:56:20 -0400
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCHv6 16/18] ath5k: report 5/10 MHz channels
Date: Mon,  8 Jul 2013 16:56:04 +0200
Message-Id: <1373295366-12823-17-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130708_172039_870499_4F659D5C)
In-Reply-To: <1373295366-12823-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1373295366-12823-1-git-send-email-siwu@hrz.tu-chemnitz.de>
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

