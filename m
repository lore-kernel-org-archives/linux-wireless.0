Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:18247 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752419Ab0BANTO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Feb 2010 08:19:14 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 01 Feb 2010 05:19:14 -0800
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <johannes@sipsolutions.net>, <linux-wireless@vger.kernel.org>,
	Vasanthakumar <vasanth@atheros.com>
Subject: [PATCH] mac80211: Don't call rate control when HW handles it
Date: Mon, 1 Feb 2010 18:49:07 +0530
Message-ID: <1265030347-5917-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vasanthakumar <vasanth@atheros.com>

Rate control should not be called to update the tx status
when HW does the RC.

Signed-off-by: Vasanthakumar <vasanth@atheros.com>
---
 net/mac80211/rate.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/rate.h b/net/mac80211/rate.h
index 669dddd..998cf7a 100644
--- a/net/mac80211/rate.h
+++ b/net/mac80211/rate.h
@@ -44,6 +44,10 @@ static inline void rate_control_tx_status(struct ieee80211_local *local,
 	struct rate_control_ref *ref = local->rate_ctrl;
 	struct ieee80211_sta *ista = &sta->sta;
 	void *priv_sta = sta->rate_ctrl_priv;
+
+	if (!ref)
+		return;
+
 	ref->ops->tx_status(ref->priv, sband, ista, priv_sta, skb);
 }
 
-- 
1.6.3.3

