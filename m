Return-Path: <SRS0=TTqJ=XV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65F3EC4360C
	for <linux-wireless@archiver.kernel.org>; Thu, 26 Sep 2019 09:05:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 30421222C0
	for <linux-wireless@archiver.kernel.org>; Thu, 26 Sep 2019 09:05:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="QmrXyW+l"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729981AbfIZJFb (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 26 Sep 2019 05:05:31 -0400
Received: from nbd.name ([46.4.11.11]:53298 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726352AbfIZJFb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 26 Sep 2019 05:05:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=C+WSjKP8RAvqp/4VZCHxEhynhQqtxp4seJkrsbWi46w=; b=QmrXyW+lJLyMa+6nDNkLgE0Hja
        pmot/VFna1NSphwuoYD1N+M11oezhv40rh2QDcLmy78jWsfuzTK2+uNiBjJIK3YSHz6SN5CBxkgyJ
        So7mc/I7UfkgQW2UioFz68mOcVPS+i7/Lbh9NvXeztg44zNviNKTy4x53imYeCpGwyiM=;
Received: from p54ae9b80.dip0.t-ipconnect.de ([84.174.155.128] helo=maeck.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1iDPiL-0008Sq-Op
        for linux-wireless@vger.kernel.org; Thu, 26 Sep 2019 11:05:29 +0200
Received: by maeck.local (Postfix, from userid 501)
        id BA40E6997D8A; Thu, 26 Sep 2019 11:05:23 +0200 (CEST)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Subject: [PATCH 2/3] mt76: remove aggr_work field from struct mt76_wcid
Date:   Thu, 26 Sep 2019 11:05:22 +0200
Message-Id: <20190926090523.68392-2-nbd@nbd.name>
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20190926090523.68392-1-nbd@nbd.name>
References: <20190926090523.68392-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

It is unused

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt76.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 570c159515a0..44bf139a531a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -190,8 +190,6 @@ DECLARE_EWMA(signal, 10, 8);
 struct mt76_wcid {
 	struct mt76_rx_tid __rcu *aggr[IEEE80211_NUM_TIDS];
 
-	struct work_struct aggr_work;
-
 	unsigned long flags;
 
 	struct ewma_signal rssi;
-- 
2.17.0

