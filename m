Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42587 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757173AbZJ3LzB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Oct 2009 07:55:01 -0400
Subject: [PATCH] mac80211: also drop qos-nullfunc frames silently
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Jouni Malinen <j@w1.fi>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 30 Oct 2009 12:55:03 +0100
Message-ID: <1256903703.3555.49.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We drop nullfunc frames, but not qos-nullfunc frames,
even though those could be used for PS state control
as well.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/linux/ieee80211.h |   12 +++++++++++-
 net/mac80211/rx.c         |   15 ++++++++++-----
 2 files changed, 21 insertions(+), 6 deletions(-)

--- wireless-testing.orig/include/linux/ieee80211.h	2009-10-30 08:18:15.000000000 +0100
+++ wireless-testing/include/linux/ieee80211.h	2009-10-30 08:19:40.000000000 +0100
@@ -472,7 +472,7 @@ static inline int ieee80211_is_cfendack(
 }
 
 /**
- * ieee80211_is_nullfunc - check if FTYPE=IEEE80211_FTYPE_DATA and STYPE=IEEE80211_STYPE_NULLFUNC
+ * ieee80211_is_nullfunc - check if frame is a regular (non-QoS) nullfunc frame
  * @fc: frame control bytes in little-endian byteorder
  */
 static inline int ieee80211_is_nullfunc(__le16 fc)
@@ -481,6 +481,16 @@ static inline int ieee80211_is_nullfunc(
 	       cpu_to_le16(IEEE80211_FTYPE_DATA | IEEE80211_STYPE_NULLFUNC);
 }
 
+/**
+ * ieee80211_is_qos_nullfunc - check if frame is a QoS nullfunc frame
+ * @fc: frame control bytes in little-endian byteorder
+ */
+static inline int ieee80211_is_qos_nullfunc(__le16 fc)
+{
+	return (fc & cpu_to_le16(IEEE80211_FCTL_FTYPE | IEEE80211_FCTL_STYPE)) ==
+	       cpu_to_le16(IEEE80211_FTYPE_DATA | IEEE80211_STYPE_QOS_NULLFUNC);
+}
+
 struct ieee80211s_hdr {
 	u8 flags;
 	u8 ttl;
--- wireless-testing.orig/net/mac80211/rx.c	2009-10-30 08:18:15.000000000 +0100
+++ wireless-testing/net/mac80211/rx.c	2009-10-30 08:18:29.000000000 +0100
@@ -886,12 +886,17 @@ ieee80211_rx_h_sta_process(struct ieee80
 		}
 	}
 
-	/* Drop data::nullfunc frames silently, since they are used only to
-	 * control station power saving mode. */
-	if (ieee80211_is_nullfunc(hdr->frame_control)) {
+	/*
+	 * Drop (qos-)data::nullfunc frames silently, since they
+	 * are used only to control station power saving mode.
+	 */
+	if (ieee80211_is_nullfunc(hdr->frame_control) ||
+	    ieee80211_is_qos_nullfunc(hdr->frame_control)) {
 		I802_DEBUG_INC(rx->local->rx_handlers_drop_nullfunc);
-		/* Update counter and free packet here to avoid counting this
-		 * as a dropped packed. */
+		/*
+		 * Update counter and free packet here to avoid
+		 * counting this as a dropped packed.
+		 */
 		sta->rx_packets++;
 		dev_kfree_skb(rx->skb);
 		return RX_QUEUED;


