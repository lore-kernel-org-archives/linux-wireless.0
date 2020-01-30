Return-Path: <SRS0=/tVN=3T=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A372FC35240
	for <linux-wireless@archiver.kernel.org>; Thu, 30 Jan 2020 14:47:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 75AEB214D8
	for <linux-wireless@archiver.kernel.org>; Thu, 30 Jan 2020 14:47:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="aqLJ7rnH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727369AbgA3Orb (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 30 Jan 2020 09:47:31 -0500
Received: from nbd.name ([46.4.11.11]:57438 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726948AbgA3OrV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 30 Jan 2020 09:47:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=9cNhnhwjM/MBcO8xwaYjS1TtkF0u2AaucPCrC7KvAG8=; b=aqLJ7rnHiF5XXW2E07qlgVy04w
        7fn8AMDdTmvME403TM60tVLzzcGKtmyKXDMYnXF20MPwXu07RXTwE1JmkMhJnn5JkCueVukjRxVnD
        jp1GOREu11T+eZCt6P4PlKkSAJAwCxIz7sSV5f5fdAaTjH9mCmICkS8HDAoJYfcE+Q2g=;
Received: from [178.162.209.135] (helo=maeck.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1ixB6G-0001Vi-HP
        for linux-wireless@vger.kernel.org; Thu, 30 Jan 2020 15:47:20 +0100
Received: by maeck.local (Postfix, from userid 501)
        id ED9237AE4691; Thu, 30 Jan 2020 15:47:18 +0100 (CET)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Subject: [PATCH 02/15] mt76: mt7615: add __aligned(4) to txp structs
Date:   Thu, 30 Jan 2020 15:47:05 +0100
Message-Id: <20200130144718.14298-2-nbd@nbd.name>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20200130144718.14298-1-nbd@nbd.name>
References: <20200130144718.14298-1-nbd@nbd.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The beginning of the struct is guaranteed to be 4-byte aligned, and this
attribute allows the compiler to generate more efficient code

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt7615/mac.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mac.h b/drivers/net/wireless/mediatek/mt76/mt7615/mac.h
index 8f053fadd3df..9b7c45bf1ec5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mac.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mac.h
@@ -243,7 +243,7 @@ struct mt7615_txp {
 	u8 nbuf;
 	__le32 buf[MT_TXP_MAX_BUF_NUM];
 	__le16 len[MT_TXP_MAX_BUF_NUM];
-} __packed;
+} __packed __aligned(4);
 
 struct mt7615_tx_free {
 	__le16 rx_byte_cnt;
@@ -251,7 +251,7 @@ struct mt7615_tx_free {
 	u8 txd_cnt;
 	u8 rsv[3];
 	__le16 token[];
-} __packed;
+} __packed __aligned(4);
 
 #define MT_TX_FREE_MSDU_ID_CNT		GENMASK(6, 0)
 
-- 
2.24.0

