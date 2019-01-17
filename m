Return-Path: <SRS0=z7UY=PZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E03A9C43387
	for <linux-wireless@archiver.kernel.org>; Thu, 17 Jan 2019 13:51:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 76D8720851
	for <linux-wireless@archiver.kernel.org>; Thu, 17 Jan 2019 13:51:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="CPQQxvCF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727458AbfAQNvh (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 17 Jan 2019 08:51:37 -0500
Received: from nbd.name ([46.4.11.11]:56446 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726876AbfAQNvg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 Jan 2019 08:51:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=TU+BFjCd46emK2RL4GXc5qDlMU+nmEa5Po7lUxzs2q0=; b=CPQQxvCFJIstxg2Kfb1H0sCHjt
        vsieMurQC9VJuFJfF2pRRiW9/J7Vy8xBO9IMuYHN9ntjhtIw7FsU1HpGav4pqqEuKcWMBTRQoUeXD
        cOzzzt8tPRDj8HOMyYuY/uXfDJGMNUCLHBSe9q/bAdN4yxFIVN/o1Ie3cKO7QGCfTl7E=;
Received: by maeck.lan (Postfix, from userid 501)
        id 30DE34C6F04C; Thu, 17 Jan 2019 14:51:33 +0100 (CET)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Subject: [PATCH 5/7] mt76: fix rssi ewma tracking
Date:   Thu, 17 Jan 2019 14:51:31 +0100
Message-Id: <20190117135133.2753-5-nbd@nbd.name>
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20190117135133.2753-1-nbd@nbd.name>
References: <20190117135133.2753-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The generic EWMA code cannot deal with negative numbers, so convert signal
to a positive number before adding it
Fixes mt76x2 AGC tuning

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mac80211.c | 4 +++-
 drivers/net/wireless/mediatek/mt76/util.c     | 2 +-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index 226f98fff6ef..3b09d4560ae2 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -567,7 +567,9 @@ mt76_check_sta(struct mt76_dev *dev, struct sk_buff *skb)
 
 	sta = container_of((void *) wcid, struct ieee80211_sta, drv_priv);
 
-	ewma_signal_add(&wcid->rssi, status->signal);
+	if (status->signal <= 0)
+		ewma_signal_add(&wcid->rssi, -status->signal);
+
 	wcid->inactive_count = 0;
 
 	if (!test_bit(MT_WCID_FLAG_CHECK_PS, &wcid->flags))
diff --git a/drivers/net/wireless/mediatek/mt76/util.c b/drivers/net/wireless/mediatek/mt76/util.c
index 6242421c6011..69270c1a9091 100644
--- a/drivers/net/wireless/mediatek/mt76/util.c
+++ b/drivers/net/wireless/mediatek/mt76/util.c
@@ -100,7 +100,7 @@ int mt76_get_min_avg_rssi(struct mt76_dev *dev)
 
 			spin_lock(&dev->rx_lock);
 			if (wcid->inactive_count++ < 5)
-				cur_rssi = ewma_signal_read(&wcid->rssi);
+				cur_rssi = -ewma_signal_read(&wcid->rssi);
 			else
 				cur_rssi = 0;
 			spin_unlock(&dev->rx_lock);
-- 
2.17.0

