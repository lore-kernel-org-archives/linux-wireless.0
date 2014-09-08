Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38581 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753103AbaIHJXp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Sep 2014 05:23:45 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: annotate MMIC head/tailroom warning
Date: Mon,  8 Sep 2014 11:23:37 +0200
Message-Id: <1410168217-25075-1-git-send-email-johannes@sipsolutions.net> (sfid-20140908_112348_637448_E1CD5D13)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This message occasionally triggers for some people as in
https://bugzilla.redhat.com/show_bug.cgi?id=1111740 but
it's not clear which (headroom or tailroom) is at fault.
Annotate the message a bit to get more information.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/wpa.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/wpa.c b/net/mac80211/wpa.c
index f7d4ca4c46e0..983527a4c1ab 100644
--- a/net/mac80211/wpa.c
+++ b/net/mac80211/wpa.c
@@ -64,8 +64,11 @@ ieee80211_tx_h_michael_mic_add(struct ieee80211_tx_data *tx)
 	if (!info->control.hw_key)
 		tail += IEEE80211_TKIP_ICV_LEN;
 
-	if (WARN_ON(skb_tailroom(skb) < tail ||
-		    skb_headroom(skb) < IEEE80211_TKIP_IV_LEN))
+	if (WARN(skb_tailroom(skb) < tail ||
+		 skb_headroom(skb) < IEEE80211_TKIP_IV_LEN,
+		 "mmic: not enough head/tail (%d/%d,%d/%d)\n",
+		 skb_headroom(skb), IEEE80211_TKIP_IV_LEN,
+		 skb_tailroom(skb), tail))
 		return TX_DROP;
 
 	key = &tx->key->conf.key[NL80211_TKIP_DATA_OFFSET_TX_MIC_KEY];
-- 
2.1.0

