Return-Path: <SRS0=Kusg=QO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86284C282C4
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 13:47:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5104D21904
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 13:47:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="XUGttqNN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727141AbfBGNrg (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 7 Feb 2019 08:47:36 -0500
Received: from nbd.name ([46.4.11.11]:47492 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727021AbfBGNrZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Feb 2019 08:47:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Rlu4Zs4I62vM0ovFtNIFVW5q3WbAkkloyUGjVW/AxN0=; b=XUGttqNNL5inbSO2MiDiBoRtVX
        j93qLPgRKhiY28XL7M0rwCR35ZJbah6Sz5XK4z1UHPtN8K6303OyhlJHQvggPU2N76KlhdYm4CWMA
        Oe/URK2LAMYopeRA63fqtB4tTI52u8bj6htXDX67nxi+ya8ApcR0Xm6d6+WWb2D0AjSs=;
Received: by maeck.lan (Postfix, from userid 501)
        id 8424D4F0BF97; Thu,  7 Feb 2019 14:47:23 +0100 (CET)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Subject: [PATCH 2/7] mt76: mt76x2: avoid running DPD calibration if tx is blocked
Date:   Thu,  7 Feb 2019 14:47:18 +0100
Message-Id: <20190207134723.59163-2-nbd@nbd.name>
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20190207134723.59163-1-nbd@nbd.name>
References: <20190207134723.59163-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Doing so could lead to hangs

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt76x2/phy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x2/phy.c
index e2ee5e498da7..1848e8ab2e21 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/phy.c
@@ -241,7 +241,7 @@ void mt76x2_phy_tssi_compensate(struct mt76x02_dev *dev)
 		t.offset1 = txp.chain[1].tssi_offset;
 		mt76x2_mcu_tssi_comp(dev, &t);
 
-		if (t.pa_mode || dev->cal.dpd_cal_done)
+		if (t.pa_mode || dev->cal.dpd_cal_done || dev->ed_tx_blocked)
 			return;
 
 		usleep_range(10000, 20000);
-- 
2.17.0

