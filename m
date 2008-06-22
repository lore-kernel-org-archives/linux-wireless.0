Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.174]:8848 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753733AbYFVXpY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Jun 2008 19:45:24 -0400
Received: by wf-out-1314.google.com with SMTP id 27so1780017wfd.4
        for <linux-wireless@vger.kernel.org>; Sun, 22 Jun 2008 16:45:24 -0700 (PDT)
Subject: [PATCH 1/4] mac80211: wep.c use new frame control helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
Content-Type: text/plain
Date: Sun, 22 Jun 2008 16:45:23 -0700
Message-Id: <1214178324.21092.14.camel@brick> (sfid-20080623_014552_635284_D3744E88)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 net/mac80211/wep.c |   39 +++++++++++++++------------------------
 1 files changed, 15 insertions(+), 24 deletions(-)

diff --git a/net/mac80211/wep.c b/net/mac80211/wep.c
index e7b6344..35b664d 100644
--- a/net/mac80211/wep.c
+++ b/net/mac80211/wep.c
@@ -84,20 +84,17 @@ static u8 *ieee80211_wep_add_iv(struct ieee80211_local *local,
 				struct sk_buff *skb,
 				struct ieee80211_key *key)
 {
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
-	u16 fc;
-	int hdrlen;
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+	unsigned int hdrlen;
 	u8 *newhdr;
 
-	fc = le16_to_cpu(hdr->frame_control);
-	fc |= IEEE80211_FCTL_PROTECTED;
-	hdr->frame_control = cpu_to_le16(fc);
+	hdr->frame_control |= cpu_to_le16(IEEE80211_FCTL_PROTECTED);
 
 	if (WARN_ON(skb_tailroom(skb) < WEP_ICV_LEN ||
 		    skb_headroom(skb) < WEP_IV_LEN))
 		return NULL;
 
-	hdrlen = ieee80211_get_hdrlen(fc);
+	hdrlen = ieee80211_hdrlen(hdr->frame_control);
 	newhdr = skb_push(skb, WEP_IV_LEN);
 	memmove(newhdr, newhdr + WEP_IV_LEN, hdrlen);
 	ieee80211_wep_get_iv(local, key, newhdr + hdrlen);
@@ -109,12 +106,10 @@ static void ieee80211_wep_remove_iv(struct ieee80211_local *local,
 				    struct sk_buff *skb,
 				    struct ieee80211_key *key)
 {
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
-	u16 fc;
-	int hdrlen;
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+	unsigned int hdrlen;
 
-	fc = le16_to_cpu(hdr->frame_control);
-	hdrlen = ieee80211_get_hdrlen(fc);
+	hdrlen = ieee80211_hdrlen(hdr->frame_control);
 	memmove(skb->data + WEP_IV_LEN, skb->data, hdrlen);
 	skb_pull(skb, WEP_IV_LEN);
 }
@@ -224,17 +219,15 @@ int ieee80211_wep_decrypt(struct ieee80211_local *local, struct sk_buff *skb,
 	u32 klen;
 	u8 *rc4key;
 	u8 keyidx;
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
-	u16 fc;
-	int hdrlen;
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+	unsigned int hdrlen;
 	size_t len;
 	int ret = 0;
 
-	fc = le16_to_cpu(hdr->frame_control);
-	if (!(fc & IEEE80211_FCTL_PROTECTED))
+	if (!ieee80211_has_protected(hdr->frame_control))
 		return -1;
 
-	hdrlen = ieee80211_get_hdrlen(fc);
+	hdrlen = ieee80211_hdrlen(hdr->frame_control);
 
 	if (skb->len < 8 + hdrlen)
 		return -1;
@@ -281,17 +274,15 @@ int ieee80211_wep_decrypt(struct ieee80211_local *local, struct sk_buff *skb,
 
 u8 * ieee80211_wep_is_weak_iv(struct sk_buff *skb, struct ieee80211_key *key)
 {
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
-	u16 fc;
-	int hdrlen;
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+	unsigned int hdrlen;
 	u8 *ivpos;
 	u32 iv;
 
-	fc = le16_to_cpu(hdr->frame_control);
-	if (!(fc & IEEE80211_FCTL_PROTECTED))
+	if (!ieee80211_has_protected(hdr->frame_control))
 		return NULL;
 
-	hdrlen = ieee80211_get_hdrlen(fc);
+	hdrlen = ieee80211_hdrlen(hdr->frame_control);
 	ivpos = skb->data + hdrlen;
 	iv = (ivpos[0] << 16) | (ivpos[1] << 8) | ivpos[2];
 
-- 
1.5.6.290.gc4e15


