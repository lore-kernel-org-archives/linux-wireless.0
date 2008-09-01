Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:39792 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751333AbYIAOP2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Sep 2008 10:15:28 -0400
Date: Mon, 1 Sep 2008 19:45:21 +0530
From: Senthil Balasubramanian <senthilkumar@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Jouni Malinen <jouni.malinen@atheros.com>
Subject: [PATCH] ath9k: Incorrect key used when group and pairwise ciphers
	are different.
Message-ID: <20080901141521.GA6106@senthil-lnx.users.atheros.com> (sfid-20080901_161532_856632_CBA88016)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Updating sc_keytype multiple times when groupwise and pairwise
ciphers are different results in incorrect pairwise key type
assumed for TX control and normal ping fails. This works fine
for cases where both groupwise and pairwise ciphers are same.

Also use mac80211 provided enums for key length calculation.

Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
---
 drivers/net/wireless/ath9k/hw.c   |    8 ++++----
 drivers/net/wireless/ath9k/main.c |    6 ++++--
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
index 2578411..4ccbbc0 100644
--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -7236,15 +7236,15 @@ ath9k_hw_set_keycache_entry(struct ath_hal *ah, u16 entry,
 		}
 		break;
 	case ATH9K_CIPHER_WEP:
-		if (k->kv_len < 40 / NBBY) {
+		if (k->kv_len < LEN_WEP40) {
 			DPRINTF(ah->ah_sc, ATH_DBG_KEYCACHE,
 				 "%s: WEP key length %u too small\n",
 				 __func__, k->kv_len);
 			return false;
 		}
-		if (k->kv_len <= 40 / NBBY)
+		if (k->kv_len <= LEN_WEP40)
 			keyType = AR_KEYTABLE_TYPE_40;
-		else if (k->kv_len <= 104 / NBBY)
+		else if (k->kv_len <= LEN_WEP104)
 			keyType = AR_KEYTABLE_TYPE_104;
 		else
 			keyType = AR_KEYTABLE_TYPE_128;
@@ -7264,7 +7264,7 @@ ath9k_hw_set_keycache_entry(struct ath_hal *ah, u16 entry,
 	key2 = get_unaligned_le32(k->kv_val + 6) ^ xorMask;
 	key3 = (get_unaligned_le16(k->kv_val + 10) ^ xorMask) & 0xffff;
 	key4 = get_unaligned_le32(k->kv_val + 12) ^ xorMask;
-	if (k->kv_len <= 104 / NBBY)
+	if (k->kv_len <= LEN_WEP104)
 		key4 &= 0xff;
 
 	if (keyType == AR_KEYTABLE_TYPE_TKIP && ATH9K_IS_MIC_ENABLED(ah)) {
diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index dc45eef..72c9f8b 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -204,7 +204,8 @@ static int ath_key_config(struct ath_softc *sc,
 	if (!ret)
 		return -EIO;
 
-	sc->sc_keytype = hk.kv_type;
+	if (mac)
+		sc->sc_keytype = hk.kv_type;
 	return 0;
 }
 
@@ -781,7 +782,8 @@ static int ath9k_set_key(struct ieee80211_hw *hw,
 			key->hw_key_idx = key->keyidx;
 			/* push IV and Michael MIC generation to stack */
 			key->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
-			key->flags |= IEEE80211_KEY_FLAG_GENERATE_MMIC;
+			if (key->alg == ALG_TKIP)
+				key->flags |= IEEE80211_KEY_FLAG_GENERATE_MMIC;
 		}
 		break;
 	case DISABLE_KEY:
-- 
1.5.5

