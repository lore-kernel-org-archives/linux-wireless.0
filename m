Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53992 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764311AbZLQMzG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Dec 2009 07:55:06 -0500
Subject: [PATCH] mac80211: remove payload alignment warning
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Kalle Valo <kalle.valo@iki.fi>, linux-wireless@vger.kernel.org
In-Reply-To: <20091216214319.17614.72837.stgit@tikku>
References: <20091216214319.17614.72837.stgit@tikku>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Dec 2009 13:54:57 +0100
Message-ID: <1261054497.10356.107.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@nokia.com>

The payload alignment warning enabled by MAC80211_DEBUG_PACKET_ALIGNMENT is
difficult. To fix it, a firmware change is needed but in most cases that's
very difficult. So the benefit from the warning is low and most probably
it just creates more confusion for people who just enable all warnings
(like it did for me).

Remove the unaligned IP payload warning and the kconfig option. But
leave the unaligned packet warning, it will be enabled with
MAC80211_VERBOSE_DEBUG.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/Kconfig |   12 ------------
 net/mac80211/rx.c    |   27 +++++++--------------------
 2 files changed, 7 insertions(+), 32 deletions(-)

--- wireless-testing.orig/net/mac80211/Kconfig	2009-11-16 19:41:00.000000000 +0100
+++ wireless-testing/net/mac80211/Kconfig	2009-12-17 13:51:17.000000000 +0100
@@ -96,18 +96,6 @@ menuconfig MAC80211_DEBUG_MENU
 	---help---
 	  This option collects various mac80211 debug settings.
 
-config MAC80211_DEBUG_PACKET_ALIGNMENT
-	bool "Enable packet alignment debugging"
-	depends on MAC80211_DEBUG_MENU
-	---help---
-	  This option is recommended for driver authors and strongly
-	  discouraged for everybody else, it will trigger a warning
-	  when a driver hands mac80211 a buffer that is aligned in
-	  a way that will cause problems with the IP stack on some
-	  architectures.
-
-	  Say N unless you're writing a mac80211 based driver.
-
 config MAC80211_NOINLINE
 	bool "Do not inline TX/RX handlers"
 	depends on MAC80211_DEBUG_MENU
--- wireless-testing.orig/net/mac80211/rx.c	2009-12-12 16:29:09.000000000 +0100
+++ wireless-testing/net/mac80211/rx.c	2009-12-17 13:51:17.000000000 +0100
@@ -361,7 +361,9 @@ static void ieee80211_parse_qos(struct i
  * boundary. In the case of regular frames, this simply means aligning the
  * payload to a four-byte boundary (because either the IP header is directly
  * contained, or IV/RFC1042 headers that have a length divisible by four are
- * in front of it).
+ * in front of it).  If the payload data is not properly aligned and the
+ * architecture doesn't support efficient unaligned operations, mac80211
+ * will align the data.
  *
  * With A-MSDU frames, however, the payload data address must yield two modulo
  * four because there are 14-byte 802.3 headers within the A-MSDU frames that
@@ -375,25 +377,10 @@ static void ieee80211_parse_qos(struct i
  */
 static void ieee80211_verify_alignment(struct ieee80211_rx_data *rx)
 {
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)rx->skb->data;
-	int hdrlen;
-
-#ifndef CONFIG_MAC80211_DEBUG_PACKET_ALIGNMENT
-	return;
+#ifdef CONFIG_MAC80211_VERBOSE_DEBUG
+	WARN_ONCE((unsigned long)rx->skb->data & 1,
+		  "unaligned packet at 0x%p\n", rx->skb->data);
 #endif
-
-	if (WARN_ONCE((unsigned long)rx->skb->data & 1,
-		      "unaligned packet at 0x%p\n", rx->skb->data))
-		return;
-
-	if (!ieee80211_is_data_present(hdr->frame_control))
-		return;
-
-	hdrlen = ieee80211_hdrlen(hdr->frame_control);
-	if (rx->flags & IEEE80211_RX_AMSDU)
-		hdrlen += ETH_HLEN;
-	WARN_ONCE(((unsigned long)(rx->skb->data + hdrlen)) & 3,
-		  "unaligned IP payload at 0x%p\n", rx->skb->data + hdrlen);
 }
 
 
@@ -1510,7 +1497,7 @@ ieee80211_deliver_skb(struct ieee80211_r
 	if (skb) {
 		int align __maybe_unused;
 
-#if defined(CONFIG_MAC80211_DEBUG_PACKET_ALIGNMENT) || !defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS)
+#ifndef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
 		/*
 		 * 'align' will only take the values 0 or 2 here
 		 * since all frames are required to be aligned


