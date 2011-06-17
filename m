Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:48048 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933112Ab1FQUnW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jun 2011 16:43:22 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: tsyvarev@ispras.ru, me@bobcopeland.com, mickflemm@gmail.com,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH v2] ath5k: free sc->ah in ath5k_deinit_softc
Date: Fri, 17 Jun 2011 16:41:30 -0400
Message-Id: <1308343290-13875-1-git-send-email-linville@tuxdriver.com> (sfid-20110617_224326_613088_9C7D9428)
In-Reply-To: <1308343066-13770-1-git-send-email-linville@tuxdriver.com>
References: <1308343066-13770-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Nothing else is freeing it, and this mirrors the error handling patch
already in ath5k_init_softc.

https://bugzilla.kernel.org/show_bug.cgi?id=37592

Signed-off-by: John W. Linville <linville@tuxdriver.com>
Reported-by: Tsyvarev Andrey <tsyvarev@ispras.ru>
---
v2 -- cite bugzilla report

 drivers/net/wireless/ath/ath5k/base.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 3e70b14..a6623dd 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -2960,6 +2960,7 @@ ath5k_deinit_softc(struct ath5k_softc *sc)
 	 * state and potentially want to use them.
 	 */
 	ath5k_hw_deinit(sc->ah);
+	kfree(sc->ah);
 	free_irq(sc->irq, sc);
 }
 
-- 
1.7.4.4

