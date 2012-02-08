Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:52849 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756229Ab2BHSRV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Feb 2012 13:17:21 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	arend@broadcom.com
Subject: [PATCH] mac80211: do not call rate control .tx_status before .rate_init
Date: Wed,  8 Feb 2012 19:17:11 +0100
Message-Id: <1328725031-35464-1-git-send-email-nbd@openwrt.org> (sfid-20120208_191725_244422_9C974539)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Most rate control implementations assume .get_rate and .tx_status are only
called once the per-station data has been fully initialized.
minstrel_ht crashes if this assumption is violated.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Tested-by: Arend van Spriel <arend@broadcom.com>
---
 net/mac80211/rate.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/rate.h b/net/mac80211/rate.h
index 5fc3135..fbb1efd 100644
--- a/net/mac80211/rate.h
+++ b/net/mac80211/rate.h
@@ -37,7 +37,7 @@ static inline void rate_control_tx_status(struct ieee80211_local *local,
 	struct ieee80211_sta *ista = &sta->sta;
 	void *priv_sta = sta->rate_ctrl_priv;
 
-	if (!ref)
+	if (!ref || !test_sta_flag(sta, WLAN_STA_RATE_CONTROL))
 		return;
 
 	ref->ops->tx_status(ref->priv, sband, ista, priv_sta, skb);
-- 
1.7.3.2

