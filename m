Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:38294 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895Ab3HNGBw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Aug 2013 02:01:52 -0400
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
Subject: [PATCH-resend 6/9] ath5k: report 5/10 MHz channels
Date: Wed, 14 Aug 2013 08:01:35 +0200
Message-Id: <1376460098-26648-7-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130814_080157_400762_7FB5B3E2)
In-Reply-To: <1376460098-26648-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1376460098-26648-1-git-send-email-siwu@hrz.tu-chemnitz.de>
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

