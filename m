Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40995 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758081Ab1FVVAa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jun 2011 17:00:30 -0400
Received: by wyb38 with SMTP id 38so854408wyb.19
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jun 2011 14:00:29 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH v2] mac80211: fix rx->key NULL dereference during mic failure
Date: Thu, 23 Jun 2011 00:00:24 +0300
Message-Id: <1308776424-12109-1-git-send-email-arik@wizery.com> (sfid-20110622_230033_916576_AC5E16DC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sometimes when reporting a MIC failure rx->key may be unset. This
code path is hit when receiving a packet meant for a multicast
address, and decryption is performed in HW.

Fortunately, the failing key_idx is not used for anything up to
(and including) usermode, so we allow ourselves to drop it on the
way up when a key cannot be retrieved.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 include/net/cfg80211.h |    2 +-
 net/mac80211/wpa.c     |    8 +++++++-
 net/wireless/nl80211.c |    3 ++-
 3 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 727131b..53be73e 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2687,7 +2687,7 @@ void cfg80211_send_unprot_disassoc(struct net_device *dev, const u8 *buf,
  * @dev: network device
  * @addr: The source MAC address of the frame
  * @key_type: The key type that the received frame used
- * @key_id: Key identifier (0..3)
+ * @key_id: Key identifier (0..3). Can be -1 if missing.
  * @tsc: The TSC value of the frame that generated the MIC failure (6 octets)
  * @gfp: allocation flags
  *
diff --git a/net/mac80211/wpa.c b/net/mac80211/wpa.c
index 9dc3b5f..d91c1a2 100644
--- a/net/mac80211/wpa.c
+++ b/net/mac80211/wpa.c
@@ -154,7 +154,13 @@ update_iv:
 	return RX_CONTINUE;
 
 mic_fail:
-	mac80211_ev_michael_mic_failure(rx->sdata, rx->key->conf.keyidx,
+	/*
+	 * In some cases the key can be unset - e.g. a multicast packet, in
+	 * a driver that supports HW encryption. Send up the key idx only if
+	 * the key is set.
+	 */
+	mac80211_ev_michael_mic_failure(rx->sdata,
+					rx->key ? rx->key->conf.keyidx : -1,
 					(void *) skb->data, NULL, GFP_ATOMIC);
 	return RX_DROP_UNUSABLE;
 }
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index ec83f41..785549d 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -6464,7 +6464,8 @@ void nl80211_michael_mic_failure(struct cfg80211_registered_device *rdev,
 	if (addr)
 		NLA_PUT(msg, NL80211_ATTR_MAC, ETH_ALEN, addr);
 	NLA_PUT_U32(msg, NL80211_ATTR_KEY_TYPE, key_type);
-	NLA_PUT_U8(msg, NL80211_ATTR_KEY_IDX, key_id);
+	if (key_id != -1)
+		NLA_PUT_U8(msg, NL80211_ATTR_KEY_IDX, key_id);
 	if (tsc)
 		NLA_PUT(msg, NL80211_ATTR_KEY_SEQ, 6, tsc);
 
-- 
1.7.4.1

