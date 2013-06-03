Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:51281 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752524Ab3FCRb4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Jun 2013 13:31:56 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Subject: [PATCH] ath9k: limit multicast buffer hardware queue depth
Date: Mon,  3 Jun 2013 19:31:54 +0200
Message-Id: <1370280714-1594-1-git-send-email-nbd@openwrt.org> (sfid-20130603_193158_851192_1A502F4B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The CAB (Content after Beacon) queue is used for beacon-triggered
transmission of buffered multicast frames. If lots of multicast frames
were buffered and this queue fills up, it drowns out all regular
traffic. To limit the damage that buffered traffic can do, try to limit
the queued data to becaon_interval / 8.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ath9k.h  | 1 +
 drivers/net/wireless/ath/ath9k/beacon.c | 6 ++++++
 drivers/net/wireless/ath/ath9k/xmit.c   | 3 +++
 3 files changed, 10 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index bd35a54..fb57d2f 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -413,6 +413,7 @@ struct ath_beacon {
 	struct ath_descdma bdma;
 	struct ath_txq *cabq;
 	struct list_head bbuf;
+	int cabq_dur;
 
 	bool tx_processed;
 	bool tx_last;
diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index fd1eeba..8a0aa22 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -205,9 +205,15 @@ static struct ath_buf *ath9k_beacon_generate(struct ieee80211_hw *hw,
 	}
 
 	ath9k_beacon_setup(sc, vif, bf, info->control.rates[0].idx);
+	sc->beacon.cabq_dur = 0;
 
 	while (skb) {
 		ath9k_tx_cabq(hw, skb);
+
+		if (sc->beacon.cabq_dur / 1000 - 1 >
+		    sc->cur_beacon_conf.beacon_interval / ATH_BCBUF)
+			break;
+
 		skb = ieee80211_get_buffered_bc(hw, vif);
 	}
 
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index d701098..5c20b3d 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1156,6 +1156,9 @@ static void ath_tx_fill_desc(struct ath_softc *sc, struct ath_buf *bf,
 				info.flags |= ATH9K_TXDESC_LDPC;
 
 			ath_buf_set_rate(sc, bf, &info, len);
+
+			if (txq == sc->beacon.cabq)
+				sc->beacon.cabq_dur += info.rates[0].PktDuration;
 		}
 
 		info.buf_addr[0] = bf->bf_buf_addr;
-- 
1.8.0.2

