Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:39492 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756491Ab0H3SVq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Aug 2010 14:21:46 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: me@bobcopeland.com, johannes@sipsolutions.net,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] ath5k: eliminate warning unintialized variable warning
Date: Mon, 30 Aug 2010 14:21:56 -0400
Message-Id: <1283192516-3324-1-git-send-email-linville@tuxdriver.com>
In-Reply-To: <1283191913-3155-1-git-send-email-linville@tuxdriver.com>
References: <1283191913-3155-1-git-send-email-linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath5k/base.c:1317: warning: ‘ret’ may be used uninitialized in this function

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
Actually include patch this time...
With right sender info this time...

 drivers/net/wireless/ath/ath5k/base.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 7139c7e..116ac66 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -1327,8 +1327,10 @@ ath5k_txbuf_setup(struct ath5k_softc *sc, struct ath5k_buf *bf,
 			PCI_DMA_TODEVICE);
 
 	rate = ieee80211_get_tx_rate(sc->hw, info);
-	if (!rate)
+	if (!rate) {
+		ret = -EINVAL;
 		goto err_unmap;
+	}
 
 	if (info->flags & IEEE80211_TX_CTL_NO_ACK)
 		flags |= AR5K_TXDESC_NOACK;
-- 
1.7.2.2

