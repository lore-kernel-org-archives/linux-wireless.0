Return-Path: <SRS0=Lwp6=R5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE31BC43381
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Mar 2019 08:34:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9E29B2084B
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Mar 2019 08:34:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="EeiFVqdI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730637AbfCZIeZ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 26 Mar 2019 04:34:25 -0400
Received: from nbd.name ([46.4.11.11]:38940 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726302AbfCZIeY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Mar 2019 04:34:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=k/eC8DAr+QG6E4chyKIMEUDoWRa9kYqTW2t7ZnZ+M5k=; b=EeiFVqdIvixC8iMnPKJ5JDN5se
        El81688w0LRZnG/PNETfHUes6yPMr5EbNcvrYnN/pMhs8dMd9jYg3nlAqE7bEDxK6yhU+aKPbB/0h
        1Ig51q0Hp6WEb9JSdm0724G5nDPEkjWIidpriWrKEDdw1g/rxt2oNXYmMLPqYU/Yt1AY=;
Received: from p4ff13338.dip0.t-ipconnect.de ([79.241.51.56] helo=maeck-2.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1h8hXK-0000g0-Os; Tue, 26 Mar 2019 09:34:22 +0100
Received: by maeck-2.local (Postfix, from userid 501)
        id EA6595583F87; Tue, 26 Mar 2019 09:34:21 +0100 (CET)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Cc:     kvalo@codeaurora.org
Subject: [PATCH 5.1 3/3] mt76: mt7603: send BAR after powersave wakeup
Date:   Tue, 26 Mar 2019 09:34:21 +0100
Message-Id: <20190326083421.57998-3-nbd@nbd.name>
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20190326083421.57998-1-nbd@nbd.name>
References: <20190326083421.57998-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Now that the sequence number allocation is fixed, we can finally send a BAR
at powersave wakeup time to refresh the receiver side reorder window

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt7603/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/main.c b/drivers/net/wireless/mediatek/mt76/mt7603/main.c
index 31a7ca691195..a3c4ef198bfe 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/main.c
@@ -372,7 +372,7 @@ mt7603_sta_ps(struct mt76_dev *mdev, struct ieee80211_sta *sta, bool ps)
 	struct mt7603_sta *msta = (struct mt7603_sta *)sta->drv_priv;
 	struct sk_buff_head list;
 
-	mt76_stop_tx_queues(&dev->mt76, sta, false);
+	mt76_stop_tx_queues(&dev->mt76, sta, true);
 	mt7603_wtbl_set_ps(dev, msta, ps);
 	if (ps)
 		return;
-- 
2.17.0

