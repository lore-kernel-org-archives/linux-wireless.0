Return-Path: <SRS0=HAyh=NM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42DA7C0044C
	for <linux-wireless@archiver.kernel.org>; Thu,  1 Nov 2018 09:46:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DEA7A20657
	for <linux-wireless@archiver.kernel.org>; Thu,  1 Nov 2018 09:46:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="tv0hjRWE"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DEA7A20657
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=nbd.name
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727759AbeKASsS (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 1 Nov 2018 14:48:18 -0400
Received: from nbd.name ([46.4.11.11]:53300 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727583AbeKASsS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Nov 2018 14:48:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=mmOddSkozM1kwv9q6d00T23VZ3GfmoL2NLInfy+8wjI=; b=tv0hjRWECIcPLGqjadMGsypDPV
        xbWa4pbGa+zBeazjzUkzNEDqE6mqPQl6LRwGXkaoG54ZnmCvPQM9y6iwsNwULyk1SO8E3FTX1matm
        hmPPF25P0F93tPb37viZEhn5wNPSiqDaKjyBuap7ut5FMfnUlg+pfcR7pJBBH0xyG5gw=;
Received: by maeck.local (Postfix, from userid 501)
        id 499B8427BB61; Thu,  1 Nov 2018 10:46:00 +0100 (CET)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, sgruszka@redhat.com
Subject: [PATCH v2 2/4] mt76: mt76x02: skip station tx status for non-sta wcid entries
Date:   Thu,  1 Nov 2018 10:45:58 +0100
Message-Id: <20181101094600.37077-2-nbd@nbd.name>
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20181101094600.37077-1-nbd@nbd.name>
References: <20181101094600.37077-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Fixes a crash that could occur if a frame is sent to a station, but the
station's wcid was not used (e.g. for software encrypted mgmt tx)

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
index 34fc9f2eb51f..ad8df680c6a5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
@@ -450,7 +450,7 @@ void mt76x02_send_tx_status(struct mt76x02_dev *dev,
 	if (stat->wcid < ARRAY_SIZE(dev->mt76.wcid))
 		wcid = rcu_dereference(dev->mt76.wcid[stat->wcid]);
 
-	if (wcid) {
+	if (wcid && wcid->sta) {
 		void *priv;
 
 		priv = msta = container_of(wcid, struct mt76x02_sta, wcid);
-- 
2.17.0

