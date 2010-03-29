Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:50325 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754769Ab0C2KRE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Mar 2010 06:17:04 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 29 Mar 2010 03:17:04 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19376.33498.24680.103591@gargle.gargle.HOWL>
Date: Mon, 29 Mar 2010 16:07:14 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 3/7] ath9k_htc: Fix watchdog pattern parsing
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Skip beyond the watchdog pattern properly.
This fixes occasional failure of the driver to load.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc_hst.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_hst.c b/drivers/net/wireless/ath/ath9k/htc_hst.c
index 9a48999..30f608b 100644
--- a/drivers/net/wireless/ath/ath9k/htc_hst.c
+++ b/drivers/net/wireless/ath/ath9k/htc_hst.c
@@ -377,7 +377,7 @@ void ath9k_htc_rx_msg(struct htc_target *htc_handle,
 		if (htc_hdr->flags & HTC_FLAGS_RECV_TRAILER) {
 			if (be32_to_cpu(*(u32 *) skb->data) == 0x00C60000)
 				/* Move past the Watchdog pattern */
-				htc_hdr = (struct htc_frame_hdr *) skb->data + 4;
+				htc_hdr = (struct htc_frame_hdr *)(skb->data + 4);
 		}
 
 		/* Get the message ID */
-- 
1.7.0.3

