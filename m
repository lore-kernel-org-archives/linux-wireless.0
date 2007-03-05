Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:59727 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934103AbXCFNJo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Mar 2007 08:09:44 -0500
Subject: [PATCH] make ieee80211_get_hdr_info static
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain
Date: Mon, 05 Mar 2007 17:41:58 +0100
Message-Id: <1173112918.6131.95.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch makes the ieee80211_get_hdr_info function which is only used
in wpa.c static.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 net/mac80211/wpa.c |    4 ++--
 net/mac80211/wpa.h |    3 ---
 2 files changed, 2 insertions(+), 5 deletions(-)

--- wireless-dev.orig/net/mac80211/wpa.c	2007-03-05 17:40:22.114711876 +0100
+++ wireless-dev/net/mac80211/wpa.c	2007-03-05 17:40:37.224711876 +0100
@@ -25,8 +25,8 @@
 #endif /* CONFIG_HOSTAPD_WPA_TESTING */
 
 
-int ieee80211_get_hdr_info(const struct sk_buff *skb, u8 **sa, u8 **da,
-			   u8 *qos_tid, u8 **data, size_t *data_len)
+static int ieee80211_get_hdr_info(const struct sk_buff *skb, u8 **sa, u8 **da,
+				  u8 *qos_tid, u8 **data, size_t *data_len)
 {
 	struct ieee80211_hdr *hdr;
 	size_t hdrlen;
--- wireless-dev.orig/net/mac80211/wpa.h	2007-03-05 17:40:16.354711876 +0100
+++ wireless-dev/net/mac80211/wpa.h	2007-03-05 17:40:19.394711876 +0100
@@ -28,7 +28,4 @@ ieee80211_tx_h_ccmp_encrypt(struct ieee8
 ieee80211_txrx_result
 ieee80211_rx_h_ccmp_decrypt(struct ieee80211_txrx_data *rx);
 
-int ieee80211_get_hdr_info(const struct sk_buff *skb, u8 **sa, u8 **da,
-			   u8 *qos_tid, u8 **data, size_t *data_len);
-
 #endif /* WPA_H */


