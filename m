Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:56226 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757676AbYFQQAn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jun 2008 12:00:43 -0400
Message-Id: <20080617155949.830340514@localhost> (sfid-20080617_180055_709783_4502BD3B)
References: <20080617154008.883383150@localhost>
Date: Tue, 17 Jun 2008 18:40:13 +0300
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [RFC PATCH 5/7] 802.11w: WEXT parameter for setting mgmt cipher
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add a new IW_AUTH parameter for setting cipher suite for
multicast/broadcast management frames. This is for full-mac drivers
that take care of RSN IE generation for (re)association request frames.

Signed-off-by: Jouni Malinen <j@w1.fi>


Index: wireless-testing/include/linux/wireless.h
===================================================================
--- wireless-testing.orig/include/linux/wireless.h
+++ wireless-testing/include/linux/wireless.h
@@ -577,18 +577,21 @@
 #define IW_AUTH_RX_UNENCRYPTED_EAPOL	8
 #define IW_AUTH_ROAMING_CONTROL		9
 #define IW_AUTH_PRIVACY_INVOKED		10
+#define IW_AUTH_CIPHER_GROUP_MGMT	11
 
 /* IW_AUTH_WPA_VERSION values (bit field) */
 #define IW_AUTH_WPA_VERSION_DISABLED	0x00000001
 #define IW_AUTH_WPA_VERSION_WPA		0x00000002
 #define IW_AUTH_WPA_VERSION_WPA2	0x00000004
 
-/* IW_AUTH_PAIRWISE_CIPHER and IW_AUTH_GROUP_CIPHER values (bit field) */
+/* IW_AUTH_PAIRWISE_CIPHER, IW_AUTH_GROUP_CIPHER, and IW_AUTH_CIPHER_GROUP_MGMT
+ * values (bit field) */
 #define IW_AUTH_CIPHER_NONE	0x00000001
 #define IW_AUTH_CIPHER_WEP40	0x00000002
 #define IW_AUTH_CIPHER_TKIP	0x00000004
 #define IW_AUTH_CIPHER_CCMP	0x00000008
 #define IW_AUTH_CIPHER_WEP104	0x00000010
+#define IW_AUTH_CIPHER_AES_CMAC	0x00000020
 
 /* IW_AUTH_KEY_MGMT values (bit field) */
 #define IW_AUTH_KEY_MGMT_802_1X	1
Index: wireless-testing/net/mac80211/wext.c
===================================================================
--- wireless-testing.orig/net/mac80211/wext.c
+++ wireless-testing/net/mac80211/wext.c
@@ -966,6 +966,7 @@ static int ieee80211_ioctl_siwauth(struc
 	case IW_AUTH_WPA_ENABLED:
 	case IW_AUTH_RX_UNENCRYPTED_EAPOL:
 	case IW_AUTH_KEY_MGMT:
+	case IW_AUTH_CIPHER_GROUP_MGMT:
 		break;
 	case IW_AUTH_DROP_UNENCRYPTED:
 		sdata->drop_unencrypted = !!data->value;

--

-- 
Jouni Malinen                                            PGP id EFC895FA
