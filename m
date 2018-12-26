Return-Path: <SRS0=rEuJ=PD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF78FC43387
	for <linux-wireless@archiver.kernel.org>; Wed, 26 Dec 2018 22:51:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 818D6214D8
	for <linux-wireless@archiver.kernel.org>; Wed, 26 Dec 2018 22:51:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1545864694;
	bh=4a62FDNSoan4VyxXV+6PkUdmMN+LV7KCA08hmS5myqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=wuKn6Te/319xlRdhW/u/DsYp7FmkxvS20eslzWwDKtpA7bysYUan3fSO2OhTylA4R
	 YOLsWy2UFfV0USpb3CTsNILO4RitvvhZ6VmC0rv3y94+XA95VrPzA5F0/SKUtgTjZQ
	 37gMRA6ZmMOHUlJcZJVIPyUhAM4uiB1XVoWbnLs8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729926AbeLZWvd (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 26 Dec 2018 17:51:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:37268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728025AbeLZWhL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Dec 2018 17:37:11 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A58AC21902;
        Wed, 26 Dec 2018 22:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1545863830;
        bh=4a62FDNSoan4VyxXV+6PkUdmMN+LV7KCA08hmS5myqY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BVupB26+lmu274sm0oul1/egaZsBvBfcMdYN9BCeUKJ3Kge1oby7EWtp6HFlj+BDX
         AH7sSV5+F2VEEUZlSCgvfDAz4Il3yYNcXGTnG/8QKVibiAx3y95o/e0ZfZTQfJj3EB
         9pGR2tprkZQ0rvZ5pBJNV28GjD4lRjHPY28XJh/c=
From:   Sasha Levin <sashal@kernel.org>
To:     stable@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 45/97] mt76: fix potential NULL pointer dereference in mt76_stop_tx_queues
Date:   Wed, 26 Dec 2018 17:35:05 -0500
Message-Id: <20181226223557.149329-45-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181226223557.149329-1-sashal@kernel.org>
References: <20181226223557.149329-1-sashal@kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>

[ Upstream commit 7c250f4612ae97aa04500c0d0cff69bb87046e3a ]

Starting from mac80211 commit adf8ed01e4fd ("mac80211: add an optional
TXQ for other PS-buffered frames") and commit 0eeb2b674f05 ("mac80211:
add an option for station management TXQ") a new per-sta queue has been
introduced for bufferable management frames.
sta->txq[IEEE80211_NUM_TIDS] is initialized just if the driver reports
the following hw flags:
- IEEE80211_HW_STA_MMPDU_TXQ
- IEEE80211_HW_BUFF_MMPDU_TXQ
This can produce a NULL pointer dereference in mt76_stop_tx_queues
since mt76 iterates on all available sta tx queues assuming they are
initialized by mac80211. This issue has been spotted analyzing the code
(it has not triggered any crash yet)

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/tx.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/tx.c b/drivers/net/wireless/mediatek/mt76/tx.c
index af48d43bb7dc..20447fdce4c3 100644
--- a/drivers/net/wireless/mediatek/mt76/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/tx.c
@@ -385,7 +385,12 @@ void mt76_stop_tx_queues(struct mt76_dev *dev, struct ieee80211_sta *sta,
 
 	for (i = 0; i < ARRAY_SIZE(sta->txq); i++) {
 		struct ieee80211_txq *txq = sta->txq[i];
-		struct mt76_txq *mtxq = (struct mt76_txq *) txq->drv_priv;
+		struct mt76_txq *mtxq;
+
+		if (!txq)
+			continue;
+
+		mtxq = (struct mt76_txq *)txq->drv_priv;
 
 		spin_lock_bh(&mtxq->hwq->lock);
 		mtxq->send_bar = mtxq->aggr && send_bar;
-- 
2.19.1

