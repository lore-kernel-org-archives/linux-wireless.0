Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:54228 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756532AbcLNTrR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Dec 2016 14:47:17 -0500
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, thomas.huehn@evernet-eg.de
Subject: [PATCH 10/10] mac80211: minstrel: avoid port control frames for sampling
Date: Wed, 14 Dec 2016 20:47:03 +0100
Message-Id: <20161214194703.33429-10-nbd@nbd.name> (sfid-20161214_204753_287020_F714EB0B)
In-Reply-To: <20161214194703.33429-1-nbd@nbd.name>
References: <20161214194703.33429-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Thomas Huehn <thomas.huehn@evernet-eg.de>

Makes connections more reliable

Signed-off-by: Thomas Huehn <thomas.huehn@evernet-eg.de>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 net/mac80211/rc80211_minstrel.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/mac80211/rc80211_minstrel.c b/net/mac80211/rc80211_minstrel.c
index 11a4cc3..3ebe440 100644
--- a/net/mac80211/rc80211_minstrel.c
+++ b/net/mac80211/rc80211_minstrel.c
@@ -367,6 +367,11 @@ minstrel_get_rate(void *priv, struct ieee80211_sta *sta,
 		return;
 #endif
 
+	/* Don't use EAPOL frames for sampling on non-mrr hw */
+	if (mp->hw->max_rates == 1 &&
+	    (info->control.flags & IEEE80211_TX_CTRL_PORT_CTRL_PROTO))
+		return;
+
 	delta = (mi->total_packets * sampling_ratio / 100) -
 			(mi->sample_packets + mi->sample_deferred / 2);
 
-- 
2.10.1
