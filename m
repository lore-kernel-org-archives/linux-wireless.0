Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:45619 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751482AbbC3ImP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2015 04:42:15 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80111: aes_gcm: clean up ieee80211_aes_gcm_key_setup_encrypt()
Date: Mon, 30 Mar 2015 10:42:12 +0200
Message-Id: <1427704932-10179-1-git-send-email-johannes@sipsolutions.net> (sfid-20150330_104218_302895_5501B405)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This code is written using an anti-pattern called "success handling"
which makes it hard to read, especially if you are used to normal kernel
style.  It should instead be written as a list of directives in a row
with branches for error handling.

(Basically copied from Dan's previous patch for CCM)

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/aes_gcm.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/aes_gcm.c b/net/mac80211/aes_gcm.c
index c2bf6698d738..fd278bbe1b0d 100644
--- a/net/mac80211/aes_gcm.c
+++ b/net/mac80211/aes_gcm.c
@@ -80,11 +80,15 @@ struct crypto_aead *ieee80211_aes_gcm_key_setup_encrypt(const u8 key[],
 		return tfm;
 
 	err = crypto_aead_setkey(tfm, key, key_len);
-	if (!err)
-		err = crypto_aead_setauthsize(tfm, IEEE80211_GCMP_MIC_LEN);
-	if (!err)
-		return tfm;
+	if (err)
+		goto free_aead;
+	err = crypto_aead_setauthsize(tfm, IEEE80211_GCMP_MIC_LEN);
+	if (err)
+		goto free_aead;
+
+	return tfm;
 
+free_aead:
 	crypto_free_aead(tfm);
 	return ERR_PTR(err);
 }
-- 
2.1.4

