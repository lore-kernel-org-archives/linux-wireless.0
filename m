Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:35733 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755297AbYFQQBD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jun 2008 12:01:03 -0400
Message-Id: <20080617160008.473796805@localhost> (sfid-20080617_180143_352695_72482E12)
References: <20080617154008.883383150@localhost>
Date: Tue, 17 Jun 2008 18:40:14 +0300
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [RFC PATCH 6/7] 802.11w: WEXT configuration for IGTK
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Added new SIOCSIWENCODEEXT algorithm for configuring BIP (AES-CMAC)
keys (IGTK).

Signed-off-by: Jouni Malinen <j@w1.fi>


Index: wireless-testing/include/linux/wireless.h
===================================================================
--- wireless-testing.orig/include/linux/wireless.h
+++ wireless-testing/include/linux/wireless.h
@@ -615,6 +615,7 @@
 #define IW_ENCODE_ALG_TKIP	2
 #define IW_ENCODE_ALG_CCMP	3
 #define IW_ENCODE_ALG_PMK	4
+#define IW_ENCODE_ALG_AES_CMAC	5
 /* struct iw_encode_ext ->ext_flags */
 #define IW_ENCODE_EXT_TX_SEQ_VALID	0x00000001
 #define IW_ENCODE_EXT_RX_SEQ_VALID	0x00000002
Index: wireless-testing/net/mac80211/wext.c
===================================================================
--- wireless-testing.orig/net/mac80211/wext.c
+++ wireless-testing/net/mac80211/wext.c
@@ -40,7 +40,14 @@ static int ieee80211_set_encryption(stru
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
-	if (idx < 0 || idx >= NUM_DEFAULT_KEYS) {
+	if (alg == ALG_AES_CMAC) {
+		if (idx < NUM_DEFAULT_KEYS ||
+		    idx >= NUM_DEFAULT_KEYS + NUM_DEFAULT_MGMT_KEYS) {
+			printk(KERN_DEBUG "%s: set_encrypt - invalid idx=%d "
+			       "(BIP)\n", dev->name, idx);
+			return -EINVAL;
+		}
+	} else if (idx < 0 || idx >= NUM_DEFAULT_KEYS) {
 		printk(KERN_DEBUG "%s: set_encrypt - invalid idx=%d\n",
 		       dev->name, idx);
 		return -EINVAL;
@@ -99,6 +106,9 @@ static int ieee80211_set_encryption(stru
 
 		if (set_tx_key || (!sta && !sdata->default_key && key))
 			ieee80211_set_default_key(sdata, idx);
+		if (alg == ALG_AES_CMAC &&
+		    (set_tx_key || (!sta && !sdata->default_mgmt_key && key)))
+			ieee80211_set_default_mgmt_key(sdata, idx);
 	}
 
  out_unlock:
@@ -1076,6 +1086,9 @@ static int ieee80211_ioctl_siwencodeext(
 	case IW_ENCODE_ALG_CCMP:
 		alg = ALG_CCMP;
 		break;
+	case IW_ENCODE_ALG_AES_CMAC:
+		alg = ALG_AES_CMAC;
+		break;
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -1084,20 +1097,41 @@ static int ieee80211_ioctl_siwencodeext(
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
 
 	return ieee80211_set_encryption(dev, ext->addr.sa_data, idx, alg,
 					remove,

--

-- 
Jouni Malinen                                            PGP id EFC895FA
