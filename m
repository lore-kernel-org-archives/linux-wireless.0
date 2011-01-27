Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:10258 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753802Ab1A0JPr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Jan 2011 04:15:47 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 27 Jan 2011 01:15:28 -0800
From: Vivek Natarajan <vnatarajan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Vivek Natarajan <vnatarajan@atheros.com>
Subject: [PATCH 4/5] ath9k: Fix a locking related issue.
Date: Thu, 27 Jan 2011 14:45:10 +0530
Message-ID: <1296119711-4024-4-git-send-email-vnatarajan@atheros.com>
In-Reply-To: <1296119711-4024-3-git-send-email-vnatarajan@atheros.com>
References: <1296119711-4024-1-git-send-email-vnatarajan@atheros.com>
 <1296119711-4024-2-git-send-email-vnatarajan@atheros.com>
 <1296119711-4024-3-git-send-email-vnatarajan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Spin_lock has been tried to be acquired twice from ath9k_tasklet
to ath_reset which resulted in a machine freeze.

Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/xmit.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index c73452d..84673fb 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -564,8 +564,11 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 
 	rcu_read_unlock();
 
-	if (needreset)
+	if (needreset) {
+		spin_unlock_bh(&sc->sc_pcu_lock);
 		ath_reset(sc, false);
+		spin_lock_bh(&sc->sc_pcu_lock);
+	}
 }
 
 static u32 ath_lookup_rate(struct ath_softc *sc, struct ath_buf *bf,
-- 
1.6.3.3

