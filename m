Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59991 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595Ab2LJWs0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2012 17:48:26 -0500
Received: by mail-pb0-f46.google.com with SMTP id wy7so2223709pbc.19
        for <linux-wireless@vger.kernel.org>; Mon, 10 Dec 2012 14:48:25 -0800 (PST)
From: Thomas Pedersen <thomas@cozybit.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH 2/3] ath9k_htc: RX timestamp is reported at end of frame
Date: Mon, 10 Dec 2012 14:48:02 -0800
Message-Id: <1355179683-24846-2-git-send-email-thomas@cozybit.com> (sfid-20121210_234829_143851_5120E7E4)
In-Reply-To: <1355179683-24846-1-git-send-email-thomas@cozybit.com>
References: <1355179683-24846-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Accurate RX timestamp reporting is important for proper IBSS merging,
mesh synchronization, and MCCA scheduling. Namely, knowing where the TSF
is recorded is needed to sync with the beacon timestamp field.

Tested with AR9271.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index 28cd50e..b6a5a08 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -1082,7 +1082,7 @@ static bool ath9k_rx_prepare(struct ath9k_htc_priv *priv,
 	rx_status->freq = hw->conf.channel->center_freq;
 	rx_status->signal =  rxbuf->rxstatus.rs_rssi + ATH_DEFAULT_NOISE_FLOOR;
 	rx_status->antenna = rxbuf->rxstatus.rs_antenna;
-	rx_status->flag |= RX_FLAG_MACTIME_START;
+	rx_status->flag |= RX_FLAG_MACTIME_END;
 
 	return true;
 
-- 
1.7.10.4

