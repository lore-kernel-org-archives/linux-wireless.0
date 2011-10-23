Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41955 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543Ab1JWGVt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Oct 2011 02:21:49 -0400
Received: by bkbzt19 with SMTP id zt19so6690457bkb.19
        for <linux-wireless@vger.kernel.org>; Sat, 22 Oct 2011 23:21:48 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH] mac80211: support adding IV-room in the skb for CCMP keys
Date: Sun, 23 Oct 2011 08:21:41 +0200
Message-Id: <1319350901-31178-1-git-send-email-arik@wizery.com> (sfid-20111023_082158_059761_2C8C327D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some cards can generate CCMP IVs in HW, but require the space for the IV
to be pre-allocated in the frame at the correct offset. Add a key flag
that allows us to achieve this.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 include/net/mac80211.h |    5 +++++
 net/mac80211/key.c     |    9 +++++++--
 net/mac80211/wpa.c     |    8 +++++++-
 3 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index cd108df..a3ea227 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -899,6 +899,10 @@ static inline bool ieee80211_vif_is_mesh(struct ieee80211_vif *vif)
  * @IEEE80211_KEY_FLAG_SW_MGMT: This flag should be set by the driver for a
  *	CCMP key if it requires CCMP encryption of management frames (MFP) to
  *	be done in software.
+ * @IEEE80211_KEY_FLAG_PUT_IV_SPACE: This flag should be set by the driver
+ *	for a CCMP key if space should be prepared for the IV, but the IV
+ *	itself should not be generated. Do not set together with
+ *	@IEEE80211_KEY_FLAG_GENERATE_IV on the same key.
  */
 enum ieee80211_key_flags {
 	IEEE80211_KEY_FLAG_WMM_STA	= 1<<0,
@@ -906,6 +910,7 @@ enum ieee80211_key_flags {
 	IEEE80211_KEY_FLAG_GENERATE_MMIC= 1<<2,
 	IEEE80211_KEY_FLAG_PAIRWISE	= 1<<3,
 	IEEE80211_KEY_FLAG_SW_MGMT	= 1<<4,
+	IEEE80211_KEY_FLAG_PUT_IV_SPACE = 1<<5,
 };
 
 /**
diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index 756b157..17a5220 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -133,9 +133,13 @@ static int ieee80211_key_enable_hw_accel(struct ieee80211_key *key)
 		key->flags |= KEY_FLAG_UPLOADED_TO_HARDWARE;
 
 		if (!((key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_MMIC) ||
-		      (key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_IV)))
+		      (key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_IV) ||
+		      (key->conf.flags & IEEE80211_KEY_FLAG_PUT_IV_SPACE)))
 			sdata->crypto_tx_tailroom_needed_cnt--;
 
+		WARN_ON((key->conf.flags & IEEE80211_KEY_FLAG_PUT_IV_SPACE) &&
+			(key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_IV));
+
 		return 0;
 	}
 
@@ -178,7 +182,8 @@ static void ieee80211_key_disable_hw_accel(struct ieee80211_key *key)
 	sdata = key->sdata;
 
 	if (!((key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_MMIC) ||
-	      (key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_IV)))
+	      (key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_IV) ||
+	      (key->conf.flags & IEEE80211_KEY_FLAG_PUT_IV_SPACE)))
 		increment_tailroom_need_count(sdata);
 
 	if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
diff --git a/net/mac80211/wpa.c b/net/mac80211/wpa.c
index 7bc8702..ae58f4d 100644
--- a/net/mac80211/wpa.c
+++ b/net/mac80211/wpa.c
@@ -389,7 +389,8 @@ static int ccmp_encrypt_skb(struct ieee80211_tx_data *tx, struct sk_buff *skb)
 	u8 scratch[6 * AES_BLOCK_SIZE];
 
 	if (info->control.hw_key &&
-	    !(info->control.hw_key->flags & IEEE80211_KEY_FLAG_GENERATE_IV)) {
+	    !(info->control.hw_key->flags & IEEE80211_KEY_FLAG_GENERATE_IV) &&
+	    !(info->control.hw_key->flags & IEEE80211_KEY_FLAG_PUT_IV_SPACE)) {
 		/*
 		 * hwaccel has no need for preallocated room for CCMP
 		 * header or MIC fields
@@ -411,6 +412,11 @@ static int ccmp_encrypt_skb(struct ieee80211_tx_data *tx, struct sk_buff *skb)
 
 	pos = skb_push(skb, CCMP_HDR_LEN);
 	memmove(pos, pos + CCMP_HDR_LEN, hdrlen);
+
+	/* the HW only needs room for the IV, but not the actual IV */
+	if (info->control.hw_key->flags & IEEE80211_KEY_FLAG_PUT_IV_SPACE)
+		return 0;
+
 	hdr = (struct ieee80211_hdr *) pos;
 	pos += hdrlen;
 
-- 
1.7.5.4

