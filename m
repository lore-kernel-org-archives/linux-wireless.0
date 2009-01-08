Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:43616 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755353AbZAHLeW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jan 2009 06:34:22 -0500
Message-Id: <20090108113413.691095122@atheros.com> (sfid-20090108_123903_213879_1CAC3973)
References: <20090108113158.681894124@atheros.com>
Date: Thu, 08 Jan 2009 13:32:12 +0200
From: Jouni Malinen <j@w1.fi>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Jouni Malinen <jouni.malinen@atheros.com>
Subject: [PATCHv2 14/16] ath9k: Fix set_key error codes
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Return -EOPNOTSUPP if the algorithm is not supported and -ENOSPC if
there is no room in the key cache. This avoids KERN_ERR printk in
mac80211 for "errors" that are actually expected to happen in normal
operating conditions.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>


---
 drivers/net/wireless/ath9k/main.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- wireless-testing.orig/drivers/net/wireless/ath9k/main.c	2009-01-08 13:03:42.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath9k/main.c	2009-01-08 13:08:51.000000000 +0200
@@ -815,7 +815,7 @@ static int ath_key_config(struct ath_sof
 		hk.kv_type = ATH9K_CIPHER_AES_CCM;
 		break;
 	default:
-		return -EINVAL;
+		return -EOPNOTSUPP;
 	}
 
 	hk.kv_len = key->keylen;
@@ -849,7 +849,7 @@ static int ath_key_config(struct ath_sof
 		else
 			idx = ath_reserve_key_cache_slot(sc);
 		if (idx < 0)
-			return -EIO; /* no free key cache entries */
+			return -ENOSPC; /* no free key cache entries */
 	}
 
 	if (key->alg == ALG_TKIP)

-- 

-- 
Jouni Malinen                                            PGP id EFC895FA
