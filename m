Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f210.google.com ([209.85.219.210]:64563 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754705AbZFRWVn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Jun 2009 18:21:43 -0400
Received: by mail-ew0-f210.google.com with SMTP id 6so1987323ewy.37
        for <linux-wireless@vger.kernel.org>; Thu, 18 Jun 2009 15:21:46 -0700 (PDT)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: orinoco-devel@lists.sourceforge.net,
	David Kilroy <kilroyd@googlemail.com>
Subject: [PATCH 02/23] cfg80211: Advertise ciphers via WE according to driver capability
Date: Thu, 18 Jun 2009 23:21:14 +0100
Message-Id: <1245363695-8289-3-git-send-email-kilroyd@googlemail.com>
In-Reply-To: <1245363695-8289-1-git-send-email-kilroyd@googlemail.com>
References: <1245363695-8289-1-git-send-email-kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: David Kilroy <kilroyd@googlemail.com>
Acked-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/wireless/wext-compat.c |   15 +++++++++++++--
 1 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/net/wireless/wext-compat.c b/net/wireless/wext-compat.c
index 9e56f35..7dbe6c6 100644
--- a/net/wireless/wext-compat.c
+++ b/net/wireless/wext-compat.c
@@ -204,8 +204,19 @@ int cfg80211_wext_giwrange(struct net_device *dev,
 	range->avg_qual.noise = range->max_qual.noise / 2;
 	range->avg_qual.updated = range->max_qual.updated;
 
-	range->enc_capa = IW_ENC_CAPA_WPA | IW_ENC_CAPA_WPA2 |
-			  IW_ENC_CAPA_CIPHER_TKIP | IW_ENC_CAPA_CIPHER_CCMP;
+	range->enc_capa = IW_ENC_CAPA_WPA | IW_ENC_CAPA_WPA2;
+
+	for (c = 0; c < wdev->wiphy->n_cipher_suites; c++) {
+		switch (wdev->wiphy->cipher_suites[c]) {
+		case WLAN_CIPHER_SUITE_TKIP:
+			range->enc_capa |= IW_ENC_CAPA_CIPHER_TKIP;
+			break;
+
+		case WLAN_CIPHER_SUITE_CCMP:
+			range->enc_capa |= IW_ENC_CAPA_CIPHER_CCMP;
+			break;
+		}
+	}
 
 	for (band = 0; band < IEEE80211_NUM_BANDS; band ++) {
 		int i;
-- 
1.6.0.6

