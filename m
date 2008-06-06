Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.231]:10485 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753730AbYFFR76 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jun 2008 13:59:58 -0400
Received: by rv-out-0506.google.com with SMTP id l9so1616487rvb.1
        for <linux-wireless@vger.kernel.org>; Fri, 06 Jun 2008 10:59:57 -0700 (PDT)
Subject: [PATCH 4/7] mac80211: make ieee80211_get_hdrlen_from_skb return
	unsigned
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 06 Jun 2008 10:51:12 -0700
Message-Id: <1212774672.6340.78.camel@brick> (sfid-20080606_200004_144126_50EDB061)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Many callers already expect it to.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 include/net/mac80211.h |    2 +-
 net/mac80211/util.c    |   10 +++++-----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 53c3b5e..7ab4ff6 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1535,7 +1535,7 @@ ieee80211_get_buffered_bc(struct ieee80211_hw *hw, struct ieee80211_vif *vif);
  *
  * @skb: the frame
  */
-int ieee80211_get_hdrlen_from_skb(const struct sk_buff *skb);
+unsigned int ieee80211_get_hdrlen_from_skb(const struct sk_buff *skb);
 
 /**
  * ieee80211_get_hdrlen - get header length from frame control
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index fade001..60fec1c 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -165,15 +165,15 @@ out:
 }
 EXPORT_SYMBOL(ieee80211_hdrlen);
 
-int ieee80211_get_hdrlen_from_skb(const struct sk_buff *skb)
+unsigned int ieee80211_get_hdrlen_from_skb(const struct sk_buff *skb)
 {
 	const struct ieee80211_hdr *hdr = (const struct ieee80211_hdr *) skb->data;
-	int hdrlen;
+	unsigned int hdrlen;
 
-	if (unlikely(skb->len < 10))
+	if (skb->len < 10)
 		return 0;
-	hdrlen = ieee80211_get_hdrlen(le16_to_cpu(hdr->frame_control));
-	if (unlikely(hdrlen > skb->len))
+	hdrlen = ieee80211_hdrlen(hdr->frame_control);
+	if (hdrlen > skb->len)
 		return 0;
 	return hdrlen;
 }
-- 
1.5.6.rc1.257.gba91d


