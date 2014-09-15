Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:53507 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbaIOFzi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2014 01:55:38 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH 2/5] ath9k: Check beaconing mode properly
Date: Mon, 15 Sep 2014 11:25:51 +0530
Message-Id: <1410760554-11844-3-git-send-email-sujith@msujith.org> (sfid-20140915_075541_009514_FAA3BC69)
In-Reply-To: <1410760554-11844-1-git-send-email-sujith@msujith.org>
References: <1410760554-11844-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

In MCC mode, the TSF of a context needs to be
adjusted only if it is GO/AP.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/channel.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index 3906df9..7be940f 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -262,6 +262,9 @@ static void ath_chanctx_adjust_tbtt_delta(struct ath_softc *sc)
 	cur = sc->cur_chan;
 	prev = ath_chanctx_get_next(sc, cur);
 
+	if (!prev->switch_after_beacon)
+		return;
+
 	getrawmonotonic(&ts);
 	cur_tsf = (u32) cur->tsf_val +
 		  ath9k_hw_get_tsf_offset(&cur->tsf_ts, &ts);
-- 
2.1.0

