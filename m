Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:54315 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937905AbYCSXtr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Mar 2008 19:49:47 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 4/7] mac80211: get a TKIP phase key from skb
Date: Wed, 19 Mar 2008 16:41:43 -0700
Message-Id: <1205970106-22196-5-git-send-email-reinette.chatre@intel.com> (sfid-20080319_235019_846003_5E2A97BC)
In-Reply-To: <1205970106-22196-4-git-send-email-reinette.chatre@intel.com>
References: <1205970106-22196-1-git-send-email-reinette.chatre@intel.com>
 <1205970106-22196-2-git-send-email-reinette.chatre@intel.com>
 <1205970106-22196-3-git-send-email-reinette.chatre@intel.com>
 <1205970106-22196-4-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This patch makes mac80211 able to compute a TKIP key from an skb.
The requested key can be a phase 1 or a phase 2 key.
This is useful for drivers who need to provide tkip key to their
HW to enable HW encryption.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 include/net/mac80211.h |   30 +++++++++++++++++++++++++++
 net/mac80211/tkip.c    |   53 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 83 insertions(+), 0 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 5ab6a35..4b35f64 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -644,6 +644,21 @@ enum sta_notify_cmd {
 };
 
 /**
+ * enum ieee80211_tkip_key_type - get tkip key
+ *
+ * Used by drivers which need to get a tkip key for skb. Some drivers need a
+ * phase 1 key, others need a phase 2 key. A single function allows the driver
+ * to get the key, this enum indicates what type of key is required.
+ *
+ * @IEEE80211_TKIP_P1_KEY: the driver needs a phase 1 key
+ * @IEEE80211_TKIP_P2_KEY: the driver needs a phase 2 key
+ */
+enum ieee80211_tkip_key_type {
+	IEEE80211_TKIP_P1_KEY	= 1<<0,
+	IEEE80211_TKIP_P2_KEY	= 1<<1,
+};
+
+/**
  * enum ieee80211_hw_flags - hardware flags
  *
  * These flags are used to indicate hardware capabilities to
@@ -1472,6 +1487,21 @@ int ieee80211_get_hdrlen_from_skb(const struct sk_buff *skb);
 int ieee80211_get_hdrlen(u16 fc);
 
 /**
+ * ieee80211_get_tkip_rc4_key - get a phase 2 key for skb
+ *
+ * This function computes a phase 2 key for an skb. It computes
+ * a phase 1 key if needed (iv16 wraps around). This function is to
+ * be used by drivers which can do HW encryption but need to compute
+ * to phase 2 key in SW.
+ *
+ * @keyconf: the parameter passed with the set key
+ * @skb: the skb for which the key is needed
+ * @rc4key: a buffer to which the key will be written
+ */
+void ieee80211_get_tkip_key(struct ieee80211_key_conf *keyconf,
+				struct sk_buff *skb,
+				enum ieee80211_tkip_key_type type, u8 *key);
+/**
  * ieee80211_wake_queue - wake specific queue
  * @hw: pointer as obtained from ieee80211_alloc_hw().
  * @queue: queue number (counted from zero).
diff --git a/net/mac80211/tkip.c b/net/mac80211/tkip.c
index 3abe194..5c36b2d 100644
--- a/net/mac80211/tkip.c
+++ b/net/mac80211/tkip.c
@@ -214,6 +214,59 @@ void ieee80211_tkip_gen_rc4key(struct ieee80211_key *key, u8 *ta,
 			   key->u.tkip.iv16, rc4key);
 }
 
+void ieee80211_get_tkip_key(struct ieee80211_key_conf *keyconf,
+			struct sk_buff *skb, enum ieee80211_tkip_key_type type,
+			u8 *outkey)
+{
+	struct ieee80211_key *key = (struct ieee80211_key *)
+			container_of(keyconf, struct ieee80211_key, conf);
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
+	u8 *data = (u8 *) hdr;
+	u16 fc = le16_to_cpu(hdr->frame_control);
+	int hdr_len = ieee80211_get_hdrlen(fc);
+	u8 *ta = hdr->addr2;
+	u16 iv16;
+	u32 iv32;
+
+	iv16 = data[hdr_len] << 8;
+	iv16 += data[hdr_len + 2];
+	iv32 = data[hdr_len + 4] +
+		(data[hdr_len + 5] >> 8) +
+		(data[hdr_len + 6] >> 16) +
+		(data[hdr_len + 7] >> 24);
+
+#ifdef CONFIG_TKIP_DEBUG
+	printk(KERN_DEBUG "TKIP encrypt: iv16 = 0x%04x, iv32 = 0x%08x\n",
+			iv16, iv32);
+
+	if (iv32 != key->u.tkip.iv32) {
+		printk(KERN_DEBUG "skb: iv32 = 0x%08x key: iv32 = 0x%08x\n",
+			iv32, key->u.tkip.iv32);
+		printk(KERN_DEBUG "Wrap around of iv16 in the middle of a "
+			"fragmented packet\n");
+	}
+#endif /* CONFIG_TKIP_DEBUG */
+
+	/* Update the p1k only when the iv16 in the packet wraps around, this
+	 * might occur after the wrap around of iv16 in the key in case of
+	 * fragmented packets. */
+	if (iv16 == 0 || !key->u.tkip.tx_initialized) {
+		/* IV16 wrapped around - perform TKIP phase 1 */
+		tkip_mixing_phase1(ta, &key->conf.key[ALG_TKIP_TEMP_ENCR_KEY],
+			iv32, key->u.tkip.p1k);
+		key->u.tkip.tx_initialized = 1;
+	}
+
+	if (type == IEEE80211_TKIP_P1_KEY) {
+		memcpy(outkey, key->u.tkip.p1k, sizeof(u16) * 5);
+		return;
+	}
+
+	tkip_mixing_phase2(key->u.tkip.p1k,
+		&key->conf.key[ALG_TKIP_TEMP_ENCR_KEY],	iv16, outkey);
+}
+EXPORT_SYMBOL(ieee80211_get_tkip_key);
+
 /* Encrypt packet payload with TKIP using @key. @pos is a pointer to the
  * beginning of the buffer containing payload. This payload must include
  * headroom of eight octets for IV and Ext. IV and taildroom of four octets
-- 
1.5.3.4

