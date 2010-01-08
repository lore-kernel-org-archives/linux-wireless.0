Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37918 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752700Ab0AHSAG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jan 2010 13:00:06 -0500
Subject: [PATCH] mac80211: fix endian error
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 08 Jan 2010 19:00:00 +0100
Message-ID: <1262973600.32112.0.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I forgot to convert the radiotap length to
CPU endian, which sparse found thankfully.

Apologies that the queue patch is requiring
so many fixups.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Cc: stable@kernel.org
---
 net/mac80211/iface.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- wireless-testing.orig/net/mac80211/iface.c	2010-01-08 18:24:05.000000000 +0100
+++ wireless-testing/net/mac80211/iface.c	2010-01-08 18:24:20.000000000 +0100
@@ -689,10 +689,10 @@ static u16 ieee80211_monitor_select_queu
 		return 0;
 
 	if (skb->len < 4 ||
-	    skb->len < rtap->it_len + 2 /* frame control */)
+	    skb->len < le16_to_cpu(rtap->it_len) + 2 /* frame control */)
 		return 0; /* doesn't matter, frame will be dropped */
 
-	hdr = (void *)((u8 *)skb->data + rtap->it_len);
+	hdr = (void *)((u8 *)skb->data + le16_to_cpu(rtap->it_len));
 
 	if (!ieee80211_is_data(hdr->frame_control)) {
 		skb->priority = 7;


