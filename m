Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:45331 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031997AbbKFLCe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2015 06:02:34 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] lib80211: ratelimit key index mismatch
Date: Fri,  6 Nov 2015 12:02:31 +0100
Message-Id: <1446807751-12717-1-git-send-email-johannes@sipsolutions.net> (sfid-20151106_120237_862698_5996B8C9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This indicates a driver key selection issue, but even then there's
no point in printing it all the time, so ratelimit it. Also remove
the priv pointer from it -- people debugging will only have a single
device anyway and it's useless as anything but a cookie.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/lib80211_crypt_ccmp.c | 4 ++--
 net/wireless/lib80211_crypt_tkip.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/wireless/lib80211_crypt_ccmp.c b/net/wireless/lib80211_crypt_ccmp.c
index dc0e59e53dbf..6beab0cfcb99 100644
--- a/net/wireless/lib80211_crypt_ccmp.c
+++ b/net/wireless/lib80211_crypt_ccmp.c
@@ -311,8 +311,8 @@ static int lib80211_ccmp_decrypt(struct sk_buff *skb, int hdr_len, void *priv)
 	}
 	keyidx >>= 6;
 	if (key->key_idx != keyidx) {
-		printk(KERN_DEBUG "CCMP: RX tkey->key_idx=%d frame "
-		       "keyidx=%d priv=%p\n", key->key_idx, keyidx, priv);
+		net_dbg_ratelimited("CCMP: RX tkey->key_idx=%d frame keyidx=%d\n",
+				    key->key_idx, keyidx);
 		return -6;
 	}
 	if (!key->key_set) {
diff --git a/net/wireless/lib80211_crypt_tkip.c b/net/wireless/lib80211_crypt_tkip.c
index 8c90ba79e56e..3cd819539241 100644
--- a/net/wireless/lib80211_crypt_tkip.c
+++ b/net/wireless/lib80211_crypt_tkip.c
@@ -434,8 +434,8 @@ static int lib80211_tkip_decrypt(struct sk_buff *skb, int hdr_len, void *priv)
 	}
 	keyidx >>= 6;
 	if (tkey->key_idx != keyidx) {
-		printk(KERN_DEBUG "TKIP: RX tkey->key_idx=%d frame "
-		       "keyidx=%d priv=%p\n", tkey->key_idx, keyidx, priv);
+		net_dbg_ratelimited("TKIP: RX tkey->key_idx=%d frame keyidx=%d\n",
+				    tkey->key_idx, keyidx);
 		return -6;
 	}
 	if (!tkey->key_set) {
-- 
2.6.2

