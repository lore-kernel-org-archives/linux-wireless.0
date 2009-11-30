Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:31265 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753854AbZK3KjT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Nov 2009 05:39:19 -0500
Subject: [PATCH] mac80211: remove payload alignment warning
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kalle.valo@iki.fi>
Cc: johannes@sipsolutions.net
Date: Mon, 30 Nov 2009 12:39:08 +0200
Message-ID: <20091130103908.30420.40019.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@nokia.com>

The payload alignment warning enabled by MAC80211_DEBUG_PACKET_ALIGNMENT is
difficult. To fix it, a firmware change is needed but in most cases that's
very difficult. So the benefit from the warning is low and most probably
it just creates more confusion for people who just enable all warnings
(like it did for me).

Remove the unaligned IP payload warning and the kconfig option. But
leave the unlialigned packet warning, it will be enabled with
MAC80211_VERBOSE_DEBUG.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---
 net/mac80211/Kconfig |   12 ------------
 net/mac80211/rx.c    |   27 +++++++--------------------
 2 files changed, 7 insertions(+), 32 deletions(-)

diff --git a/net/mac80211/Kconfig b/net/mac80211/Kconfig
index a10d508..a952b7f 100644
--- a/net/mac80211/Kconfig
+++ b/net/mac80211/Kconfig
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
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 57b8a0a..18a0248 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -361,7 +361,9 @@ static void ieee80211_parse_qos(struct ieee80211_rx_data *rx)
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
@@ -375,25 +377,10 @@ static void ieee80211_parse_qos(struct ieee80211_rx_data *rx)
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
 
 
@@ -1512,7 +1499,7 @@ ieee80211_deliver_skb(struct ieee80211_rx_data *rx)
 	if (skb) {
 		int align __maybe_unused;
 
-#if defined(CONFIG_MAC80211_DEBUG_PACKET_ALIGNMENT) || !defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS)
+#ifndef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
 		/*
 		 * 'align' will only take the values 0 or 2 here
 		 * since all frames are required to be aligned

