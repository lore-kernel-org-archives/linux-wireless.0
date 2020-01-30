Return-Path: <SRS0=/tVN=3T=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F976C2D0DB
	for <linux-wireless@archiver.kernel.org>; Thu, 30 Jan 2020 14:47:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 47F62206D3
	for <linux-wireless@archiver.kernel.org>; Thu, 30 Jan 2020 14:47:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="A1c4RlZQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727304AbgA3OrX (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 30 Jan 2020 09:47:23 -0500
Received: from nbd.name ([46.4.11.11]:57446 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727277AbgA3OrW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 30 Jan 2020 09:47:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=hopMXXudVgxUE09QFd7S/cI25V1vxrKnSLrL8OYn20k=; b=A1c4RlZQKFsKUoRAaW59Rf/Qnp
        LNaPDfBKRzOB3pwlL9yjyclTFA2g1/kVaqq9ayJNg4M6NdH9YugwLtk070POI2W815M628kzGBOoB
        SdQywGatjl17xy/oQ8riTrBwy8jTQzcjZiM0TBFM+KVr2C/1lZfSy+DtdVXPJh91TvJQ=;
Received: from [178.162.209.135] (helo=maeck.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1ixB6G-0001Vg-Gz
        for linux-wireless@vger.kernel.org; Thu, 30 Jan 2020 15:47:20 +0100
Received: by maeck.local (Postfix, from userid 501)
        id EC9FC7AE468E; Thu, 30 Jan 2020 15:47:18 +0100 (CET)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Subject: [PATCH 06/15] mt76: mt7615: fix MT_INT_TX_DONE_ALL definition for MT7622
Date:   Thu, 30 Jan 2020 15:47:09 +0100
Message-Id: <20200130144718.14298-6-nbd@nbd.name>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20200130144718.14298-1-nbd@nbd.name>
References: <20200130144718.14298-1-nbd@nbd.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

MT7622 uses more interrupt bits for queue tx completion events.
Enabling those extra bits is harmless on MT7615

Co-developed-by: Shayne Chen <shayne.chen@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt7615/regs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/regs.h b/drivers/net/wireless/mediatek/mt76/mt7615/regs.h
index 33e6087b58fe..1d764c587d25 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/regs.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/regs.h
@@ -37,7 +37,7 @@
 
 #define MT_INT_RX_DONE(_n)		BIT(_n)
 #define MT_INT_RX_DONE_ALL		GENMASK(1, 0)
-#define MT_INT_TX_DONE_ALL		GENMASK(7, 4)
+#define MT_INT_TX_DONE_ALL		GENMASK(19, 4)
 #define MT_INT_TX_DONE(_n)		BIT((_n) + 4)
 
 #define MT_WPDMA_GLO_CFG		MT_HIF(0x208)
-- 
2.24.0

