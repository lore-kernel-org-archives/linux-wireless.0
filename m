Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ffm.saftware.de ([83.141.3.46]:56125 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751479AbZGVUPi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jul 2009 16:15:38 -0400
Message-ID: <4A677126.3040907@linuxtv.org>
Date: Wed, 22 Jul 2009 22:05:58 +0200
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: johannes@sipsolutions.net
CC: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: fix autoloading of crypto modules for WEP
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If at least one of arc4 and ecb is built as a module, then autoloading
of the algorithm fails, because crypto_alloc_blkcipher tries to
request the module "ecb(arc4)", which does not exist.

This patch was made against 2.6.30, but should apply cleanly on top of
the wireless-2.6 git tree.

Signed-off-by: Andreas Oberritter <obi@linuxtv.org>

---
 net/mac80211/wep.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/wep.c b/net/mac80211/wep.c
index ef73105..78e9119 100644
--- a/net/mac80211/wep.c
+++ b/net/mac80211/wep.c
@@ -29,6 +29,17 @@ int ieee80211_wep_init(struct ieee80211_local *local)
 	/* start WEP IV from a random value */
 	get_random_bytes(&local->wep_iv, WEP_IV_LEN);

+	/*
+	 * crypto_alloc_blkcipher() will request the
+	 * module "ecb(arc4)", which does not exist.
+	 */
+#ifdef CONFIG_CRYPTO_ARC4_MODULE
+	request_module("arc4");
+#endif
+#ifdef CONFIG_CRYPTO_ECB_MODULE
+	request_module("ecb");
+#endif
+
 	local->wep_tx_tfm = crypto_alloc_blkcipher("ecb(arc4)", 0,
 						CRYPTO_ALG_ASYNC);
 	if (IS_ERR(local->wep_tx_tfm))
-- 
1.6.0.4

