Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.224]:21901 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251AbZGVTXs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jul 2009 15:23:48 -0400
Received: by rv-out-0506.google.com with SMTP id k40so1317635rvb.5
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2009 12:23:47 -0700 (PDT)
Subject: [PATCH] compat-wireless-old: Fix problem with TX on amd64
From: Gao Lei <lei.alvin.gao@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain
Date: Thu, 23 Jul 2009 03:23:25 +0800
Message-Id: <1248290605.4717.76.camel@mountain.triplerocks.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On amd64, the `ieee80211_tx_info' struct takes 56 bytes, thus cannot fit
into skb's control buffer.

The very first result is that nothing can be really sent out, because
skb's next member `len' also gets cleared when doing:

	info = IEEE80211_SKB_CB(skb);
	memset(info, 0, sizeof(*info));

A quick fix may be removing the TX control's sta pointer, since IMHO
it's rarely used for now (the only place that I found was a function
assigning values to it).

It has been working well for me so far, but please let me know if
there're better solutions. Thanks!

Best regards,
Gao Lei


diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index e3adf99..b9a5ae7 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -331,7 +331,6 @@ struct ieee80211_tx_info {
 		struct {
 			struct ieee80211_vif *vif;
 			struct ieee80211_key_conf *hw_key;
-			struct ieee80211_sta *sta;
 			unsigned long jiffies;
 			int ifindex;
 			u16 aid;
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 7d1b32c..ee0ed32 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -540,9 +540,6 @@ ieee80211_tx_h_misc(struct ieee80211_tx_data *tx)
 
 	sband = tx->local->hw.wiphy->bands[tx->channel->band];
 
-	if (tx->sta)
-		info->control.sta = &tx->sta->sta;
-
 	if (!info->control.retry_limit) {
 		if (!is_multicast_ether_addr(hdr->addr1)) {
 			int len = min_t(int, tx->skb->len + FCS_LEN,
@@ -620,9 +617,6 @@ ieee80211_tx_h_misc(struct ieee80211_tx_data *tx)
 			info->control.rts_cts_rate_idx = 0;
 	}
 
-	if (tx->sta)
-		info->control.sta = &tx->sta->sta;
-
 	return TX_CONTINUE;
 }
 

