Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58415 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756221Ab2CJC5u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Mar 2012 21:57:50 -0500
Received: by iagz16 with SMTP id z16so3158399iag.19
        for <linux-wireless@vger.kernel.org>; Fri, 09 Mar 2012 18:57:49 -0800 (PST)
From: Ashok Nagarajan <ashok@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: javier@cozybit.com, zefir.kurtisi@neratec.com,
	chunkeey@googlemail.com, Ashok Nagarajan <ashok@cozybit.com>
Subject: [PATCH v2] ath9k: Fix mactime from being clobbered in rx_status
Date: Fri,  9 Mar 2012 18:57:39 -0800
Message-Id: <1331348259-14985-1-git-send-email-ashok@cozybit.com> (sfid-20120310_035754_424558_E2AB4382)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mactime was being overwritten by the function ath9k_rx_skb_preprocess. Fixed by
memsetting rx_status in ath_rx_tasklet.

Signed-off-by: Ashok Nagarajan <ashok@cozybit.com>
Signed-off-by: Javier Cardona <javier@cozybit.com>
---
v1:
Fix reverting "ath9k: trivial: reorder rx_tasklet processing" logic (Christian
Lamparter)
 drivers/net/wireless/ath/ath9k/recv.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 1b1b279..f4ae3ba 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -982,8 +982,6 @@ static int ath9k_rx_skb_preprocess(struct ath_common *common,
 {
 	struct ath_hw *ah = common->ah;
 
-	memset(rx_status, 0, sizeof(struct ieee80211_rx_status));
-
 	/*
 	 * everything but the rate is checked here, the rate check is done
 	 * separately to avoid doing two lookups for a rate for each frame.
@@ -1841,6 +1839,8 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 		if (sc->sc_flags & SC_OP_RXFLUSH)
 			goto requeue_drop_frag;
 
+		memset(rxs, 0, sizeof(struct ieee80211_rx_status));
+
 		rxs->mactime = (tsf & ~0xffffffffULL) | rs.rs_tstamp;
 		if (rs.rs_tstamp > tsf_lower &&
 		    unlikely(rs.rs_tstamp - tsf_lower > 0x10000000))
-- 
1.7.5.4

