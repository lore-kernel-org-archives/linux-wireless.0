Return-Path: <SRS0=ZGUU=N3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33CE2C43441
	for <linux-wireless@archiver.kernel.org>; Fri, 16 Nov 2018 16:19:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 04DBD20825
	for <linux-wireless@archiver.kernel.org>; Fri, 16 Nov 2018 16:19:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 04DBD20825
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390057AbeKQCcg (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 16 Nov 2018 21:32:36 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:42008 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390012AbeKQCcf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Nov 2018 21:32:35 -0500
Received: by mail-wr1-f68.google.com with SMTP id u5-v6so20174798wrn.9
        for <linux-wireless@vger.kernel.org>; Fri, 16 Nov 2018 08:19:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1X16iHmDd4YMcnEPID7nAONpqF+ypp0cZdi5BxFdtwo=;
        b=Uw07afxFh1A/QeUhcn83drihERBHwwbwTUHUQG4vC1np3BiUvPvbzbn2AC9tk6G/oG
         W+VCe5fEPKsU7bRt5A/WxK6r/GrAJ5HdEwt4E5KU2kKtsL4azu/YNp419wESnxFgwpJA
         ouHEod4dTbN/O1wQeKSJWgUeuc17tuLOl6Z3Sae1hEOnlN3xQLi9qGDaL4Dp6jA+9XYp
         tod9oDJT1Fz7itCyAtKRHp3XZWjkEJR9drQKQ97/43N5ya2tcEQJqa1BAZ0XfxVStElc
         BAhdY1K1NKIKbF+srz/wOlXdWp/p+yAf4fP0cnwjKO9iq6CNSSKkcbFTgCra0+6y+zov
         29tA==
X-Gm-Message-State: AA+aEWazFgyBKUd1lbWTaTYTM8T4YZuuq7z4eQ5/CF1PVN4ZpeBQZnrq
        NrpMvY6vehWYpss2KSc0Ppd2xQ==
X-Google-Smtp-Source: AJdET5fVQtZJiaYk0CZnoP7OP+q7HumeZOX84pTsRIrrWiiclv8L3j/0uQp8GLdQ5mF70uH3pGSsoA==
X-Received: by 2002:adf:e608:: with SMTP id p8mr8466676wrm.166.1542385173903;
        Fri, 16 Nov 2018 08:19:33 -0800 (PST)
Received: from localhost.localdomain ([151.21.135.68])
        by smtp.gmail.com with ESMTPSA id c4-v6sm22551228wrr.74.2018.11.16.08.19.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 16 Nov 2018 08:19:33 -0800 (PST)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     kvalo@codeaurora.org
Cc:     nbd@nbd.name, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH] mt76: fix potential NULL pointer dereference in mt76_stop_tx_queues
Date:   Fri, 16 Nov 2018 17:19:21 +0100
Message-Id: <98cf4a8f8a7f7840803b91b7c9078d8b61febee9.1542384797.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <cover.1542384797.git.lorenzo.bianconi@redhat.com>
References: <cover.1542384797.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

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
---
This patch is for 4.20
---
 drivers/net/wireless/mediatek/mt76/tx.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/tx.c b/drivers/net/wireless/mediatek/mt76/tx.c
index 7cbce03aa65b..aa426b838ffa 100644
--- a/drivers/net/wireless/mediatek/mt76/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/tx.c
@@ -400,7 +400,12 @@ void mt76_stop_tx_queues(struct mt76_dev *dev, struct ieee80211_sta *sta,
 
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

