Return-Path: <SRS0=k7+a=M4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09D6BC04EBD
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Oct 2018 09:42:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C25F82083C
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Oct 2018 09:42:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C25F82083C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727024AbeJPRcR (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 16 Oct 2018 13:32:17 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:36957 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726083AbeJPRcR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Oct 2018 13:32:17 -0400
Received: by mail-wm1-f66.google.com with SMTP id 185-v6so22599989wmt.2
        for <linux-wireless@vger.kernel.org>; Tue, 16 Oct 2018 02:42:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=q48DOPTuQYbB2GZamcVwYYLetfhADt7441UZ2nE058A=;
        b=O5mnEQofRptdp9y8HxzHAvQVwYFmRFQ80aPJyy7EMsOu9Pyf5Za0bjJXmHPUqXCeVw
         hVpad7jSnE1Z4AwbmLup9x/1MF1DoVc5yYx8AypsxxqNB7c/i+w1XhhYfAIQmd3SBHTW
         IMrV7MOc+aozxfTog8u0cY2pjIRZ7eevGx7CrMdCqBLufEsbrXLD7H+q13U4k5HOkjh4
         MRs0fZQthfu/pseKtmud3u5cG3JksmOzO8y9wseXTEFlUDGmpyL+n4/Ad1lFGVTgb3qo
         GK6zEXHRB+gn5ZMg7GIdw1qfFgWK3mnIR7je8wLpkOgnAeEHjSrFmXtdKRVfnWvShffN
         fbSg==
X-Gm-Message-State: ABuFfogfU2/tfNsCxyYUXwyoxWwHX95I3NwS2zemu5qiarRf+lDKPKJW
        Imkdle+LMagesS1xfzDDazkGad1NdW4=
X-Google-Smtp-Source: ACcGV60AqeLg5oYidKnW6cE0g/Dbhh42bB5fR+CpPRMVxdvkEqJl5HqSlFne8nx2N7vMhOKRXoXZ5w==
X-Received: by 2002:a1c:5505:: with SMTP id j5-v6mr15512484wmb.146.1539682959776;
        Tue, 16 Oct 2018 02:42:39 -0700 (PDT)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id s17-v6sm10116044wrq.41.2018.10.16.02.42.38
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 16 Oct 2018 02:42:39 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH] mt76x0: init: simplify mt76x0_init_mac_registers
Date:   Tue, 16 Oct 2018 11:42:32 +0200
Message-Id: <defe9c65647315088cc2bb87951f9b081f68bf0f.1539682476.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <cover.1539682476.git.lorenzo.bianconi@redhat.com>
References: <cover.1539682476.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Simplify mt76x0_init_mac_registers routine using mt76_set, mt76_clear
and mt76_rmw utility routines

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../net/wireless/mediatek/mt76/mt76x0/init.c  | 27 +++++++------------
 1 file changed, 10 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
index f5c7db9ca02a..d49357c7f104 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
@@ -134,8 +134,6 @@ static int mt76x0_init_bbp(struct mt76x02_dev *dev)
 
 static void mt76x0_init_mac_registers(struct mt76x02_dev *dev)
 {
-	u32 reg;
-
 	RANDOM_WRITE(dev, common_mac_reg_table);
 
 	mt76x02_set_beacon_offsets(dev);
@@ -144,27 +142,22 @@ static void mt76x0_init_mac_registers(struct mt76x02_dev *dev)
 	RANDOM_WRITE(dev, mt76x0_mac_reg_table);
 
 	/* Release BBP and MAC reset MAC_SYS_CTRL[1:0] = 0x0 */
-	reg = mt76_rr(dev, MT_MAC_SYS_CTRL);
-	reg &= ~0x3;
-	mt76_wr(dev, MT_MAC_SYS_CTRL, reg);
+	mt76_clear(dev, MT_MAC_SYS_CTRL, 0x3);
 
 	/* Set 0x141C[15:12]=0xF */
-	reg = mt76_rr(dev, MT_EXT_CCA_CFG);
-	reg |= 0x0000F000;
-	mt76_wr(dev, MT_EXT_CCA_CFG, reg);
+	mt76_set(dev, MT_EXT_CCA_CFG, 0xf000);
 
 	mt76_clear(dev, MT_FCE_L2_STUFF, MT_FCE_L2_STUFF_WR_MPDU_LEN_EN);
 
 	/*
-		TxRing 9 is for Mgmt frame.
-		TxRing 8 is for In-band command frame.
-		WMM_RG0_TXQMA: This register setting is for FCE to define the rule of TxRing 9.
-		WMM_RG1_TXQMA: This register setting is for FCE to define the rule of TxRing 8.
-	*/
-	reg = mt76_rr(dev, MT_WMM_CTRL);
-	reg &= ~0x000003FF;
-	reg |= 0x00000201;
-	mt76_wr(dev, MT_WMM_CTRL, reg);
+	 * tx_ring 9 is for mgmt frame
+	 * tx_ring 8 is for in-band command frame.
+	 * WMM_RG0_TXQMA: this register setting is for FCE to
+	 *		  define the rule of tx_ring 9
+	 * WMM_RG1_TXQMA: this register setting is for FCE to
+	 *		  define the rule of tx_ring 8
+	 */
+	mt76_rmw(dev, MT_WMM_CTRL, 0x3ff, 0x201);
 }
 
 static int mt76x0_init_wcid_mem(struct mt76x02_dev *dev)
-- 
2.17.2

