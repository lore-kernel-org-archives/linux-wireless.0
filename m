Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:34802 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752745Ab0LALSh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Dec 2010 06:18:37 -0500
Received: by bwz15 with SMTP id 15so5996245bwz.19
        for <linux-wireless@vger.kernel.org>; Wed, 01 Dec 2010 03:18:36 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH] mac80211: Update last_tx_rate only for data frames
Date: Wed,  1 Dec 2010 12:18:22 +0100
Message-Id: <1291202302-9698-1-git-send-email-helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The last_tx_rate field was also updated for non-data frames that are
often sent with a lower rate (for example management frames at 1 Mbps).
This is confusing when the data rate is actually much higher.

Hence, only update the last_tx_rate field with tx rate information
gathered from the last data frames.

Cc: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---

Not sure if there are any reasons why somebody would like to see the "real"
last tx rate including management frames?

 net/mac80211/tx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index e694836..f753081 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -669,7 +669,7 @@ ieee80211_tx_h_rate_ctrl(struct ieee80211_tx_data *tx)
 	if (txrc.reported_rate.idx < 0)
 		txrc.reported_rate = info->control.rates[0];
 
-	if (tx->sta)
+	if (tx->sta && ieee80211_is_data(hdr->frame_control))
 		tx->sta->last_tx_rate = txrc.reported_rate;
 
 	if (unlikely(!info->control.rates[0].count))
-- 
1.7.1

