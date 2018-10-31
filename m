Return-Path: <SRS0=7415=NL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7AF1ECDE4B
	for <linux-wireless@archiver.kernel.org>; Wed, 31 Oct 2018 08:58:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7945A20840
	for <linux-wireless@archiver.kernel.org>; Wed, 31 Oct 2018 08:58:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7945A20840
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727733AbeJaRz6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 31 Oct 2018 13:55:58 -0400
Received: from alexa-out-ams-01.qualcomm.com ([185.23.61.162]:23736 "EHLO
        alexa-out-ams-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727610AbeJaRz6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 31 Oct 2018 13:55:58 -0400
X-IronPort-AV: E=Sophos;i="5.54,447,1534802400"; 
   d="scan'208";a="1418123"
Received: from ironmsg01-ams.qualcomm.com ([10.251.56.2])
  by alexa-out-ams-01.qualcomm.com with ESMTP; 31 Oct 2018 09:52:29 +0100
X-IronPort-AV: E=McAfee;i="5900,7806,9062"; a="6147923"
Received: from lx-merez1.mea.qualcomm.com ([10.18.173.103])
  by ironmsg01-ams.qualcomm.com with ESMTP; 31 Oct 2018 09:52:28 +0100
From:   Maya Erez <merez@codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Maya Erez <merez@codeaurora.org>, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com
Subject: [PATCH 03/16] wil6210: increase RX rings and RX buff array size
Date:   Wed, 31 Oct 2018 10:52:11 +0200
Message-Id: <1540975944-30576-4-git-send-email-merez@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1540975944-30576-1-git-send-email-merez@codeaurora.org>
References: <1540975944-30576-1-git-send-email-merez@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

In Talyn-MB, the 11ad throughput is higher and performance drops
may occur in the current RX configuration due to unavailability
of Rx buffers.
Increase the RX descriptor ring, RX status ring and number of RX
buffers to stabilize the performance in high throughput.

Signed-off-by: Maya Erez <merez@codeaurora.org>
---
 drivers/net/wireless/ath/wil6210/main.c      | 7 ++++++-
 drivers/net/wireless/ath/wil6210/txrx_edma.c | 4 ++--
 drivers/net/wireless/ath/wil6210/txrx_edma.h | 4 ++--
 drivers/net/wireless/ath/wil6210/wil6210.h   | 1 +
 4 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index c54b008..078ad5cf 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -80,7 +80,7 @@ static int mtu_max_set(const char *val, const struct kernel_param *kp)
 module_param_cb(mtu_max, &mtu_max_ops, &mtu_max, 0444);
 MODULE_PARM_DESC(mtu_max, " Max MTU value.");
 
-static uint rx_ring_order = WIL_RX_RING_SIZE_ORDER_DEFAULT;
+static uint rx_ring_order;
 static uint tx_ring_order = WIL_TX_RING_SIZE_ORDER_DEFAULT;
 static uint bcast_ring_order = WIL_BCAST_RING_SIZE_ORDER_DEFAULT;
 
@@ -1684,6 +1684,11 @@ int __wil_up(struct wil6210_priv *wil)
 		return rc;
 
 	/* Rx RING. After MAC and beacon */
+	if (rx_ring_order == 0)
+		rx_ring_order = wil->hw_version < HW_VER_TALYN_MB ?
+			WIL_RX_RING_SIZE_ORDER_DEFAULT :
+			WIL_RX_RING_SIZE_ORDER_TALYN_DEFAULT;
+
 	rc = wil->txrx_ops.rx_init(wil, 1 << rx_ring_order);
 	if (rc)
 		return rc;
diff --git a/drivers/net/wireless/ath/wil6210/txrx_edma.c b/drivers/net/wireless/ath/wil6210/txrx_edma.c
index 2bbae75..ce71358 100644
--- a/drivers/net/wireless/ath/wil6210/txrx_edma.c
+++ b/drivers/net/wireless/ath/wil6210/txrx_edma.c
@@ -357,8 +357,8 @@ static int wil_init_rx_sring(struct wil6210_priv *wil,
 	struct wil_status_ring *sring = &wil->srings[ring_id];
 	int rc;
 
-	wil_dbg_misc(wil, "init RX sring: size=%u, ring_id=%u\n", sring->size,
-		     ring_id);
+	wil_dbg_misc(wil, "init RX sring: size=%u, ring_id=%u\n",
+		     status_ring_size, ring_id);
 
 	memset(&sring->rx_data, 0, sizeof(sring->rx_data));
 
diff --git a/drivers/net/wireless/ath/wil6210/txrx_edma.h b/drivers/net/wireless/ath/wil6210/txrx_edma.h
index a7fe929..343516a 100644
--- a/drivers/net/wireless/ath/wil6210/txrx_edma.h
+++ b/drivers/net/wireless/ath/wil6210/txrx_edma.h
@@ -23,9 +23,9 @@
 #define WIL_SRING_SIZE_ORDER_MIN	(WIL_RING_SIZE_ORDER_MIN)
 #define WIL_SRING_SIZE_ORDER_MAX	(WIL_RING_SIZE_ORDER_MAX)
 /* RX sring order should be bigger than RX ring order */
-#define WIL_RX_SRING_SIZE_ORDER_DEFAULT	(11)
+#define WIL_RX_SRING_SIZE_ORDER_DEFAULT	(12)
 #define WIL_TX_SRING_SIZE_ORDER_DEFAULT	(12)
-#define WIL_RX_BUFF_ARR_SIZE_DEFAULT (1536)
+#define WIL_RX_BUFF_ARR_SIZE_DEFAULT (2600)
 
 #define WIL_DEFAULT_RX_STATUS_RING_ID 0
 #define WIL_RX_DESC_RING_ID 0
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index abb8201..414de54 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -81,6 +81,7 @@ static inline u32 WIL_GET_BITS(u32 x, int b0, int b1)
 
 #define WIL_TX_Q_LEN_DEFAULT		(4000)
 #define WIL_RX_RING_SIZE_ORDER_DEFAULT	(10)
+#define WIL_RX_RING_SIZE_ORDER_TALYN_DEFAULT	(11)
 #define WIL_TX_RING_SIZE_ORDER_DEFAULT	(12)
 #define WIL_BCAST_RING_SIZE_ORDER_DEFAULT	(7)
 #define WIL_BCAST_MCS0_LIMIT		(1024) /* limit for MCS0 frame size */
-- 
1.9.1

