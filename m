Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4804 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755190Ab1HZNT5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Aug 2011 09:19:57 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 05/13] staging: brcm80211: rename key endian conversion
 functions
Date: Fri, 26 Aug 2011 15:19:32 +0200
Message-ID: <1314364780-9462-6-git-send-email-rvossen@broadcom.com> (sfid-20110826_152018_978344_40CAEBBC)
In-Reply-To: <1314364780-9462-1-git-send-email-rvossen@broadcom.com>
References: <1314364780-9462-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The key endian conversion functions in wl_cfg80211.c have been
renamed as the old names were misleasing.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
index 80bb30a..8b052b0 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
@@ -215,8 +215,8 @@ static s32 brcmf_add_keyext(struct wiphy *wiphy, struct net_device *dev,
 /*
 ** key indianess swap utilities
 */
-static void swap_key_from_BE(struct brcmf_wsec_key *key);
-static void swap_key_to_BE(struct brcmf_wsec_key *key);
+static void convert_key_from_CPU(struct brcmf_wsec_key *key);
+static void convert_key_to_CPU(struct brcmf_wsec_key *key);
 
 /*
 ** brcmf_cfg80211_priv memory init/deinit utilities
@@ -509,7 +509,7 @@ static const u32 __wl_cipher_suites[] = {
 	WLAN_CIPHER_SUITE_AES_CMAC,
 };
 
-static void swap_key_from_BE(struct brcmf_wsec_key *key)
+static void convert_key_from_CPU(struct brcmf_wsec_key *key)
 {
 	key->index = cpu_to_le32(key->index);
 	key->len = cpu_to_le32(key->len);
@@ -520,7 +520,7 @@ static void swap_key_from_BE(struct brcmf_wsec_key *key)
 	key->iv_initialized = cpu_to_le32(key->iv_initialized);
 }
 
-static void swap_key_to_BE(struct brcmf_wsec_key *key)
+static void convert_key_to_CPU(struct brcmf_wsec_key *key)
 {
 	key->index = le32_to_cpu(key->index);
 	key->len = le32_to_cpu(key->len);
@@ -1344,7 +1344,7 @@ brcmf_set_set_sharedkey(struct net_device *dev,
 			WL_CONN("key length (%d) key index (%d) algo (%d)\n",
 			       key.len, key.index, key.algo);
 			WL_CONN("key \"%s\"\n", key.data);
-			swap_key_from_BE(&key);
+			convert_key_from_CPU(&key);
 			err = brcmf_dev_ioctl(dev, BRCMF_C_SET_KEY, &key,
 					sizeof(key));
 			if (unlikely(err)) {
@@ -1612,7 +1612,7 @@ brcmf_add_keyext(struct wiphy *wiphy, struct net_device *dev,
 	/* check for key index change */
 	if (key.len == 0) {
 		/* key delete */
-		swap_key_from_BE(&key);
+		convert_key_from_CPU(&key);
 		err = brcmf_dev_ioctl(dev, BRCMF_C_SET_KEY, &key, sizeof(key));
 		if (unlikely(err)) {
 			WL_ERR("key delete error (%d)\n", err);
@@ -1670,7 +1670,7 @@ brcmf_add_keyext(struct wiphy *wiphy, struct net_device *dev,
 			WL_ERR("Invalid cipher (0x%x)\n", params->cipher);
 			return -EINVAL;
 		}
-		swap_key_from_BE(&key);
+		convert_key_from_CPU(&key);
 
 		brcmf_netdev_wait_pend8021x(dev);
 		err = brcmf_dev_ioctl(dev, BRCMF_C_SET_KEY, &key, sizeof(key));
@@ -1745,7 +1745,7 @@ brcmf_cfg80211_add_key(struct wiphy *wiphy, struct net_device *dev,
 	}
 
 	/* Set the new key/index */
-	swap_key_from_BE(&key);
+	convert_key_from_CPU(&key);
 	err = brcmf_dev_ioctl(dev, BRCMF_C_SET_KEY, &key, sizeof(key));
 	if (unlikely(err)) {
 		WL_ERR("WLC_SET_KEY error (%d)\n", err);
@@ -1795,7 +1795,7 @@ brcmf_cfg80211_del_key(struct wiphy *wiphy, struct net_device *dev,
 
 	WL_CONN("key index (%d)\n", key_idx);
 	/* Set the new key/index */
-	swap_key_from_BE(&key);
+	convert_key_from_CPU(&key);
 	err = brcmf_dev_ioctl(dev, BRCMF_C_SET_KEY, &key, sizeof(key));
 	if (unlikely(err)) {
 		if (err == -EINVAL) {
@@ -1859,7 +1859,7 @@ brcmf_cfg80211_get_key(struct wiphy *wiphy, struct net_device *dev,
 
 	memset(&key, 0, sizeof(key));
 	key.index = key_idx;
-	swap_key_to_BE(&key);
+	convert_key_to_CPU(&key);
 	memset(&params, 0, sizeof(params));
 	params.key_len = (u8) min_t(u8, WLAN_MAX_KEY_LEN, key.len);
 	memcpy(params.key, key.data, params.key_len);
-- 
1.7.4.1


