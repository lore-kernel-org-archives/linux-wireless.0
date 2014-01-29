Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:51020 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753081AbaA2TIR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jan 2014 14:08:17 -0500
Received: from ultralex.lan ([93.196.93.204]) by mail.gmx.com (mrgmx102) with
 ESMTPSA (Nemesis) id 0LuJDv-1VATUF0Lu3-011mn1 for
 <linux-wireless@vger.kernel.org>; Wed, 29 Jan 2014 20:08:16 +0100
From: Oleksij Rempel <linux@rempel-privat.de>
To: ath9k-devel@lists.ath9k.org, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH 09/13] ath9k_htc: sync rx_status-> related code with ath9k
Date: Wed, 29 Jan 2014 20:07:00 +0100
Message-Id: <1391022424-21087-8-git-send-email-linux@rempel-privat.de> (sfid-20140129_200820_640317_D30CA922)
In-Reply-To: <1391022424-21087-1-git-send-email-linux@rempel-privat.de>
References: <1391022315-20946-1-git-send-email-linux@rempel-privat.de>
 <1391022424-21087-1-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index e55659b..7321b64 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -970,6 +970,7 @@ static bool ath9k_rx_prepare(struct ath9k_htc_priv *priv,
 	struct ieee80211_hw *hw = priv->hw;
 	struct sk_buff *skb = rxbuf->skb;
 	struct ath_common *common = ath9k_hw_common(priv->ah);
+	struct ath_hw *ah = common->ah;
 	struct ath_htc_rx_status *rxstatus;
 	struct ath_rx_status *rx_stats;
 	int hdrlen, padsize;
@@ -1046,10 +1047,10 @@ static bool ath9k_rx_prepare(struct ath9k_htc_priv *priv,
 	ath9k_cmn_process_rssi(common, hw, rx_stats, rx_status);
 
 	rx_status->mactime = be64_to_cpu(rxbuf->rxstatus.rs_tstamp);
-	rx_status->band = hw->conf.chandef.chan->band;
-	rx_status->freq = hw->conf.chandef.chan->center_freq;
-	rx_status->signal =  rxbuf->rxstatus.rs_rssi + ATH_DEFAULT_NOISE_FLOOR;
-	rx_status->antenna = rxbuf->rxstatus.rs_antenna;
+
+	rx_status->band = ah->curchan->chan->band;
+	rx_status->freq = ah->curchan->chan->center_freq;
+	rx_status->antenna = rx_stats->rs_antenna;
 	rx_status->flag |= RX_FLAG_MACTIME_END;
 
 	kfree(rx_stats);
-- 
1.8.5.3

