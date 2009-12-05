Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:51051 "EHLO ds10.mine.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752028AbZLERIB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Dec 2009 12:08:01 -0500
Message-ID: <4B1A9375.6080105@openwrt.org>
Date: Sat, 05 Dec 2009 18:08:05 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: ath9k: fix tx status reporting
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes a bug in ath9k's tx status check, which
caused mac80211 to consider regularly transmitted unicast frames
as un-acked.
When checking the ts_status field for errors, it needs to be masked
with ATH9K_TXERR_FILT, because this field also contains other fields
like ATH9K_TX_ACKED.
Without this patch, AP mode is pretty much unusable, as hostapd
checks the ACK status for the frames that it injects.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---

--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -2078,7 +2078,7 @@ static void ath_tx_processq(struct ath_s
 				&txq->axq_q, lastbf->list.prev);
 
 		txq->axq_depth--;
-		txok = (ds->ds_txstat.ts_status == 0);
+		txok = !(ds->ds_txstat.ts_status & ATH9K_TXERR_FILT);
 		txq->axq_tx_inprogress = false;
 		spin_unlock_bh(&txq->axq_lock);
 
