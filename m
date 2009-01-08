Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:43566 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754944AbZAHLdr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jan 2009 06:33:47 -0500
Message-Id: <20090108113336.845643864@atheros.com> (sfid-20090108_123351_121276_12888B40)
References: <20090108113158.681894124@atheros.com>
Date: Thu, 08 Jan 2009 13:32:03 +0200
From: Jouni Malinen <j@w1.fi>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
Subject: [PATCHv2 05/16] mac80211: 802.11w - WEXT parameter for setting mgmt cipher
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

--- wireless-testing.orig/include/linux/wireless.h	2009-01-08 13:03:43.000000000 +0200
+++ wireless-testing/include/linux/wireless.h	2009-01-08 13:06:29.000000000 +0200
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
--- wireless-testing.orig/net/mac80211/wext.c	2009-01-08 13:05:41.000000000 +0200
+++ wireless-testing/net/mac80211/wext.c	2009-01-08 13:06:29.000000000 +0200
@@ -922,6 +922,7 @@ static int ieee80211_ioctl_siwauth(struc
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
