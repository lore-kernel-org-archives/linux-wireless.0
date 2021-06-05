Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1575C47082
	for <linux-wireless@archiver.kernel.org>; Sat,  5 Jun 2021 11:46:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA8EF613B4
	for <linux-wireless@archiver.kernel.org>; Sat,  5 Jun 2021 11:46:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230118AbhFELr7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 5 Jun 2021 07:47:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:52260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229931AbhFELr6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 5 Jun 2021 07:47:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1A0EB613AA;
        Sat,  5 Jun 2021 11:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622893571;
        bh=DMnGpRc6CO1BVac6M1Nv/k0wfcmK9nGiVomagPoDugg=;
        h=From:To:Cc:Subject:Date:From;
        b=XqUuZlfvDere8+b4BzhYDdtE2rPtTlXJaKgyr9jE8XSsFTL44WKIchc5NL9nhOhC/
         nsyp0zrn1ftVZtXpkcN/8wbHNO50cvqNJ/EIoqwX3v/smHd6iVIUX62ixZcWwoJm5G
         qiIE53iUku+OO+9IYEYERN2dh9RfR3a8xZmrmHH6A4BJUaSIq/Bz3/vIhOmH/9w6au
         adY2DQIsks26siECEwRZT9cic05XtkEeCQ3DszJqX3/kYfMRSkMlnxkjYFyMr09sH0
         gA3pKsd/rZUlx9M0jfphbqfhz+1NLDQCxtAlvxqwouc4IPI59Qs/e2R3G/SxF/9kTk
         fiOGQ9hzH5baw==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     lorenzo.bianconi@redhat.com, linux-wireless@vger.kernel.org,
        deren.wu@mediatek.com, sean.wang@mediatek.com
Subject: [PATCH] mt76: mt7921: wake the device before dumping power table
Date:   Sat,  5 Jun 2021 13:46:03 +0200
Message-Id: <337a5087d6f696fa7ba9048fdcb342f0e96480cd.1622893491.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Always wake the device up before dumping the single_sku power table
otherwise the device can hang.

Fixes: ea29acc97c555 ("mt76: mt7921: add dumping Tx power tabl")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/debugfs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/debugfs.c b/drivers/net/wireless/mediatek/mt76/mt7921/debugfs.c
index b41d70be948b..c8cba1821cd7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/debugfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/debugfs.c
@@ -184,7 +184,10 @@ mt7921_txpwr(struct seq_file *s, void *data)
 	struct mt7921_txpwr txpwr;
 	int ret;
 
+	mt7921_mutex_acquire(dev);
 	ret = mt7921_get_txpwr_info(dev, &txpwr);
+	mt7921_mutex_release(dev);
+
 	if (ret)
 		return ret;
 
-- 
2.31.1

