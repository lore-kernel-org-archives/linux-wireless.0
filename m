Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:41933 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751364Ab0FAJsn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jun 2010 05:48:43 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 01 Jun 2010 02:48:43 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19460.54898.616315.983281@gargle.gargle.HOWL>
Date: Tue, 1 Jun 2010 15:14:18 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 12/13] ath9k_htc: Handle host RX disable
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The MIB counters used by ANI have to be disabled
on the host because the FW doesn't do it on the target side.
Also, flush the receive buffers before initializing
RX on the target.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ani.c          |    1 +
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |   10 ++++++++++
 2 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ani.c b/drivers/net/wireless/ath/ath9k/ani.c
index ba8b20f..3da820f 100644
--- a/drivers/net/wireless/ath/ath9k/ani.c
+++ b/drivers/net/wireless/ath/ath9k/ani.c
@@ -495,6 +495,7 @@ void ath9k_hw_disable_mib_counters(struct ath_hw *ah)
 	REG_WRITE(ah, AR_FILT_OFDM, 0);
 	REG_WRITE(ah, AR_FILT_CCK, 0);
 }
+EXPORT_SYMBOL(ath9k_hw_disable_mib_counters);
 
 u32 ath9k_hw_GetMibCycleCountsPct(struct ath_hw *ah,
 				  u32 *rxc_pcnt,
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 1ed88fb..86145ef 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1117,6 +1117,12 @@ static void ath9k_htc_radio_disable(struct ieee80211_hw *hw)
 	/* Stop RX */
 	WMI_CMD(WMI_STOP_RECV_CMDID);
 
+	/*
+	 * The MIB counters have to be disabled here,
+	 * since the target doesn't do it.
+	 */
+	ath9k_hw_disable_mib_counters(ah);
+
 	if (!ah->curchan)
 		ah->curchan = ath9k_cmn_get_curchannel(hw, ah);
 
@@ -1198,6 +1204,10 @@ static int ath9k_htc_start(struct ieee80211_hw *hw)
 		  "Starting driver with initial channel: %d MHz\n",
 		  curchan->center_freq);
 
+	/* Ensure that HW is awake before flushing RX */
+	ath9k_htc_setpower(priv, ATH9K_PM_AWAKE);
+	WMI_CMD(WMI_FLUSH_RECV_CMDID);
+
 	/* setup initial channel */
 	init_channel = ath9k_cmn_get_curchannel(hw, ah);
 
-- 
1.7.1

