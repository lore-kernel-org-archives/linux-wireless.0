Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:43574 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755081AbZAHLdv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jan 2009 06:33:51 -0500
Message-Id: <20090108113340.903414148@atheros.com> (sfid-20090108_123355_106474_484038E9)
References: <20090108113158.681894124@atheros.com>
Date: Thu, 08 Jan 2009 13:32:04 +0200
From: Jouni Malinen <j@w1.fi>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
Subject: [PATCHv2 06/16] mac80211: 802.11w - WEXT configuration for IGTK
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Added new SIOCSIWENCODEEXT algorithm for configuring BIP (AES-CMAC)
keys (IGTK).

Signed-off-by: Jouni Malinen <j@w1.fi>


---
 include/linux/wireless.h |    1 
 net/mac80211/wext.c      |   62 ++++++++++++++++++++++++++++++++++++-----------
 2 files changed, 49 insertions(+), 14 deletions(-)

--- wireless-testing.orig/include/linux/wireless.h	2009-01-08 13:06:29.000000000 +0200
+++ wireless-testing/include/linux/wireless.h	2009-01-08 13:06:33.000000000 +0200
@@ -615,6 +615,7 @@
 #define IW_ENCODE_ALG_TKIP	2
 #define IW_ENCODE_ALG_CCMP	3
 #define IW_ENCODE_ALG_PMK	4
+#define IW_ENCODE_ALG_AES_CMAC	5
 /* struct iw_encode_ext ->ext_flags */
 #define IW_ENCODE_EXT_TX_SEQ_VALID	0x00000001
 #define IW_ENCODE_EXT_RX_SEQ_VALID	0x00000002
--- wireless-testing.orig/net/mac80211/wext.c	2009-01-08 13:06:29.000000000 +0200
+++ wireless-testing/net/mac80211/wext.c	2009-01-08 13:06:33.000000000 +0200
@@ -37,7 +37,14 @@ static int ieee80211_set_encryption(stru
 	struct ieee80211_key *key;
 	int err;
 
-	if (idx < 0 || idx >= NUM_DEFAULT_KEYS) {
+	if (alg == ALG_AES_CMAC) {
+		if (idx < NUM_DEFAULT_KEYS ||
+		    idx >= NUM_DEFAULT_KEYS + NUM_DEFAULT_MGMT_KEYS) {
+			printk(KERN_DEBUG "%s: set_encrypt - invalid idx=%d "
+			       "(BIP)\n", sdata->dev->name, idx);
+			return -EINVAL;
+		}
+	} else if (idx < 0 || idx >= NUM_DEFAULT_KEYS) {
 		printk(KERN_DEBUG "%s: set_encrypt - invalid idx=%d\n",
 		       sdata->dev->name, idx);
 		return -EINVAL;
@@ -103,6 +110,9 @@ static int ieee80211_set_encryption(stru
 
 		if (set_tx_key || (!sta && !sdata->default_key && key))
 			ieee80211_set_default_key(sdata, idx);
+		if (alg == ALG_AES_CMAC &&
+		    (set_tx_key || (!sta && !sdata->default_mgmt_key && key)))
+			ieee80211_set_default_mgmt_key(sdata, idx);
 	}
 
  out_unlock:
@@ -1043,6 +1053,9 @@ static int ieee80211_ioctl_siwencodeext(
 	case IW_ENCODE_ALG_CCMP:
 		alg = ALG_CCMP;
 		break;
+	case IW_ENCODE_ALG_AES_CMAC:
+		alg = ALG_AES_CMAC;
+		break;
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -1051,20 +1064,41 @@ static int ieee80211_ioctl_siwencodeext(
 		remove = 1;
 
 	idx = erq->flags & IW_ENCODE_INDEX;
-	if (idx < 1 || idx > 4) {
-		idx = -1;
-		if (!sdata->default_key)
-			idx = 0;
-		else for (i = 0; i < NUM_DEFAULT_KEYS; i++) {
-			if (sdata->default_key == sdata->keys[i]) {
-				idx = i;
-				break;
+	if (alg == ALG_AES_CMAC) {
+		if (idx < NUM_DEFAULT_KEYS + 1 ||
+		    idx > NUM_DEFAULT_KEYS + NUM_DEFAULT_MGMT_KEYS) {
+			idx = -1;
+			if (!sdata->default_mgmt_key)
+				idx = 0;
+			else for (i = NUM_DEFAULT_KEYS;
+				  i < NUM_DEFAULT_KEYS + NUM_DEFAULT_MGMT_KEYS;
+				  i++) {
+				if (sdata->default_mgmt_key == sdata->keys[i])
+				{
+					idx = i;
+					break;
+				}
 			}
-		}
-		if (idx < 0)
-			return -EINVAL;
-	} else
-		idx--;
+			if (idx < 0)
+				return -EINVAL;
+		} else
+			idx--;
+	} else {
+		if (idx < 1 || idx > 4) {
+			idx = -1;
+			if (!sdata->default_key)
+				idx = 0;
+			else for (i = 0; i < NUM_DEFAULT_KEYS; i++) {
+				if (sdata->default_key == sdata->keys[i]) {
+					idx = i;
+					break;
+				}
+			}
+			if (idx < 0)
+				return -EINVAL;
+		} else
+			idx--;
+	}
 
 	return ieee80211_set_encryption(sdata, ext->addr.sa_data, idx, alg,
 					remove,

-- 

-- 
Jouni Malinen                                            PGP id EFC895FA
