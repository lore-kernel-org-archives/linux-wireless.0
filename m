Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.184]:31605 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968AbXBRNRA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Feb 2007 08:17:00 -0500
Received: by mu-out-0910.google.com with SMTP id g7so198597muf
        for <linux-wireless@vger.kernel.org>; Sun, 18 Feb 2007 05:16:58 -0800 (PST)
To: linux-wireless@vger.kernel.org
Subject: [PATCH] d80211: Fix skb panic during passive scan
Date: Sun, 18 Feb 2007 14:16:24 +0100
Cc: Jiri Benc <jbenc@suse.cz>, "John Linville" <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200702181416.24396.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Only add the extra_tx_headroom to the len when allocating
the sk_buff. This will prevent using an invalid length for skb_put
which would cause a skb panic inside the driver.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>

---

diff --git a/net/d80211/ieee80211_scan.c b/net/d80211/ieee80211_scan.c
index 263de0d..1d77155 100644
--- a/net/d80211/ieee80211_scan.c
+++ b/net/d80211/ieee80211_scan.c
@@ -280,7 +280,7 @@ void ieee80211_init_scan(struct ieee80211_local *local)
 {
 	struct ieee80211_hdr hdr;
 	u16 fc;
-	int len = 10 + local->hw.extra_tx_headroom;
+	int len = 10;
 	struct rate_control_extra extra;
 
 	/* Only initialize passive scanning if the hardware supports it */
@@ -303,7 +303,8 @@ void ieee80211_init_scan(struct ieee80211_local *local)
 
 	/* Create a CTS from for broadcasting before
 	 * the low level changes channels */
-	local->scan.skb = alloc_skb(len, GFP_KERNEL);
+	local->scan.skb = alloc_skb(len + local->hw.extra_tx_headroom,
+		GFP_KERNEL);
 	if (!local->scan.skb) {
 		printk(KERN_WARNING "%s: Failed to allocate CTS packet for "
 		       "passive scan\n", local->mdev->name);
