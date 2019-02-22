Return-Path: <SRS0=FR9J=Q5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F047C43381
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 14:21:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7B17720700
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 14:21:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727156AbfBVOVo (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Feb 2019 09:21:44 -0500
Received: from alexa-out-ams-01.qualcomm.com ([185.23.61.162]:22290 "EHLO
        alexa-out-ams-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727069AbfBVOVi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Feb 2019 09:21:38 -0500
X-IronPort-AV: E=Sophos;i="5.58,400,1544482800"; 
   d="scan'208";a="2017383"
Received: from ironmsg02-ams.qualcomm.com ([10.251.56.3])
  by alexa-out-ams-01.qualcomm.com with ESMTP; 22 Feb 2019 15:21:31 +0100
X-IronPort-AV: E=McAfee;i="5900,7806,9174"; a="7285589"
Received: from lx-merez1.mea.qualcomm.com ([10.18.173.103])
  by ironmsg02-ams.qualcomm.com with ESMTP; 22 Feb 2019 15:21:31 +0100
From:   Maya Erez <merez@codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Ahmad Masri <amasri@codeaurora.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        Maya Erez <merez@codeaurora.org>
Subject: [PATCH 16/21] wil6210: fix report of rx packet checksum in edma mode
Date:   Fri, 22 Feb 2019 16:21:14 +0200
Message-Id: <1550845279-16103-17-git-send-email-merez@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1550845279-16103-1-git-send-email-merez@codeaurora.org>
References: <1550845279-16103-1-git-send-email-merez@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ahmad Masri <amasri@codeaurora.org>

Update the rx packet checksum of received packet according to edma
HW spec:

No need to calculate checksum in the following cases:
L4_status=0 and L3_status=0 - No L3 and no L4 known protocols found
L4_status=0 and L3_status=1 - L3 was found, and checksum check passed.
No known L4 protocol was found.
L4_status=1 - L4 was found, and checksum check passed.

Recalculate checksum in the following cases:
L4_status=3 and L3_status=1 - It means that L3 protocol was found,
and checksum passed, but L4 checksum failed.
L4_status=3 and L3_status=2	- Both L3 and L4 checksum check failed.

Signed-off-by: Ahmad Masri <amasri@codeaurora.org>
Signed-off-by: Maya Erez <merez@codeaurora.org>
---
 drivers/net/wireless/ath/wil6210/txrx_edma.c | 21 +-------------
 drivers/net/wireless/ath/wil6210/txrx_edma.h | 41 +++++++++++++++++++++++++++-
 2 files changed, 41 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/txrx_edma.c b/drivers/net/wireless/ath/wil6210/txrx_edma.c
index 48098ae..492f7bd 100644
--- a/drivers/net/wireless/ath/wil6210/txrx_edma.c
+++ b/drivers/net/wireless/ath/wil6210/txrx_edma.c
@@ -807,18 +807,9 @@ static int wil_rx_error_check_edma(struct wil6210_priv *wil,
 				   struct sk_buff *skb,
 				   struct wil_net_stats *stats)
 {
-	int error;
 	int l2_rx_status;
-	int l3_rx_status;
-	int l4_rx_status;
 	void *msg = wil_skb_rxstatus(skb);
 
-	error = wil_rx_status_get_error(msg);
-	if (!error) {
-		skb->ip_summed = CHECKSUM_UNNECESSARY;
-		return 0;
-	}
-
 	l2_rx_status = wil_rx_status_get_l2_rx_status(msg);
 	if (l2_rx_status != 0) {
 		wil_dbg_txrx(wil, "L2 RX error, l2_rx_status=0x%x\n",
@@ -847,17 +838,7 @@ static int wil_rx_error_check_edma(struct wil6210_priv *wil,
 		return -EFAULT;
 	}
 
-	l3_rx_status = wil_rx_status_get_l3_rx_status(msg);
-	l4_rx_status = wil_rx_status_get_l4_rx_status(msg);
-	if (!l3_rx_status && !l4_rx_status)
-		skb->ip_summed = CHECKSUM_UNNECESSARY;
-	/* If HW reports bad checksum, let IP stack re-check it
-	 * For example, HW don't understand Microsoft IP stack that
-	 * mis-calculates TCP checksum - if it should be 0x0,
-	 * it writes 0xffff in violation of RFC 1624
-	 */
-	else
-		stats->rx_csum_err++;
+	skb->ip_summed = wil_rx_status_get_checksum(msg, stats);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/ath/wil6210/txrx_edma.h b/drivers/net/wireless/ath/wil6210/txrx_edma.h
index 343516a..9cf9ecf 100644
--- a/drivers/net/wireless/ath/wil6210/txrx_edma.h
+++ b/drivers/net/wireless/ath/wil6210/txrx_edma.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2012-2016,2018, The Linux Foundation. All rights reserved.
+ * Copyright (c) 2012-2016,2018-2019, The Linux Foundation. All rights reserved.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
@@ -511,6 +511,45 @@ static inline int wil_rx_status_get_l4_rx_status(void *msg)
 			    5, 6);
 }
 
+/* L4	L3	Expected result
+ * 0	0	Ok. No L3 and no L4 known protocols found.
+ *		Treated as L2 packet. (no offloads on this packet)
+ * 0	1	Ok. It means that L3 was found, and checksum check passed.
+ *		No known L4 protocol was found.
+ * 0	2	It means that L3 protocol was found, and checksum check failed.
+ *		No L4 known protocol was found.
+ * 1	any	Ok. It means that L4 was found, and checksum check passed.
+ * 3	0	Not a possible scenario.
+ * 3	1	Recalculate. It means that L3 protocol was found, and checksum
+ *		passed. But L4 checksum failed. Need to see if really failed,
+ *		or due to fragmentation.
+ * 3	2	Both L3 and L4 checksum check failed.
+ */
+static inline int wil_rx_status_get_checksum(void *msg,
+					     struct wil_net_stats *stats)
+{
+	int l3_rx_status = wil_rx_status_get_l3_rx_status(msg);
+	int l4_rx_status = wil_rx_status_get_l4_rx_status(msg);
+
+	if (l4_rx_status == 1)
+		return CHECKSUM_UNNECESSARY;
+
+	if (l4_rx_status == 0 && l3_rx_status == 1)
+		return CHECKSUM_UNNECESSARY;
+
+	if (l3_rx_status == 0 && l4_rx_status == 0)
+		/* L2 packet */
+		return CHECKSUM_NONE;
+
+	/* If HW reports bad checksum, let IP stack re-check it
+	 * For example, HW doesn't understand Microsoft IP stack that
+	 * mis-calculates TCP checksum - if it should be 0x0,
+	 * it writes 0xffff in violation of RFC 1624
+	 */
+	stats->rx_csum_err++;
+	return CHECKSUM_NONE;
+}
+
 static inline int wil_rx_status_get_security(void *msg)
 {
 	return WIL_GET_BITS(((struct wil_rx_status_compressed *)msg)->d0,
-- 
1.9.1

