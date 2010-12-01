Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55250 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992Ab0LAPfC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Dec 2010 10:35:02 -0500
Received: by bwz15 with SMTP id 15so6231476bwz.19
        for <linux-wireless@vger.kernel.org>; Wed, 01 Dec 2010 07:35:00 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, shafi.wireless@gmail.com,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCHv2] mac80211: Update last_tx_rate only for data frames
Date: Wed,  1 Dec 2010 16:34:45 +0100
Message-Id: <1291217685-26755-1-git-send-email-helmut.schaa@googlemail.com>
In-Reply-To: <1291202302-9698-1-git-send-email-helmut.schaa@googlemail.com>
References: <1291202302-9698-1-git-send-email-helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The last_tx_rate field was also updated for non-data frames that are
often sent with a lower rate (for example management frames at 1 Mbps).
This is confusing when the data rate is actually much higher.

Hence, only update the last_tx_rate field with tx rate information
gathered from last data frames.

If the rate control algorithm filled in txrc.reported_rate we don't need
to verify this information.

Cc: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 net/mac80211/tx.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index e694836..41bfbbf 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -666,10 +666,11 @@ ieee80211_tx_h_rate_ctrl(struct ieee80211_tx_data *tx)
 	if (unlikely(info->control.rates[0].idx < 0))
 		return TX_DROP;
 
-	if (txrc.reported_rate.idx < 0)
+	if (txrc.reported_rate.idx < 0) {
 		txrc.reported_rate = info->control.rates[0];
-
-	if (tx->sta)
+		if (tx->sta && ieee80211_is_data(hdr->frame_control))
+			tx->sta->last_tx_rate = txrc.reported_rate;
+	} else if (tx->sta)
 		tx->sta->last_tx_rate = txrc.reported_rate;
 
 	if (unlikely(!info->control.rates[0].count))
-- 
1.7.1

