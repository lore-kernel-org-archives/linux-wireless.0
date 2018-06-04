Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:33739 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750868AbeFDJTw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Jun 2018 05:19:52 -0400
Received: by mail-wm0-f66.google.com with SMTP id z6-v6so13387714wma.0
        for <linux-wireless@vger.kernel.org>; Mon, 04 Jun 2018 02:19:51 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mt76x2: fix mrr idx/count estimation in mt76x2_mac_fill_tx_status()
Date: Mon,  4 Jun 2018 11:19:41 +0200
Message-Id: <b69193d3a01564778b9824ebb07cb4e677e3462a.1528098972.git.lorenzo.bianconi@redhat.com> (sfid-20180604_111956_083497_B1427A83)
In-Reply-To: <cover.1528098972.git.lorenzo.bianconi@redhat.com>
References: <cover.1528098972.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix mcs and attempt count estimation in mt76x2_mac_fill_tx_status routine
if the number of tx retries reported by the hw is grater than
IEEE80211_TX_MAX_RATES

Fixes: 7bc04215a66b ("mt76: add driver code for MT76x2e")
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x2_mac.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c
index b49aea4da2d6..8985446570bd 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c
@@ -439,15 +439,13 @@ mt76x2_mac_fill_tx_status(struct mt76x2_dev *dev,
 	if (last_rate < IEEE80211_TX_MAX_RATES - 1)
 		rate[last_rate + 1].idx = -1;
 
-	cur_idx = rate[last_rate].idx + st->retry;
+	cur_idx = rate[last_rate].idx + last_rate;
 	for (i = 0; i <= last_rate; i++) {
 		rate[i].flags = rate[last_rate].flags;
 		rate[i].idx = max_t(int, 0, cur_idx - i);
 		rate[i].count = 1;
 	}
-
-	if (last_rate > 0)
-		rate[last_rate - 1].count = st->retry + 1 - last_rate;
+	rate[last_rate].count = st->retry + 1 - last_rate;
 
 	info->status.ampdu_len = n_frames;
 	info->status.ampdu_ack_len = st->success ? n_frames : 0;
-- 
2.14.4
