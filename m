Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3040 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752781AbYAUWJH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jan 2008 17:09:07 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] ath5k: use AR5K_KEYTABLE_SIZE when initializing key table
Date: Mon, 21 Jan 2008 15:36:04 -0500
Message-Id: <1200947765-12012-1-git-send-email-linville@tuxdriver.com> (sfid-20080121_220911_964574_8AD17422)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

...instead of using AR5K_KEYCACHE_SIZE, which would seem to be a
typo/thinko...

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/ath5k/base.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index 742616a..75e5970 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -663,7 +663,7 @@ ath5k_attach(struct pci_dev *pdev, struct ieee80211_hw *hw)
 	 * Reset the key cache since some parts do not
 	 * reset the contents on initial power up.
 	 */
-	for (i = 0; i < AR5K_KEYCACHE_SIZE; i++)
+	for (i = 0; i < AR5K_KEYTABLE_SIZE; i++)
 		ath5k_hw_reset_key(ah, i);
 
 	/*
-- 
1.5.3.3

