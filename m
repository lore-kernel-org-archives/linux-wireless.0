Return-Path: <SRS0=IMqP=SN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66562C10F13
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Apr 2019 11:53:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2BE8F2133D
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Apr 2019 11:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1554983580;
	bh=YHDwszi0Lk2gN8MWevLmfQXXk6CtPZoswIjVGQK8EMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=p+VyLEanacqpMAM3Tii6d6+YZB29GkK6uCtOEqADdxr7WOOPLHawpGMlPhGuIfM43
	 aNiT95FKhPzXpEO1r/pJdBwz081JNYp0kLQ50dDmPcD0QiAlb+udMiKdWlVcRmum/7
	 7TGZ26MHvOw9oWfzGcJV7EEent72ExmFwD2swAdY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726812AbfDKLw7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 11 Apr 2019 07:52:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:33032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726628AbfDKLw6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 Apr 2019 07:52:58 -0400
Received: from localhost.localdomain (unknown [151.66.24.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 985262133D;
        Thu, 11 Apr 2019 11:52:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1554983577;
        bh=YHDwszi0Lk2gN8MWevLmfQXXk6CtPZoswIjVGQK8EMo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gWg6AS9KBzuhnaafO6/LxSHR4I0qYB81jh+Wlw8AIpR5B4RrG53LRjuKjqWvkqja9
         gxWJWY/SCsP1E/FjdWdmOfidRw0aGnBLGbbIuZJlPGQnCW+XFy/gxGxxk6svERp3rU
         zMvTiMwm6Xc0vDejLLnqVuK8bz10iyBfZXWP1yVU=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     lorenzo.bianconi@redhat.com, linux-wireless@vger.kernel.org
Subject: [RFC 4/5] mt76: introduce mt76_mcu_restart macro
Date:   Thu, 11 Apr 2019 13:52:36 +0200
Message-Id: <43516550e51f748975b1d8d02cc7d65daf67d38c.1554982661.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1554982661.git.lorenzo@kernel.org>
References: <cover.1554982661.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Use common function wrapper in mt76x02_watchdog_reset

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt76.h         | 2 ++
 drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index a23ec92fae97..def76af77cd8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -537,6 +537,8 @@ struct mt76_rx_status {
 
 #define mt76_mcu_send_msg(dev, ...)	(dev)->mt76.mcu_ops->mcu_send_msg(&((dev)->mt76), __VA_ARGS__)
 #define __mt76_mcu_send_msg(dev, ...)	(dev)->mcu_ops->mcu_send_msg((dev), __VA_ARGS__)
+#define mt76_mcu_restart(dev, ...)	(dev)->mt76.mcu_ops->mcu_restart(&((dev)->mt76))
+#define __mt76_mcu_restart(dev, ...)	(dev)->mcu_ops->mcu_restart((dev))
 
 #define mt76_set(dev, offset, val)	mt76_rmw(dev, offset, 0, val)
 #define mt76_clear(dev, offset, val)	mt76_rmw(dev, offset, val, 0)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
index ca8320711bc2..f2d2c4112e80 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
@@ -454,7 +454,7 @@ static void mt76x02_watchdog_reset(struct mt76x02_dev *dev)
 	mt76_set(dev, 0x734, 0x3);
 
 	if (restart)
-		dev->mt76.mcu_ops->mcu_restart(&dev->mt76);
+		mt76_mcu_restart(dev);
 
 	for (i = 0; i < ARRAY_SIZE(dev->mt76.q_tx); i++)
 		mt76_queue_tx_cleanup(dev, i, true);
-- 
2.20.1

