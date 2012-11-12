Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:51309 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752Ab2KLSrs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Nov 2012 13:47:48 -0500
Received: by mail-pa0-f46.google.com with SMTP id hz1so4478273pad.19
        for <linux-wireless@vger.kernel.org>; Mon, 12 Nov 2012 10:47:48 -0800 (PST)
From: Thomas Pedersen <thomas@cozybit.com>
To: ath9k-devel@lists.ath9k.org
Cc: mcgrof@qca.qualcomm.com, jouni@qca.qualcomm.com,
	vthiagar@qca.qualcomm.com, senthilb@qca.qualcomm.com,
	linux-wireless@vger.kernel.org,
	Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH 2/2] ath9k_htc: RX timestamp is reported at end of frame
Date: Mon, 12 Nov 2012 10:47:32 -0800
Message-Id: <1352746052-1828-3-git-send-email-thomas@cozybit.com> (sfid-20121112_194802_738471_911DABE1)
In-Reply-To: <1352746052-1828-1-git-send-email-thomas@cozybit.com>
References: <1352746052-1828-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tested with AR9271.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index 06cdcb7..1708b01 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -1082,7 +1082,7 @@ static bool ath9k_rx_prepare(struct ath9k_htc_priv *priv,
 	rx_status->freq = hw->conf.channel->center_freq;
 	rx_status->signal =  rxbuf->rxstatus.rs_rssi + ATH_DEFAULT_NOISE_FLOOR;
 	rx_status->antenna = rxbuf->rxstatus.rs_antenna;
-	rx_status->flag |= RX_FLAG_MACTIME_MPDU;
+	rx_status->flag |= RX_FLAG_MACTIME_END;
 
 	return true;
 
-- 
1.7.10.4

