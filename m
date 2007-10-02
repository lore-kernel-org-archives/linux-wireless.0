Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:40301
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960AbXJBKUx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Oct 2007 06:20:53 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH #2 fixed] mac80211: Update beacon_update callback documentation
Date: Tue, 2 Oct 2007 12:17:56 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200710021217.56812.mb@bu3sch.de> (sfid-20071002_112055_982257_E072C542)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Michael Buesch <mb@bu3sch.de>

Index: wireless-2.6/include/net/mac80211.h
===================================================================
--- wireless-2.6.orig/include/net/mac80211.h	2007-09-25 22:51:28.000000000 +0200
+++ wireless-2.6/include/net/mac80211.h	2007-10-02 12:16:59.000000000 +0200
@@ -890,7 +890,14 @@ struct ieee80211_ops {
 
 	/* Setup beacon data for IBSS beacons. Unlike access point (Master),
 	 * IBSS uses a fixed beacon frame which is configured using this
-	 * function. This handler is required only for IBSS mode. */
+	 * function.
+	 * If the driver returns success (0) from this callback, it owns
+	 * the skb. That means the driver is responsible to kfree_skb() it.
+	 * The control structure is not dynamically allocated. That means the
+	 * driver does not own the pointer and if it needs it somewhere
+	 * outside of the context of this function, it must copy it
+	 * somewhere else.
+	 * This handler is required only for IBSS mode. */
 	int (*beacon_update)(struct ieee80211_hw *hw,
 			     struct sk_buff *skb,
 			     struct ieee80211_tx_control *control);

-- 
Greetings Michael.
