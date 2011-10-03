Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.ch ([80.75.119.105]:51308 "EHLO mail.neratec.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755291Ab1JCKaL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Oct 2011 06:30:11 -0400
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
To: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Cc: kgiori@qca.qualcomm.com, rodrigue@qca.qualcomm.com,
	nbd@openwrt.org, Zefir Kurtisi <zefir.kurtisi@neratec.com>
Subject: [RFC 5/6] ath9k: enable DFS pulse detection
Date: Mon,  3 Oct 2011 12:29:17 +0200
Message-Id: <1317637758-11907-6-git-send-email-zefir.kurtisi@neratec.com> (sfid-20111003_123015_178616_A1308F60)
In-Reply-To: <1317637758-11907-1-git-send-email-zefir.kurtisi@neratec.com>
References: <1317637758-11907-1-git-send-email-zefir.kurtisi@neratec.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Zefir Kurtisi <zefir.kurtisi@neratec.com>
---
 drivers/net/wireless/ath/ath9k/main.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index e8aeb98..5defebe 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -344,6 +344,18 @@ static int ath_reset_internal(struct ath_softc *sc, struct ath9k_channel *hchan,
 			"Unable to reset channel, reset status %d\n", r);
 		goto out;
 	}
+#ifdef CONFIG_ATH9K_DFS
+	/**
+	 * enable radar pulse detection
+	 *
+	 * TODO: do this only for DFS channels
+	 */
+	ah->private_ops.set_radar_params(ah, &ah->radar_conf);
+	ath9k_hw_setrxfilter(ah,
+			ath9k_hw_getrxfilter(ah) | ATH9K_RX_FILTER_PHYRADAR);
+	ath_dbg(common, ATH_DBG_DFS,
+		"DFS enabled for channel %d\n", hchan->chan->center_freq);
+#endif
 
 	if (!ath_complete_reset(sc, true))
 		r = -EIO;
-- 
1.7.4.1

