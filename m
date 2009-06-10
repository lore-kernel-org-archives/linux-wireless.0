Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:37431 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756689AbZFJITp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2009 04:19:45 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net, j@w1.fi
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 02/18] mac80211: drop frames for sta with no valid rate
Date: Wed, 10 Jun 2009 04:19:19 -0400
Message-Id: <1244621975-1238-3-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1244621975-1238-1-git-send-email-lrodriguez@atheros.com>
References: <1244621975-1238-1-git-send-email-lrodriguez@atheros.com>
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
 include/net/mac80211.h |   11 +++++++++++
 net/mac80211/tx.c      |   23 +++++++++++++++++++++++
 2 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 17d61d1..9559efa 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2103,6 +2103,17 @@ rate_lowest_index(struct ieee80211_supported_band *sband,
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
index e43fbb9..915c8a3 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -511,6 +511,7 @@ ieee80211_tx_h_rate_ctrl(struct ieee80211_tx_data *tx)
 	int i, len;
 	bool inval = false, rts = false, short_preamble = false;
 	struct ieee80211_tx_rate_control txrc;
+	u32 sta_flags;
 
 	memset(&txrc, 0, sizeof(txrc));
 
@@ -543,7 +544,29 @@ ieee80211_tx_h_rate_ctrl(struct ieee80211_tx_data *tx)
 	     (tx->sta && test_sta_flags(tx->sta, WLAN_STA_SHORT_PREAMBLE))))
 		txrc.short_preamble = short_preamble = true;
 
+	sta_flags = tx->sta ? get_sta_flags(tx->sta) : 0;
+
+	/*
+	 * Lets not bother rate control if we're associated and cannot
+	 * talk to the sta. This should not happen.
+	 */
+	if (unlikely((tx->local->sw_scanning) &&
+	    (sta_flags & WLAN_STA_ASSOC) &&
+	    !rate_usable_index_exists(sband, &tx->sta->sta))) {
+#ifdef CONFIG_MAC80211_VERBOSE_DEBUG
+		printk(KERN_DEBUG "%s: dropped data frame -- no "
+		       "supported rate for station %pM on %c GHz band\n",
+		       tx->dev->name, hdr->addr1,
+		       tx->channel->band ? '5' : '2');
+#endif /* CONFIG_MAC80211_VERBOSE_DEBUG */
+		WARN_ON(1);
+		return TX_DROP;
+	}
 
+	/*
+	 * If we're associated point with the sta we know we can at
+	 * least send the frame at the lowest bit rate.
+	 */
 	rate_control_get_rate(tx->sdata, tx->sta, &txrc);
 
 	if (unlikely(info->control.rates[0].idx < 0))
-- 
1.6.0.6

