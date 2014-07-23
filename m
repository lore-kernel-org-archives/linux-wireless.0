Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static.88-198-24-112.clients.your-server.de ([88.198.24.112]:54096
	"EHLO nbd.name" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751549AbaGWNlJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jul 2014 09:41:09 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, antonio@open-mesh.com
Subject: [PATCH] ath9k: fix aggregation session lockup
Date: Wed, 23 Jul 2014 15:40:54 +0200
Message-Id: <1406122854-60239-1-git-send-email-nbd@openwrt.org> (sfid-20140723_154113_711218_DF924617)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If an aggregation session fails, frames still end up in the driver queue
with IEEE80211_TX_CTL_AMPDU set.
This causes tx for the affected station/tid to stall, since
ath_tx_get_tid_subframe returning packets to send.

Fix this by clearing IEEE80211_TX_CTL_AMPDU as long as no aggregation
session is running.

Cc: stable@vger.kernel.org
Reported-by: Antonio Quartulli <antonio@open-mesh.com>
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/xmit.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 3611529..704fcbc 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -897,6 +897,15 @@ ath_tx_get_tid_subframe(struct ath_softc *sc, struct ath_txq *txq,
 
 		tx_info = IEEE80211_SKB_CB(skb);
 		tx_info->flags &= ~IEEE80211_TX_CTL_CLEAR_PS_FILT;
+
+		/*
+		 * No aggregation session is running, but there may be frames
+		 * from a previous session or a failed attempt in the queue.
+		 * Send them out as normal data frames
+		 */
+		if (!tid->active)
+			tx_info->flags &= ~IEEE80211_TX_CTL_AMPDU;
+
 		if (!(tx_info->flags & IEEE80211_TX_CTL_AMPDU)) {
 			bf->bf_state.bf_type = 0;
 			return bf;
-- 
1.8.5.2 (Apple Git-48)

