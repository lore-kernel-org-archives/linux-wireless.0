Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:56286 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514AbaESVPS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 May 2014 17:15:18 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
	ath9k-devel@venema.h4ckr.net,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] ath9k_htc: use 'struct ath_htc_rx_status *' in call to ath9k_htc_err_stat_rx
Date: Mon, 19 May 2014 17:07:50 -0400
Message-Id: <1400533670-23340-1-git-send-email-linville@tuxdriver.com> (sfid-20140519_231526_652741_8B6B49A1)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  CC [M]  drivers/net/wireless/ath/ath9k/htc_drv_txrx.o
drivers/net/wireless/ath/ath9k/htc_drv_txrx.c: In function ‘ath9k_rx_prepare’:
drivers/net/wireless/ath/ath9k/htc_drv_txrx.c:1006:2: warning: passing argument 2 of ‘ath9k_htc_err_stat_rx’ from incompatible pointer type [enabled by default]
  ath9k_htc_err_stat_rx(priv, &rx_stats);
  ^
In file included from drivers/net/wireless/ath/ath9k/htc_drv_txrx.c:17:0:
drivers/net/wireless/ath/ath9k/htc.h:380:20: note: expected ‘struct ath_htc_rx_status *’ but argument is of type ‘struct ath_rx_status *’
 static inline void ath9k_htc_err_stat_rx(struct ath9k_htc_priv *priv,

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
Compile-test only...seems reasonable?

 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index bb86eb2ffc95..c1490ddc2965 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -1003,7 +1003,7 @@ static bool ath9k_rx_prepare(struct ath9k_htc_priv *priv,
 	/* Copy everything from ath_htc_rx_status (HTC_RX_FRAME_HEADER).
 	 * After this, we can drop this part of skb. */
 	rx_status_htc_to_ath(&rx_stats, rxstatus);
-	ath9k_htc_err_stat_rx(priv, &rx_stats);
+	ath9k_htc_err_stat_rx(priv, rxstatus);
 	rx_status->mactime = be64_to_cpu(rxstatus->rs_tstamp);
 	skb_pull(skb, HTC_RX_FRAME_HEADER_SIZE);
 
-- 
1.9.0

