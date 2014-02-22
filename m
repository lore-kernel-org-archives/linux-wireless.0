Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:36617 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751237AbaBVMsg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Feb 2014 07:48:36 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Subject: [PATCH 3.14] ath9k: fix ps-poll responses under a-mpdu sessions
Date: Sat, 22 Feb 2014 13:48:19 +0100
Message-Id: <1393073299-4831-1-git-send-email-nbd@openwrt.org> (sfid-20140222_134839_848505_90498FC0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When passing tx frames to the U-APSD queue for powersave poll responses,
the ath_atx_tid pointer needs to be passed to ath_tx_setup_buffer for
proper sequence number accounting.

This fixes high latency and connection stability issues with ath9k
running as AP and a few kinds of mobile phones as client, when PS-Poll
is heavily used

Cc: stable@vger.kernel.org
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/xmit.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 4f4ce83..f042a18 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -2186,14 +2186,15 @@ int ath_tx_start(struct ieee80211_hw *hw, struct sk_buff *skb,
 		txq->stopped = true;
 	}
 
+	if (txctl->an)
+		tid = ath_get_skb_tid(sc, txctl->an, skb);
+
 	if (info->flags & IEEE80211_TX_CTL_PS_RESPONSE) {
 		ath_txq_unlock(sc, txq);
 		txq = sc->tx.uapsdq;
 		ath_txq_lock(sc, txq);
 	} else if (txctl->an &&
 		   ieee80211_is_data_present(hdr->frame_control)) {
-		tid = ath_get_skb_tid(sc, txctl->an, skb);
-
 		WARN_ON(tid->ac->txq != txctl->txq);
 
 		if (info->flags & IEEE80211_TX_CTL_CLEAR_PS_FILT)
-- 
1.8.3.4 (Apple Git-47)

