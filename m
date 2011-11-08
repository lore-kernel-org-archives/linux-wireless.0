Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37858 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509Ab1KHMEq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Nov 2011 07:04:46 -0500
Subject: [PATCH] mac80211: fix bug in ieee80211_build_probe_req
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Nov 2011 13:04:41 +0100
Message-ID: <1320753881.4304.28.camel@jlt3.sipsolutions.net> (sfid-20111108_130449_320433_34C6C605)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

ieee80211_probereq_get() can return NULL in
which case we should clean up & return NULL
in ieee80211_build_probe_req() as well.

Cc: stable@vger.kernel.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/util.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/mac80211/util.c	2011-11-08 09:24:02.000000000 +0100
+++ b/net/mac80211/util.c	2011-11-08 12:50:12.000000000 +0100
@@ -880,6 +880,8 @@ struct sk_buff *ieee80211_build_probe_re
 	skb = ieee80211_probereq_get(&local->hw, &sdata->vif,
 				     ssid, ssid_len,
 				     buf, buf_len);
+	if (!skb)
+		goto out;
 
 	if (dst) {
 		mgmt = (struct ieee80211_mgmt *) skb->data;
@@ -888,6 +890,8 @@ struct sk_buff *ieee80211_build_probe_re
 	}
 
 	IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT;
+
+ out:
 	kfree(buf);
 
 	return skb;


