Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.172]:13312 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753893AbYFIT2b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jun 2008 15:28:31 -0400
Received: by wf-out-1314.google.com with SMTP id 27so2230439wfd.4
        for <linux-wireless@vger.kernel.org>; Mon, 09 Jun 2008 12:28:31 -0700 (PDT)
Subject: [PATCHv2 4/8] mac80211: make ieee80211_get_hdrlen_from_skb return
	unsigned
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 09 Jun 2008 12:28:21 -0700
Message-Id: <1213039701.5974.69.camel@brick> (sfid-20080609_212835_549153_C2DC6C69)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Many callers already expect it to.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 include/net/mac80211.h |    2 +-
 net/mac80211/util.c    |    8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

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
index 722a4eb..9f365a3 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -165,14 +165,14 @@ out:
 }
 EXPORT_SYMBOL(ieee80211_hdrlen);
 
-int ieee80211_get_hdrlen_from_skb(const struct sk_buff *skb)
+unsigned int ieee80211_get_hdrlen_from_skb(const struct sk_buff *skb)
 {
-	const struct ieee80211_hdr *hdr = (const struct ieee80211_hdr *) skb->data;
-	int hdrlen;
+	const struct ieee80211_hdr *hdr = (const struct ieee80211_hdr *)skb->data;
+	unsigned int hdrlen;
 
 	if (unlikely(skb->len < 10))
 		return 0;
-	hdrlen = ieee80211_get_hdrlen(le16_to_cpu(hdr->frame_control));
+	hdrlen = ieee80211_hdrlen(hdr->frame_control);
 	if (unlikely(hdrlen > skb->len))
 		return 0;
 	return hdrlen;
-- 
1.5.6.rc2.261.ga8fbe


