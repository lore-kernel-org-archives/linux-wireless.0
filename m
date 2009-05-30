Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f176.google.com ([209.85.219.176]:56827 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762592AbZE3RhT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 May 2009 13:37:19 -0400
Received: by mail-ew0-f176.google.com with SMTP id 24so6938274ewy.37
        for <linux-wireless@vger.kernel.org>; Sat, 30 May 2009 10:37:20 -0700 (PDT)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: orinoco-devel@lists.sourceforge.net,
	David Kilroy <kilroyd@googlemail.com>
Subject: [RFC v2 05/23] cfg80211: infer WPA and WPA2 support from TKIP and CCMP
Date: Sat, 30 May 2009 18:36:39 +0100
Message-Id: <1243705017-8784-6-git-send-email-kilroyd@googlemail.com>
In-Reply-To: <1243705017-8784-1-git-send-email-kilroyd@googlemail.com>
References: <1243705017-8784-1-git-send-email-kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: David Kilroy <kilroyd@googlemail.com>
---
Not sure if this is how we want to detect WPA/WPA2 capability, but from
what I've read this is valid. An alternative would be to add a
capabilities flag to struct wiphy.
---
 net/wireless/wext-compat.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/wireless/wext-compat.c b/net/wireless/wext-compat.c
index e5385f0..f090737 100644
--- a/net/wireless/wext-compat.c
+++ b/net/wireless/wext-compat.c
@@ -201,15 +201,15 @@ int cfg80211_wext_giwrange(struct net_device *dev,
 	range->avg_qual.noise = range->max_qual.noise / 2;
 	range->avg_qual.updated = range->max_qual.updated;
 
-	range->enc_capa = IW_ENC_CAPA_WPA | IW_ENC_CAPA_WPA2;
-
 	for (c = 0; c < wdev->wiphy->n_cipher_suites; c++) {
 		u32 suite = wdev->wiphy->cipher_suites[c];
 
 		if (suite == WLAN_CIPHER_SUITE_TKIP)
-			range->enc_capa |= IW_ENC_CAPA_CIPHER_TKIP;
+			range->enc_capa |= (IW_ENC_CAPA_CIPHER_TKIP |
+					    IW_ENC_CAPA_WPA);
 		else if (suite == WLAN_CIPHER_SUITE_CCMP)
-			range->enc_capa |= IW_ENC_CAPA_CIPHER_CCMP;
+			range->enc_capa |= (IW_ENC_CAPA_CIPHER_CCMP |
+					    IW_ENC_CAPA_WPA2);
 		else if (suite == WLAN_CIPHER_SUITE_WEP40)
 			range->encoding_size[range->num_encoding_sizes++] =
 				WLAN_KEY_LEN_WEP40;
-- 
1.6.0.6

