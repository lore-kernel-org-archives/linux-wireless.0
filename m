Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45278 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753450Ab1CUOJ4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Mar 2011 10:09:56 -0400
Received: by bwz15 with SMTP id 15so5040302bwz.19
        for <linux-wireless@vger.kernel.org>; Mon, 21 Mar 2011 07:09:54 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [PATCH] mac80211: Minor optimization in tx status handling
Date: Mon, 21 Mar 2011 15:07:55 +0100
Message-Id: <1300716475-9830-1-git-send-email-helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ieee80211_tx_status iterates over all tx rates the driver reports back
in order to
1) mark tx rates as invalid if the driver cannot have tried that rate
2) find the actually used tx rate for the final retransmission

By leaving the for loop when the first invalid rate index is found we
can move the rates_idx assignment after the loop and therefore save
a few assignments and conditionals.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 net/mac80211/status.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index b936dd2..3ed3c83 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -189,16 +189,19 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 	bool acked;
 
 	for (i = 0; i < IEEE80211_TX_MAX_RATES; i++) {
-		/* the HW cannot have attempted that rate */
-		if (i >= hw->max_report_rates) {
+		if (info->status.rates[i].idx < 0) {
+			break;
+		} else if (i >= hw->max_report_rates) {
+			/* the HW cannot have attempted that rate */
 			info->status.rates[i].idx = -1;
 			info->status.rates[i].count = 0;
-		} else if (info->status.rates[i].idx >= 0) {
-			rates_idx = i;
+			break;
 		}
 
 		retry_count += info->status.rates[i].count;
 	}
+	rates_idx = i - 1;
+
 	if (retry_count < 0)
 		retry_count = 0;
 
-- 
1.7.3.4

