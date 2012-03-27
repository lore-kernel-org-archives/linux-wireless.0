Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36832 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751903Ab2C0MUS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Mar 2012 08:20:18 -0400
Message-Id: <20120327121921.444935239@sipsolutions.net> (sfid-20120327_142029_720349_6D10FE63)
Date: Tue, 27 Mar 2012 14:18:38 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 3/5] mac80211: make ieee80211_downgrade_queue static
References: <20120327121835.299635879@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's no reason for it to not be static.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/wme.c |   40 ++++++++++++++++++++--------------------
 net/mac80211/wme.h |    3 ---
 2 files changed, 20 insertions(+), 23 deletions(-)

--- a/net/mac80211/wme.c	2012-03-23 14:11:47.000000000 +0100
+++ b/net/mac80211/wme.c	2012-03-23 14:14:00.000000000 +0100
@@ -52,6 +52,26 @@ static int wme_downgrade_ac(struct sk_bu
 	}
 }
 
+static u16 ieee80211_downgrade_queue(struct ieee80211_local *local,
+				     struct sk_buff *skb)
+{
+	/* in case we are a client verify acm is not set for this ac */
+	while (unlikely(local->wmm_acm & BIT(skb->priority))) {
+		if (wme_downgrade_ac(skb)) {
+			/*
+			 * This should not really happen. The AP has marked all
+			 * lower ACs to require admission control which is not
+			 * a reasonable configuration. Allow the frame to be
+			 * transmitted using AC_BK as a workaround.
+			 */
+			break;
+		}
+	}
+
+	/* look up which queue to use for frames with this 1d tag */
+	return ieee802_1d_to_ac[skb->priority];
+}
+
 /* Indicate which queue to use for this fully formed 802.11 frame */
 u16 ieee80211_select_queue_80211(struct ieee80211_local *local,
 				 struct sk_buff *skb,
@@ -139,26 +159,6 @@ u16 ieee80211_select_queue(struct ieee80
 	return ieee80211_downgrade_queue(local, skb);
 }
 
-u16 ieee80211_downgrade_queue(struct ieee80211_local *local,
-			      struct sk_buff *skb)
-{
-	/* in case we are a client verify acm is not set for this ac */
-	while (unlikely(local->wmm_acm & BIT(skb->priority))) {
-		if (wme_downgrade_ac(skb)) {
-			/*
-			 * This should not really happen. The AP has marked all
-			 * lower ACs to require admission control which is not
-			 * a reasonable configuration. Allow the frame to be
-			 * transmitted using AC_BK as a workaround.
-			 */
-			break;
-		}
-	}
-
-	/* look up which queue to use for frames with this 1d tag */
-	return ieee802_1d_to_ac[skb->priority];
-}
-
 void ieee80211_set_qos_hdr(struct ieee80211_sub_if_data *sdata,
 			   struct sk_buff *skb)
 {
--- a/net/mac80211/wme.h	2012-03-15 14:31:56.000000000 +0100
+++ b/net/mac80211/wme.h	2012-03-23 14:14:03.000000000 +0100
@@ -22,8 +22,5 @@ u16 ieee80211_select_queue(struct ieee80
 			   struct sk_buff *skb);
 void ieee80211_set_qos_hdr(struct ieee80211_sub_if_data *sdata,
 			   struct sk_buff *skb);
-u16 ieee80211_downgrade_queue(struct ieee80211_local *local,
-                              struct sk_buff *skb);
-
 
 #endif /* _WME_H */


