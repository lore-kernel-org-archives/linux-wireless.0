Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:44052 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751284Ab2FWRXp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jun 2012 13:23:45 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com,
	sgruszka@redhat.com
Subject: [PATCH 3.5] ath9k: fix dynamic WEP related regression
Date: Sat, 23 Jun 2012 19:23:31 +0200
Message-Id: <1340472211-762-1-git-send-email-nbd@openwrt.org> (sfid-20120623_192425_325946_3543E5D8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

commit 7a532fe7131216a02c81a6c1b1f8632da1195a58
ath9k_hw: fix interpretation of the rx KeyMiss flag

This commit used the rx key miss indication to detect packets that were
passed from the hardware without being decrypted, however it seems that
this bit is not only undefined in the static WEP case, but also for
dynamically allocated WEP keys. This caused a regression when using
WEP-LEAP.

This patch fixes the regression by keeping track of which key indexes
refer to CCMP keys and only using the key miss indication for those.

Reported-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Cc: stable@vger.kernel.org
---
 drivers/net/wireless/ath/ath.h        |    1 +
 drivers/net/wireless/ath/ath9k/recv.c |    3 ++-
 drivers/net/wireless/ath/key.c        |    4 ++++
 3 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath.h b/drivers/net/wireless/ath/ath.h
index c54b7d37..420d69b 100644
--- a/drivers/net/wireless/ath/ath.h
+++ b/drivers/net/wireless/ath/ath.h
@@ -143,6 +143,7 @@ struct ath_common {
 	u32 keymax;
 	DECLARE_BITMAP(keymap, ATH_KEYMAX);
 	DECLARE_BITMAP(tkip_keymap, ATH_KEYMAX);
+	DECLARE_BITMAP(ccmp_keymap, ATH_KEYMAX);
 	enum ath_crypt_caps crypt_caps;
 
 	unsigned int clockrate;
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index e1fcc68..599667a 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -822,7 +822,8 @@ static bool ath9k_rx_accept(struct ath_common *common,
 	 * descriptor does contain a valid key index. This has been observed
 	 * mostly with CCMP encryption.
 	 */
-	if (rx_stats->rs_keyix == ATH9K_RXKEYIX_INVALID)
+	if (rx_stats->rs_keyix == ATH9K_RXKEYIX_INVALID ||
+	    !test_bit(rx_stats->rs_keyix, common->ccmp_keymap))
 		rx_stats->rs_status &= ~ATH9K_RXERR_KEYMISS;
 
 	if (!rx_stats->rs_datalen) {
diff --git a/drivers/net/wireless/ath/key.c b/drivers/net/wireless/ath/key.c
index 0e81904..5c54aa4 100644
--- a/drivers/net/wireless/ath/key.c
+++ b/drivers/net/wireless/ath/key.c
@@ -556,6 +556,9 @@ int ath_key_config(struct ath_common *common,
 		return -EIO;
 
 	set_bit(idx, common->keymap);
+	if (key->cipher == WLAN_CIPHER_SUITE_CCMP)
+		set_bit(idx, common->ccmp_keymap);
+
 	if (key->cipher == WLAN_CIPHER_SUITE_TKIP) {
 		set_bit(idx + 64, common->keymap);
 		set_bit(idx, common->tkip_keymap);
@@ -582,6 +585,7 @@ void ath_key_delete(struct ath_common *common, struct ieee80211_key_conf *key)
 		return;
 
 	clear_bit(key->hw_key_idx, common->keymap);
+	clear_bit(key->hw_key_idx, common->ccmp_keymap);
 	if (key->cipher != WLAN_CIPHER_SUITE_TKIP)
 		return;
 
-- 
1.7.3.2

