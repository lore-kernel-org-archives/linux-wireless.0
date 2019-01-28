Return-Path: <SRS0=aQ0V=QE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F27F0C282CD
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 15:43:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CB63520880
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 15:43:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726804AbfA1PnB (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 28 Jan 2019 10:43:01 -0500
Received: from alexa-out-ams-02.qualcomm.com ([185.23.61.163]:17286 "EHLO
        alexa-out-ams-02.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726693AbfA1Pmr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Jan 2019 10:42:47 -0500
X-IronPort-AV: E=Sophos;i="5.56,534,1539640800"; 
   d="scan'208";a="1881351"
Received: from ironmsg03-ams.qualcomm.com ([10.251.56.4])
  by alexa-out-ams-02.qualcomm.com with ESMTP; 28 Jan 2019 16:36:30 +0100
X-IronPort-AV: E=McAfee;i="5900,7806,9150"; a="7037501"
Received: from lx-merez1.mea.qualcomm.com ([10.18.173.103])
  by ironmsg03-ams.qualcomm.com with ESMTP; 28 Jan 2019 16:36:29 +0100
From:   Maya Erez <merez@codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Ahmad Masri <amasri@codeaurora.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        Maya Erez <merez@codeaurora.org>
Subject: [PATCH v2 03/12] wil6210: support ndo_select_queue in net_device_ops
Date:   Mon, 28 Jan 2019 17:36:17 +0200
Message-Id: <1548689786-23288-4-git-send-email-merez@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1548689786-23288-1-git-send-email-merez@codeaurora.org>
References: <1548689786-23288-1-git-send-email-merez@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ahmad Masri <amasri@codeaurora.org>

Add support for Access Category to select queue for transmit packets.
The callback wil_select_queue will return the queue id [0..3] to use for
the current skb transmission.

This feature is disabled by default. Use ac_queues module param to enable.

Signed-off-by: Ahmad Masri <amasri@codeaurora.org>
Signed-off-by: Maya Erez <merez@codeaurora.org>
---
 drivers/net/wireless/ath/wil6210/netdev.c       | 43 +++++++++++++++++++++++--
 drivers/net/wireless/ath/wil6210/wil_platform.h |  2 ++
 2 files changed, 43 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/netdev.c b/drivers/net/wireless/ath/wil6210/netdev.c
index ca10626..dfc9617 100644
--- a/drivers/net/wireless/ath/wil6210/netdev.c
+++ b/drivers/net/wireless/ath/wil6210/netdev.c
@@ -20,6 +20,8 @@
 #include "wil6210.h"
 #include "txrx.h"
 
+#define WIL6210_TX_QUEUES (4)
+
 bool wil_has_other_active_ifaces(struct wil6210_priv *wil,
 				 struct net_device *ndev, bool up, bool ok)
 {
@@ -91,10 +93,43 @@ static int wil_stop(struct net_device *ndev)
 	return rc;
 }
 
+/**
+ * AC to queue mapping
+ *
+ * AC_VO -> queue 3
+ * AC_VI -> queue 2
+ * AC_BE -> queue 1
+ * AC_BK -> queue 0
+ */
+static u16 wil_select_queue(struct net_device *ndev,
+			    struct sk_buff *skb,
+			    struct net_device *sb_dev,
+			    select_queue_fallback_t fallback)
+{
+	static const u16 wil_1d_to_queue[8] = {1, 0, 0, 1, 2, 2, 3, 3};
+	struct wil6210_priv *wil = ndev_to_wil(ndev);
+	u16 qid;
+
+	if (!wil->config.ac_queues)
+		return 0;
+
+	/* determine the priority */
+	if (skb->priority == 0 || skb->priority > 7)
+		skb->priority = cfg80211_classify8021d(skb, NULL);
+
+	qid = wil_1d_to_queue[skb->priority];
+
+	wil_dbg_txrx(wil, "select queue for priority %d -> queue %d\n",
+		     skb->priority, qid);
+
+	return qid;
+}
+
 static const struct net_device_ops wil_netdev_ops = {
 	.ndo_open		= wil_open,
 	.ndo_stop		= wil_stop,
 	.ndo_start_xmit		= wil_start_xmit,
+	.ndo_select_queue	= wil_select_queue,
 	.ndo_set_mac_address	= eth_mac_addr,
 	.ndo_validate_addr	= eth_validate_addr,
 };
@@ -317,8 +352,12 @@ struct wil6210_vif *
 		return ERR_PTR(-EINVAL);
 	}
 
-	ndev = alloc_netdev(sizeof(*vif), name, name_assign_type,
-			    wil_dev_setup);
+	if (wil->config.ac_queues)
+		ndev = alloc_netdev_mqs(sizeof(*vif), name, name_assign_type,
+					wil_dev_setup, WIL6210_TX_QUEUES, 1);
+	else
+		ndev = alloc_netdev(sizeof(*vif), name, name_assign_type,
+				    wil_dev_setup);
 	if (!ndev) {
 		dev_err(wil_to_dev(wil), "alloc_netdev failed\n");
 		return ERR_PTR(-ENOMEM);
diff --git a/drivers/net/wireless/ath/wil6210/wil_platform.h b/drivers/net/wireless/ath/wil6210/wil_platform.h
index 6132888..cab6af3 100644
--- a/drivers/net/wireless/ath/wil6210/wil_platform.h
+++ b/drivers/net/wireless/ath/wil6210/wil_platform.h
@@ -60,6 +60,8 @@ struct wil_platform_config {
 	u8 disable_ap_sme;
 	/* Max number of stations associated to the AP */
 	unsigned int max_assoc_sta;
+	/* enable access category for transmit packets, default - no */
+	u8 ac_queues;
 };
 
 /**
-- 
1.9.1

