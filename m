Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:42651 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872Ab1IUPNe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Sep 2011 11:13:34 -0400
Date: Wed, 21 Sep 2011 18:11:33 +0300
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] cfg80211: Remove strict validation of AKM suites
Message-ID: <20110921151133.GA32016@jouni.qca.qualcomm.com> (sfid-20110921_171338_172873_5DC301F1)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

NL80211_ATTR_AKM_SUITES can be used to configure new AKMs, like FT or
the SHA-256 -based AKMs or FT from 802.11r/802.11w. In addition, vendor
specific AKMs could be used. The current validation code for the connect
command prevents cfg80211-based drivers from using these mechanisms even
if the driver would not actually use this AKM value (i.e., it uses
WPA/RSN IE from user space). mac80211-based drivers allow any AKM to be
used since this value is not used there.

Remove the unnecessary validation step in cfg80211 to allow drivers to
decide what AKMs are supported. In theory, we could handle this by
advertising supported AKMs, but that would not be very effective unless
we enforce all drivers (including mac80211) to advertise the set of
supported AKMs. This would require additional changes in many places
whenever a new AKM is introduced even though no actually functionality
changes may be required in most drivers.

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 net/wireless/nl80211.c |   12 +-----------
 1 files changed, 1 insertions(+), 11 deletions(-)

(this is on top of the "cfg80211: Fix validation of AKM suites" patch I
sent earlier today)


diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index c26a1da..fd4da99 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4126,12 +4126,6 @@ static bool nl80211_valid_wpa_versions(u32 wpa_versions)
 				  NL80211_WPA_VERSION_2));
 }
 
-static bool nl80211_valid_akm_suite(u32 akm)
-{
-	return akm == WLAN_AKM_SUITE_8021X ||
-		akm == WLAN_AKM_SUITE_PSK;
-}
-
 static bool nl80211_valid_cipher_suite(u32 cipher)
 {
 	return cipher == WLAN_CIPHER_SUITE_WEP40 ||
@@ -4295,7 +4289,7 @@ static int nl80211_crypto_settings(struct cfg80211_registered_device *rdev,
 
 	if (info->attrs[NL80211_ATTR_AKM_SUITES]) {
 		void *data;
-		int len, i;
+		int len;
 
 		data = nla_data(info->attrs[NL80211_ATTR_AKM_SUITES]);
 		len = nla_len(info->attrs[NL80211_ATTR_AKM_SUITES]);
@@ -4308,10 +4302,6 @@ static int nl80211_crypto_settings(struct cfg80211_registered_device *rdev,
 			return -EINVAL;
 
 		memcpy(settings->akm_suites, data, len);
-
-		for (i = 0; i < settings->n_akm_suites; i++)
-			if (!nl80211_valid_akm_suite(settings->akm_suites[i]))
-				return -EINVAL;
 	}
 
 	return 0;
-- 
1.7.4.1


-- 
Jouni Malinen                                            PGP id EFC895FA
