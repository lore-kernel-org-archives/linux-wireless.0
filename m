Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:39355 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751072AbYIQHKH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Sep 2008 03:10:07 -0400
Date: Wed, 17 Sep 2008 12:39:49 +0530
From: Senthil Balasubramanian <senthilkumar@atheros.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Jouni Malinen <jouni.malinen@atheros.com>
Subject: [PATCH] ath9k: connectivity is lost after Group rekeying is done
Message-ID: <20080917070949.GA7727@senthil-lnx.users.atheros.com> (sfid-20080917_091025_012069_27A29BD0)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Connectivtiy is lost after Group rekeying is done. The keytype
maintained by ath9k is reset when group key is updated. Though
sc_keytype can be reset only for broadcast key the proper fix
would be to use mac80211 provided key type from txinfo during
xmit and get rid of sc_keytype from ath9k ath_softc.

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
---
 drivers/net/wireless/ath9k/core.h |    1 -
 drivers/net/wireless/ath9k/main.c |    3 ---
 drivers/net/wireless/ath9k/xmit.c |    6 +++---
 3 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath9k/core.h b/drivers/net/wireless/ath9k/core.h
index b66de29..e8ccbe4 100644
--- a/drivers/net/wireless/ath9k/core.h
+++ b/drivers/net/wireless/ath9k/core.h
@@ -976,7 +976,6 @@ struct ath_softc {
 	u32 sc_keymax;		/* size of key cache */
 	DECLARE_BITMAP(sc_keymap, ATH_KEYMAX);	/* key use bit map */
 	u8 sc_splitmic;		/* split TKIP MIC keys */
-	int sc_keytype;
 
 	/* RX */
 	struct list_head sc_rxbuf;
diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index 1ba1800..aca893a 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -204,8 +204,6 @@ static int ath_key_config(struct ath_softc *sc,
 	if (!ret)
 		return -EIO;
 
-	if (mac)
-		sc->sc_keytype = hk.kv_type;
 	return 0;
 }
 
@@ -1507,7 +1505,6 @@ static int ath9k_set_key(struct ieee80211_hw *hw,
 	case DISABLE_KEY:
 		ath_key_delete(sc, key);
 		clear_bit(key->keyidx, sc->sc_keymap);
-		sc->sc_keytype = ATH9K_CIPHER_CLR;
 		break;
 	default:
 		ret = -EINVAL;
diff --git a/drivers/net/wireless/ath9k/xmit.c b/drivers/net/wireless/ath9k/xmit.c
index 3fc6641..2592905 100644
--- a/drivers/net/wireless/ath9k/xmit.c
+++ b/drivers/net/wireless/ath9k/xmit.c
@@ -239,11 +239,11 @@ static int ath_tx_prepare(struct ath_softc *sc,
 		txctl->keyix = tx_info->control.hw_key->hw_key_idx;
 		txctl->frmlen += tx_info->control.icv_len;
 
-		if (sc->sc_keytype == ATH9K_CIPHER_WEP)
+		if (tx_info->control.hw_key->alg == ALG_WEP)
 			txctl->keytype = ATH9K_KEY_TYPE_WEP;
-		else if (sc->sc_keytype == ATH9K_CIPHER_TKIP)
+		else if (tx_info->control.hw_key->alg == ALG_TKIP)
 			txctl->keytype = ATH9K_KEY_TYPE_TKIP;
-		else if (sc->sc_keytype == ATH9K_CIPHER_AES_CCM)
+		else if (tx_info->control.hw_key->alg == ALG_CCMP)
 			txctl->keytype = ATH9K_KEY_TYPE_AES;
 	}
 
-- 
1.5.5

