Return-Path: <SRS0=x8ok=SU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 712F6C10F0E
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Apr 2019 14:32:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3BDA1217D7
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Apr 2019 14:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1555597940;
	bh=k/huu4zoEszx11tQVccoGMb5L4yv8wz0cuBs6eQERac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=wIq5JEyLptSGalw1ibvz46cKKF19SO7LpNKRZeRTtMri/bpvrZb43kj9JlJorzLDx
	 iVYaWviCWxwDygK/RUyws65fXx9sDos9E9CCfsh1ffNg3Dj5i9ps5qb6CVXDxooObu
	 dpCP47gqWu709qz5Tq6l8ZO/ls1cC97j2fteQYaw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389275AbfDROcT (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 18 Apr 2019 10:32:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:34854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388097AbfDROcT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 Apr 2019 10:32:19 -0400
Received: from localhost.localdomain (unknown [151.66.24.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A6B7221479;
        Thu, 18 Apr 2019 14:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1555597938;
        bh=k/huu4zoEszx11tQVccoGMb5L4yv8wz0cuBs6eQERac=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=daHuj8veoxDLnkp8gw4m1K0CmYuSiTcclf6P9HoEwHDsRFfQaoE0Zi3vofLO7MHm4
         S7HGKEzL/xDsqOVgmTKzxSI+2Z+767epq5ORcd3I/Ux0gZzCBsrMHyG2i2RoGJRjOP
         eF+bZmPysh/jXmD3MaGzSKJ+O/CtCX/3yRnsRB/Q=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     lorenzo.bianconi@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH] mt7603: mcu: run __mt76_mcu_send_msg in mt7603_mcu_send_firmware
Date:   Thu, 18 Apr 2019 16:32:00 +0200
Message-Id: <0fc0574d197f732865dd0e21b08b9f8d2c02890a.1555597590.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1555597590.git.lorenzo@kernel.org>
References: <cover.1555597590.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Run __mt76_mcu_send_msg instead of __mt7603_mcu_msg_send and remove
duplicated code.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
- this patch is based on 'use standard signature for mt7603 mcu api'
  https://patchwork.kernel.org/cover/10899435/
---
 drivers/net/wireless/mediatek/mt76/mt7603/mcu.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7603/mcu.c
index 7ebfcb021d40..ca08b546fa0a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/mcu.c
@@ -122,19 +122,14 @@ mt7603_mcu_init_download(struct mt7603_dev *dev, u32 addr, u32 len)
 static int
 mt7603_mcu_send_firmware(struct mt7603_dev *dev, const void *data, int len)
 {
-	struct sk_buff *skb;
-	int ret = 0;
+	int cur_len, ret = 0;
 
 	while (len > 0) {
-		int cur_len = min_t(int, 4096 - sizeof(struct mt7603_mcu_txd),
-				    len);
-
-		skb = mt7603_mcu_msg_alloc(data, cur_len);
-		if (!skb)
-			return -ENOMEM;
+		cur_len = min_t(int, 4096 - sizeof(struct mt7603_mcu_txd),
+				len);
 
-		ret = __mt7603_mcu_msg_send(dev, skb, -MCU_CMD_FW_SCATTER,
-					    NULL);
+		ret = __mt76_mcu_send_msg(&dev->mt76, -MCU_CMD_FW_SCATTER,
+					  data, cur_len, false);
 		if (ret)
 			break;
 
-- 
2.20.1

