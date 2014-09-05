Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:46411 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755604AbaIECdY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Sep 2014 22:33:24 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH v3 09/11] ath9k: Fix COMP_BAR filter
Date: Fri,  5 Sep 2014 08:03:17 +0530
Message-Id: <1409884399-32289-10-git-send-email-sujith@msujith.org> (sfid-20140905_043328_446666_3FBB2DD2)
In-Reply-To: <1409884399-32289-1-git-send-email-sujith@msujith.org>
References: <1409884399-32289-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

ATH9K_RX_FILTER_COMP_BAR is used to receive BAR
completion frames and is set if the current channel
is HT. When channel contexts are enabled, instead of using
the mac80211 helpers, check if the current channel
definition is HT.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/recv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 04b02b5..63fbc3e 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -412,7 +412,7 @@ u32 ath_calcrxfilter(struct ath_softc *sc)
 	    (sc->rx.rxfilter & FIF_PSPOLL))
 		rfilt |= ATH9K_RX_FILTER_PSPOLL;
 
-	if (conf_is_ht(&sc->hw->conf))
+	if (sc->cur_chandef.width != NL80211_CHAN_WIDTH_20_NOHT)
 		rfilt |= ATH9K_RX_FILTER_COMP_BAR;
 
 	if (sc->nvifs > 1 || (sc->rx.rxfilter & FIF_OTHER_BSS)) {
-- 
2.1.0

