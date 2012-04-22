Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:48528 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141Ab2DVTuu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Apr 2012 15:50:50 -0400
Received: by wgbdr13 with SMTP id dr13so11206298wgb.1
        for <linux-wireless@vger.kernel.org>; Sun, 22 Apr 2012 12:50:49 -0700 (PDT)
From: Zefir Kurtisi <zefir.kurtisi@gmail.com>
To: linville@tuxdriver.com
Cc: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org,
	rodrigue@qca.qualcomm.com, achadd@qca.qualcomm.com,
	chunkeey@googlemail.com, Zefir Kurtisi <zefir.kurtisi@neratec.com>
Subject: [PATCH 3/4] ath9k: forward pulse events to DFS pulse detector
Date: Sun, 22 Apr 2012 21:50:22 +0200
Message-Id: <1335124223-15439-4-git-send-email-zefir.kurtisi@gmail.com> (sfid-20120422_215054_972978_D94EFEEB)
In-Reply-To: <1335124223-15439-1-git-send-email-zefir.kurtisi@gmail.com>
References: <1335124223-15439-1-git-send-email-zefir.kurtisi@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Zefir Kurtisi <zefir.kurtisi@neratec.com>


Signed-off-by: Zefir Kurtisi <zefir.kurtisi@neratec.com>
---
 drivers/net/wireless/ath/ath9k/recv.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index ef45c0c..f647d0b 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -1856,6 +1856,9 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 		    unlikely(tsf_lower - rs.rs_tstamp > 0x10000000))
 			rxs->mactime += 0x100000000ULL;
 
+		if (rs.rs_phyerr == ATH9K_PHYERR_RADAR)
+			ath9k_dfs_process_phyerr(sc, hdr, &rs, rxs->mactime);
+
 		retval = ath9k_rx_skb_preprocess(common, hw, hdr, &rs,
 						 rxs, &decrypt_error);
 		if (retval)
-- 
1.7.4.1

