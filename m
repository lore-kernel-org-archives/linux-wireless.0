Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:52943 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934377Ab0GOUQh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Jul 2010 16:16:37 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] mac80211: improve error checking if WEP fails to init
Date: Thu, 15 Jul 2010 16:16:17 -0400
Message-Id: <1279224977-23100-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Do this by poisoning the values of wep_tx_tfm and wep_rx_tfm if either
crypto allocation fails.

Reported-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 net/mac80211/wep.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/wep.c b/net/mac80211/wep.c
index 6d133b6..9ebc8d8 100644
--- a/net/mac80211/wep.c
+++ b/net/mac80211/wep.c
@@ -32,13 +32,16 @@ int ieee80211_wep_init(struct ieee80211_local *local)
 
 	local->wep_tx_tfm = crypto_alloc_blkcipher("ecb(arc4)", 0,
 						CRYPTO_ALG_ASYNC);
-	if (IS_ERR(local->wep_tx_tfm))
+	if (IS_ERR(local->wep_tx_tfm)) {
+		local->wep_rx_tfm = ERR_PTR(-EINVAL);
 		return PTR_ERR(local->wep_tx_tfm);
+	}
 
 	local->wep_rx_tfm = crypto_alloc_blkcipher("ecb(arc4)", 0,
 						CRYPTO_ALG_ASYNC);
 	if (IS_ERR(local->wep_rx_tfm)) {
 		crypto_free_blkcipher(local->wep_tx_tfm);
+		local->wep_tx_tfm = ERR_PTR(-EINVAL);
 		return PTR_ERR(local->wep_rx_tfm);
 	}
 
-- 
1.7.1.1

