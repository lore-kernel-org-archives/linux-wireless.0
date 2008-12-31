Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:46709 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755144AbYLaPmZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Dec 2008 10:42:25 -0500
Message-Id: <20081231154217.012384698@w1.fi> (sfid-20081231_164228_827006_DCBD1747)
References: <20081231153834.840526845@w1.fi>
Date: Wed, 31 Dec 2008 17:38:39 +0200
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
Subject: [RFC 05/11] mac80211: 802.11w - WEXT parameter for setting mgmt cipher
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add a new IW_AUTH parameter for setting cipher suite for
multicast/broadcast management frames. This is for full-mac drivers
that take care of RSN IE generation for (re)association request frames.

Signed-off-by: Jouni Malinen <j@w1.fi>


---
 include/linux/wireless.h |    5 ++++-
 net/mac80211/wext.c      |    1 +
 2 files changed, 5 insertions(+), 1 deletion(-)

--- wireless-testing.orig/include/linux/wireless.h	2008-12-31 17:08:47.000000000 +0200
+++ wireless-testing/include/linux/wireless.h	2008-12-31 17:10:50.000000000 +0200
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
--- wireless-testing.orig/net/mac80211/wext.c	2008-12-31 17:08:47.000000000 +0200
+++ wireless-testing/net/mac80211/wext.c	2008-12-31 17:10:50.000000000 +0200
@@ -913,6 +913,7 @@ static int ieee80211_ioctl_siwauth(struc
 	case IW_AUTH_WPA_ENABLED:
 	case IW_AUTH_RX_UNENCRYPTED_EAPOL:
 	case IW_AUTH_KEY_MGMT:
+	case IW_AUTH_CIPHER_GROUP_MGMT:
 		break;
 	case IW_AUTH_CIPHER_PAIRWISE:
 		if (sdata->vif.type == NL80211_IFTYPE_STATION) {

-- 

-- 
Jouni Malinen                                            PGP id EFC895FA
