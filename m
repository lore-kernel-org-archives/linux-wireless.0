Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:34036 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752497AbZAGL2U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jan 2009 06:28:20 -0500
Message-Id: <20090107112711.698791712@atheros.com> (sfid-20090107_123903_784505_94133E93)
References: <20090107112346.369581673@atheros.com>
Date: Wed, 07 Jan 2009 13:23:59 +0200
From: Jouni Malinen <j@w1.fi>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Jouni Malinen <jouni.malinen@atheros.com>
Subject: [PATCH 13/14] ath9k: Fix set_key error codes
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

--- wireless-testing.orig/drivers/net/wireless/ath9k/main.c	2009-01-07 10:39:55.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath9k/main.c	2009-01-07 13:08:10.000000000 +0200
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
