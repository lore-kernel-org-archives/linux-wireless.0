Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39107 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751220AbbB1U2q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Feb 2015 15:28:46 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: j@w1.fi, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: don't look up stations for multicast addresses
Date: Sat, 28 Feb 2015 21:28:39 +0100
Message-Id: <1425155319-22553-1-git-send-email-johannes@sipsolutions.net> (sfid-20150228_212851_931668_14D8896C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Since multicast addresses don't exist as stations, don't attempt
to look them up in the hashtable on TX.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
This replaces the broken commit "mac80211: simplify station
assignment in ieee80211_tx_prepare()".
---
 net/mac80211/tx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 88a18ffe2975..0e56ac5729ef 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1172,7 +1172,7 @@ ieee80211_tx_prepare(struct ieee80211_sub_if_data *sdata,
 		   tx->sdata->control_port_protocol == tx->skb->protocol) {
 		tx->sta = sta_info_get_bss(sdata, hdr->addr1);
 	}
-	if (!tx->sta)
+	if (!tx->sta && !is_multicast_ether_addr(hdr->addr1))
 		tx->sta = sta_info_get(sdata, hdr->addr1);
 
 	if (tx->sta && ieee80211_is_data_qos(hdr->frame_control) &&
-- 
2.1.4

