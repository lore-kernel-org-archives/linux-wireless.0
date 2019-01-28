Return-Path: <SRS0=aQ0V=QE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C1B2C282CF
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 15:42:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 67DB920880
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 15:42:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726804AbfA1Pmo (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 28 Jan 2019 10:42:44 -0500
Received: from alexa-out-ams-02.qualcomm.com ([185.23.61.163]:19718 "EHLO
        alexa-out-ams-02.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726779AbfA1Pmn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Jan 2019 10:42:43 -0500
X-Greylist: delayed 371 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Jan 2019 10:42:40 EST
X-IronPort-AV: E=Sophos;i="5.56,534,1539640800"; 
   d="scan'208";a="1881353"
Received: from ironmsg03-ams.qualcomm.com ([10.251.56.4])
  by alexa-out-ams-02.qualcomm.com with ESMTP; 28 Jan 2019 16:36:31 +0100
X-IronPort-AV: E=McAfee;i="5900,7806,9150"; a="7037503"
Received: from lx-merez1.mea.qualcomm.com ([10.18.173.103])
  by ironmsg03-ams.qualcomm.com with ESMTP; 28 Jan 2019 16:36:30 +0100
From:   Maya Erez <merez@codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Dedy Lansky <dlansky@codeaurora.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        Maya Erez <merez@codeaurora.org>
Subject: [PATCH v2 05/12] wil6210: add option to drop Tx packets when tx ring is full
Date:   Mon, 28 Jan 2019 17:36:19 +0200
Message-Id: <1548689786-23288-6-git-send-email-merez@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1548689786-23288-1-git-send-email-merez@codeaurora.org>
References: <1548689786-23288-1-git-send-email-merez@codeaurora.org>
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
index 51ff242..00996f1 100644
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
index aca5d0d..986985c 100644
--- a/drivers/net/wireless/ath/wil6210/wil_platform.h
+++ b/drivers/net/wireless/ath/wil6210/wil_platform.h
@@ -64,6 +64,8 @@ struct wil_platform_config {
 	u8 ac_queues;
 	/* enable allocating tx queue(s) per station, default - no */
 	u8 q_per_sta;
+	/* drop Tx packets in case tx ring is full, default - no */
+	u8 drop_if_ring_full;
 };
 
 /**
-- 
1.9.1

