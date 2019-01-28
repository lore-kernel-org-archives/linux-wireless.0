Return-Path: <SRS0=aQ0V=QE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B6DBC282CD
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 15:42:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6A16E20880
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 15:42:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726913AbfA1Pm5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 28 Jan 2019 10:42:57 -0500
Received: from alexa-out-ams-02.qualcomm.com ([185.23.61.163]:17286 "EHLO
        alexa-out-ams-02.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726266AbfA1Pmt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Jan 2019 10:42:49 -0500
X-IronPort-AV: E=Sophos;i="5.56,534,1539640800"; 
   d="scan'208";a="1881356"
Received: from ironmsg03-ams.qualcomm.com ([10.251.56.4])
  by alexa-out-ams-02.qualcomm.com with ESMTP; 28 Jan 2019 16:36:33 +0100
X-IronPort-AV: E=McAfee;i="5900,7806,9150"; a="7037506"
Received: from lx-merez1.mea.qualcomm.com ([10.18.173.103])
  by ironmsg03-ams.qualcomm.com with ESMTP; 28 Jan 2019 16:36:32 +0100
From:   Maya Erez <merez@codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Dedy Lansky <dlansky@codeaurora.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        Maya Erez <merez@codeaurora.org>
Subject: [PATCH v2 08/12] wil6210: fix invalid sta statistics update
Date:   Mon, 28 Jan 2019 17:36:22 +0200
Message-Id: <1548689786-23288-9-git-send-email-merez@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1548689786-23288-1-git-send-email-merez@codeaurora.org>
References: <1548689786-23288-1-git-send-email-merez@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Dedy Lansky <dlansky@codeaurora.org>

Upon status ring handling, in case there are both unicast and
multicast (cid == max) status messages to handle, wrong sta statistics
might get updated.
Fix this by setting stats to NULL upon invalid cid
(e.g. == max_assoc_sta).

Signed-off-by: Dedy Lansky <dlansky@codeaurora.org>
Signed-off-by: Maya Erez <merez@codeaurora.org>
---
 drivers/net/wireless/ath/wil6210/txrx_edma.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/txrx_edma.c b/drivers/net/wireless/ath/wil6210/txrx_edma.c
index ae0d123..3277816 100644
--- a/drivers/net/wireless/ath/wil6210/txrx_edma.c
+++ b/drivers/net/wireless/ath/wil6210/txrx_edma.c
@@ -1137,7 +1137,7 @@ int wil_tx_sring_handler(struct wil6210_priv *wil,
 	/* Total number of completed descriptors in all descriptor rings */
 	int desc_cnt = 0;
 	int cid;
-	struct wil_net_stats *stats = NULL;
+	struct wil_net_stats *stats;
 	struct wil_tx_enhanced_desc *_d;
 	unsigned int ring_id;
 	unsigned int num_descs;
@@ -1187,8 +1187,8 @@ int wil_tx_sring_handler(struct wil6210_priv *wil,
 		ndev = vif_to_ndev(vif);
 
 		cid = wil->ring2cid_tid[ring_id][0];
-		if (cid < wil->config.max_assoc_sta)
-			stats = &wil->sta[cid].stats;
+		stats = (cid < wil->config.max_assoc_sta ?
+			&wil->sta[cid].stats : NULL);
 
 		wil_dbg_txrx(wil,
 			     "tx_status: completed desc_ring (%d), num_descs (%d)\n",
-- 
1.9.1

