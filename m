Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f210.google.com ([209.85.219.210]:64563 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754656AbZFRWVu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Jun 2009 18:21:50 -0400
Received: by mail-ew0-f210.google.com with SMTP id 6so1987323ewy.37
        for <linux-wireless@vger.kernel.org>; Thu, 18 Jun 2009 15:21:53 -0700 (PDT)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: orinoco-devel@lists.sourceforge.net,
	David Kilroy <kilroyd@googlemail.com>
Subject: [PATCH 04/23] cfg80211: set WE encoding size based on available ciphers
Date: Thu, 18 Jun 2009 23:21:16 +0100
Message-Id: <1245363695-8289-5-git-send-email-kilroyd@googlemail.com>
In-Reply-To: <1245363695-8289-1-git-send-email-kilroyd@googlemail.com>
References: <1245363695-8289-1-git-send-email-kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Only set the sizes for WEP40 and WEP104.

Signed-off-by: David Kilroy <kilroyd@googlemail.com>
Acked-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/wireless/wext-compat.c |   13 ++++++++++---
 1 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/net/wireless/wext-compat.c b/net/wireless/wext-compat.c
index bb97061..2f7e776 100644
--- a/net/wireless/wext-compat.c
+++ b/net/wireless/wext-compat.c
@@ -173,9 +173,6 @@ int cfg80211_wext_giwrange(struct net_device *dev,
 	range->min_frag = 256;
 	range->max_frag = 2346;
 
-	range->encoding_size[0] = 5;
-	range->encoding_size[1] = 13;
-	range->num_encoding_sizes = 2;
 	range->max_encoding_tokens = 4;
 
 	range->max_qual.updated = IW_QUAL_NOISE_INVALID;
@@ -215,6 +212,16 @@ int cfg80211_wext_giwrange(struct net_device *dev,
 		case WLAN_CIPHER_SUITE_CCMP:
 			range->enc_capa |= IW_ENC_CAPA_CIPHER_CCMP;
 			break;
+
+		case WLAN_CIPHER_SUITE_WEP40:
+			range->encoding_size[range->num_encoding_sizes++] =
+				WLAN_KEY_LEN_WEP40;
+			break;
+
+		case WLAN_CIPHER_SUITE_WEP104:
+			range->encoding_size[range->num_encoding_sizes++] =
+				WLAN_KEY_LEN_WEP104;
+			break;
 		}
 	}
 
-- 
1.6.0.6

