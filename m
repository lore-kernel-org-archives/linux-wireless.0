Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from andre.telenet-ops.be ([195.130.132.53]:54895 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752435AbaAZK61 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Jan 2014 05:58:27 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Felix Fietkau <nbd@openwrt.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	QCA ath9k Development <ath9k-devel@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] ath9k: Fix uninitialized variable in ath9k_has_tx_pending()
Date: Sun, 26 Jan 2014 11:53:21 +0100
Message-Id: <1390733601-11244-1-git-send-email-geert@linux-m68k.org> (sfid-20140126_115830_160614_CE0EF599)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

drivers/net/wireless/ath/ath9k/main.c: In function ‘ath9k_has_tx_pending’:
drivers/net/wireless/ath/ath9k/main.c:1869: warning: ‘npend’ may be used uninitialized in this function

Introduced by commit 10e2318103f5941aa70c318afe34bc41f1b98529 ("ath9k:
optimize ath9k_flush").

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
This doesn't look like a false positive to me

 drivers/net/wireless/ath/ath9k/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 5924f72dd493..f08d5051c13f 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1866,7 +1866,7 @@ static void ath9k_set_coverage_class(struct ieee80211_hw *hw, u8 coverage_class)
 
 static bool ath9k_has_tx_pending(struct ath_softc *sc)
 {
-	int i, npend;
+	int i, npend = 0;
 
 	for (i = 0; i < ATH9K_NUM_TX_QUEUES; i++) {
 		if (!ATH_TXQ_SETUP(sc, i))
-- 
1.7.9.5

