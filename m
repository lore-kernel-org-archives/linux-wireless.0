Return-Path: <SRS0=M/jX=SP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E946FC10F11
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Apr 2019 14:02:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AECC020869
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Apr 2019 14:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1555164124;
	bh=0SyqVmK995UFWDyhjBPZS77CTCuO9EEtFS6wgxFzgtQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=E/8uaDCQ7J0O9mwxkNMJlPXJX0lmONXOJPpAkzCUgOmVF5FenPtAUeoG2wpW6nG44
	 vqiuzoDm7KrIuGq9F+HEv5xv0wjhXX2qJ2hUPZ5RGjSSN248zpYMXRF2kmgI3LM62D
	 thlqORwRv0yIM46XmVjRXkyKV16mc8lFYe6DreLY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726207AbfDMOCE (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 13 Apr 2019 10:02:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:32918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727104AbfDMOCD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 13 Apr 2019 10:02:03 -0400
Received: from localhost.localdomain.com (unknown [151.66.24.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C2CE620848;
        Sat, 13 Apr 2019 14:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1555164122;
        bh=0SyqVmK995UFWDyhjBPZS77CTCuO9EEtFS6wgxFzgtQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qECxcg4um4AzracqkBl0T7JRw01AMS+nMTW7i/He0rFWmGMl9yrdBIFnt+DAkyfTQ
         uPWhX+dCu/+7a0YsjVyTFb52KJwKZqFq7qo2d5pCh7rGlmDBxXmgSSfc6VkMj3T3dH
         uFr6jK93DN4gRBM4EqQOgMJnM6W6l9cqKAcynbuo=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     lorenzo.bianconi@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 4/5] mt76: introduce mt76_mcu_restart macro
Date:   Sat, 13 Apr 2019 16:01:27 +0200
Message-Id: <5039ab9a5ed0df5b9919f02c3bd50e2dc55855ab.1555163776.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1555163776.git.lorenzo@kernel.org>
References: <cover.1555163776.git.lorenzo@kernel.org>
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
index cff9c57d2838..4eed7b489349 100644
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
index 705c0939d10b..88aa992aa679 100644
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

