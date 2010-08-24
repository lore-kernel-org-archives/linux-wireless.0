Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:34381 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710Ab0HXT3m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Aug 2010 15:29:42 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>, stable@kernel.org
Subject: [PATCH 2.6.36] ath5k: check return value of ieee80211_get_tx_rate
Date: Tue, 24 Aug 2010 15:27:34 -0400
Message-Id: <1282678054-10894-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This avoids a NULL pointer dereference as reported here:

	https://bugzilla.redhat.com/show_bug.cgi?id=625889

When the WARN condition is hit in ieee80211_get_tx_rate, it will return
NULL.  So, we need to check the return value and avoid dereferencing it
in that case.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
Cc: stable@kernel.org
---
Of course, the better question is why are we hitting that condition at
all...?

 drivers/net/wireless/ath/ath5k/base.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 373dcfe..c7720e4 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -1327,6 +1327,8 @@ ath5k_txbuf_setup(struct ath5k_softc *sc, struct ath5k_buf *bf,
 			PCI_DMA_TODEVICE);
 
 	rate = ieee80211_get_tx_rate(sc->hw, info);
+	if (!rate)
+		goto err_unmap;
 
 	if (info->flags & IEEE80211_TX_CTL_NO_ACK)
 		flags |= AR5K_TXDESC_NOACK;
-- 
1.7.2.1

