Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30s.wh2.ocn.ne.jp ([125.206.180.198]:29905 "HELO
	mail30s.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752908Ab1AYEPv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Jan 2011 23:15:51 -0500
Received: from vs3006.wh2.ocn.ne.jp (125.206.180.169)
	by mail30s.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 2-0372278950
	for <linux-wireless@vger.kernel.org>; Tue, 25 Jan 2011 13:15:50 +0900 (JST)
Subject: [PATCH 6/6] ath: Fix WEP hardware encryption
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Date: Tue, 25 Jan 2011 13:15:49 +0900
Message-ID: <20110125041549.6944.15800.stgit@localhost6.localdomain6>
In-Reply-To: <20110125041522.6944.22566.stgit@localhost6.localdomain6>
References: <20110125041522.6944.22566.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In AP mode hardware encryption for WEP was not used on the RX side because
there was a mismatch in the key indices. The key index in the WLAN header is
0-3 while the hardware key cache was configured for key indices >= 4. This is
ok for transmit but received packets were not decrypted in HW and therefore
mac80211 had to decrypt them in SW - this can be easily seen by adding some
debug prints in mac80211/wep.c (around line 296). I have noticed it by watching
the system CPU load under high traffic.

This patch configures WEP keys into the "standard" key indices 0-4 which were
reserved for that.

Tested with ath5k on a 600MHz mips board the difference is ~15% CPU load (with
this patch) vs. ~45% CPU load (before) when the AP receives 28Mbps of WEP
encrypted data.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 drivers/net/wireless/ath/key.c |   14 +++++++++++---
 1 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/key.c b/drivers/net/wireless/ath/key.c
index 5d465e5..5748dae 100644
--- a/drivers/net/wireless/ath/key.c
+++ b/drivers/net/wireless/ath/key.c
@@ -465,6 +465,16 @@ int ath_key_config(struct ath_common *common,
 	hk.kv_len = key->keylen;
 	memcpy(hk.kv_val, key->key, key->keylen);
 
+	/* set WEP keys directly to index */
+	if ((key->cipher == WLAN_CIPHER_SUITE_WEP40 ||
+	     key->cipher == WLAN_CIPHER_SUITE_WEP104) && key->keyidx < 4) {
+		ret = ath_hw_set_keycache_entry(common, key->keyidx, &hk, NULL);
+		if (!ret)
+			return -EIO;
+		set_bit(key->keyidx, common->keymap);
+		return key->keyidx;
+	}
+
 	if (!(key->flags & IEEE80211_KEY_FLAG_PAIRWISE)) {
 		switch (vif->type) {
 		case NL80211_IFTYPE_AP:
@@ -541,10 +551,8 @@ EXPORT_SYMBOL(ath_key_config);
 void ath_key_delete(struct ath_common *common, struct ieee80211_key_conf *key)
 {
 	ath_hw_keyreset(common, key->hw_key_idx);
-	if (key->hw_key_idx < IEEE80211_WEP_NKID)
-		return;
-
 	clear_bit(key->hw_key_idx, common->keymap);
+
 	if (key->cipher != WLAN_CIPHER_SUITE_TKIP)
 		return;
 

