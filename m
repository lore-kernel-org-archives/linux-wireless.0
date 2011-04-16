Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:43745 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751973Ab1DPIri (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Apr 2011 04:47:38 -0400
Received: from mail.atheros.com ([10.234.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sat, 16 Apr 2011 01:47:12 -0700
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanoharan@atheros.com>
Subject: [PATCH] ath9k_htc: Fix free slot value for cab queue
Date: Sat, 16 Apr 2011 14:17:39 +0530
Message-ID: <1302943659-20116-1-git-send-email-rmanoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath9k_htc_tx_get_slot can return zero as valid index.

Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_beacon.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
index bf7ef1b..a157107 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
@@ -322,7 +322,7 @@ static void ath9k_htc_send_buffered(struct ath9k_htc_priv *priv,
 		}
 
 		tx_slot = ath9k_htc_tx_get_slot(priv);
-		if (tx_slot != 0) {
+		if (tx_slot < 0) {
 			ath_dbg(common, ATH_DBG_XMIT, "No free CAB slot\n");
 			dev_kfree_skb_any(skb);
 			goto next;
-- 
1.7.4.4

