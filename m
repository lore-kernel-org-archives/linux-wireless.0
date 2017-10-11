Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:48274 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757296AbdJKNrS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Oct 2017 09:47:18 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: use crypto_aead_authsize()
Date: Wed, 11 Oct 2017 15:47:15 +0200
Message-Id: <20171011134715.30673-1-johannes@sipsolutions.net> (sfid-20171011_154727_593339_FA882193)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Evidently this API is intended to be used to isolate against
API changes, so use it instead of accessing ->authsize.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/aead_api.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/aead_api.c b/net/mac80211/aead_api.c
index 347f13953b2c..160f9df30402 100644
--- a/net/mac80211/aead_api.c
+++ b/net/mac80211/aead_api.c
@@ -21,7 +21,7 @@
 int aead_encrypt(struct crypto_aead *tfm, u8 *b_0, u8 *aad, size_t aad_len,
 		 u8 *data, size_t data_len, u8 *mic)
 {
-	size_t mic_len = tfm->authsize;
+	size_t mic_len = crypto_aead_authsize(tfm);
 	struct scatterlist sg[3];
 	struct aead_request *aead_req;
 	int reqsize = sizeof(*aead_req) + crypto_aead_reqsize(tfm);
@@ -52,7 +52,7 @@ int aead_encrypt(struct crypto_aead *tfm, u8 *b_0, u8 *aad, size_t aad_len,
 int aead_decrypt(struct crypto_aead *tfm, u8 *b_0, u8 *aad, size_t aad_len,
 		 u8 *data, size_t data_len, u8 *mic)
 {
-	size_t mic_len = tfm->authsize;
+	size_t mic_len = crypto_aead_authsize(tfm);
 	struct scatterlist sg[3];
 	struct aead_request *aead_req;
 	int reqsize = sizeof(*aead_req) + crypto_aead_reqsize(tfm);
-- 
2.14.2
