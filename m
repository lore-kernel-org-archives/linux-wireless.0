Return-Path: <SRS0=FR9J=Q5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9150EC10F00
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 14:21:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6B8EC20700
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 14:21:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726737AbfBVOV1 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Feb 2019 09:21:27 -0500
Received: from alexa-out-ams-01.qualcomm.com ([185.23.61.162]:46067 "EHLO
        alexa-out-ams-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726663AbfBVOV1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Feb 2019 09:21:27 -0500
X-IronPort-AV: E=Sophos;i="5.58,400,1544482800"; 
   d="scan'208";a="2017368"
Received: from ironmsg02-ams.qualcomm.com ([10.251.56.3])
  by alexa-out-ams-01.qualcomm.com with ESMTP; 22 Feb 2019 15:21:23 +0100
X-IronPort-AV: E=McAfee;i="5900,7806,9174"; a="7285575"
Received: from lx-merez1.mea.qualcomm.com ([10.18.173.103])
  by ironmsg02-ams.qualcomm.com with ESMTP; 22 Feb 2019 15:21:23 +0100
From:   Maya Erez <merez@codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Dedy Lansky <dlansky@codeaurora.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        Maya Erez <merez@codeaurora.org>
Subject: [PATCH 02/21] wil6210: add option to drop Tx packets when Tx ring is full
Date:   Fri, 22 Feb 2019 16:21:00 +0200
Message-Id: <1550845279-16103-3-git-send-email-merez@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1550845279-16103-1-git-send-email-merez@codeaurora.org>
References: <1550845279-16103-1-git-send-email-merez@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Dedy Lansky <dlansky@codeaurora.org>

In AP mode with multiple clients, driver stops net queue
(netif_tx_stop_queue) upon first ring (serving specific client)
becoming full. This can have negative effect on transmission to
other clients which may still have room in their corresponding rings.

Implement new policy in which stop/wake net queue are not used. In
case there is no room in the ring for a transmitted packet, drop the
packet.

New policy can be helpful to debug performance issues, to guarantee
maximum utilization of net queues.
New policy is disabled by default and can be enabled by debugfs:
echo 1 > drop_if_ring_full

Signed-off-by: Dedy Lansky <dlansky@codeaurora.org>
Signed-off-by: Maya Erez <merez@codeaurora.org>
---
 drivers/net/wireless/ath/wil6210/debugfs.c | 3 ++-
 drivers/net/wireless/ath/wil6210/txrx.c    | 9 +++++++++
 drivers/net/wireless/ath/wil6210/wil6210.h | 3 ++-
 3 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index 835c902..acbf2f0 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2012-2017 Qualcomm Atheros, Inc.
- * Copyright (c) 2018, The Linux Foundation. All rights reserved.
+ * Copyright (c) 2018-2019, The Linux Foundation. All rights reserved.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
@@ -2386,6 +2386,7 @@ static void wil6210_debugfs_init_isr(struct wil6210_priv *wil,
 	{"led_polarity", 0644, (ulong)&led_polarity, doff_u8},
 	{"status_index", 0644, (ulong)&dbg_status_msg_index, doff_u32},
 	{"sring_index",	0644, (ulong)&dbg_sring_index, doff_u32},
+	{"drop_if_ring_full", 0644, (ulong)&drop_if_ring_full, doff_u8},
 	{},
 };
 
diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index 4d286fb..de259dc 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -38,6 +38,9 @@
 module_param(rx_large_buf, bool, 0444);
 MODULE_PARM_DESC(rx_large_buf, " allocate 8KB RX buffers, default - no");
 
+/* Drop Tx packets in case Tx ring is full */
+bool drop_if_ring_full;
+
 static inline uint wil_rx_snaplen(void)
 {
 	return rx_align_2 ? 6 : 0;
@@ -1974,6 +1977,10 @@ static inline void __wil_update_net_queues(struct wil6210_priv *wil,
 		wil_dbg_txrx(wil, "check_stop=%d, mid=%d, stopped=%d",
 			     check_stop, vif->mid, vif->net_queue_stopped);
 
+	if (ring && drop_if_ring_full)
+		/* no need to stop/wake net queues */
+		return;
+
 	if (check_stop == vif->net_queue_stopped)
 		/* net queues already in desired state */
 		return;
@@ -2099,6 +2106,8 @@ netdev_tx_t wil_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 		dev_kfree_skb_any(skb);
 		return NETDEV_TX_OK;
 	case -ENOMEM:
+		if (drop_if_ring_full)
+			goto drop;
 		return NETDEV_TX_BUSY;
 	default:
 		break; /* goto drop; */
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 0f3be3ff..ba833ac 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2012-2017 Qualcomm Atheros, Inc.
- * Copyright (c) 2018, The Linux Foundation. All rights reserved.
+ * Copyright (c) 2018-2019, The Linux Foundation. All rights reserved.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
@@ -38,6 +38,7 @@
 extern bool debug_fw;
 extern bool disable_ap_sme;
 extern bool ftm_mode;
+extern bool drop_if_ring_full;
 
 struct wil6210_priv;
 struct wil6210_vif;
-- 
1.9.1

