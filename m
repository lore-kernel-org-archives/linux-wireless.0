Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f176.google.com ([209.85.219.176]:56827 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761221AbZE3RhJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 May 2009 13:37:09 -0400
Received: by mail-ew0-f176.google.com with SMTP id 24so6938274ewy.37
        for <linux-wireless@vger.kernel.org>; Sat, 30 May 2009 10:37:11 -0700 (PDT)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: orinoco-devel@lists.sourceforge.net,
	David Kilroy <kilroyd@googlemail.com>
Subject: [RFC v2 02/23] cfg80211: Advertise ciphers via WE according to driver capability
Date: Sat, 30 May 2009 18:36:36 +0100
Message-Id: <1243705017-8784-3-git-send-email-kilroyd@googlemail.com>
In-Reply-To: <1243705017-8784-1-git-send-email-kilroyd@googlemail.com>
References: <1243705017-8784-1-git-send-email-kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: David Kilroy <kilroyd@googlemail.com>
---
 net/wireless/wext-compat.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/net/wireless/wext-compat.c b/net/wireless/wext-compat.c
index 711e00a..b132f85 100644
--- a/net/wireless/wext-compat.c
+++ b/net/wireless/wext-compat.c
@@ -204,8 +204,16 @@ int cfg80211_wext_giwrange(struct net_device *dev,
 	range->avg_qual.noise = range->max_qual.noise / 2;
 	range->avg_qual.updated = range->max_qual.updated;
 
-	range->enc_capa = IW_ENC_CAPA_WPA | IW_ENC_CAPA_WPA2 |
-			  IW_ENC_CAPA_CIPHER_TKIP | IW_ENC_CAPA_CIPHER_CCMP;
+	range->enc_capa = IW_ENC_CAPA_WPA | IW_ENC_CAPA_WPA2;
+
+	for (c = 0; c < wdev->wiphy->n_cipher_suites; c++) {
+		u32 suite = wdev->wiphy->cipher_suites[c];
+
+		if (suite == WLAN_CIPHER_SUITE_TKIP)
+			range->enc_capa |= IW_ENC_CAPA_CIPHER_TKIP;
+		else if (suite == WLAN_CIPHER_SUITE_CCMP)
+			range->enc_capa |= IW_ENC_CAPA_CIPHER_CCMP;
+	}
 
 	for (band = 0; band < IEEE80211_NUM_BANDS; band ++) {
 		int i;
-- 
1.6.0.6

