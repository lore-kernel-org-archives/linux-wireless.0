Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:34034 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752594AbZAGL2R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jan 2009 06:28:17 -0500
Message-Id: <20090107112707.370907962@atheros.com> (sfid-20090107_123904_503223_F4BC7E3B)
References: <20090107112346.369581673@atheros.com>
Date: Wed, 07 Jan 2009 13:23:58 +0200
From: Jouni Malinen <j@w1.fi>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Jouni Malinen <jouni.malinen@atheros.com>
Subject: [PATCH 12/14] mac80211: 802.11w - Optional software CCMP for management frames
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If driver/firmware/hardware does not support CCMP for management
frames, it can now request mac80211 to take care of encryption and
decryption of management frames (when MFP is enabled) in software. The
driver will need to add this new IEEE80211_KEY_FLAG_SW_MGMT flag when a
CCMP key is being configured for TX side and return the encrypted frames
on RX side without RX_FLAG_DECRYPTED flag to use software CCMP for
management frames (but hardware for data frames).

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>


---
 include/net/mac80211.h |    4 ++++
 net/mac80211/wpa.c     |    9 +++++++--
 2 files changed, 11 insertions(+), 2 deletions(-)

--- wireless-testing.orig/include/net/mac80211.h	2009-01-07 13:07:49.000000000 +0200
+++ wireless-testing/include/net/mac80211.h	2009-01-07 13:08:07.000000000 +0200
@@ -692,12 +692,16 @@ enum ieee80211_key_len {
  *	generation in software.
  * @IEEE80211_KEY_FLAG_PAIRWISE: Set by mac80211, this flag indicates
  *	that the key is pairwise rather then a shared key.
+ * @IEEE80211_KEY_FLAG_SW_MGMT: This flag should be set by the driver for a
+ *	CCMP key if it requires CCMP encryption of management frames (MFP) to
+ *	be done in software.
  */
 enum ieee80211_key_flags {
 	IEEE80211_KEY_FLAG_WMM_STA	= 1<<0,
 	IEEE80211_KEY_FLAG_GENERATE_IV	= 1<<1,
 	IEEE80211_KEY_FLAG_GENERATE_MMIC= 1<<2,
 	IEEE80211_KEY_FLAG_PAIRWISE	= 1<<3,
+	IEEE80211_KEY_FLAG_SW_MGMT	= 1<<4,
 };
 
 /**
--- wireless-testing.orig/net/mac80211/wpa.c	2009-01-07 13:07:46.000000000 +0200
+++ wireless-testing/net/mac80211/wpa.c	2009-01-07 13:08:07.000000000 +0200
@@ -369,9 +369,14 @@ static int ccmp_encrypt_skb(struct ieee8
 	int hdrlen, len, tail;
 	u8 *pos, *pn;
 	int i;
+	bool skip_hw;
+
+	skip_hw = (tx->key->conf.flags & IEEE80211_KEY_FLAG_SW_MGMT) &&
+		ieee80211_is_mgmt(hdr->frame_control);
 
 	if ((tx->key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE) &&
-	    !(tx->key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_IV)) {
+	    !(tx->key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_IV) &&
+	    !skip_hw) {
 		/* hwaccel - with no need for preallocated room for CCMP
 		 * header or MIC fields */
 		info->control.hw_key = &tx->key->conf;
@@ -406,7 +411,7 @@ static int ccmp_encrypt_skb(struct ieee8
 
 	ccmp_pn2hdr(pos, pn, key->conf.keyidx);
 
-	if (key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE) {
+	if ((key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE) && !skip_hw) {
 		/* hwaccel - with preallocated room for CCMP header */
 		info->control.hw_key = &tx->key->conf;
 		return 0;

-- 

-- 
Jouni Malinen                                            PGP id EFC895FA
