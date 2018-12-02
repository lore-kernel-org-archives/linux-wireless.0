Return-Path: <SRS0=9n1M=OL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BC7DC04EB8
	for <linux-wireless@archiver.kernel.org>; Sun,  2 Dec 2018 09:43:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F2BE02080A
	for <linux-wireless@archiver.kernel.org>; Sun,  2 Dec 2018 09:43:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F2BE02080A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725828AbeLBJns (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 2 Dec 2018 04:43:48 -0500
Received: from alexa-out-ams-02.qualcomm.com ([185.23.61.163]:35535 "EHLO
        alexa-out-ams-02.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725781AbeLBJns (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 2 Dec 2018 04:43:48 -0500
X-IronPort-AV: E=Sophos;i="5.56,306,1539640800"; 
   d="scan'208";a="1585239"
Received: from ironmsg03-ams.qualcomm.com ([10.251.56.4])
  by alexa-out-ams-02.qualcomm.com with ESMTP; 02 Dec 2018 10:43:42 +0100
X-IronPort-AV: E=McAfee;i="5900,7806,9094"; a="6502871"
Received: from lx-merez1.mea.qualcomm.com ([10.18.173.103])
  by ironmsg03-ams.qualcomm.com with ESMTP; 02 Dec 2018 10:43:41 +0100
From:   Maya Erez <merez@codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Ahmad Masri <amasri@codeaurora.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        Maya Erez <merez@codeaurora.org>
Subject: [PATCH 03/12] wil6210: support ndo_select_queue in net_device_ops
Date:   Sun,  2 Dec 2018 11:43:28 +0200
Message-Id: <1543743817-10298-4-git-send-email-merez@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1543743817-10298-1-git-send-email-merez@codeaurora.org>
References: <1543743817-10298-1-git-send-email-merez@codeaurora.org>
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
index b99470c..bab457d 100644
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
index 7090e68..ac47e9d 100644
--- a/drivers/net/wireless/ath/wil6210/wil_platform.h
+++ b/drivers/net/wireless/ath/wil6210/wil_platform.h
@@ -59,6 +59,8 @@ struct wil_platform_config {
 	bool disable_ap_sme;
 	/* Max number of stations associated to the AP */
 	unsigned int max_assoc_sta;
+	/* enable access category for transmit packets, default - no */
+	bool ac_queues;
 };
 
 /**
-- 
1.9.1

