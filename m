Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms-smtp-01.rdc-kc.rr.com ([24.94.166.115]:44204 "EHLO
	ms-smtp-01.rdc-kc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753624AbXDNSOC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Apr 2007 14:14:02 -0400
Date: Sat, 14 Apr 2007 13:15:15 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John Linville <linville@tuxdriver.com>
Cc: Michael Wu <flamingice@sourmilk.net>,
	Michael Buesch <mb@bu3sch.de>, Bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org
Subject: [PATCH 4/4] mac80211: Remove old names for statistics variables
Message-ID: <46211a33.JlaK27J9HyTa6JIz%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Patch 4/4: Remove old stats variables from mac80211 structs.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: wireless-dev/include/net/mac80211.h
===================================================================
--- wireless-dev.orig/include/net/mac80211.h
+++ wireless-dev/include/net/mac80211.h
@@ -227,8 +227,6 @@ struct ieee80211_rx_status {
 	int freq; /* receive frequency in Mhz */
 	int channel;
 	int phymode;
-	int ssi;
-	int signal; /* used as qual in statistics reporting */
 	int level;  /* used in statistics reporting */
 	int qual; /* used in statistics reporting */
 	int noise;
@@ -544,9 +542,7 @@ struct ieee80211_hw {
 	int channel_change_time;
 	/* Maximum values for various statistics.
 	 * Leave at 0 to indicate no support. Use negative numbers for dBm. */
-	s8 max_rssi;
 	s8 max_level;
-	s8 max_signal;
 	s8 max_qual;
 	s8 max_noise;
 
Index: wireless-dev/net/mac80211/ieee80211.c
===================================================================
--- wireless-dev.orig/net/mac80211/ieee80211.c
+++ wireless-dev/net/mac80211/ieee80211.c
@@ -4211,7 +4211,7 @@ void ieee80211_rx_irqsafe(struct ieee802
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 
-//	BUILD_BUG_ON(sizeof(struct ieee80211_rx_status) > sizeof(skb->cb));
+	BUILD_BUG_ON(sizeof(struct ieee80211_rx_status) > sizeof(skb->cb));
 
 	skb->dev = local->mdev;
 	/* copy status into skb->cb for use by tasklet */
Index: wireless-dev/net/mac80211/ieee80211_i.h
===================================================================
--- wireless-dev.orig/net/mac80211/ieee80211_i.h
+++ wireless-dev/net/mac80211/ieee80211_i.h
@@ -82,7 +82,6 @@ struct ieee80211_sta_bss {
 	int hw_mode;
 	int channel;
 	int freq;
-	int rssi, signal;
 	int level, qual, noise;
 	u8 *wpa_ie;
 	size_t wpa_ie_len;
Index: wireless-dev/net/mac80211/sta_info.h
===================================================================
--- wireless-dev.orig/net/mac80211/sta_info.h
+++ wireless-dev/net/mac80211/sta_info.h
@@ -83,10 +83,8 @@ struct sta_info {
 	unsigned long rx_fragments; /* number of received MPDUs */
 	unsigned long rx_dropped; /* number of dropped MPDUs from this STA */
 
-	int last_rssi; /* RSSI of last received frame from this STA */
-	int last_signal; /* signal of last received frame from this STA */
 	int last_level; /* level of last received frame from this STA */
-	int last_qual; /* qual of last received frame from this STA */
+	int last_qual; /* quality value of last received frame from this STA */
 	int last_noise; /* noise of last received frame from this STA */
 	int last_ack_rssi[3]; /* RSSI of last received ACKs from this STA */
 	unsigned long last_ack;
