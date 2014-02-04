Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:56397 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753100AbaBDJ2s (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Feb 2014 04:28:48 -0500
Received: from ultralex.lan ([93.196.93.204]) by mail.gmx.com (mrgmx002) with
 ESMTPSA (Nemesis) id 0MFuWk-1Vz1Cd22Le-00EtUE for
 <linux-wireless@vger.kernel.org>; Tue, 04 Feb 2014 10:28:47 +0100
From: Oleksij Rempel <linux@rempel-privat.de>
To: ath9k-devel@lists.ath9k.org, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH v2 09/13] ath9k_htc: sync rx_status-> related code with ath9k
Date: Tue,  4 Feb 2014 10:27:46 +0100
Message-Id: <1391506070-8636-10-git-send-email-linux@rempel-privat.de> (sfid-20140204_102852_732484_48047908)
In-Reply-To: <1391506070-8636-1-git-send-email-linux@rempel-privat.de>
References: <1391506070-8636-1-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index 8aba265..e36bf61 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -971,6 +971,7 @@ static bool ath9k_rx_prepare(struct ath9k_htc_priv *priv,
 	struct ieee80211_hw *hw = priv->hw;
 	struct sk_buff *skb = rxbuf->skb;
 	struct ath_common *common = ath9k_hw_common(priv->ah);
+	struct ath_hw *ah = common->ah;
 	struct ath_htc_rx_status *rxstatus;
 	struct ath_rx_status rx_stats;
 	int hdrlen, padsize;
@@ -1042,10 +1043,10 @@ static bool ath9k_rx_prepare(struct ath9k_htc_priv *priv,
 	ath9k_cmn_process_rssi(common, hw, &rx_stats, rx_status);
 
 	rx_status->mactime = be64_to_cpu(rxbuf->rxstatus.rs_tstamp);
-	rx_status->band = hw->conf.chandef.chan->band;
-	rx_status->freq = hw->conf.chandef.chan->center_freq;
-	rx_status->signal =  rxbuf->rxstatus.rs_rssi + ATH_DEFAULT_NOISE_FLOOR;
-	rx_status->antenna = rxbuf->rxstatus.rs_antenna;
+
+	rx_status->band = ah->curchan->chan->band;
+	rx_status->freq = ah->curchan->chan->center_freq;
+	rx_status->antenna = rx_stats.rs_antenna;
 	rx_status->flag |= RX_FLAG_MACTIME_END;
 
 	return true;
-- 
1.9.rc1

