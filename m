Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:35386 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035AbaJQCJ4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Oct 2014 22:09:56 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH v2 06/23] ath9k: Disable beacon tasklet during reset
Date: Fri, 17 Oct 2014 07:40:13 +0530
Message-Id: <1413511830-5536-7-git-send-email-sujith@msujith.org> (sfid-20141017_041000_197252_10283952)
In-Reply-To: <1413511830-5536-1-git-send-email-sujith@msujith.org>
References: <1413511830-5536-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

When a chip reset is done, all running timers,
tasklets etc. are stopped but the beacon tasklet
is left running. Fix this.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index dda09ba..5d54f39 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -281,6 +281,7 @@ static int ath_reset_internal(struct ath_softc *sc, struct ath9k_channel *hchan)
 	__ath_cancel_work(sc);
 
 	tasklet_disable(&sc->intr_tq);
+	tasklet_disable(&sc->bcon_tasklet);
 	spin_lock_bh(&sc->sc_pcu_lock);
 
 	if (!sc->cur_chan->offchannel) {
@@ -326,6 +327,7 @@ static int ath_reset_internal(struct ath_softc *sc, struct ath9k_channel *hchan)
 
 out:
 	spin_unlock_bh(&sc->sc_pcu_lock);
+	tasklet_enable(&sc->bcon_tasklet);
 	tasklet_enable(&sc->intr_tq);
 
 	return r;
-- 
2.1.2

