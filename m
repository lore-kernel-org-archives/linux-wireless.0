Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41996 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755464AbcLSKzC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Dec 2016 05:55:02 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 02/11] rt2800: don't set ht parameters for non-aggregated frames
Date: Mon, 19 Dec 2016 11:52:48 +0100
Message-Id: <1482144777-16760-3-git-send-email-sgruszka@redhat.com> (sfid-20161219_120429_563067_9E9F548B)
In-Reply-To: <1482144777-16760-1-git-send-email-sgruszka@redhat.com>
References: <1482144777-16760-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Do not set ampdu_density and ba_size for frames without AMPDU bit i.e.
frames that will not be aggregated to AMPDU.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2x00queue.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00queue.c b/drivers/net/wireless/ralink/rt2x00/rt2x00queue.c
index 68b620b..b2364d3 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00queue.c
@@ -306,13 +306,12 @@ static void rt2x00queue_create_tx_descriptor_ht(struct rt2x00_dev *rt2x00dev,
 	struct ieee80211_tx_rate *txrate = &tx_info->control.rates[0];
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	struct rt2x00_sta *sta_priv = NULL;
+	u8 density = 0;
 
 	if (sta) {
-		txdesc->u.ht.mpdu_density =
-		    sta->ht_cap.ampdu_density;
-
 		sta_priv = sta_to_rt2x00_sta(sta);
 		txdesc->u.ht.wcid = sta_priv->wcid;
+		density = sta->ht_cap.ampdu_density;
 	}
 
 	/*
@@ -345,8 +344,6 @@ static void rt2x00queue_create_tx_descriptor_ht(struct rt2x00_dev *rt2x00dev,
 		return;
 	}
 
-	txdesc->u.ht.ba_size = 7;	/* FIXME: What value is needed? */
-
 	/*
 	 * Only one STBC stream is supported for now.
 	 */
@@ -358,8 +355,11 @@ static void rt2x00queue_create_tx_descriptor_ht(struct rt2x00_dev *rt2x00dev,
 	 * frames that are intended to probe a specific tx rate.
 	 */
 	if (tx_info->flags & IEEE80211_TX_CTL_AMPDU &&
-	    !(tx_info->flags & IEEE80211_TX_CTL_RATE_CTRL_PROBE))
+	    !(tx_info->flags & IEEE80211_TX_CTL_RATE_CTRL_PROBE)) {
 		__set_bit(ENTRY_TXD_HT_AMPDU, &txdesc->flags);
+		txdesc->u.ht.mpdu_density = density;
+		txdesc->u.ht.ba_size = 7; /* FIXME: What value is needed? */
+	}
 
 	/*
 	 * Set 40Mhz mode if necessary (for legacy rates this will
-- 
1.7.1
