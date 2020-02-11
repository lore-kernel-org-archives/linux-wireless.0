Return-Path: <SRS0=yzGj=37=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60FF7C352A3
	for <linux-wireless@archiver.kernel.org>; Tue, 11 Feb 2020 12:26:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 38FBE20714
	for <linux-wireless@archiver.kernel.org>; Tue, 11 Feb 2020 12:26:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728454AbgBKM0R (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 11 Feb 2020 07:26:17 -0500
Received: from nbd.name ([46.4.11.11]:59474 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728288AbgBKM0R (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Feb 2020 07:26:17 -0500
Received: from [46.59.221.152] (helo=bertha.fritz.box)
        by ds12 with esmtpa (Exim 4.89)
        (envelope-from <john@phrozen.org>)
        id 1j1UcH-000356-8p; Tue, 11 Feb 2020 13:26:13 +0100
From:   John Crispin <john@phrozen.org>
To:     Johannes Berg <johannes@sipsolutions.net>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, ath11k@lists.infradead.org,
        John Crispin <john@phrozen.org>
Subject: [PATCH 2/2] ath11k: set queue_len to 4096
Date:   Tue, 11 Feb 2020 13:26:05 +0100
Message-Id: <20200211122605.13002-2-john@phrozen.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200211122605.13002-1-john@phrozen.org>
References: <20200211122605.13002-1-john@phrozen.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The driver currently does not use wake_txq_queue. This leads to the
tx_queue_len being defaulted to 1000. Setting this parameter will
change the queue_len to 4096 which is more fitting for HE.

Signed-off-by: John Crispin <john@phrozen.org>
---
 drivers/net/wireless/ath/ath11k/hw.h  | 1 +
 drivers/net/wireless/ath/ath11k/mac.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath11k/hw.h b/drivers/net/wireless/ath/ath11k/hw.h
index dd39333ec0ea..9973477ae373 100644
--- a/drivers/net/wireless/ath/ath11k/hw.h
+++ b/drivers/net/wireless/ath/ath11k/hw.h
@@ -62,6 +62,7 @@
 #define TARGET_RX_BATCHMODE		1
 
 #define ATH11K_HW_MAX_QUEUES		4
+#define ATH11K_QUEUE_LEN		4096
 
 #define ATH11k_HW_RATECODE_CCK_SHORT_PREAM_MASK  0x4
 
diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index 139ecbcf0179..c0606e4a8967 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -6025,6 +6025,7 @@ static int __ath11k_mac_register(struct ath11k *ar)
 	ar->hw->wiphy->max_ap_assoc_sta = ar->max_num_stations;
 
 	ar->hw->queues = ATH11K_HW_MAX_QUEUES;
+	ar->hw->wiphy->tx_queue_len = ATH11K_QUEUE_LEN;
 	ar->hw->offchannel_tx_hw_queue = ATH11K_HW_MAX_QUEUES - 1;
 	ar->hw->max_rx_aggregation_subframes = IEEE80211_MAX_AMPDU_BUF;
 
-- 
2.20.1

