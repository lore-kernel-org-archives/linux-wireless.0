Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:47274 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752266AbYLONpI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Dec 2008 08:45:08 -0500
Date: Mon, 15 Dec 2008 15:44:53 +0200
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] ath9k: Fix TX status reporting for retries and MCS index
Message-ID: <20081215134453.GA15720@jm.kir.nu> (sfid-20081215_144513_433125_CD31D2A5)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The count field in struct ieee80211_tx_rate does not include the final
successful attempt, so only report retries here.

Fix the struct ieee80211_tx_rate::idx field when MCS was used. It is
supposed to be the MCS index, not an internal index to the rate
control algorithm table.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>
---
 drivers/net/wireless/ath9k/xmit.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- wireless-testing.orig/drivers/net/wireless/ath9k/xmit.c	2008-12-15 15:28:09.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath9k/xmit.c	2008-12-15 15:35:33.000000000 +0200
@@ -125,7 +125,15 @@ static void ath_tx_complete(struct ath_s
 		tx_info->flags |= IEEE80211_TX_STAT_ACK;
 	}
 
-	tx_info->status.rates[0].count = tx_status->retries + 1;
+	tx_info->status.rates[0].count = tx_status->retries;
+	if (tx_info->status.rates[0].flags & IEEE80211_TX_RC_MCS) {
+		/* Change idx from internal table index to MCS index */
+		int idx = tx_info->status.rates[0].idx;
+		struct ath_rate_table *rate_table = sc->cur_rate_table;
+		if (idx >= 0 && idx < rate_table->rate_cnt)
+			tx_info->status.rates[0].idx =
+				rate_table->info[idx].ratecode & 0x7f;
+	}
 
 	ieee80211_tx_status(hw, skb);
 }

-- 
Jouni Malinen                                            PGP id EFC895FA
