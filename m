Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:42409 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035AbaJQCJ7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Oct 2014 22:09:59 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH v2 07/23] ath9k: Clear NoA schedule properly
Date: Fri, 17 Oct 2014 07:40:14 +0530
Message-Id: <1413511830-5536-8-git-send-email-sujith@msujith.org> (sfid-20141017_041002_569780_C7986C04)
In-Reply-To: <1413511830-5536-1-git-send-email-sujith@msujith.org>
References: <1413511830-5536-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

When an active context transitions to inactive
state, the NoA schedule needs to be removed
for the context that has beaconing enabled.
Not doing this will affect p2p clients.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/channel.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index 709facc..74a5c27 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -356,6 +356,21 @@ void ath_chanctx_event(struct ath_softc *sc, struct ieee80211_vif *vif,
 				"Move chanctx state from WAIT_FOR_TIMER to WAIT_FOR_BEACON\n");
 		}
 
+		/*
+		 * When a context becomes inactive, for example,
+		 * disassociation of a station context, the NoA
+		 * attribute needs to be removed from subsequent
+		 * beacons.
+		 */
+		if (!ctx->active && avp->noa_duration &&
+		    sc->sched.state != ATH_CHANCTX_STATE_WAIT_FOR_BEACON) {
+			avp->noa_duration = 0;
+			avp->periodic_noa = false;
+
+			ath_dbg(common, CHAN_CTX,
+				"Clearing NoA schedule\n");
+		}
+
 		if (sc->sched.state != ATH_CHANCTX_STATE_WAIT_FOR_BEACON)
 			break;
 
-- 
2.1.2

