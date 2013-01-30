Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f49.google.com ([209.85.214.49]:65255 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756131Ab3A3XCU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jan 2013 18:02:20 -0500
Received: by mail-bk0-f49.google.com with SMTP id w11so1088285bku.36
        for <linux-wireless@vger.kernel.org>; Wed, 30 Jan 2013 15:02:19 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Wed, 30 Jan 2013 23:37:41 +0100
Subject: [PATCH] ath9k: report A-MPDU status
To: linux-wireless@vger.kernel.org
Cc: Felix Fietkau <nbd@openwrt.org>, senthilb@qca.qualcomm.com,
	vthiagar@qca.qualcomm.com, Adrian Chadd <adrian@freebsd.org>,
	John Linville <linville@tuxdriver.com>
Message-Id: <20130130230216.42EA11001D6@blech.mobile> (sfid-20130131_000224_212349_FA3C3C82)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The ath9k hardware reports whenever an frame was part
of an A-MPDU. MAC80211 already provides the necessary
API to pass this additional information along to
whomever needs it.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
No locking necessary. The ampdu_ref var is only
read and updated within the rx tasklet. 
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    2 ++
 drivers/net/wireless/ath/ath9k/recv.c  |   20 ++++++++++++++++++++
 2 files changed, 22 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 67df864..21e2e42 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -319,6 +319,8 @@ struct ath_rx {
 	struct ath_rx_edma rx_edma[ATH9K_RX_QUEUE_MAX];
 
 	struct sk_buff *frag;
+
+	u32 ampdu_ref;
 };
 
 int ath_startrecv(struct ath_softc *sc);
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 2af6f19..87497f3 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -1123,6 +1123,24 @@ static int ath_process_fft(struct ath_softc *sc, struct ieee80211_hdr *hdr,
 #endif
 }
 
+static void ath9k_apply_ampdu_details(struct ath_softc *sc,
+	struct ath_rx_status *rs, struct ieee80211_rx_status *rxs)
+{
+	if (rs->rs_isaggr) {
+		rxs->flag |= RX_FLAG_AMPDU_DETAILS | RX_FLAG_AMPDU_LAST_KNOWN;
+
+		rxs->ampdu_reference = sc->rx.ampdu_ref;
+
+		if (!rs->rs_moreaggr) {
+			rxs->flag |= RX_FLAG_AMPDU_IS_LAST;
+			sc->rx.ampdu_ref++;
+		}
+
+		if (rs->rs_flags & ATH9K_RX_DELIM_CRC_PRE)
+			rxs->flag |= RX_FLAG_AMPDU_DELIM_CRC_ERROR;
+	}
+}
+
 int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 {
 	struct ath_buf *bf;
@@ -1329,6 +1347,8 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 		if ((ah->caps.hw_caps & ATH9K_HW_CAP_ANT_DIV_COMB) && sc->ant_rx == 3)
 			ath_ant_comb_scan(sc, &rs);
 
+		ath9k_apply_ampdu_details(sc, &rs, rxs);
+
 		ieee80211_rx(hw, skb);
 
 requeue_drop_frag:
-- 
1.7.10.4

