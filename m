Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:61694 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994Ab2DMLNo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Apr 2012 07:13:44 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 2/3] ath9k: skip beaconing when reset work is pending
Date: Fri, 13 Apr 2012 16:44:21 +0530
Message-ID: <1334315662-5017-2-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20120413_131409_750424_F761B787)
In-Reply-To: <1334315662-5017-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1334315662-5017-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Whenever the reset work is queued up, do not generate beacon. And also
clear the beacon miss count once the beacon stuck was observed.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/beacon.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index 719a271..c7f012a 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -359,6 +359,11 @@ void ath_beacon_tasklet(unsigned long data)
 	int slot;
 	u32 bfaddr, bc = 0;
 
+	if (work_pending(&sc->hw_reset_work)) {
+		ath_dbg(common, RESET,
+			"reset work is pending, skip beaconing now\n");
+		return;
+	}
 	/*
 	 * Check if the previous beacon has gone out.  If
 	 * not don't try to post another, skip this period
@@ -378,6 +383,7 @@ void ath_beacon_tasklet(unsigned long data)
 				ath9k_hw_bstuck_nfcal(ah);
 		} else if (sc->beacon.bmisscnt >= BSTUCK_THRESH) {
 			ath_dbg(common, BSTUCK, "beacon is officially stuck\n");
+			sc->beacon.bmisscnt = 0;
 			sc->sc_flags |= SC_OP_TSF_RESET;
 			ieee80211_queue_work(sc->hw, &sc->hw_reset_work);
 		}
-- 
1.7.10

