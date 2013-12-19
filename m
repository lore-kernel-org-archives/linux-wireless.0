Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:59654 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753515Ab3LSRCB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Dec 2013 12:02:01 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Subject: [PATCH 4/4] ath9k: simplify/fix tx packet TID handling
Date: Thu, 19 Dec 2013 18:01:51 +0100
Message-Id: <1387472511-86178-4-git-send-email-nbd@openwrt.org> (sfid-20131219_180207_139109_0F0C1A1B)
In-Reply-To: <1387472511-86178-1-git-send-email-nbd@openwrt.org>
References: <1387472511-86178-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mac80211 guarantees that skb->priority is set to the TID, so use it
instead of trying to parse the QoS header manually.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/xmit.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index a907bc9..9d735c5 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -174,14 +174,7 @@ static void ath_txq_skb_done(struct ath_softc *sc, struct ath_txq *txq,
 static struct ath_atx_tid *
 ath_get_skb_tid(struct ath_softc *sc, struct ath_node *an, struct sk_buff *skb)
 {
-	struct ieee80211_hdr *hdr;
-	u8 tidno = 0;
-
-	hdr = (struct ieee80211_hdr *) skb->data;
-	if (ieee80211_is_data_qos(hdr->frame_control))
-		tidno = ieee80211_get_qos_ctl(hdr)[0];
-
-	tidno &= IEEE80211_QOS_CTL_TID_MASK;
+	u8 tidno = skb->priority & IEEE80211_QOS_CTL_TID_MASK;
 	return ATH_AN_2_TID(an, tidno);
 }
 
-- 
1.8.3.4 (Apple Git-47)

