Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:45747 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752943Ab2KVUjb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Nov 2012 15:39:31 -0500
Received: by mail-pa0-f46.google.com with SMTP id bh2so3083395pad.19
        for <linux-wireless@vger.kernel.org>; Thu, 22 Nov 2012 12:39:31 -0800 (PST)
From: Thomas Pedersen <thomas@cozybit.com>
To: ath9k-devel@lists.ath9k.org
Cc: mcgrof@qca.qualcomm.com, jouni@qca.qualcomm.com,
	vthiagar@qca.qualcomm.com, senthilb@qca.qualcomm.com,
	linux-wireless@vger.kernel.org,
	Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH v3 2/2] ath9k_htc: RX timestamp is reported at end of frame
Date: Wed, 21 Nov 2012 18:06:27 -0800
Message-Id: <1353549987-24656-2-git-send-email-thomas@cozybit.com> (sfid-20121122_213938_133520_86E0917A)
In-Reply-To: <1353549987-24656-1-git-send-email-thomas@cozybit.com>
References: <1353549987-24656-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Accurate RX timestamp reporting is important for proper IBSS merging,
mesh synchronization, and MCCA scheduling. Namely, knowing where the TSF
is recorded is needed to sync with the beacon timestamp field.

Tested with AR9271.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
v2:
        clarify commit log (Luis)

v3:
	rebase on wt

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

