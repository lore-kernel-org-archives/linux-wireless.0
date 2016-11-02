Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44776 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754872AbcKBOM3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 Nov 2016 10:12:29 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 05/10] rt2800: make ba_size depend on ampdu_factor
Date: Wed,  2 Nov 2016 15:11:00 +0100
Message-Id: <1478095865-8651-6-git-send-email-sgruszka@redhat.com> (sfid-20161102_151232_083927_80307FE6)
In-Reply-To: <1478095865-8651-1-git-send-email-sgruszka@redhat.com>
References: <1478095865-8651-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We can calculate BA window size (max number of pending frames not
yet block acked) of remote station using Maximum A-MPDU length factor
for that station.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2x00queue.c |   15 ++++++++++-----
 1 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00queue.c b/drivers/net/wireless/ralink/rt2x00/rt2x00queue.c
index 68b620b..9da89e3 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00queue.c
@@ -305,14 +305,19 @@ static void rt2x00queue_create_tx_descriptor_ht(struct rt2x00_dev *rt2x00dev,
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_tx_rate *txrate = &tx_info->control.rates[0];
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
-	struct rt2x00_sta *sta_priv = NULL;
+	u8 ba_size = 0;
 
 	if (sta) {
-		txdesc->u.ht.mpdu_density =
-		    sta->ht_cap.ampdu_density;
+		struct rt2x00_sta *sta_priv = sta_to_rt2x00_sta(sta);
 
-		sta_priv = sta_to_rt2x00_sta(sta);
+		txdesc->u.ht.mpdu_density = sta->ht_cap.ampdu_density;
 		txdesc->u.ht.wcid = sta_priv->wcid;
+
+		if (!(tx_info->flags & IEEE80211_TX_CTL_RATE_CTRL_PROBE)) {
+			ba_size = IEEE80211_MIN_AMPDU_BUF;
+			ba_size <<= sta->ht_cap.ampdu_factor;
+			ba_size = min_t(int, 63, ba_size - 1);
+		}
 	}
 
 	/*
@@ -345,7 +350,7 @@ static void rt2x00queue_create_tx_descriptor_ht(struct rt2x00_dev *rt2x00dev,
 		return;
 	}
 
-	txdesc->u.ht.ba_size = 7;	/* FIXME: What value is needed? */
+	txdesc->u.ht.ba_size = ba_size;
 
 	/*
 	 * Only one STBC stream is supported for now.
-- 
1.7.1
