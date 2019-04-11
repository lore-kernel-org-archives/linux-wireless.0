Return-Path: <SRS0=IMqP=SN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC851C10F14
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Apr 2019 11:53:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A25BC2133D
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Apr 2019 11:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1554983581;
	bh=8ddBA1TRhgyqJmmbzAWKu8999yT9vFIGS2gOHjTEKy8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=DOXamdwuoWZRBn+WBd9Q73SF8jc5PyRCfz2lhtCc0vzdnx/zpXRiqYAElt1/MCAJI
	 3rAq9Ce3fHHfH0MG+c/8FljRohC3xTUstOYUrzIoKWuV9AvIBt/mKIJmEnTz6S0Cxm
	 BavTN8TnOUOptq6opZ/Szrfp1Hm+JKSHyoXHMeHM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726826AbfDKLxA (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 11 Apr 2019 07:53:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:33060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726628AbfDKLw7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 Apr 2019 07:52:59 -0400
Received: from localhost.localdomain (unknown [151.66.24.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F49A2184E;
        Thu, 11 Apr 2019 11:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1554983579;
        bh=8ddBA1TRhgyqJmmbzAWKu8999yT9vFIGS2gOHjTEKy8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TThI7yJ1phs/KTtxh/6OMZvFvyZmGVMjQaUO/SOC21Hpqa5J0crHHr0YnlVdcSUAR
         Q/+c8o2BU8TN7+1GmsTe+Hm2JocJn8VJNmq3Wsmx9rOkJAZGbA3d7H6PpBhqraF0O5
         3LYAMVGGzNH1J++19fVLuf8EpqeAPHCIdsSWMRmk=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     lorenzo.bianconi@redhat.com, linux-wireless@vger.kernel.org
Subject: [RFC 5/5] mt7603: init mcu_restart function pointer
Date:   Thu, 11 Apr 2019 13:52:37 +0200
Message-Id: <9bdbaa32ab0421c87b8c8afaa0d723cd9fa7dcbd.1554982661.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1554982661.git.lorenzo@kernel.org>
References: <cover.1554982661.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Use common function wrapper in mt7603_mcu_exit since the code is shared
with mt7615 driver

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7603/mcu.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7603/mcu.c
index c52ae301062c..7ebfcb021d40 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/mcu.c
@@ -161,9 +161,9 @@ mt7603_mcu_start_firmware(struct mt7603_dev *dev, u32 addr)
 }
 
 static int
-mt7603_mcu_restart(struct mt7603_dev *dev)
+mt7603_mcu_restart(struct mt76_dev *dev)
 {
-	return __mt76_mcu_send_msg(&dev->mt76, -MCU_CMD_RESTART_DL_REQ,
+	return __mt76_mcu_send_msg(dev, -MCU_CMD_RESTART_DL_REQ,
 				   NULL, 0, true);
 }
 
@@ -269,6 +269,7 @@ int mt7603_mcu_init(struct mt7603_dev *dev)
 {
 	static const struct mt76_mcu_ops mt7603_mcu_ops = {
 		.mcu_send_msg = mt7603_mcu_msg_send,
+		.mcu_restart = mt7603_mcu_restart,
 	};
 
 	dev->mt76.mcu_ops = &mt7603_mcu_ops;
@@ -277,7 +278,7 @@ int mt7603_mcu_init(struct mt7603_dev *dev)
 
 void mt7603_mcu_exit(struct mt7603_dev *dev)
 {
-	mt7603_mcu_restart(dev);
+	__mt76_mcu_restart(&dev->mt76);
 	skb_queue_purge(&dev->mt76.mmio.mcu.res_q);
 }
 
-- 
2.20.1

