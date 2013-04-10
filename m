Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:42153 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759589Ab3DJWMn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Apr 2013 18:12:43 -0400
Message-ID: <5165E1C2.4020407@net.t-labs.tu-berlin.de> (sfid-20130411_001249_363686_6B1C3F08)
Date: Thu, 11 Apr 2013 00:03:46 +0200
From: Tobias Steinicke <tobias.steinicke@net.t-labs.tu-berlin.de>
MIME-Version: 1.0
To: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Subject: [RFC] ath9k: Respect current txpower setting
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In routine ath_tx_fill_desc(), the txpower is only set to
MAX_RATE_POWER. Now it respects the txpower from bss_conf and set it if it
is (txpower * 2) < MAX_RATE_POWER else set to MAX_RATE_POWER.

Signed-off-by: Tobias Steinicke <tsteinicke@net.t-labs.tu-berlin.de>
---
  drivers/net/wireless/ath/ath9k/xmit.c |    7 ++++++-
  1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c 
b/drivers/net/wireless/ath/ath9k/xmit.c
index 5bc5802..90701e4 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1110,13 +1110,18 @@ static void ath_tx_fill_desc(struct ath_softc 
*sc, struct ath_buf *bf,
  	struct ath_buf *bf_first = bf;
  	struct ath_tx_info info;
  	bool aggr = !!(bf->bf_state.bf_type & BUF_AGGR);
+	u8 txpower = tx_info->control.vif->bss_conf.txpower * 2;
   	memset(&info, 0, sizeof(info));
  	info.is_first = true;
  	info.is_last = true;
-	info.txpower = MAX_RATE_POWER;
  	info.qcu = txq->axq_qnum;
  +	if (txpower > MAX_RATE_POWER)
+		info.txpower = MAX_RATE_POWER;
+	else
+		info.txpower = txpower;
+
  	info.flags = ATH9K_TXDESC_INTREQ;
  	if (tx_info->flags & IEEE80211_TX_CTL_NO_ACK)
  		info.flags |= ATH9K_TXDESC_NOACK;
-- 
1.7.9.5

