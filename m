Return-Path: <SRS0=7415=NL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1CA0ECDE44
	for <linux-wireless@archiver.kernel.org>; Wed, 31 Oct 2018 08:58:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B367320685
	for <linux-wireless@archiver.kernel.org>; Wed, 31 Oct 2018 08:58:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B367320685
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727805AbeJaR4D (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 31 Oct 2018 13:56:03 -0400
Received: from alexa-out-ams-01.qualcomm.com ([185.23.61.162]:23734 "EHLO
        alexa-out-ams-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727758AbeJaR4B (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 31 Oct 2018 13:56:01 -0400
X-Greylist: delayed 372 seconds by postgrey-1.27 at vger.kernel.org; Wed, 31 Oct 2018 13:55:51 EDT
X-IronPort-AV: E=Sophos;i="5.54,447,1534802400"; 
   d="scan'208";a="1418134"
Received: from ironmsg01-ams.qualcomm.com ([10.251.56.2])
  by alexa-out-ams-01.qualcomm.com with ESMTP; 31 Oct 2018 09:52:35 +0100
X-IronPort-AV: E=McAfee;i="5900,7806,9062"; a="6147934"
Received: from lx-merez1.mea.qualcomm.com ([10.18.173.103])
  by ironmsg01-ams.qualcomm.com with ESMTP; 31 Oct 2018 09:52:35 +0100
From:   Maya Erez <merez@codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Ahmad Masri <amasri@codeaurora.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        Maya Erez <merez@codeaurora.org>
Subject: [PATCH 14/16] wil6210: remove unnecessary alignment code from rx flow
Date:   Wed, 31 Oct 2018 10:52:22 +0200
Message-Id: <1540975944-30576-15-git-send-email-merez@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1540975944-30576-1-git-send-email-merez@codeaurora.org>
References: <1540975944-30576-1-git-send-email-merez@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ahmad Masri <amasri@codeaurora.org>

Rx buffers in EDMA mode are initialized to 4 bytes aligned size.
Remove the unnecessary alignment code applied on rx buffer size.

Signed-off-by: Ahmad Masri <amasri@codeaurora.org>
Signed-off-by: Maya Erez <merez@codeaurora.org>
---
 drivers/net/wireless/ath/wil6210/txrx_edma.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/txrx_edma.c b/drivers/net/wireless/ath/wil6210/txrx_edma.c
index c8490e7..686ba34 100644
--- a/drivers/net/wireless/ath/wil6210/txrx_edma.c
+++ b/drivers/net/wireless/ath/wil6210/txrx_edma.c
@@ -160,7 +160,7 @@ static int wil_ring_alloc_skb_edma(struct wil6210_priv *wil,
 				   struct wil_ring *ring, u32 i)
 {
 	struct device *dev = wil_to_dev(wil);
-	unsigned int sz = ALIGN(wil->rx_buf_len, 4);
+	unsigned int sz = wil->rx_buf_len;
 	dma_addr_t pa;
 	u16 buff_id;
 	struct list_head *active = &wil->rx_buff_mgmt.active;
@@ -602,6 +602,7 @@ static bool wil_is_rx_idle_edma(struct wil6210_priv *wil)
 
 static void wil_rx_buf_len_init_edma(struct wil6210_priv *wil)
 {
+	/* RX buffer size must be aligned to 4 bytes */
 	wil->rx_buf_len = rx_large_buf ?
 		WIL_MAX_ETH_MTU : WIL_EDMA_RX_BUF_LEN_DEFAULT;
 }
@@ -615,7 +616,6 @@ static int wil_rx_init_edma(struct wil6210_priv *wil, uint desc_ring_order)
 		sizeof(struct wil_rx_status_compressed) :
 		sizeof(struct wil_rx_status_extended);
 	int i;
-	u16 max_rx_pl_per_desc;
 
 	/* In SW reorder one must use extended status messages */
 	if (wil->use_compressed_rx_status && !wil->use_rx_hw_reordering) {
@@ -641,8 +641,6 @@ static int wil_rx_init_edma(struct wil6210_priv *wil, uint desc_ring_order)
 
 	wil_rx_buf_len_init_edma(wil);
 
-	max_rx_pl_per_desc = ALIGN(wil->rx_buf_len, 4);
-
 	/* Use debugfs dbg_num_rx_srings if set, reserve one sring for TX */
 	if (wil->num_rx_status_rings > WIL6210_MAX_STATUS_RINGS - 1)
 		wil->num_rx_status_rings = WIL6210_MAX_STATUS_RINGS - 1;
@@ -650,7 +648,7 @@ static int wil_rx_init_edma(struct wil6210_priv *wil, uint desc_ring_order)
 	wil_dbg_misc(wil, "rx_init: allocate %d status rings\n",
 		     wil->num_rx_status_rings);
 
-	rc = wil_wmi_cfg_def_rx_offload(wil, max_rx_pl_per_desc);
+	rc = wil_wmi_cfg_def_rx_offload(wil, wil->rx_buf_len);
 	if (rc)
 		return rc;
 
@@ -887,7 +885,7 @@ static struct sk_buff *wil_sring_reap_rx_edma(struct wil6210_priv *wil,
 	struct sk_buff *skb;
 	dma_addr_t pa;
 	struct wil_ring_rx_data *rxdata = &sring->rx_data;
-	unsigned int sz = ALIGN(wil->rx_buf_len, 4);
+	unsigned int sz = wil->rx_buf_len;
 	struct wil_net_stats *stats = NULL;
 	u16 dmalen;
 	int cid;
-- 
1.9.1

