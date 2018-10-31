Return-Path: <SRS0=7415=NL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E410ECDE44
	for <linux-wireless@archiver.kernel.org>; Wed, 31 Oct 2018 08:58:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C9B7A20685
	for <linux-wireless@archiver.kernel.org>; Wed, 31 Oct 2018 08:58:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C9B7A20685
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727716AbeJaRz5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 31 Oct 2018 13:55:57 -0400
Received: from alexa-out-ams-01.qualcomm.com ([185.23.61.162]:23734 "EHLO
        alexa-out-ams-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727381AbeJaRz4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 31 Oct 2018 13:55:56 -0400
X-Greylist: delayed 372 seconds by postgrey-1.27 at vger.kernel.org; Wed, 31 Oct 2018 13:55:51 EDT
X-IronPort-AV: E=Sophos;i="5.54,447,1534802400"; 
   d="scan'208";a="1418121"
Received: from ironmsg01-ams.qualcomm.com ([10.251.56.2])
  by alexa-out-ams-01.qualcomm.com with ESMTP; 31 Oct 2018 09:52:28 +0100
X-IronPort-AV: E=McAfee;i="5900,7806,9062"; a="6147921"
Received: from lx-merez1.mea.qualcomm.com ([10.18.173.103])
  by ironmsg01-ams.qualcomm.com with ESMTP; 31 Oct 2018 09:52:27 +0100
From:   Maya Erez <merez@codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Hamad Kadmany <hkadmany@codeaurora.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        Maya Erez <merez@codeaurora.org>,
        Lior David <liord@codeaurora.org>
Subject: [PATCH 01/16] wil6210: remove fake support for RXHASH
Date:   Wed, 31 Oct 2018 10:52:09 +0200
Message-Id: <1540975944-30576-2-git-send-email-merez@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1540975944-30576-1-git-send-email-merez@codeaurora.org>
References: <1540975944-30576-1-git-send-email-merez@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Hamad Kadmany <hkadmany@codeaurora.org>

Setting the same fake hash to all skbs prevents
distributing different flows to different CPU cores.

Signed-off-by: Hamad Kadmany <hkadmany@codeaurora.org>
Signed-off-by: Lior David <liord@codeaurora.org>
Signed-off-by: Maya Erez <merez@codeaurora.org>
---
 drivers/net/wireless/ath/wil6210/netdev.c | 3 +--
 drivers/net/wireless/ath/wil6210/txrx.c   | 8 --------
 2 files changed, 1 insertion(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/netdev.c b/drivers/net/wireless/ath/wil6210/netdev.c
index 7a78a06..64fa1a2 100644
--- a/drivers/net/wireless/ath/wil6210/netdev.c
+++ b/drivers/net/wireless/ath/wil6210/netdev.c
@@ -345,8 +345,7 @@ struct wil6210_vif *
 	ndev->ieee80211_ptr = wdev;
 	ndev->hw_features = NETIF_F_HW_CSUM | NETIF_F_RXCSUM |
 			    NETIF_F_SG | NETIF_F_GRO |
-			    NETIF_F_TSO | NETIF_F_TSO6 |
-			    NETIF_F_RXHASH;
+			    NETIF_F_TSO | NETIF_F_TSO6;
 
 	ndev->features |= ndev->hw_features;
 	SET_NETDEV_DEV(ndev, wiphy_dev(wdev->wiphy));
diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index cc5f263..70eceec 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -743,14 +743,6 @@ void wil_netif_rx_any(struct sk_buff *skb, struct net_device *ndev)
 
 	stats = &wil->sta[cid].stats;
 
-	if (ndev->features & NETIF_F_RXHASH)
-		/* fake L4 to ensure it won't be re-calculated later
-		 * set hash to any non-zero value to activate rps
-		 * mechanism, core will be chosen according
-		 * to user-level rps configuration.
-		 */
-		skb_set_hash(skb, 1, PKT_HASH_TYPE_L4);
-
 	skb_orphan(skb);
 
 	if (security && (wil->txrx_ops.rx_crypto_check(wil, skb) != 0)) {
-- 
1.9.1

