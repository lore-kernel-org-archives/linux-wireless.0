Return-Path: <SRS0=9n1M=OL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24FC2C65BAE
	for <linux-wireless@archiver.kernel.org>; Sun,  2 Dec 2018 09:43:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D6EBD2080A
	for <linux-wireless@archiver.kernel.org>; Sun,  2 Dec 2018 09:43:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D6EBD2080A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725837AbeLBJnu (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 2 Dec 2018 04:43:50 -0500
Received: from alexa-out-ams-02.qualcomm.com ([185.23.61.163]:35535 "EHLO
        alexa-out-ams-02.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725781AbeLBJnu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 2 Dec 2018 04:43:50 -0500
X-IronPort-AV: E=Sophos;i="5.56,306,1539640800"; 
   d="scan'208";a="1585241"
Received: from ironmsg03-ams.qualcomm.com ([10.251.56.4])
  by alexa-out-ams-02.qualcomm.com with ESMTP; 02 Dec 2018 10:43:43 +0100
X-IronPort-AV: E=McAfee;i="5900,7806,9094"; a="6502873"
Received: from lx-merez1.mea.qualcomm.com ([10.18.173.103])
  by ironmsg03-ams.qualcomm.com with ESMTP; 02 Dec 2018 10:43:42 +0100
From:   Maya Erez <merez@codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Dedy Lansky <dlansky@codeaurora.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        Maya Erez <merez@codeaurora.org>
Subject: [PATCH 05/12] wil6210: add option to drop Tx packets when tx ring is full
Date:   Sun,  2 Dec 2018 11:43:30 +0200
Message-Id: <1543743817-10298-6-git-send-email-merez@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1543743817-10298-1-git-send-email-merez@codeaurora.org>
References: <1543743817-10298-1-git-send-email-merez@codeaurora.org>
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
New policy is disabled by default and can be enabled with new
drop_if_ring_full module param.

Signed-off-by: Dedy Lansky <dlansky@codeaurora.org>
Signed-off-by: Maya Erez <merez@codeaurora.org>
---
 drivers/net/wireless/ath/wil6210/txrx.c         | 6 ++++++
 drivers/net/wireless/ath/wil6210/wil_platform.h | 2 ++
 2 files changed, 8 insertions(+)

diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index 714ca0f..1e715ba 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -2064,6 +2064,10 @@ static inline void __wil_update_net_queues(struct wil6210_priv *wil,
 		wil_dbg_txrx(wil, "check_stop=%d, mid=%d, stopped=%d",
 			     check_stop, vif->mid, vif->net_queue_stopped);
 
+	if (ring && wil->config.drop_if_ring_full)
+		/* no need to stop/wake net queues */
+		return;
+
 	if (ring && WIL_Q_PER_STA_USED(vif)) {
 		__wil_update_net_queues_per_sta(wil, vif, ring, check_stop);
 		return;
@@ -2227,6 +2231,8 @@ netdev_tx_t wil_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 		dev_kfree_skb_any(skb);
 		return NETDEV_TX_OK;
 	case -ENOMEM:
+		if (wil->config.drop_if_ring_full)
+			goto drop;
 		return NETDEV_TX_BUSY;
 	default:
 		break; /* goto drop; */
diff --git a/drivers/net/wireless/ath/wil6210/wil_platform.h b/drivers/net/wireless/ath/wil6210/wil_platform.h
index 60b4abc..c90ab7577 100644
--- a/drivers/net/wireless/ath/wil6210/wil_platform.h
+++ b/drivers/net/wireless/ath/wil6210/wil_platform.h
@@ -63,6 +63,8 @@ struct wil_platform_config {
 	bool ac_queues;
 	/* enable allocating tx queue(s) per station, default - no */
 	bool q_per_sta;
+	/* drop Tx packets in case tx ring is full, default - no */
+	bool drop_if_ring_full;
 };
 
 /**
-- 
1.9.1

