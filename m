Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61861 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753370Ab1KNO2a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Nov 2011 09:28:30 -0500
Received: by mail-bw0-f46.google.com with SMTP id 11so5946855bke.19
        for <linux-wireless@vger.kernel.org>; Mon, 14 Nov 2011 06:28:30 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, nbd@openwrt.org,
	Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [PATCH 2/3] mac80211: Check rate->idx before rate->count
Date: Mon, 14 Nov 2011 15:28:19 +0100
Message-Id: <1321280900-24006-2-git-send-email-helmut.schaa@googlemail.com> (sfid-20111114_152834_717024_FE170711)
In-Reply-To: <1321280900-24006-1-git-send-email-helmut.schaa@googlemail.com>
References: <1321280900-24006-1-git-send-email-helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The drivers are not required to fill in rate->count if rate->idx is set
to -1. Hence, we should first check rate->idx before accessing
rate->count.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 net/mac80211/rc80211_minstrel_ht.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index 63f1821..3d76fd7 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -300,10 +300,10 @@ minstrel_ht_update_stats(struct minstrel_priv *mp, struct minstrel_ht_sta *mi)
 static bool
 minstrel_ht_txstat_valid(struct ieee80211_tx_rate *rate)
 {
-	if (!rate->count)
+	if (rate->idx < 0)
 		return false;
 
-	if (rate->idx < 0)
+	if (!rate->count)
 		return false;
 
 	return !!(rate->flags & IEEE80211_TX_RC_MCS);
-- 
1.7.3.4

