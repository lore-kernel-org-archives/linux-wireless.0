Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:47286 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753378Ab0JUArf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Oct 2010 20:47:35 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 2/3] ath9k: fix handling of rate control probe frames
Date: Thu, 21 Oct 2010 02:47:24 +0200
Message-Id: <1287622045-21795-2-git-send-email-nbd@openwrt.org>
In-Reply-To: <1287622045-21795-1-git-send-email-nbd@openwrt.org>
References: <1287622045-21795-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The ath9k aggregation code was already checking the rate control probe flag
to prevent starting an aggregate frame with a sampling rate. What was missing
was closing an aggregate before adding a probing frame to it.
Without that, rate control cannot have precise control over probing, which
delays using faster rates when the channel conditions improve.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/xmit.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index d077186..089b05e 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -673,6 +673,7 @@ static enum ATH_AGGR_STATUS ath_tx_form_aggr(struct ath_softc *sc,
 	u16 aggr_limit = 0, al = 0, bpad = 0,
 		al_delta, h_baw = tid->baw_size / 2;
 	enum ATH_AGGR_STATUS status = ATH_AGGR_DONE;
+	struct ieee80211_tx_info *tx_info;
 
 	bf_first = list_first_entry(&tid->buf_q, struct ath_buf, list);
 
@@ -699,6 +700,11 @@ static enum ATH_AGGR_STATUS ath_tx_form_aggr(struct ath_softc *sc,
 			break;
 		}
 
+		tx_info = IEEE80211_SKB_CB(bf->bf_mpdu);
+		if (nframes && ((tx_info->flags & IEEE80211_TX_CTL_RATE_CTRL_PROBE) ||
+			!(tx_info->control.rates[0].flags & IEEE80211_TX_RC_MCS)))
+			break;
+
 		/* do not exceed subframe limit */
 		if (nframes >= min((int)h_baw, ATH_AMPDU_SUBFRAME_DEFAULT)) {
 			status = ATH_AGGR_LIMITED;
-- 
1.7.2.2

