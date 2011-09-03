Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62245 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843Ab1ICHGm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Sep 2011 03:06:42 -0400
Received: by fxh19 with SMTP id 19so2284462fxh.19
        for <linux-wireless@vger.kernel.org>; Sat, 03 Sep 2011 00:06:41 -0700 (PDT)
To: linux-wireless@vger.kernel.org
Subject: [RESEND][PATCH] minstrel_ht: fix Open BA session request floods
Cc: John Linville <linville@tuxdriver.com>, nbd@openwrt.org
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Sat, 3 Sep 2011 09:06:20 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <201109030906.21009.chunkeey@googlemail.com> (sfid-20110903_090646_048305_0174529E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Minstrel HT tries very hard to establish a BA session with
each peer once there's some data on the way. However the
stack does not inform minstrel if an aggregation session
is already in place, so it keeps trying and wastes good
cycles in the tx status path.

[ 8149.946393] Open BA session requested for $AP tid 0
[ 8150.048765] Open BA session requested for $AP tid 0
[ 8150.174509] Open BA session requested for $AP tid 0
[ 8150.274376] Open BA session requested for $AP tid 0
...

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
Hm, this time without the HTML-part.
---
diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index 2158838..e19249b 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -452,7 +452,8 @@ minstrel_ht_tx_status(void *priv, struct ieee80211_supported_band *sband,
 
 	if (time_after(jiffies, mi->stats_update + (mp->update_interval / 2 * HZ) / 1000)) {
 		minstrel_ht_update_stats(mp, mi);
-		minstrel_aggr_check(mp, sta, skb);
+		if (!(info->flags & IEEE80211_TX_CTL_AMPDU))
+			minstrel_aggr_check(mp, sta, skb);
 	}
 }
 


