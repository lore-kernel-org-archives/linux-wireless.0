Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:34497 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750877AbeFTImd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Jun 2018 04:42:33 -0400
Received: by mail-lf0-f67.google.com with SMTP id e13-v6so3401790lfc.1
        for <linux-wireless@vger.kernel.org>; Wed, 20 Jun 2018 01:42:32 -0700 (PDT)
From: Niklas Cassel <niklas.cassel@linaro.org>
To: Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>
Cc: alagusankar@silex-india.com,
        Niklas Cassel <niklas.cassel@linaro.org>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] ath10k: sdio: use same endpoint id for all packets in a bundle
Date: Wed, 20 Jun 2018 10:42:20 +0200
Message-Id: <20180620084222.3521-2-niklas.cassel@linaro.org> (sfid-20180620_110322_714920_185B7F16)
In-Reply-To: <20180620084222.3521-1-niklas.cassel@linaro.org>
References: <20180620084222.3521-1-niklas.cassel@linaro.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All packets in a bundle should use the same endpoint id as the
first lookahead.

This matches how things are done is ath6kl, however,
this patch can theoretically handle several bundles
in ath10k_sdio_mbox_rx_process_packets().

Without this patch we get lots of errors about invalid endpoint id:

ath10k_sdio mmc2:0001:1: invalid endpoint in look-ahead: 224
ath10k_sdio mmc2:0001:1: failed to get pending recv messages: -12
ath10k_sdio mmc2:0001:1: failed to process pending SDIO interrupts: -12

Signed-off-by: Alagu Sankar <alagusankar@silex-india.com>
Signed-off-by: Niklas Cassel <niklas.cassel@linaro.org>
---
 drivers/net/wireless/ath/ath10k/sdio.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/sdio.c b/drivers/net/wireless/ath/ath10k/sdio.c
index d612ce8c9cff..d46523b0472c 100644
--- a/drivers/net/wireless/ath/ath10k/sdio.c
+++ b/drivers/net/wireless/ath/ath10k/sdio.c
@@ -434,12 +434,14 @@ static int ath10k_sdio_mbox_rx_process_packets(struct ath10k *ar,
 	enum ath10k_htc_ep_id id;
 	int ret, i, *n_lookahead_local;
 	u32 *lookaheads_local;
+	int lookahead_idx = 0;
 
 	for (i = 0; i < ar_sdio->n_rx_pkts; i++) {
 		lookaheads_local = lookaheads;
 		n_lookahead_local = n_lookahead;
 
-		id = ((struct ath10k_htc_hdr *)&lookaheads[i])->eid;
+		id = ((struct ath10k_htc_hdr *)
+		      &lookaheads[lookahead_idx++])->eid;
 
 		if (id >= ATH10K_HTC_EP_COUNT) {
 			ath10k_warn(ar, "invalid endpoint in look-ahead: %d\n",
@@ -462,6 +464,7 @@ static int ath10k_sdio_mbox_rx_process_packets(struct ath10k *ar,
 			/* Only read lookahead's from RX trailers
 			 * for the last packet in a bundle.
 			 */
+			lookahead_idx--;
 			lookaheads_local = NULL;
 			n_lookahead_local = NULL;
 		}
-- 
2.17.1
