Return-Path: <SRS0=iVws=XB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3855AC43331
	for <linux-wireless@archiver.kernel.org>; Fri,  6 Sep 2019 15:29:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0DB2D2082C
	for <linux-wireless@archiver.kernel.org>; Fri,  6 Sep 2019 15:29:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1567783766;
	bh=goP0T3nK9wdPLM00EOzxui8WH6coYbI+vkgT50x1Uug=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=gh7bYVnruCjGgoLaX/pPBpwTyycv4IEIrWxo5w7Q6IVRMWetgQi8c2fPYgeYAPM39
	 s6+UiSORinUpBjrljnEGrW5Mmf0wN/sNQM5jRfXCjFhqbD1YUeYJ5sWedr8Zue2l9o
	 AsgRePG+4OorEVcT3zQpYIDrkB/ue1GXsJlnMpF4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391143AbfIFP3Z (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 6 Sep 2019 11:29:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:54826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388007AbfIFP3Z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 6 Sep 2019 11:29:25 -0400
Received: from localhost.localdomain.com (unknown [151.66.4.139])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 622092070C;
        Fri,  6 Sep 2019 15:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567783764;
        bh=goP0T3nK9wdPLM00EOzxui8WH6coYbI+vkgT50x1Uug=;
        h=From:To:Cc:Subject:Date:From;
        b=iCVkv0XW9kvBUvbAlgcQYhkSe+ErY/EBI3yhViGoadkYST84/2FwRuESWtDMLPxrM
         0YoXMTp8u8k+ufz0xsKovvtT+jLTPBY7mKGZ+PMTRyv8Pe9JJN+WZzWu12VRQMxRJI
         hFaT+JuVGxXHcrwFVq07SFPyuwJ58maj7IYUqwSs=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     lorenzo.bianconi@redhat.com, linux-wireless@vger.kernel.org,
        ryder.lee@mediatek.com, royluo@google.com
Subject: [PATCH] mt76: mt7615: enable SCS by default
Date:   Fri,  6 Sep 2019 17:29:04 +0200
Message-Id: <5933942ffd23f71b925cc6be26e9918fd663ed46.1567783646.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Enable Smart Carrier Sense algorithm by default in order to improve
performances in a noisy environment

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/init.c b/drivers/net/wireless/mediatek/mt76/mt7615/init.c
index 1104e4c8aaa6..835499979b73 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/init.c
@@ -50,7 +50,7 @@ static void mt7615_mac_init(struct mt7615_dev *dev)
 		 MT_TMAC_CTCR0_INS_DDLMT_EN);
 
 	mt7615_mcu_set_rts_thresh(dev, 0x92b);
-	mt7615_mac_set_scs(dev, false);
+	mt7615_mac_set_scs(dev, true);
 
 	mt76_rmw(dev, MT_AGG_SCR, MT_AGG_SCR_NLNAV_MID_PTEC_DIS,
 		 MT_AGG_SCR_NLNAV_MID_PTEC_DIS);
-- 
2.21.0

