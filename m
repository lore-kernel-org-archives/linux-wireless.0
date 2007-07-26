Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:59667 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752095AbXGZMKx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jul 2007 08:10:53 -0400
Received: from armbox7.home.warmcat.com (cpc1-nthc5-0-0-cust289.nrth.cable.ntl.com [82.29.29.34])
	by mailserver.mog.warmcat.com (Postfix) with ESMTP id 27DDC8CAD8
	for <linux-wireless@vger.kernel.org>; Thu, 26 Jul 2007 14:10:49 +0200 (CEST)
Received: from meerkat.home.warmcat.com (unknown [192.168.0.242])
	by armbox7.home.warmcat.com (Postfix) with ESMTP id 2922D1044E
	for <linux-wireless@vger.kernel.org>; Thu, 26 Jul 2007 12:12:35 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by meerkat.home.warmcat.com (Postfix) with ESMTP id AB76013639A2
	for <linux-wireless@vger.kernel.org>; Thu, 26 Jul 2007 13:10:51 +0100 (BST)
From: warmcat <andy@warmcat.com>
Subject: [PATCH 1/2] Add get_unaligned to ieee80211_get_radiotap_len
To: linux-wireless@vger.kernel.org
Date: Thu, 26 Jul 2007 13:10:51 +0100
Message-ID: <20070726121051.11153.36250.stgit@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ieee80211_get_radiotap_len() tries to dereference radiotap length without
taking care that it is completely unaligned and get_unaligned()
is required.

Signed-off-by: Andy Green <andy@warmcat.com>
---

 net/mac80211/ieee80211.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
index a42e70e..6f5c001 100644
--- a/net/mac80211/ieee80211.c
+++ b/net/mac80211/ieee80211.c
@@ -350,7 +350,7 @@ static int ieee80211_get_radiotap_len(struct sk_buff *skb)
 	struct ieee80211_radiotap_header *hdr =
 		(struct ieee80211_radiotap_header *) skb->data;
 
-	return le16_to_cpu(hdr->it_len);
+	return le16_to_cpu(get_unaligned(&hdr->it_len));
 }
 
 #ifdef CONFIG_MAC80211_LOWTX_FRAME_DUMP

