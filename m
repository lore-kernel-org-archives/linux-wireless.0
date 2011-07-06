Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56476 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753445Ab1GFMNl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2011 08:13:41 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.76)
	(envelope-from <johannes@sipsolutions.net>)
	id 1QeQz6-0004CQ-3n
	for linux-wireless@vger.kernel.org; Wed, 06 Jul 2011 14:13:40 +0200
Message-Id: <20110706121315.485961879@sipsolutions.net> (sfid-20110706_141344_632489_61996602)
Date: Wed, 06 Jul 2011 14:12:38 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC 2/2] mac80211: allow driver to generate P1K for IV32
References: <20110706121236.333408679@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

In order to support pre-populating the P1K cache in
iwlwifi hardware for WoWLAN, we need to calculate
the P1K for the current IV32. Allow drivers to get
the P1K for any given IV32 instead of for a given
packet, but keep the packet-based version around as
an inline.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
This should also enable fixing b43's code -- it's
also pre-populating the cache in normal operation.

 include/net/mac80211.h |   24 ++++++++++++++++++++++--
 net/mac80211/tkip.c    |    9 +++------
 2 files changed, 25 insertions(+), 8 deletions(-)

--- a/include/net/mac80211.h	2011-07-06 12:45:35.000000000 +0200
+++ b/include/net/mac80211.h	2011-07-06 12:45:55.000000000 +0200
@@ -20,6 +20,7 @@
 #include <linux/device.h>
 #include <linux/ieee80211.h>
 #include <net/cfg80211.h>
+#include <asm/unaligned.h>
 
 /**
  * DOC: Introduction
@@ -2564,6 +2565,18 @@ struct sk_buff *
 ieee80211_get_buffered_bc(struct ieee80211_hw *hw, struct ieee80211_vif *vif);
 
 /**
+ * ieee80211_get_tkip_p1k_iv - get a TKIP phase 1 key for IV32
+ *
+ * This function returns the TKIP phase 1 key for the given IV32.
+ *
+ * @keyconf: the parameter passed with the set key
+ * @iv32: IV32 to get the P1K for
+ * @p1k: a buffer to which the key will be written, as 5 u16 values
+ */
+void ieee80211_get_tkip_p1k_iv(struct ieee80211_key_conf *keyconf,
+			       u32 iv32, u16 *p1k);
+
+/**
  * ieee80211_get_tkip_p1k - get a TKIP phase 1 key
  *
  * This function returns the TKIP phase 1 key for the IV32 taken
@@ -2574,8 +2587,15 @@ ieee80211_get_buffered_bc(struct ieee802
  *	with this P1K
  * @p1k: a buffer to which the key will be written, as 5 u16 values
  */
-void ieee80211_get_tkip_p1k(struct ieee80211_key_conf *keyconf,
-			    struct sk_buff *skb, u16 *p1k);
+static inline void ieee80211_get_tkip_p1k(struct ieee80211_key_conf *keyconf,
+					  struct sk_buff *skb, u16 *p1k)
+{
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+	const u8 *data = (u8 *)hdr + ieee80211_hdrlen(hdr->frame_control);
+	u32 iv32 = get_unaligned_le32(&data[4]);
+
+	ieee80211_get_tkip_p1k_iv(keyconf, iv32, p1k);
+}
 
 /**
  * ieee80211_get_tkip_p2k - get a TKIP phase 2 key
--- a/net/mac80211/tkip.c	2011-07-06 12:45:34.000000000 +0200
+++ b/net/mac80211/tkip.c	2011-07-06 13:30:50.000000000 +0200
@@ -170,15 +170,12 @@ static void ieee80211_compute_tkip_p1k(s
 		tkip_mixing_phase1(tk, ctx, sdata->vif.addr, iv32);
 }
 
-void ieee80211_get_tkip_p1k(struct ieee80211_key_conf *keyconf,
-			    struct sk_buff *skb, u16 *p1k)
+void ieee80211_get_tkip_p1k_iv(struct ieee80211_key_conf *keyconf,
+			       u32 iv32, u16 *p1k)
 {
 	struct ieee80211_key *key = (struct ieee80211_key *)
 			container_of(keyconf, struct ieee80211_key, conf);
 	struct tkip_ctx *ctx = &key->u.tkip.tx;
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
-	const u8 *data = (u8 *)hdr + ieee80211_hdrlen(hdr->frame_control);
-	u32 iv32 = get_unaligned_le32(&data[4]);
 	unsigned long flags;
 
 	spin_lock_irqsave(&key->u.tkip.txlock, flags);
@@ -186,7 +183,7 @@ void ieee80211_get_tkip_p1k(struct ieee8
 	memcpy(p1k, ctx->p1k, sizeof(ctx->p1k));
 	spin_unlock_irqrestore(&key->u.tkip.txlock, flags);
 }
-EXPORT_SYMBOL(ieee80211_get_tkip_p1k);
+EXPORT_SYMBOL(ieee80211_get_tkip_p1k_iv);
 
 void ieee80211_get_tkip_p2k(struct ieee80211_key_conf *keyconf,
 			    struct sk_buff *skb, u8 *p2k)


