Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59637 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756112Ab2CJAkS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Mar 2012 19:40:18 -0500
Received: by iagz16 with SMTP id z16so2999357iag.19
        for <linux-wireless@vger.kernel.org>; Fri, 09 Mar 2012 16:40:17 -0800 (PST)
From: Ashok Nagarajan <ashok@cozybit.com>
To: linux-wireless@vger.kernel.org, javier@cozybit.com
Cc: Ashok Nagarajan <ashok@cozybit.com>
Subject: [PATCH] ath9k: Fix mactime from being clobbered in rx_status
Date: Fri,  9 Mar 2012 16:40:08 -0800
Message-Id: <1331340008-1713-1-git-send-email-ashok@cozybit.com> (sfid-20120310_014022_343899_096C5812)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mactime was being overwritten by the function ath9k_rx_skb_preprocess.  Fixed
by calling the function before setting the mactime.

Signed-off-by: Ashok Nagarajan <ashok@cozybit.com>
Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 drivers/net/wireless/ath/ath9k/recv.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 1b1b279..52a0466 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -1841,6 +1841,9 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 		if (sc->sc_flags & SC_OP_RXFLUSH)
 			goto requeue_drop_frag;
 
+		retval = ath9k_rx_skb_preprocess(common, hw, hdr, &rs,
+						 rxs, &decrypt_error);
+
 		rxs->mactime = (tsf & ~0xffffffffULL) | rs.rs_tstamp;
 		if (rs.rs_tstamp > tsf_lower &&
 		    unlikely(rs.rs_tstamp - tsf_lower > 0x10000000))
@@ -1850,8 +1853,6 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 		    unlikely(tsf_lower - rs.rs_tstamp > 0x10000000))
 			rxs->mactime += 0x100000000ULL;
 
-		retval = ath9k_rx_skb_preprocess(common, hw, hdr, &rs,
-						 rxs, &decrypt_error);
 		if (retval)
 			goto requeue_drop_frag;
 
-- 
1.7.5.4

