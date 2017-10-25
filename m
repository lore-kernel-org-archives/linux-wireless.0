Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:48896 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932316AbdJYJHk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 25 Oct 2017 05:07:40 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: don't compare TKIP TX MIC key in reinstall prevention
Date: Wed, 25 Oct 2017 11:07:36 +0200
Message-Id: <20171025090736.11739-1-johannes@sipsolutions.net> (sfid-20171025_110744_035538_3D71331B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

For the reinstall prevention, the code I had added compares the
whole key. It turns out though that iwlwifi firmware doesn't
provide the TKIP TX MIC key as it's not needed in client mode,
and thus the comparison will always return false.

For client mode, thus always zero out the TX MIC key part before
doing the comparison in order to avoid accepting the reinstall
of the key with identical encryption and RX MIC key, but not the
same TX MIC key (since the supplicant provides the real one.)

Fixes: fdf7cb4185b6 ("mac80211: accept key reinstall without changing anything")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/key.c | 36 ++++++++++++++++++++++++++++++++++--
 1 file changed, 34 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index 035d16fe926e..938049395f90 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -610,6 +610,39 @@ void ieee80211_key_free_unused(struct ieee80211_key *key)
 	ieee80211_key_free_common(key);
 }
 
+static bool ieee80211_key_identical(struct ieee80211_sub_if_data *sdata,
+				    struct ieee80211_key *old,
+				    struct ieee80211_key *new)
+{
+	u8 tkip_old[WLAN_KEY_LEN_TKIP], tkip_new[WLAN_KEY_LEN_TKIP];
+	u8 *tk_old, *tk_new;
+
+	if (!old || new->conf.keylen != old->conf.keylen)
+		return false;
+
+	tk_old = old->conf.key;
+	tk_new = new->conf.key;
+
+	/*
+	 * In station mode, don't compare the TX MIC key, as it's never used
+	 * and offloaded rekeying may not care to send it to the host. This
+	 * is the case in iwlwifi, for example.
+	 */
+	if (sdata->vif.type == NL80211_IFTYPE_STATION &&
+	    new->conf.cipher == WLAN_CIPHER_SUITE_TKIP &&
+	    new->conf.keylen == WLAN_KEY_LEN_TKIP &&
+	    !(new->conf.flags & IEEE80211_KEY_FLAG_PAIRWISE)) {
+		memcpy(tkip_old, tk_old, WLAN_KEY_LEN_TKIP);
+		memcpy(tkip_new, tk_new, WLAN_KEY_LEN_TKIP);
+		memset(tkip_old + NL80211_TKIP_DATA_OFFSET_TX_MIC_KEY, 0, 8);
+		memset(tkip_new + NL80211_TKIP_DATA_OFFSET_TX_MIC_KEY, 0, 8);
+		tk_old = tkip_old;
+		tk_new = tkip_new;
+	}
+
+	return !crypto_memneq(tk_old, tk_new, new->conf.keylen);
+}
+
 int ieee80211_key_link(struct ieee80211_key *key,
 		       struct ieee80211_sub_if_data *sdata,
 		       struct sta_info *sta)
@@ -635,8 +668,7 @@ int ieee80211_key_link(struct ieee80211_key *key,
 	 * Silently accept key re-installation without really installing the
 	 * new version of the key to avoid nonce reuse or replay issues.
 	 */
-	if (old_key && key->conf.keylen == old_key->conf.keylen &&
-	    !crypto_memneq(key->conf.key, old_key->conf.key, key->conf.keylen)) {
+	if (ieee80211_key_identical(sdata, old_key, key)) {
 		ieee80211_key_free_unused(key);
 		ret = 0;
 		goto out;
-- 
2.14.2
