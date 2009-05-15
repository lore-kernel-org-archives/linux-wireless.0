Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:51079 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758876AbZEOJiq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 May 2009 05:38:46 -0400
Date: Fri, 15 May 2009 12:38:32 +0300
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] nl80211: Validate NL80211_ATTR_KEY_SEQ length
Message-ID: <20090515093832.GA2421@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Validate RSC (NL80211_ATTR_KEY_SEQ) length in nl80211/cfg80211 instead
of having to do this in all the drivers.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

---
 net/mac80211/key.c     |    6 +++---
 net/wireless/nl80211.c |    1 +
 net/wireless/util.c    |   15 +++++++++++++++
 3 files changed, 19 insertions(+), 3 deletions(-)

--- uml.orig/net/mac80211/key.c	2009-05-15 12:15:34.000000000 +0300
+++ uml/net/mac80211/key.c	2009-05-15 12:24:48.000000000 +0300
@@ -320,7 +320,7 @@ struct ieee80211_key *ieee80211_key_allo
 	case ALG_TKIP:
 		key->conf.iv_len = TKIP_IV_LEN;
 		key->conf.icv_len = TKIP_ICV_LEN;
-		if (seq && seq_len == 6) {
+		if (seq) {
 			for (i = 0; i < NUM_RX_DATA_QUEUES; i++) {
 				key->u.tkip.rx[i].iv32 =
 					get_unaligned_le32(&seq[2]);
@@ -332,7 +332,7 @@ struct ieee80211_key *ieee80211_key_allo
 	case ALG_CCMP:
 		key->conf.iv_len = CCMP_HDR_LEN;
 		key->conf.icv_len = CCMP_MIC_LEN;
-		if (seq && seq_len == CCMP_PN_LEN) {
+		if (seq) {
 			for (i = 0; i < NUM_RX_DATA_QUEUES; i++)
 				for (j = 0; j < CCMP_PN_LEN; j++)
 					key->u.ccmp.rx_pn[i][j] =
@@ -342,7 +342,7 @@ struct ieee80211_key *ieee80211_key_allo
 	case ALG_AES_CMAC:
 		key->conf.iv_len = 0;
 		key->conf.icv_len = sizeof(struct ieee80211_mmie);
-		if (seq && seq_len == 6)
+		if (seq)
 			for (j = 0; j < 6; j++)
 				key->u.aes_cmac.rx_pn[j] = seq[6 - j - 1];
 		break;
--- uml.orig/net/wireless/nl80211.c	2009-05-15 12:13:26.000000000 +0300
+++ uml/net/wireless/nl80211.c	2009-05-15 12:30:44.000000000 +0300
@@ -77,6 +77,7 @@ static struct nla_policy nl80211_policy[
 	[NL80211_ATTR_KEY_IDX] = { .type = NLA_U8 },
 	[NL80211_ATTR_KEY_CIPHER] = { .type = NLA_U32 },
 	[NL80211_ATTR_KEY_DEFAULT] = { .type = NLA_FLAG },
+	[NL80211_ATTR_KEY_SEQ] = { .type = NLA_BINARY, .len = 8 },
 
 	[NL80211_ATTR_BEACON_INTERVAL] = { .type = NLA_U32 },
 	[NL80211_ATTR_DTIM_PERIOD] = { .type = NLA_U32 },
--- uml.orig/net/wireless/util.c	2009-05-15 12:29:21.000000000 +0300
+++ uml/net/wireless/util.c	2009-05-15 12:30:25.000000000 +0300
@@ -181,5 +181,20 @@ int cfg80211_validate_key_settings(struc
 		return -EINVAL;
 	}
 
+	if (params->seq) {
+		switch (params->cipher) {
+		case WLAN_CIPHER_SUITE_WEP40:
+		case WLAN_CIPHER_SUITE_WEP104:
+			/* These ciphers do not use key sequence */
+			return -EINVAL;
+		case WLAN_CIPHER_SUITE_TKIP:
+		case WLAN_CIPHER_SUITE_CCMP:
+		case WLAN_CIPHER_SUITE_AES_CMAC:
+			if (params->seq_len != 6)
+				return -EINVAL;
+			break;
+		}
+	}
+
 	return 0;
 }

-- 
Jouni Malinen                                            PGP id EFC895FA
