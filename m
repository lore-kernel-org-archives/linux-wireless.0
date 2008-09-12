Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50764 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836AbYILNXa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Sep 2008 09:23:30 -0400
Subject: [PATCH] mac80211: remove debug frame dumping
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 12 Sep 2008 15:22:53 +0200
Message-Id: <1221225773.11204.47.camel@johannes.berg> (sfid-20080912_152334_008849_955E2615)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

You can just pull up a monitor interface to get much more
detailed information, or, when debugging a driver, insert
dump code into the driver (which usually you will have to
do anyway to dump the driver-specific information). Hence
this option is useless.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/Kconfig |   13 -------------
 net/mac80211/tx.c    |   42 ------------------------------------------
 2 files changed, 55 deletions(-)

--- everything.orig/net/mac80211/Kconfig	2008-09-12 15:20:09.000000000 +0200
+++ everything/net/mac80211/Kconfig	2008-09-12 15:20:15.000000000 +0200
@@ -179,19 +179,6 @@ config MAC80211_VERBOSE_MPL_DEBUG
 
 	  Do not select this option.
 
-config MAC80211_LOWTX_FRAME_DUMP
-	bool "Debug frame dumping"
-	depends on MAC80211_DEBUG_MENU
-	---help---
-	  Selecting this option will cause the stack to
-	  print a message for each frame that is handed
-	  to the lowlevel driver for transmission. This
-	  message includes all MAC addresses and the
-	  frame control field.
-
-	  If unsure, say N and insert the debugging code
-	  you require into the driver you are debugging.
-
 config MAC80211_DEBUG_COUNTERS
 	bool "Extra statistics for TX/RX debugging"
 	depends on MAC80211_DEBUG_MENU
--- everything.orig/net/mac80211/tx.c	2008-09-12 15:20:18.000000000 +0200
+++ everything/net/mac80211/tx.c	2008-09-12 15:20:37.000000000 +0200
@@ -38,43 +38,6 @@
 
 /* misc utils */
 
-#ifdef CONFIG_MAC80211_LOWTX_FRAME_DUMP
-static void ieee80211_dump_frame(const char *ifname, const char *title,
-				 const struct sk_buff *skb)
-{
-	const struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
-	unsigned int hdrlen;
-	DECLARE_MAC_BUF(mac);
-
-	printk(KERN_DEBUG "%s: %s (len=%d)", ifname, title, skb->len);
-	if (skb->len < 4) {
-		printk("\n");
-		return;
-	}
-
-	hdrlen = ieee80211_hdrlen(hdr->frame_control);
-	if (hdrlen > skb->len)
-		hdrlen = skb->len;
-	if (hdrlen >= 4)
-		printk(" FC=0x%04x DUR=0x%04x",
-		    le16_to_cpu(hdr->frame_control), le16_to_cpu(hdr->duration_id));
-	if (hdrlen >= 10)
-		printk(" A1=%s", print_mac(mac, hdr->addr1));
-	if (hdrlen >= 16)
-		printk(" A2=%s", print_mac(mac, hdr->addr2));
-	if (hdrlen >= 24)
-		printk(" A3=%s", print_mac(mac, hdr->addr3));
-	if (hdrlen >= 30)
-		printk(" A4=%s", print_mac(mac, hdr->addr4));
-	printk("\n");
-}
-#else /* CONFIG_MAC80211_LOWTX_FRAME_DUMP */
-static inline void ieee80211_dump_frame(const char *ifname, const char *title,
-					struct sk_buff *skb)
-{
-}
-#endif /* CONFIG_MAC80211_LOWTX_FRAME_DUMP */
-
 static __le16 ieee80211_duration(struct ieee80211_tx_data *tx, int group_addr,
 				 int next_frag_len)
 {
@@ -1069,8 +1032,6 @@ static int __ieee80211_tx(struct ieee802
 			return IEEE80211_TX_AGAIN;
 		info =  IEEE80211_SKB_CB(skb);
 
-		ieee80211_dump_frame(wiphy_name(local->hw.wiphy),
-				     "TX to low-level driver", skb);
 		ret = local->ops->tx(local_to_hw(local), skb);
 		if (ret)
 			return IEEE80211_TX_AGAIN;
@@ -1100,9 +1061,6 @@ static int __ieee80211_tx(struct ieee802
 						~IEEE80211_TX_CTL_RATE_CTRL_PROBE;
 			}
 
-			ieee80211_dump_frame(wiphy_name(local->hw.wiphy),
-					     "TX to low-level driver",
-					     tx->extra_frag[i]);
 			ret = local->ops->tx(local_to_hw(local),
 					    tx->extra_frag[i]);
 			if (ret)


