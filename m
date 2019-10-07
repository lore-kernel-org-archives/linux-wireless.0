Return-Path: <SRS0=BfPD=YA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E642AECE596
	for <linux-wireless@archiver.kernel.org>; Mon,  7 Oct 2019 14:10:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B1C6A206C2
	for <linux-wireless@archiver.kernel.org>; Mon,  7 Oct 2019 14:10:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="g/W78oKb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728148AbfJGOKY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 7 Oct 2019 10:10:24 -0400
Received: from nbd.name ([46.4.11.11]:59054 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727824AbfJGOKY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 Oct 2019 10:10:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=NrnsEPCHCVPbmoGVji/ksMDKosGpryp88Mm58XPiiDs=; b=g/W78oKbPjGf8W0+q4bB1Rp11U
        M09/ZOkVTnBVFNCJ1/T4ToID4M5CLhduILxoQ+4yOSrgWmq9pYevqYQki8d/XEJXX55VKCgQonk/A
        iSG0G3lV3dt7O7oa/bJzloQmMLPfi8hi7EjMyLwddB1DPV3qAisE9De3yrAJpaUyZcxY=;
Received: from p54ae9582.dip0.t-ipconnect.de ([84.174.149.130] helo=maeck.lan)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1iHTiQ-0002Wr-Uy
        for linux-wireless@vger.kernel.org; Mon, 07 Oct 2019 16:10:23 +0200
Received: by maeck.lan (Postfix, from userid 501)
        id 55A326AB2C96; Mon,  7 Oct 2019 16:10:22 +0200 (CEST)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Subject: [PATCH 3/4] mt76: fix aggregation stop issue
Date:   Mon,  7 Oct 2019 16:10:21 +0200
Message-Id: <20191007141022.75184-3-nbd@nbd.name>
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20191007141022.75184-1-nbd@nbd.name>
References: <20191007141022.75184-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Cancel the workqueue after the tid has been cleaned up, in order to
avoid a possible rescheduling from within the work function.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/agg-rx.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/agg-rx.c b/drivers/net/wireless/mediatek/mt76/agg-rx.c
index b05d439dca3b..53b5a4b2dcc5 100644
--- a/drivers/net/wireless/mediatek/mt76/agg-rx.c
+++ b/drivers/net/wireless/mediatek/mt76/agg-rx.c
@@ -130,8 +130,10 @@ mt76_rx_aggr_check_ctl(struct sk_buff *skb, struct sk_buff_head *frames)
 		return;
 
 	spin_lock_bh(&tid->lock);
-	mt76_rx_aggr_release_frames(tid, frames, seqno);
-	mt76_rx_aggr_release_head(tid, frames);
+	if (!tid->stopped) {
+		mt76_rx_aggr_release_frames(tid, frames, seqno);
+		mt76_rx_aggr_release_head(tid, frames);
+	}
 	spin_unlock_bh(&tid->lock);
 }
 
@@ -257,8 +259,6 @@ static void mt76_rx_aggr_shutdown(struct mt76_dev *dev, struct mt76_rx_tid *tid)
 	u8 size = tid->size;
 	int i;
 
-	cancel_delayed_work_sync(&tid->reorder_work);
-
 	spin_lock_bh(&tid->lock);
 
 	tid->stopped = true;
@@ -273,6 +273,8 @@ static void mt76_rx_aggr_shutdown(struct mt76_dev *dev, struct mt76_rx_tid *tid)
 	}
 
 	spin_unlock_bh(&tid->lock);
+
+	cancel_delayed_work_sync(&tid->reorder_work);
 }
 
 void mt76_rx_aggr_stop(struct mt76_dev *dev, struct mt76_wcid *wcid, u8 tidno)
-- 
2.17.0

