Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54532 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751123Ab1KNQ5J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Nov 2011 11:57:09 -0500
Subject: [PATCH 1/2] compat-wireless: disable SKB TX status stamping in
 mac80211
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Nov 2011 17:14:49 +0100
Message-ID: <1321287289.10264.16.camel@jlt3.sipsolutions.net> (sfid-20111114_175713_926907_64425DAA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---

diff --git a/patches/12-mac80211-disable-tx-status.patch b/patches/12-mac80211-disable-tx-status.patch
new file mode 100644
index 0000000..522cb8c
--- /dev/null
+++ b/patches/12-mac80211-disable-tx-status.patch
@@ -0,0 +1,24 @@
+We can't possibly backport the wifi TX status since
+skb_shinfo()->tx_flags used to be a union and there
+is no way to make the & work properly in that case.
+So we need to just ifdef this part out.
+
+
+--- a/net/mac80211/tx.c	2011-11-14 16:46:04.000000000 +0100
++++ b/net/mac80211/tx.c	2011-11-14 17:04:09.000000000 +0100
+@@ -1915,6 +1915,7 @@ netdev_tx_t ieee80211_subif_start_xmit(s
+ 		goto fail;
+ 	}
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(3,3,0))
+ 	if (unlikely(!multicast && skb->sk &&
+ 		     skb_shinfo(skb)->tx_flags & SKBTX_WIFI_STATUS)) {
+ 		struct sk_buff *orig_skb = skb;
+@@ -1953,6 +1954,7 @@ netdev_tx_t ieee80211_subif_start_xmit(s
+ 			skb = orig_skb;
+ 		}
+ 	}
++#endif
+ 
+ 	/*
+ 	 * If the skb is shared we need to obtain our own copy.


