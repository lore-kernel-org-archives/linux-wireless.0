Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:65014 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755420Ab0DWE6i (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Apr 2010 00:58:38 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 22 Apr 2010 21:58:38 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19409.10471.390330.74954@gargle.gargle.HOWL>
Date: Fri, 23 Apr 2010 10:28:15 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 06/11] ath9k_htc: Pass correct private pointer
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In the TX callback, the HTC layer has to pass the
priv pointer that was registered during service initialization.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc_hst.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_hst.c b/drivers/net/wireless/ath/ath9k/htc_hst.c
index f2dca25..7bf6ce1 100644
--- a/drivers/net/wireless/ath/ath9k/htc_hst.c
+++ b/drivers/net/wireless/ath/ath9k/htc_hst.c
@@ -341,8 +341,9 @@ void ath9k_htc_txcompletion_cb(struct htc_target *htc_handle,
 		skb_pull(skb, sizeof(struct htc_frame_hdr));
 
 		if (endpoint->ep_callbacks.tx) {
-			endpoint->ep_callbacks.tx(htc_handle->drv_priv, skb,
-						  htc_hdr->endpoint_id, txok);
+			endpoint->ep_callbacks.tx(endpoint->ep_callbacks.priv,
+						  skb, htc_hdr->endpoint_id,
+						  txok);
 		}
 	}
 
-- 
1.7.0.5

