Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:54735 "EHLO silver.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965119AbXBSWj0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Feb 2007 17:39:26 -0500
From: Jiri Benc <jbenc@suse.cz>
To: "John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <20070219233919.221549000.midnight@suse.cz>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 10/12] d80211: Fix skb panic during passive scan
Message-Id: <20070219223956.30F10484B1@silver.suse.cz>
Date: Mon, 19 Feb 2007 23:39:56 +0100 (CET)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ivo van Doorn <ivdoorn@gmail.com>

Only add the extra_tx_headroom to the len when allocating
the sk_buff. This will prevent using an invalid length for skb_put
which would cause a skb panic inside the driver.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
Signed-off-by: Jiri Benc <jbenc@suse.cz>

---

 net/d80211/ieee80211_scan.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

27cfdcaec0ff523ce5a09915f76e36348753c9e2
diff --git a/net/d80211/ieee80211_scan.c b/net/d80211/ieee80211_scan.c
index 263de0d..1d77155 100644
--- a/net/d80211/ieee80211_scan.c
+++ b/net/d80211/ieee80211_scan.c
@@ -280,7 +280,7 @@ void ieee80211_init_scan(struct ieee8021
 {
 	struct ieee80211_hdr hdr;
 	u16 fc;
-	int len = 10 + local->hw.extra_tx_headroom;
+	int len = 10;
 	struct rate_control_extra extra;
 
 	/* Only initialize passive scanning if the hardware supports it */
@@ -303,7 +303,8 @@ void ieee80211_init_scan(struct ieee8021
 
 	/* Create a CTS from for broadcasting before
 	 * the low level changes channels */
-	local->scan.skb = alloc_skb(len, GFP_KERNEL);
+	local->scan.skb = alloc_skb(len + local->hw.extra_tx_headroom,
+		GFP_KERNEL);
 	if (!local->scan.skb) {
 		printk(KERN_WARNING "%s: Failed to allocate CTS packet for "
 		       "passive scan\n", local->mdev->name);
-- 
1.3.0

