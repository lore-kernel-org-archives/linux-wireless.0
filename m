Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36402 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754416Ab2HTMEG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Aug 2012 08:04:06 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: simplify buffers in aes_128_cmac_vector
Date: Mon, 20 Aug 2012 14:04:01 +0200
Message-Id: <1345464241-16608-1-git-send-email-johannes@sipsolutions.net> (sfid-20120820_140410_617145_FC7ED3F0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's no need to use a single scratch buffer and
calculate offsets into it, just use two separate
buffers for the separate variables.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/aes_cmac.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/net/mac80211/aes_cmac.c b/net/mac80211/aes_cmac.c
index 8dfd70d..a04752e 100644
--- a/net/mac80211/aes_cmac.c
+++ b/net/mac80211/aes_cmac.c
@@ -38,14 +38,10 @@ static void gf_mulx(u8 *pad)
 static void aes_128_cmac_vector(struct crypto_cipher *tfm, size_t num_elem,
 				const u8 *addr[], const size_t *len, u8 *mac)
 {
-	u8 scratch[2 * AES_BLOCK_SIZE];
-	u8 *cbc, *pad;
+	u8 cbc[AES_BLOCK_SIZE], pad[AES_BLOCK_SIZE];
 	const u8 *pos, *end;
 	size_t i, e, left, total_len;
 
-	cbc = scratch;
-	pad = scratch + AES_BLOCK_SIZE;
-
 	memset(cbc, 0, AES_BLOCK_SIZE);
 
 	total_len = 0;
-- 
1.7.10.4

