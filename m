Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:52228 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993214AbbEEOlB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 May 2015 10:41:01 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 2/2] mac80211: extend get_key() to return PN for all ciphers
Date: Tue,  5 May 2015 16:40:57 +0200
Message-Id: <1430836857-4393-2-git-send-email-johannes@sipsolutions.net> (sfid-20150505_194356_959938_EFBA72B1)
In-Reply-To: <1430836857-4393-1-git-send-email-johannes@sipsolutions.net>
References: <1430836857-4393-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

For ciphers not supported by mac80211, the function currently
doesn't return any PN data. Fix this by extending the driver's
get_key_seq() a little more to allow moving arbitrary PN data.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h | 7 +++++++
 net/mac80211/cfg.c     | 9 +++++++++
 net/mac80211/key.c     | 4 ++--
 net/mac80211/key.h     | 3 +--
 4 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index d719812759fc..c49840fe980f 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1501,6 +1501,8 @@ struct ieee80211_key_conf {
 	u8 key[0];
 };
 
+#define IEEE80211_MAX_PN_LEN	16
+
 /**
  * struct ieee80211_key_seq - key sequence counter
  *
@@ -1513,6 +1515,7 @@ struct ieee80211_key_conf {
  *	reverse order than in packet)
  * @gcmp: PN data, most significant byte first (big endian,
  *	reverse order than in packet)
+ * @hw: data for HW-only (e.g. cipher scheme) keys
  */
 struct ieee80211_key_seq {
 	union {
@@ -1532,6 +1535,10 @@ struct ieee80211_key_seq {
 		struct {
 			u8 pn[6];
 		} gcmp;
+		struct {
+			u8 seq[IEEE80211_MAX_PN_LEN];
+			u8 seq_len;
+		} hw;
 	};
 };
 
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index dd7014b09396..3469bbdc891c 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -431,6 +431,15 @@ static int ieee80211_get_key(struct wiphy *wiphy, struct net_device *dev,
 		params.seq = seq;
 		params.seq_len = 6;
 		break;
+	default:
+		if (!(key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE))
+			break;
+		if (WARN_ON(key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_IV))
+			break;
+		drv_get_key_seq(sdata->local, key, &kseq);
+		params.seq = kseq.hw.seq;
+		params.seq_len = kseq.hw.seq_len;
+		break;
 	}
 
 	params.key = key->conf.key;
diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index 3e0b814f4db3..0a5d5c5ad30f 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -485,8 +485,8 @@ ieee80211_key_alloc(u32 cipher, int idx, size_t key_len,
 		break;
 	default:
 		if (cs) {
-			size_t len = (seq_len > MAX_PN_LEN) ?
-						MAX_PN_LEN : seq_len;
+			size_t len = (seq_len > IEEE80211_MAX_PN_LEN) ?
+						IEEE80211_MAX_PN_LEN : seq_len;
 
 			key->conf.iv_len = cs->hdr_len;
 			key->conf.icv_len = cs->mic_len;
diff --git a/net/mac80211/key.h b/net/mac80211/key.h
index c5a31835be0e..df430a618764 100644
--- a/net/mac80211/key.h
+++ b/net/mac80211/key.h
@@ -18,7 +18,6 @@
 
 #define NUM_DEFAULT_KEYS 4
 #define NUM_DEFAULT_MGMT_KEYS 2
-#define MAX_PN_LEN 16
 
 struct ieee80211_local;
 struct ieee80211_sub_if_data;
@@ -116,7 +115,7 @@ struct ieee80211_key {
 		} gcmp;
 		struct {
 			/* generic cipher scheme */
-			u8 rx_pn[IEEE80211_NUM_TIDS + 1][MAX_PN_LEN];
+			u8 rx_pn[IEEE80211_NUM_TIDS + 1][IEEE80211_MAX_PN_LEN];
 		} gen;
 	} u;
 
-- 
2.1.4

