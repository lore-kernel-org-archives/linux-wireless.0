Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:23328 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932198AbZGOSSr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jul 2009 14:18:47 -0400
Received: from mail.atheros.com ([10.10.20.104])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 15 Jul 2009 11:18:47 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <johannes@sipsolutions.net>, <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v3] mac80211: drop frames for sta with no valid rate
Date: Wed, 15 Jul 2009 11:18:39 -0700
Message-ID: <1247681919-13208-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When we're associated we should be able to send data to
target sta. If we cannot we may be trying to use the incorrect
band to talk to the sta. Lets catch any such cases, warn, and
drop the frames to not invalidate assumptions being made on
rate control algorithms when they have a valid sta to
communicate with. Any such cases should be handled and fixed.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---

John, sorry but this one is simpler, removes the #ifdef crap.

 include/net/mac80211.h |   11 +++++++++++
 net/mac80211/tx.c      |   20 ++++++++++++++++++++
 2 files changed, 31 insertions(+), 0 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 14ef478..9428258 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2113,6 +2113,17 @@ rate_lowest_index(struct ieee80211_supported_band *sband,
 	return 0;
 }
 
+static inline
+bool rate_usable_index_exists(struct ieee80211_supported_band *sband,
+			      struct ieee80211_sta *sta)
+{
+	unsigned int i;
+
+	for (i = 0; i < sband->n_bitrates; i++)
+		if (rate_supported(sta, sband->band, i))
+			return true;
+	return false;
+}
 
 int ieee80211_rate_control_register(struct rate_control_ops *ops);
 void ieee80211_rate_control_unregister(struct rate_control_ops *ops);
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 969a4b2..eae43e9 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -512,6 +512,7 @@ ieee80211_tx_h_rate_ctrl(struct ieee80211_tx_data *tx)
 	int i, len;
 	bool inval = false, rts = false, short_preamble = false;
 	struct ieee80211_tx_rate_control txrc;
+	u32 sta_flags;
 
 	memset(&txrc, 0, sizeof(txrc));
 
@@ -544,7 +545,26 @@ ieee80211_tx_h_rate_ctrl(struct ieee80211_tx_data *tx)
 	     (tx->sta && test_sta_flags(tx->sta, WLAN_STA_SHORT_PREAMBLE))))
 		txrc.short_preamble = short_preamble = true;
 
+	sta_flags = tx->sta ? get_sta_flags(tx->sta) : 0;
+
+	/*
+	 * Lets not bother rate control if we're associated and cannot
+	 * talk to the sta. This should not happen.
+	 */
+	if (WARN((tx->local->sw_scanning) &&
+		 (sta_flags & WLAN_STA_ASSOC) &&
+		 !rate_usable_index_exists(sband, &tx->sta->sta),
+		 "%s: Dropped data from as no usable bitrate found while "
+		 "scanning and associated. Target station: "
+		 "%pM on %d GHz band\n",
+		 tx->dev->name, hdr->addr1,
+		 tx->channel->band ? 5 : 2))
+		return TX_DROP;
 
+	/*
+	 * If we're associated with the sta at this point we know we can at
+	 * least send the frame at the lowest bit rate.
+	 */
 	rate_control_get_rate(tx->sdata, tx->sta, &txrc);
 
 	if (unlikely(info->control.rates[0].idx < 0))
-- 
1.6.3.3

