Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:24276 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754239Ab1IFOum (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Sep 2011 10:50:42 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 2/2] ath9k: Move cycle conters under cc_lock
Date: Tue, 6 Sep 2011 20:21:08 +0530
Message-ID: <1315320668-2882-2-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20110906_165045_199249_6B29A048)
In-Reply-To: <1315320668-2882-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1315320668-2882-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch protects cycle counters access by cc_lock
and also prints current sample index.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/debug.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 3d377ee..ee8640d 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -1323,16 +1323,17 @@ void ath9k_debug_samp_bb_mac(struct ath_softc *sc)
 
 	ath9k_ps_wakeup(sc);
 
+	spin_lock_bh(&sc->debug.samp_lock);
+
 	spin_lock_irqsave(&common->cc_lock, flags);
 	ath_hw_cycle_counters_update(common);
-	spin_unlock_irqrestore(&common->cc_lock, flags);
-
-	spin_lock_bh(&sc->debug.samp_lock);
 
 	ATH_SAMP_DBG(cc.cycles) = common->cc_ani.cycles;
 	ATH_SAMP_DBG(cc.rx_busy) = common->cc_ani.rx_busy;
 	ATH_SAMP_DBG(cc.rx_frame) = common->cc_ani.rx_frame;
 	ATH_SAMP_DBG(cc.tx_frame) = common->cc_ani.tx_frame;
+	spin_unlock_irqrestore(&common->cc_lock, flags);
+
 	ATH_SAMP_DBG(noise) = ah->noise;
 
 	REG_WRITE_D(ah, AR_MACMISC,
@@ -1387,6 +1388,8 @@ static int open_file_bb_mac_samps(struct inode *inode, struct file *file)
 	spin_lock_bh(&sc->debug.samp_lock);
 	memcpy(bb_mac_samp, sc->debug.bb_mac_samp,
 			sizeof(*bb_mac_samp) * ATH_DBG_MAX_SAMPLES);
+	len += snprintf(buf + len, size - len,
+			"Current Sample Index: %d\n", sc->debug.sampidx);
 	spin_unlock_bh(&sc->debug.samp_lock);
 
 	len += snprintf(buf + len, size - len,
-- 
1.7.6.1

