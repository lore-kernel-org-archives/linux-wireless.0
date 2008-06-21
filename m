Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ruslug.rutgers.edu ([165.230.139.146]:36764 "EHLO
	ruslug.rutgers.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbYFUOCt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Jun 2008 10:02:49 -0400
Date: Sat, 21 Jun 2008 10:02:46 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH v2] mac80211: Let drivers have access to TKIP key offets for TX and RX MIC
Message-ID: <20080621140246.GJ17936@ruslug.rutgers.edu> (sfid-20080621_160253_325228_ED2F254E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some drivers may want to to use the TKIP key offsets for TX and RX
MIC so lets move this out. Lets also clear up a bit how this is used
internally in mac80211.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 include/linux/nl80211.h |    5 ++++-
 include/net/mac80211.h  |    7 ++++++-
 net/mac80211/key.h      |   37 ++++++++++++-------------------------
 net/mac80211/tkip.c     |   10 +++++-----
 net/mac80211/wpa.c      |   20 ++++++++++++++------
 5 files changed, 41 insertions(+), 38 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index aa8411e..2be7c63 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -241,7 +241,10 @@ enum nl80211_attrs {
 	NL80211_ATTR_MAX = __NL80211_ATTR_AFTER_LAST - 1
 };
 
-#define NL80211_MAX_SUPP_RATES	32
+#define NL80211_MAX_SUPP_RATES			32
+#define NL80211_TKIP_DATA_OFFSET_ENCR_KEY	0
+#define NL80211_TKIP_DATA_OFFSET_TX_MIC_KEY	16
+#define NL80211_TKIP_DATA_OFFSET_RX_MIC_KEY	24
 
 /**
  * enum nl80211_iftype - (virtual) interface types
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 7ab4ff6..19f1e41 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -595,7 +595,12 @@ enum ieee80211_key_flags {
  * @flags: key flags, see &enum ieee80211_key_flags.
  * @keyidx: the key index (0-3)
  * @keylen: key material length
- * @key: key material
+ * @key: key material. For ALG_TKIP the key is encoded as a 256-bit (32 byte)
+ * 	data block:
+ * 	- Temporal Encryption Key (128 bits)
+ * 	- Temporal Authenticator Tx MIC Key (64 bits)
+ * 	- Temporal Authenticator Rx MIC Key (64 bits)
+ *
  */
 struct ieee80211_key_conf {
 	enum ieee80211_key_alg alg;
diff --git a/net/mac80211/key.h b/net/mac80211/key.h
index a0f774a..425816e 100644
--- a/net/mac80211/key.h
+++ b/net/mac80211/key.h
@@ -16,31 +16,18 @@
 #include <linux/rcupdate.h>
 #include <net/mac80211.h>
 
-/* ALG_TKIP
- * struct ieee80211_key::key is encoded as a 256-bit (32 byte) data block:
- * Temporal Encryption Key (128 bits)
- * Temporal Authenticator Tx MIC Key (64 bits)
- * Temporal Authenticator Rx MIC Key (64 bits)
- */
-
-#define WEP_IV_LEN 4
-#define WEP_ICV_LEN 4
-
-#define ALG_TKIP_KEY_LEN 32
-/* Starting offsets for each key */
-#define ALG_TKIP_TEMP_ENCR_KEY 0
-#define ALG_TKIP_TEMP_AUTH_TX_MIC_KEY 16
-#define ALG_TKIP_TEMP_AUTH_RX_MIC_KEY 24
-#define TKIP_IV_LEN 8
-#define TKIP_ICV_LEN 4
-
-#define ALG_CCMP_KEY_LEN 16
-#define CCMP_HDR_LEN 8
-#define CCMP_MIC_LEN 8
-#define CCMP_TK_LEN 16
-#define CCMP_PN_LEN 6
-
-#define NUM_RX_DATA_QUEUES 17
+#define WEP_IV_LEN		4
+#define WEP_ICV_LEN		4
+#define ALG_TKIP_KEY_LEN	32
+#define ALG_CCMP_KEY_LEN	16
+#define CCMP_HDR_LEN		8
+#define CCMP_MIC_LEN		8
+#define CCMP_TK_LEN		16
+#define CCMP_PN_LEN		6
+#define TKIP_IV_LEN		8
+#define TKIP_ICV_LEN		4
+
+#define NUM_RX_DATA_QUEUES	17
 
 struct ieee80211_local;
 struct ieee80211_sub_if_data;
diff --git a/net/mac80211/tkip.c b/net/mac80211/tkip.c
index e710243..40922b9 100644
--- a/net/mac80211/tkip.c
+++ b/net/mac80211/tkip.c
@@ -164,7 +164,7 @@ void ieee80211_get_tkip_key(struct ieee80211_key_conf *keyconf,
 	iv16 = data[2] | (data[0] << 8);
 	iv32 = get_unaligned_le32(&data[4]);
 
-	tk = &key->conf.key[ALG_TKIP_TEMP_ENCR_KEY];
+	tk = &key->conf.key[NL80211_TKIP_DATA_OFFSET_ENCR_KEY];
 	ctx = &key->u.tkip.tx;
 
 #ifdef CONFIG_TKIP_DEBUG
@@ -205,7 +205,7 @@ void ieee80211_tkip_encrypt_data(struct crypto_blkcipher *tfm,
 {
 	u8 rc4key[16];
 	struct tkip_ctx *ctx = &key->u.tkip.tx;
-	const u8 *tk = &key->conf.key[ALG_TKIP_TEMP_ENCR_KEY];
+	const u8 *tk = &key->conf.key[NL80211_TKIP_DATA_OFFSET_ENCR_KEY];
 
 	/* Calculate per-packet key */
 	if (ctx->iv16 == 0 || !ctx->initialized)
@@ -231,7 +231,7 @@ int ieee80211_tkip_decrypt_data(struct crypto_blkcipher *tfm,
 	u32 iv16;
 	u8 rc4key[16], keyid, *pos = payload;
 	int res;
-	const u8 *tk = &key->conf.key[ALG_TKIP_TEMP_ENCR_KEY];
+	const u8 *tk = &key->conf.key[NL80211_TKIP_DATA_OFFSET_ENCR_KEY];
 
 	if (payload_len < 12)
 		return -1;
@@ -286,13 +286,13 @@ int ieee80211_tkip_decrypt_data(struct crypto_blkcipher *tfm,
 #ifdef CONFIG_TKIP_DEBUG
 		{
 			int i;
+			u8 key_offset = NL80211_TKIP_DATA_OFFSET_ENCR_KEY;
 			DECLARE_MAC_BUF(mac);
 			printk(KERN_DEBUG "TKIP decrypt: Phase1 TA=%s"
 			       " TK=", print_mac(mac, ta));
 			for (i = 0; i < 16; i++)
 				printk("%02x ",
-				       key->conf.key[
-						ALG_TKIP_TEMP_ENCR_KEY + i]);
+				       key->conf.key[key_offset + i]);
 			printk("\n");
 			printk(KERN_DEBUG "TKIP decrypt: P1K=");
 			for (i = 0; i < 5; i++)
diff --git a/net/mac80211/wpa.c b/net/mac80211/wpa.c
index 345e10e..f809761 100644
--- a/net/mac80211/wpa.c
+++ b/net/mac80211/wpa.c
@@ -49,7 +49,7 @@ static int ieee80211_get_hdr_info(const struct sk_buff *skb, u8 **sa, u8 **da,
 ieee80211_tx_result
 ieee80211_tx_h_michael_mic_add(struct ieee80211_tx_data *tx)
 {
-	u8 *data, *sa, *da, *key, *mic, qos_tid;
+	u8 *data, *sa, *da, *key, *mic, qos_tid, key_offset;
 	size_t data_len;
 	u16 fc;
 	struct sk_buff *skb = tx->skb;
@@ -88,8 +88,12 @@ ieee80211_tx_h_michael_mic_add(struct ieee80211_tx_data *tx)
 #else
 	authenticator = 1;
 #endif
-	key = &tx->key->conf.key[authenticator ? ALG_TKIP_TEMP_AUTH_TX_MIC_KEY :
-				 ALG_TKIP_TEMP_AUTH_RX_MIC_KEY];
+	/* At this point we know we're using ALG_TKIP. To get the MIC key
+	 * we now will rely on the offset from the ieee80211_key_conf::key */
+	key_offset = authenticator ?
+		NL80211_TKIP_DATA_OFFSET_TX_MIC_KEY :
+		NL80211_TKIP_DATA_OFFSET_RX_MIC_KEY;
+	key = &tx->key->conf.key[key_offset];
 	mic = skb_put(skb, MICHAEL_MIC_LEN);
 	michael_mic(key, da, sa, qos_tid & 0x0f, data, data_len, mic);
 
@@ -100,7 +104,7 @@ ieee80211_tx_h_michael_mic_add(struct ieee80211_tx_data *tx)
 ieee80211_rx_result
 ieee80211_rx_h_michael_mic_verify(struct ieee80211_rx_data *rx)
 {
-	u8 *data, *sa, *da, *key = NULL, qos_tid;
+	u8 *data, *sa, *da, *key = NULL, qos_tid, key_offset;
 	size_t data_len;
 	u16 fc;
 	u8 mic[MICHAEL_MIC_LEN];
@@ -131,8 +135,12 @@ ieee80211_rx_h_michael_mic_verify(struct ieee80211_rx_data *rx)
 #else
 	authenticator = 1;
 #endif
-	key = &rx->key->conf.key[authenticator ? ALG_TKIP_TEMP_AUTH_RX_MIC_KEY :
-				 ALG_TKIP_TEMP_AUTH_TX_MIC_KEY];
+	/* At this point we know we're using ALG_TKIP. To get the MIC key
+	 * we now will rely on the offset from the ieee80211_key_conf::key */
+	key_offset = authenticator ?
+		NL80211_TKIP_DATA_OFFSET_RX_MIC_KEY :
+		NL80211_TKIP_DATA_OFFSET_TX_MIC_KEY;
+	key = &rx->key->conf.key[key_offset];
 	michael_mic(key, da, sa, qos_tid & 0x0f, data, data_len, mic);
 	if (memcmp(mic, data + data_len, MICHAEL_MIC_LEN) != 0 || wpa_test) {
 		if (!(rx->flags & IEEE80211_RX_RA_MATCH))
-- 
1.5.5.3

