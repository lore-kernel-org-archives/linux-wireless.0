Return-Path: <SRS0=7415=NL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06192ECDE46
	for <linux-wireless@archiver.kernel.org>; Wed, 31 Oct 2018 08:58:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CB06F20685
	for <linux-wireless@archiver.kernel.org>; Wed, 31 Oct 2018 08:58:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CB06F20685
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727741AbeJaRz6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 31 Oct 2018 13:55:58 -0400
Received: from alexa-out-ams-01.qualcomm.com ([185.23.61.162]:23734 "EHLO
        alexa-out-ams-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727661AbeJaRz6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 31 Oct 2018 13:55:58 -0400
X-Greylist: delayed 372 seconds by postgrey-1.27 at vger.kernel.org; Wed, 31 Oct 2018 13:55:51 EDT
X-IronPort-AV: E=Sophos;i="5.54,447,1534802400"; 
   d="scan'208";a="1418124"
Received: from ironmsg01-ams.qualcomm.com ([10.251.56.2])
  by alexa-out-ams-01.qualcomm.com with ESMTP; 31 Oct 2018 09:52:29 +0100
X-IronPort-AV: E=McAfee;i="5900,7806,9062"; a="6147924"
Received: from lx-merez1.mea.qualcomm.com ([10.18.173.103])
  by ironmsg01-ams.qualcomm.com with ESMTP; 31 Oct 2018 09:52:29 +0100
From:   Maya Erez <merez@codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Dedy Lansky <dlansky@codeaurora.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        Maya Erez <merez@codeaurora.org>
Subject: [PATCH 04/16] wil6210: make sure Rx ring sizes are correlated
Date:   Wed, 31 Oct 2018 10:52:12 +0200
Message-Id: <1540975944-30576-5-git-send-email-merez@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1540975944-30576-1-git-send-email-merez@codeaurora.org>
References: <1540975944-30576-1-git-send-email-merez@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Dedy Lansky <dlansky@codeaurora.org>

When enlarging rx_ring_order module param, wil6210 fails to load
because there are not enough Rx buffers.
Fix this by enlarging number of Rx buffers at startup, if needed based
on rx_ring_order.

Signed-off-by: Dedy Lansky <dlansky@codeaurora.org>
Signed-off-by: Maya Erez <merez@codeaurora.org>
---
 drivers/net/wireless/ath/wil6210/main.c      |  2 +-
 drivers/net/wireless/ath/wil6210/txrx.c      |  4 ++--
 drivers/net/wireless/ath/wil6210/txrx_edma.c | 11 ++++++++---
 drivers/net/wireless/ath/wil6210/wil6210.h   |  2 +-
 4 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 078ad5cf..55084770 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -1689,7 +1689,7 @@ int __wil_up(struct wil6210_priv *wil)
 			WIL_RX_RING_SIZE_ORDER_DEFAULT :
 			WIL_RX_RING_SIZE_ORDER_TALYN_DEFAULT;
 
-	rc = wil->txrx_ops.rx_init(wil, 1 << rx_ring_order);
+	rc = wil->txrx_ops.rx_init(wil, rx_ring_order);
 	if (rc)
 		return rc;
 
diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index 70eceec..c592c8e 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -872,7 +872,7 @@ static void wil_rx_buf_len_init(struct wil6210_priv *wil)
 	}
 }
 
-static int wil_rx_init(struct wil6210_priv *wil, u16 size)
+static int wil_rx_init(struct wil6210_priv *wil, uint order)
 {
 	struct wil_ring *vring = &wil->ring_rx;
 	int rc;
@@ -886,7 +886,7 @@ static int wil_rx_init(struct wil6210_priv *wil, u16 size)
 
 	wil_rx_buf_len_init(wil);
 
-	vring->size = size;
+	vring->size = 1 << order;
 	vring->is_rx = true;
 	rc = wil_vring_alloc(wil, vring);
 	if (rc)
diff --git a/drivers/net/wireless/ath/wil6210/txrx_edma.c b/drivers/net/wireless/ath/wil6210/txrx_edma.c
index ce71358..fe758f2 100644
--- a/drivers/net/wireless/ath/wil6210/txrx_edma.c
+++ b/drivers/net/wireless/ath/wil6210/txrx_edma.c
@@ -606,9 +606,9 @@ static void wil_rx_buf_len_init_edma(struct wil6210_priv *wil)
 		WIL_MAX_ETH_MTU : WIL_EDMA_RX_BUF_LEN_DEFAULT;
 }
 
-static int wil_rx_init_edma(struct wil6210_priv *wil, u16 desc_ring_size)
+static int wil_rx_init_edma(struct wil6210_priv *wil, uint desc_ring_order)
 {
-	u16 status_ring_size;
+	u16 status_ring_size, desc_ring_size = 1 << desc_ring_order;
 	struct wil_ring *ring = &wil->ring_rx;
 	int rc;
 	size_t elem_size = wil->use_compressed_rx_status ?
@@ -623,7 +623,12 @@ static int wil_rx_init_edma(struct wil6210_priv *wil, u16 desc_ring_size)
 			"compressed RX status cannot be used with SW reorder\n");
 		return -EINVAL;
 	}
-
+	if (wil->rx_status_ring_order <= desc_ring_order)
+		/* make sure sring is larger than desc ring */
+		wil->rx_status_ring_order = desc_ring_order + 1;
+	if (wil->rx_buff_id_count <= desc_ring_size)
+		/* make sure we will not run out of buff_ids */
+		wil->rx_buff_id_count = desc_ring_size + 512;
 	if (wil->rx_status_ring_order < WIL_SRING_SIZE_ORDER_MIN ||
 	    wil->rx_status_ring_order > WIL_SRING_SIZE_ORDER_MAX)
 		wil->rx_status_ring_order = WIL_RX_SRING_SIZE_ORDER_DEFAULT;
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 414de54..31753f94 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -614,7 +614,7 @@ struct wil_txrx_ops {
 			      int cid, int tid);
 	irqreturn_t (*irq_tx)(int irq, void *cookie);
 	/* RX ops */
-	int (*rx_init)(struct wil6210_priv *wil, u16 ring_size);
+	int (*rx_init)(struct wil6210_priv *wil, uint ring_order);
 	void (*rx_fini)(struct wil6210_priv *wil);
 	int (*wmi_addba_rx_resp)(struct wil6210_priv *wil, u8 mid, u8 cid,
 				 u8 tid, u8 token, u16 status, bool amsdu,
-- 
1.9.1

