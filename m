Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35952 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759937Ab1JGME7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Oct 2011 08:04:59 -0400
Message-Id: <20111007120216.981189361@sipsolutions.net> (sfid-20111007_140504_935208_B11BB413)
Date: Fri, 07 Oct 2011 14:01:24 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2/4] mac80211: remove tx_data ethertype
References: <20111007120122.982757001@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

It's set, but never used, so kill it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ieee80211_i.h |    1 -
 net/mac80211/tx.c          |    7 +------
 2 files changed, 1 insertion(+), 7 deletions(-)

--- a/net/mac80211/ieee80211_i.h	2011-10-07 10:08:27.000000000 +0200
+++ b/net/mac80211/ieee80211_i.h	2011-10-07 10:23:10.000000000 +0200
@@ -149,7 +149,6 @@ struct ieee80211_tx_data {
 
 	struct ieee80211_channel *channel;
 
-	u16 ethertype;
 	unsigned int flags;
 };
 
--- a/net/mac80211/tx.c	2011-10-07 10:17:04.000000000 +0200
+++ b/net/mac80211/tx.c	2011-10-07 10:24:37.000000000 +0200
@@ -1198,7 +1198,7 @@ ieee80211_tx_prepare(struct ieee80211_su
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_hdr *hdr;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-	int hdrlen, tid;
+	int tid;
 	u8 *qc;
 
 	memset(tx, 0, sizeof(*tx));
@@ -1295,11 +1295,6 @@ ieee80211_tx_prepare(struct ieee80211_su
 	else if (test_and_clear_sta_flag(tx->sta, WLAN_STA_CLEAR_PS_FILT))
 		info->flags |= IEEE80211_TX_CTL_CLEAR_PS_FILT;
 
-	hdrlen = ieee80211_hdrlen(hdr->frame_control);
-	if (skb->len > hdrlen + sizeof(rfc1042_header) + 2) {
-		u8 *pos = &skb->data[hdrlen + sizeof(rfc1042_header)];
-		tx->ethertype = (pos[0] << 8) | pos[1];
-	}
 	info->flags |= IEEE80211_TX_CTL_FIRST_FRAGMENT;
 
 	return TX_CONTINUE;


