Return-Path: <SRS0=p1B+=3K=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F007C33CAA
	for <linux-wireless@archiver.kernel.org>; Tue, 21 Jan 2020 07:14:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6D1B322522
	for <linux-wireless@archiver.kernel.org>; Tue, 21 Jan 2020 07:14:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728843AbgAUHOJ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 21 Jan 2020 02:14:09 -0500
Received: from alexa-out-blr-01.qualcomm.com ([103.229.18.197]:18844 "EHLO
        alexa-out-blr-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725789AbgAUHOJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Jan 2020 02:14:09 -0500
Received: from ironmsg01-blr.qualcomm.com ([10.86.208.130])
  by alexa-out-blr-01.qualcomm.com with ESMTP/TLS/AES256-SHA; 21 Jan 2020 12:42:39 +0530
Received: from pillair-linux.qualcomm.com ([10.204.116.193])
  by ironmsg01-blr.qualcomm.com with ESMTP; 21 Jan 2020 12:42:33 +0530
Received: by pillair-linux.qualcomm.com (Postfix, from userid 452944)
        id A2C2838EF; Tue, 21 Jan 2020 12:42:32 +0530 (IST)
From:   Rakesh Pillai <pillair@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Rakesh Pillai <pillair@codeaurora.org>
Subject: [PATCH] ath10k: Correct the DMA direction for management tx buffers
Date:   Tue, 21 Jan 2020 12:42:28 +0530
Message-Id: <1579590748-17883-1-git-send-email-pillair@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The management packets, send to firmware via WMI, are
mapped using the direction DMA_TO_DEVICE. Currently in
case of wmi cleanup, these buffers are being unmapped
using an incorrect DMA direction. This can cause unwanted
behavior when the host driver is handling a restart
of the wlan firmware.

We might see a trace like below

[<ffffff8008098b18>] __dma_inv_area+0x28/0x58
[<ffffff8001176734>] ath10k_wmi_mgmt_tx_clean_up_pending+0x60/0xb0 [ath10k_core]
[<ffffff80088c7c50>] idr_for_each+0x78/0xe4
[<ffffff80011766a4>] ath10k_wmi_detach+0x4c/0x7c [ath10k_core]
[<ffffff8001163d7c>] ath10k_core_stop+0x58/0x68 [ath10k_core]
[<ffffff800114fb74>] ath10k_halt+0xec/0x13c [ath10k_core]
[<ffffff8001165110>] ath10k_core_restart+0x11c/0x1a8 [ath10k_core]
[<ffffff80080c36bc>] process_one_work+0x16c/0x31c

Fix the incorrect DMA direction during the wmi
management tx buffer cleanup.

Tested HW: WCN3990
Tested FW: WLAN.HL.3.1-00784-QCAHLSWMTPLZ-1

Fixes: dc405152bb6 ("ath10k: handle mgmt tx completion event")
Signed-off-by: Rakesh Pillai <pillair@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/wmi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 13f7531..61885d4 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -9490,7 +9490,7 @@ static int ath10k_wmi_mgmt_tx_clean_up_pending(int msdu_id, void *ptr,
 
 	msdu = pkt_addr->vaddr;
 	dma_unmap_single(ar->dev, pkt_addr->paddr,
-			 msdu->len, DMA_FROM_DEVICE);
+			 msdu->len, DMA_TO_DEVICE);
 	ieee80211_free_txskb(ar->hw, msdu);
 
 	return 0;
-- 
2.7.4

