Return-Path: <SRS0=2yIc=AD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A615C433DF
	for <linux-wireless@archiver.kernel.org>; Mon, 22 Jun 2020 20:13:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E8FD2075A
	for <linux-wireless@archiver.kernel.org>; Mon, 22 Jun 2020 20:13:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="cqgaRuiY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728830AbgFVUNm (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 22 Jun 2020 16:13:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728581AbgFVUNk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Jun 2020 16:13:40 -0400
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8675EC06179A
        for <linux-wireless@vger.kernel.org>; Mon, 22 Jun 2020 13:13:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=WwtoSWwCAJj1lvocPiy1gGPRx95YbleOW2FNSHoNHWc=; b=cqgaRuiYZ122B/NCziMCCam5/L
        qV/QIBPcZ1IieNeuSQDPUiEK0ngBnG1QvRW0O1khnexu8a5qSidKgZxdiRgdKCK5FiuOOYBU1tUso
        PiJkkOVGDmTi3zKGYnQaDzawFkMD44nJBNtH0soqFHA0gVsEOsGlLYpWjBBKJEdiU9eI=;
Received: from p54ae948c.dip0.t-ipconnect.de ([84.174.148.140] helo=localhost.localdomain)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_CBC_SHA1:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1jnSp0-0000qE-7d
        for linux-wireless@vger.kernel.org; Mon, 22 Jun 2020 22:13:38 +0200
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Subject: [PATCH 4/7] mt76: mt7615: use full on-chip memory address for WF_PHY registers
Date:   Mon, 22 Jun 2020 22:13:24 +0200
Message-Id: <20200622201327.94414-4-nbd@nbd.name>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20200622201327.94414-1-nbd@nbd.name>
References: <20200622201327.94414-1-nbd@nbd.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Now that the bus access functions can use mapping for accessing full
register addresses, use it for WF_PHY registers to keep them constant.
Needed for follow-up work on testmode support

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt7615/mmio.c | 2 --
 drivers/net/wireless/mediatek/mt76/mt7615/regs.h | 3 +--
 drivers/net/wireless/mediatek/mt76/mt7615/usb.c  | 1 -
 3 files changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mmio.c b/drivers/net/wireless/mediatek/mt76/mt7615/mmio.c
index 07ad64e4a77a..461ac6c42271 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mmio.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mmio.c
@@ -17,7 +17,6 @@ const u32 mt7615e_reg_map[] = {
 	[MT_CSR_BASE]		= 0x07000,
 	[MT_PLE_BASE]		= 0x08000,
 	[MT_PSE_BASE]		= 0x0c000,
-	[MT_PHY_BASE]		= 0x10000,
 	[MT_CFG_BASE]		= 0x20200,
 	[MT_AGG_BASE]		= 0x20a00,
 	[MT_TMAC_BASE]		= 0x21000,
@@ -44,7 +43,6 @@ const u32 mt7663e_reg_map[] = {
 	[MT_CSR_BASE]		= 0x07000,
 	[MT_PLE_BASE]		= 0x08000,
 	[MT_PSE_BASE]		= 0x0c000,
-	[MT_PHY_BASE]		= 0x10000,
 	[MT_CFG_BASE]		= 0x20000,
 	[MT_AGG_BASE]		= 0x22000,
 	[MT_TMAC_BASE]		= 0x24000,
diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/regs.h b/drivers/net/wireless/mediatek/mt76/mt7615/regs.h
index f0b36b162bf3..4743c12005a4 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/regs.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/regs.h
@@ -14,7 +14,6 @@ enum mt7615_reg_base {
 	MT_CSR_BASE,
 	MT_PLE_BASE,
 	MT_PSE_BASE,
-	MT_PHY_BASE,
 	MT_CFG_BASE,
 	MT_AGG_BASE,
 	MT_TMAC_BASE,
@@ -169,7 +168,7 @@ enum mt7615_reg_base {
 #define MT_PSE_PG_INFO			MT_PSE(0x194)
 #define MT_PSE_SRC_CNT			GENMASK(27, 16)
 
-#define MT_WF_PHY_BASE			((dev)->reg_map[MT_PHY_BASE])
+#define MT_WF_PHY_BASE			0x82070000
 #define MT_WF_PHY(ofs)			(MT_WF_PHY_BASE + (ofs))
 
 #define MT_WF_PHY_WF2_RFCTRL0(n)	MT_WF_PHY(0x1900 + (n) * 0x400)
diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/usb.c b/drivers/net/wireless/mediatek/mt76/mt7615/usb.c
index f5dc1b828518..0ba28d37c414 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/usb.c
@@ -25,7 +25,6 @@ static const u32 mt7663u_reg_map[] = {
 	[MT_TOP_MISC_BASE]	= 0x81020000,
 	[MT_PLE_BASE]		= 0x82060000,
 	[MT_PSE_BASE]		= 0x82068000,
-	[MT_PHY_BASE]		= 0x82070000,
 	[MT_WTBL_BASE_ADDR]	= 0x820e0000,
 	[MT_CFG_BASE]		= 0x820f0000,
 	[MT_AGG_BASE]		= 0x820f2000,
-- 
2.24.0

