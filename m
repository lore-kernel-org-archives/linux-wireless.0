Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.bugwerft.de ([46.23.86.59]:57028 "EHLO mail.bugwerft.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754207AbeDPNQo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 16 Apr 2018 09:16:44 -0400
From: Daniel Mack <daniel@zonque.org>
To: linux-wireless@vger.kernel.org
Cc: wcn36xx@lists.infradead.org, kvalo@codeaurora.org,
        loic.poulain@linaro.org, rfried@codeaurora.org,
        bjorn.andersson@linaro.org, Daniel Mack <daniel@zonque.org>
Subject: [PATCH 1/5] wcn36xx: abort scan request when 'dequeued' indicator is sent
Date: Mon, 16 Apr 2018 15:16:30 +0200
Message-Id: <20180416131634.25432-2-daniel@zonque.org> (sfid-20180416_151648_036820_6D00ED74)
In-Reply-To: <20180416131634.25432-1-daniel@zonque.org>
References: <20180416131634.25432-1-daniel@zonque.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When the firmware sends a WCN36XX_HAL_SCAN_IND_DEQUEUED indication,
the request is apparently no longer valid. Attempts to stop the hardware
scan request subsequently will lead to the following error message, and
the hardware is no longer able to communicate with any AP:

[   57.917186] wcn36xx: ERROR hal_stop_scan_offload response failed err=5

Interpreting this indicator message as scan abortion fixes this.

While at it, add a newline to a debug print.

Signed-off-by: Daniel Mack <daniel@zonque.org>
---
 drivers/net/wireless/ath/wcn36xx/smd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
index 297a785d0785..b7964f79d837 100644
--- a/drivers/net/wireless/ath/wcn36xx/smd.c
+++ b/drivers/net/wireless/ath/wcn36xx/smd.c
@@ -2140,10 +2140,11 @@ static int wcn36xx_smd_hw_scan_ind(struct wcn36xx *wcn, void *buf, size_t len)
 		return -EIO;
 	}
 
-	wcn36xx_dbg(WCN36XX_DBG_HAL, "scan indication (type %x)", rsp->type);
+	wcn36xx_dbg(WCN36XX_DBG_HAL, "scan indication (type %x)\n", rsp->type);
 
 	switch (rsp->type) {
 	case WCN36XX_HAL_SCAN_IND_FAILED:
+	case WCN36XX_HAL_SCAN_IND_DEQUEUED:
 		scan_info.aborted = true;
 		/* fall through */
 	case WCN36XX_HAL_SCAN_IND_COMPLETED:
@@ -2156,7 +2157,6 @@ static int wcn36xx_smd_hw_scan_ind(struct wcn36xx *wcn, void *buf, size_t len)
 		break;
 	case WCN36XX_HAL_SCAN_IND_STARTED:
 	case WCN36XX_HAL_SCAN_IND_FOREIGN_CHANNEL:
-	case WCN36XX_HAL_SCAN_IND_DEQUEUED:
 	case WCN36XX_HAL_SCAN_IND_PREEMPTED:
 	case WCN36XX_HAL_SCAN_IND_RESTARTED:
 		break;
-- 
2.14.3
