Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52549 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543AbZFQPp4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2009 11:45:56 -0400
Subject: [PATCH] net: remove unused skb->do_not_encrypt
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 17 Jun 2009 17:45:28 +0200
Message-Id: <1245253528.31588.30.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mac80211 required this due to the master netdev, but now
it can put all information into skb->cb and this can go.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
Depends on the rt2x00 patch Ivo sent.

 include/linux/skbuff.h |    6 +-----
 net/core/skbuff.c      |    3 ---
 2 files changed, 1 insertion(+), 8 deletions(-)

--- wireless-testing.orig/include/linux/skbuff.h	2009-06-16 18:10:51.000000000 +0200
+++ wireless-testing/include/linux/skbuff.h	2009-06-17 17:44:04.000000000 +0200
@@ -300,7 +300,6 @@ typedef unsigned char *sk_buff_data_t;
  *	@tc_index: Traffic control index
  *	@tc_verd: traffic control verdict
  *	@ndisc_nodetype: router type (from link layer)
- *	@do_not_encrypt: set to prevent encryption of this frame
  *	@dma_cookie: a cookie to one of several possible DMA operations
  *		done by skb DMA functions
  *	@secmark: security marking
@@ -375,10 +374,7 @@ struct sk_buff {
 #ifdef CONFIG_IPV6_NDISC_NODETYPE
 	__u8			ndisc_nodetype:2;
 #endif
-#if defined(CONFIG_MAC80211) || defined(CONFIG_MAC80211_MODULE)
-	__u8			do_not_encrypt:1;
-#endif
-	/* 0/13/14 bit hole */
+	/* 0/14 bit hole */
 
 #ifdef CONFIG_NET_DMA
 	dma_cookie_t		dma_cookie;
--- wireless-testing.orig/net/core/skbuff.c	2009-06-16 18:10:51.000000000 +0200
+++ wireless-testing/net/core/skbuff.c	2009-06-17 17:44:04.000000000 +0200
@@ -575,9 +575,6 @@ static struct sk_buff *__skb_clone(struc
 	C(head);
 	C(data);
 	C(truesize);
-#if defined(CONFIG_MAC80211) || defined(CONFIG_MAC80211_MODULE)
-	C(do_not_encrypt);
-#endif
 	atomic_set(&n->users, 1);
 
 	atomic_inc(&(skb_shinfo(skb)->dataref));


