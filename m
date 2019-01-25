Return-Path: <SRS0=MEvv=QB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D54D8C282C0
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Jan 2019 04:21:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A72B7218A6
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Jan 2019 04:21:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="mS6fvVJr";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="dgk8De1o"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728258AbfAYEVZ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 24 Jan 2019 23:21:25 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:53068 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727163AbfAYEVZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 Jan 2019 23:21:25 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 2C5706086A; Fri, 25 Jan 2019 04:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1548390084;
        bh=fRFSjXX+kyFWZt1jmSYvaeuTIYOdu7bnIcUUx81cd/0=;
        h=From:To:Cc:Subject:Date:From;
        b=mS6fvVJrowPka6Fd0yxdkExqn799ReHUa/PWclHLe0bUvck7IQyaroKm5kkFFITYj
         h5MR5umW9ncVr6B3eSiHUrJYaYX7yVnpQ7Zo9mMgUrawe0VLxSPwrFudx46s4I5MTM
         tFBt+Nw1ZZjz7wIVUGJV/jqpWXWJOWQcOyUG0E5A=
Received: from pillair-linux.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pillair@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 95E3160A04;
        Fri, 25 Jan 2019 04:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1548390080;
        bh=fRFSjXX+kyFWZt1jmSYvaeuTIYOdu7bnIcUUx81cd/0=;
        h=From:To:Cc:Subject:Date:From;
        b=dgk8De1oFbl1MMs0mDDbTbxxw60bv4k1lfo/lQcJzt+t5Lm6JFCXoT8TtGgcHgQPq
         iRFH/xm/xSSv1/T738VkG2tCjiG318rMDMWjQKSXopUMvYsbIJiNRGb5YfQt5jzV2x
         NjBU0eRBDgfjejL4HtWYNnZ1/Zeg99HB0INfIUJ4=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 95E3160A04
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=pillair@codeaurora.org
From:   Rakesh Pillai <pillair@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Rakesh Pillai <pillair@codeaurora.org>
Subject: [PATCH] ath10k: fix dma unmap direction for management frames
Date:   Fri, 25 Jan 2019 09:51:06 +0530
Message-Id: <1548390066-12305-1-git-send-email-pillair@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The management frames transmitted are dma mapped with
direction TO_DEVICE, but incorrectly mapped with
direction FROM_DEVICE during tx complete and error cases.

Fix the direction of dma during dma unmap of the
transmitted management frames.

Tested HW: WCN3990
Tested FW: WLAN.HL.2.0-01188-QCAHLSWMTPLZ-1

Fixes: 38a1390e02b7
Signed-off-by: Rakesh Pillai <pillair@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/mac.c | 4 ++--
 drivers/net/wireless/ath/ath10k/wmi.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index e49b367..8c6c515 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -1,7 +1,7 @@
 /*
  * Copyright (c) 2005-2011 Atheros Communications Inc.
  * Copyright (c) 2011-2017 Qualcomm Atheros, Inc.
- * Copyright (c) 2018, The Linux Foundation. All rights reserved.
+ * Copyright (c) 2018-2019, The Linux Foundation. All rights reserved.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
@@ -3863,7 +3863,7 @@ void ath10k_mgmt_over_wmi_tx_work(struct work_struct *work)
 				ath10k_warn(ar, "failed to transmit management frame by ref via WMI: %d\n",
 					    ret);
 				dma_unmap_single(ar->dev, paddr, skb->len,
-						 DMA_FROM_DEVICE);
+						 DMA_TO_DEVICE);
 				ieee80211_free_txskb(ar->hw, skb);
 			}
 		} else {
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index ba83740..5a07c7d 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -1,7 +1,7 @@
 /*
  * Copyright (c) 2005-2011 Atheros Communications Inc.
  * Copyright (c) 2011-2017 Qualcomm Atheros, Inc.
- * Copyright (c) 2018, The Linux Foundation. All rights reserved.
+ * Copyright (c) 2018-2019, The Linux Foundation. All rights reserved.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
@@ -2346,7 +2346,7 @@ static int wmi_process_mgmt_tx_comp(struct ath10k *ar, u32 desc_id,
 
 	msdu = pkt_addr->vaddr;
 	dma_unmap_single(ar->dev, pkt_addr->paddr,
-			 msdu->len, DMA_FROM_DEVICE);
+			 msdu->len, DMA_TO_DEVICE);
 	info = IEEE80211_SKB_CB(msdu);
 
 	if (status)
-- 
2.7.4

