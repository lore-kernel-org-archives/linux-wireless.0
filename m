Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61861 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753370Ab1KNO22 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Nov 2011 09:28:28 -0500
Received: by bke11 with SMTP id 11so5946855bke.19
        for <linux-wireless@vger.kernel.org>; Mon, 14 Nov 2011 06:28:27 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, nbd@openwrt.org,
	Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [PATCH 1/3] mac80211: Minor optimization in minstrel_ht tx status path
Date: Mon, 14 Nov 2011 15:28:18 +0100
Message-Id: <1321280900-24006-1-git-send-email-helmut.schaa@googlemail.com> (sfid-20111114_152832_367826_DC90A0F6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Under the assumption that minstrel_ht most likely picks a suitable rate
it makes sense to reorder the check for the "last" rate since in most
cases we won't hit the maximum number of tried rates.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 net/mac80211/rc80211_minstrel_ht.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index cdb2853..63f1821 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -421,8 +421,8 @@ minstrel_ht_tx_status(void *priv, struct ieee80211_supported_band *sband,
 		mi->sample_packets += info->status.ampdu_len;
 
 	for (i = 0; !last; i++) {
-		last = (i == IEEE80211_TX_MAX_RATES - 1) ||
-		       !minstrel_ht_txstat_valid(&ar[i + 1]);
+		last = !minstrel_ht_txstat_valid(&ar[i + 1]) ||
+		       (i == IEEE80211_TX_MAX_RATES - 1);
 
 		if (!minstrel_ht_txstat_valid(&ar[i]))
 			break;
-- 
1.7.3.4

