Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:39729 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750797Ab2BEUPf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Feb 2012 15:15:35 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com,
	mohammed@qca.qualcomm.com
Subject: [PATCH 3.3 1/2] ath9k: fix a WEP crypto related regression
Date: Sun,  5 Feb 2012 21:15:17 +0100
Message-Id: <1328472918-30012-1-git-send-email-nbd@openwrt.org> (sfid-20120205_211547_379644_F7CF2582)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

commit b4a82a0 "ath9k_hw: fix interpretation of the rx KeyMiss flag"
fixed the interpretation of the KeyMiss flag for keycache based lookups,
however WEP encryption uses a static index, so KeyMiss is always asserted
for it, even though frames are decrypted properly.
Fix this by clearing the ATH9K_RXERR_KEYMISS flag if no keycache based
lookup was performed.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Cc: stable@vger.kernel.org
Reported-by: Laurent Bonnans <bonnans.l@gmail.com>
Reported-by: Jurica Vukadin <u.ra604@googlemail.com>
---
 drivers/net/wireless/ath/ath9k/recv.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 0e666fb..7e1a91a 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -822,6 +822,14 @@ static bool ath9k_rx_accept(struct ath_common *common,
 		(ATH9K_RXERR_DECRYPT | ATH9K_RXERR_CRC | ATH9K_RXERR_MIC |
 		 ATH9K_RXERR_KEYMISS));
 
+	/*
+	 * Key miss events are only relevant for pairwise keys where the
+	 * descriptor does contain a valid key index. This has been observed
+	 * mostly with CCMP encryption.
+	 */
+	if (rx_stats->rs_keyix == ATH9K_RXKEYIX_INVALID)
+		rx_stats->rs_status &= ~ATH9K_RXERR_KEYMISS;
+
 	if (!rx_stats->rs_datalen)
 		return false;
         /*
-- 
1.7.3.2

