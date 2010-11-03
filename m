Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52969 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752528Ab0KCVvJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Nov 2010 17:51:09 -0400
Received: by mail-fx0-f46.google.com with SMTP id 16so938815fxm.19
        for <linux-wireless@vger.kernel.org>; Wed, 03 Nov 2010 14:51:08 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>,
	Luciano Coelho <luciano.coelho@nokia.com>
Cc: Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 3/4] mac80211: don't fragment packets when HW-fragmentation is on
Date: Wed,  3 Nov 2010 23:50:52 +0200
Message-Id: <1288821053-19013-4-git-send-email-arik@wizery.com>
In-Reply-To: <1288821053-19013-1-git-send-email-arik@wizery.com>
References: <1288821053-19013-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If the driver supports hardware TX fragmentation, don't fragment
packets in the stack.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 net/mac80211/tx.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 96c5943..b7d38c5 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1033,6 +1033,7 @@ static bool __ieee80211_parse_tx_radiotap(struct ieee80211_tx_data *tx,
 	struct ieee80211_radiotap_header *rthdr =
 		(struct ieee80211_radiotap_header *) skb->data;
 	struct ieee80211_supported_band *sband;
+	u32 hw_flags = tx->local->hw.flags;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	int ret = ieee80211_radiotap_iterator_init(&iterator, rthdr, skb->len,
 						   NULL);
@@ -1078,7 +1079,8 @@ static bool __ieee80211_parse_tx_radiotap(struct ieee80211_tx_data *tx,
 			}
 			if (*iterator.this_arg & IEEE80211_RADIOTAP_F_WEP)
 				info->flags &= ~IEEE80211_TX_INTFL_DONT_ENCRYPT;
-			if (*iterator.this_arg & IEEE80211_RADIOTAP_F_FRAG)
+			if ((*iterator.this_arg & IEEE80211_RADIOTAP_F_FRAG) &&
+			    !(hw_flags & IEEE80211_HW_TX_FRAGMENTATION))
 				tx->flags |= IEEE80211_TX_FRAGMENTED;
 			break;
 
@@ -1181,8 +1183,10 @@ ieee80211_tx_prepare(struct ieee80211_sub_if_data *sdata,
 	/*
 	 * Set this flag (used below to indicate "automatic fragmentation"),
 	 * it will be cleared/left by radiotap as desired.
+	 * Only valid when fragmentation is done by the stack.
 	 */
-	tx->flags |= IEEE80211_TX_FRAGMENTED;
+	if (!(local->hw.flags & IEEE80211_HW_TX_FRAGMENTATION))
+		tx->flags |= IEEE80211_TX_FRAGMENTED;
 
 	/* process and remove the injection radiotap header */
 	if (unlikely(info->flags & IEEE80211_TX_INTFL_HAS_RADIOTAP)) {
-- 
1.7.1

