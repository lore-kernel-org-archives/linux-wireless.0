Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:40916 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752831Ab3DMWDu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Apr 2013 18:03:50 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH 2/5] mac80211: fix CTS protection handling
Date: Sun, 14 Apr 2013 00:03:43 +0200
Message-Id: <1365890626-86895-2-git-send-email-nbd@openwrt.org> (sfid-20130414_000403_123067_E22608A0)
In-Reply-To: <1365890626-86895-1-git-send-email-nbd@openwrt.org>
References: <1365890626-86895-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The rates[0] CTS and RTS flags are only set after rate control has been
called, so minstrel cannot use them to for setting the number of
retries. This patch adds two new flags to explicitly indicate RTS/CTS use.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 include/net/mac80211.h          | 4 +++-
 net/mac80211/rc80211_minstrel.c | 6 ++++--
 net/mac80211/tx.c               | 9 +++++++++
 3 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 96cb507..3cef0dd 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -655,7 +655,9 @@ struct ieee80211_tx_info {
 					struct ieee80211_tx_rate rates[
 						IEEE80211_TX_MAX_RATES];
 					s8 rts_cts_rate_idx;
-					/* 3 bytes free */
+					u8 use_rts:1;
+					u8 use_cts_prot:1;
+					/* 2 bytes free */
 				};
 				/* only needed before rate control */
 				unsigned long jiffies;
diff --git a/net/mac80211/rc80211_minstrel.c b/net/mac80211/rc80211_minstrel.c
index 1c36c9b..eda290f 100644
--- a/net/mac80211/rc80211_minstrel.c
+++ b/net/mac80211/rc80211_minstrel.c
@@ -209,9 +209,9 @@ minstrel_get_retry_count(struct minstrel_rate *mr,
 {
 	unsigned int retry = mr->adjusted_retry_count;
 
-	if (info->control.rates[0].flags & IEEE80211_TX_RC_USE_RTS_CTS)
+	if (info->control.use_rts)
 		retry = max(2U, min(mr->retry_count_rtscts, retry));
-	else if (info->control.rates[0].flags & IEEE80211_TX_RC_USE_CTS_PROTECT)
+	else if (info->control.use_cts_prot)
 		retry = max(2U, min(mr->retry_count_cts, retry));
 	return retry;
 }
@@ -460,6 +460,8 @@ minstrel_rate_init(void *priv, struct ieee80211_supported_band *sband,
 		} while ((tx_time < mp->segment_size) &&
 				(++mr->retry_count < mp->max_retry));
 		mr->adjusted_retry_count = mr->retry_count;
+		if (!(sband->bitrates[i].flags & IEEE80211_RATE_ERP_G))
+			mr->retry_count_cts = mr->retry_count;
 	}
 
 	for (i = n; i < sband->n_bitrates; i++) {
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index c3f3ff6..ba2aa23 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -656,6 +656,9 @@ ieee80211_tx_h_rate_ctrl(struct ieee80211_tx_data *tx)
 		txrc.rts = rts = true;
 	}
 
+	info->control.use_rts = rts;
+	info->control.use_cts_prot = tx->sdata->vif.bss_conf.use_cts_prot;
+
 	/*
 	 * Use short preamble if the BSS can handle it, but not for
 	 * management frames unless we know the receiver can handle
@@ -761,6 +764,12 @@ ieee80211_tx_h_rate_ctrl(struct ieee80211_tx_data *tx)
 		 */
 		if (info->control.rates[i].flags & IEEE80211_TX_RC_MCS) {
 			WARN_ON(info->control.rates[i].idx > 76);
+
+			if (!(info->control.rates[i].flags &
+			      IEEE80211_TX_RC_USE_RTS_CTS) &&
+			    tx->sdata->vif.bss_conf.use_cts_prot)
+				info->control.rates[i].flags |=
+					IEEE80211_TX_RC_USE_CTS_PROTECT;
 			continue;
 		}
 
-- 
1.8.0.2

