Return-Path: <SRS0=c+XT=TL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCC12C04AB1
	for <linux-wireless@archiver.kernel.org>; Sat, 11 May 2019 10:18:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 85B1E217F9
	for <linux-wireless@archiver.kernel.org>; Sat, 11 May 2019 10:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1557569903;
	bh=T3BeGIptBzq2b6f5ZHqirDgDDMqJwCJZntMup+LH5/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=H5LLu3OKyzR4M8PTmxOBl3wXda2x5NkjY1j+shMLngdLoZq5n8orVoF6L12PiRNyv
	 AlpElTIvQbthG/GzKJYn1pFE+U96t5eK6fNbpfuDCFqcJdrX06Cd0E4a5w4/qjz3LA
	 9/oqU+i9BMW7c7jdMDzFiYOkm6tDNQ1VWM0op9R0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728555AbfEKKSX (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 11 May 2019 06:18:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:36828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728477AbfEKKSW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 11 May 2019 06:18:22 -0400
Received: from localhost.localdomain (unknown [151.66.17.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 395032146F;
        Sat, 11 May 2019 10:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557569902;
        bh=T3BeGIptBzq2b6f5ZHqirDgDDMqJwCJZntMup+LH5/c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kfACHb9cHZyCxFuw4SKrjYEG8TgCxkmybLAJD0XxjAP+DEE0kqsWaBFrpaUxCc4JI
         yMIOpc/22RvarBgMXrtprgE97whzIcHnKsu5JimdyzIcBbpdfKHrYjmiObhViCX3dQ
         v/v53qjkyRLXh6xHVFTlynEuk3BwLtYdDybH2sBw=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     lorenzo.bianconi@redhat.com, linux-wireless@vger.kernel.org,
        sgruszka@redhat.com
Subject: [PATCH 2/4] mt76: mt76x2u: remove mt76x02_edcca_init in mt76x2u_set_channel
Date:   Sat, 11 May 2019 12:17:52 +0200
Message-Id: <e43e1e880751af77694f86d73a013c711ad40523.1557567465.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1557567465.git.lorenzo@kernel.org>
References: <cover.1557567465.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Remove mt76x02_edcca_init in mt76x2u_set_channel since it is already
run by mt76x2u_phy_channel_calibrate performing channel calibration

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c
index 6657693edc3e..3351b736603d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c
@@ -59,7 +59,6 @@ mt76x2u_set_channel(struct mt76x02_dev *dev,
 	err = mt76x2u_phy_set_channel(dev, chandef);
 
 	mt76x2_mac_resume(dev);
-	mt76x02_edcca_init(dev);
 
 	dev->beacon_ops->pre_tbtt_enable(dev, true);
 
-- 
2.20.1

