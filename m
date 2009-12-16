Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:36275 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759047AbZLPQvy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Dec 2009 11:51:54 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: greg@kroah.com, stable@kernel.org
Cc: linux-wireless@vger.kernel.org, Felix Fietkau <nbd@openwrt.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 4/5] ath9k: fix tx status reporting
Date: Wed, 16 Dec 2009 11:51:44 -0500
Message-Id: <1260982305-32244-5-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1260982305-32244-1-git-send-email-lrodriguez@atheros.com>
References: <1260982305-32244-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Felix Fietkau <nbd@openwrt.org>

This patch fixes a bug in ath9k's tx status check, which
caused mac80211 to consider regularly transmitted unicast frames
as un-acked.

When checking the ts_status field for errors, it needs to be masked
with ATH9K_TXERR_FILT, because this field also contains other fields
like ATH9K_TX_ACKED.

Without this patch, AP mode is pretty much unusable, as hostapd
checks the ACK status for the frames that it injects.

This is a backport of upstream commit:

e8c6342d989e241513baeba4b05a04b6b1f3bc8b

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/xmit.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index e78bd57..4753909 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -2020,7 +2020,7 @@ static void ath_tx_processq(struct ath_softc *sc, struct ath_txq *txq)
 		if (bf_isaggr(bf))
 			txq->axq_aggr_depth--;
 
-		txok = (ds->ds_txstat.ts_status == 0);
+		txok = !(ds->ds_txstat.ts_status & ATH9K_TXERR_FILT);
 		txq->axq_tx_inprogress = false;
 		spin_unlock_bh(&txq->axq_lock);
 
-- 
1.6.3.3

