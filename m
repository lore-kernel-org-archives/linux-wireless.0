Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static.88-198-24-112.clients.your-server.de ([88.198.24.112]:59381
	"EHLO nbd.name" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756311AbaKSTIQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Nov 2014 14:08:16 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH v2 2/7] mac80211: add tx_status_noskb to rate_control_ops
Date: Wed, 19 Nov 2014 20:08:08 +0100
Message-Id: <1416424093-19439-2-git-send-email-nbd@openwrt.org> (sfid-20141119_200831_671896_C488E81D)
In-Reply-To: <1416424093-19439-1-git-send-email-nbd@openwrt.org>
References: <1416424093-19439-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This op works like .tx_status, except it does not need access to the
skb. This will be used by drivers that cannot match tx status
information to specific packets.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 include/net/mac80211.h | 4 ++++
 net/mac80211/rate.h    | 6 +++++-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 5f203a6..32a779c 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -4727,6 +4727,10 @@ struct rate_control_ops {
 	void (*free_sta)(void *priv, struct ieee80211_sta *sta,
 			 void *priv_sta);
 
+	void (*tx_status_noskb)(void *priv,
+				struct ieee80211_supported_band *sband,
+				struct ieee80211_sta *sta, void *priv_sta,
+				struct ieee80211_tx_info *info);
 	void (*tx_status)(void *priv, struct ieee80211_supported_band *sband,
 			  struct ieee80211_sta *sta, void *priv_sta,
 			  struct sk_buff *skb);
diff --git a/net/mac80211/rate.h b/net/mac80211/rate.h
index 18babe3..dd25964 100644
--- a/net/mac80211/rate.h
+++ b/net/mac80211/rate.h
@@ -37,11 +37,15 @@ static inline void rate_control_tx_status(struct ieee80211_local *local,
 	struct rate_control_ref *ref = local->rate_ctrl;
 	struct ieee80211_sta *ista = &sta->sta;
 	void *priv_sta = sta->rate_ctrl_priv;
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 
 	if (!ref || !test_sta_flag(sta, WLAN_STA_RATE_CONTROL))
 		return;
 
-	ref->ops->tx_status(ref->priv, sband, ista, priv_sta, skb);
+	if (ref->ops->tx_status)
+		ref->ops->tx_status(ref->priv, sband, ista, priv_sta, skb);
+	else
+		ref->ops->tx_status_noskb(ref->priv, sband, ista, priv_sta, info);
 }
 
 
-- 
2.1.2

