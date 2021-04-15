Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BE40C433ED
	for <linux-wireless@archiver.kernel.org>; Thu, 15 Apr 2021 22:22:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 57D10610F7
	for <linux-wireless@archiver.kernel.org>; Thu, 15 Apr 2021 22:22:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236438AbhDOWWc (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 15 Apr 2021 18:22:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:60602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237581AbhDOWW0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Apr 2021 18:22:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A33D9610F7;
        Thu, 15 Apr 2021 22:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618525322;
        bh=JvZE+9lTDGZ4sdhx3Au7lFYGT52c+IutwB1Z+wjVDe4=;
        h=From:To:Cc:Subject:Date:From;
        b=YTWk2uzhfDI/BmGZXr+SF/9KWpPc/WUA61IsddxRIvAwxQlio3n8cE8pvFSKrs5Il
         l8X2QuVObtSEDoqgBFToRjlXg79E0oPSqxWYm+h/rExUBY9FImC2KSa/2ARx64fN9A
         kfC0tYwvlZvZ6LgNIEh55+bKodWMC/uBHirxoqu4HTZCHIJcuK6xDIXzUcDeT882BL
         pRcUsMLkLs0VCztxn/bzLmae3YxxJvGkeo4jPW8kB4jk2ql7YMLYbFZj7DGnrMB73p
         uXBkoVSmNSIxBSyQX2Ngh81MiC5Jy1uy3lCI+HAsisBssW/8yHUN2O85bmFtrkLNZG
         wcwUV8K4bcWIg==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, lorenzo.bianconi@redhat.com,
        sean.wang@mediatek.com
Subject: [PATCH] mt76: mt7921: run mt7921_mcu_fw_log_2_host holding mt76 mutex
Date:   Fri, 16 Apr 2021 00:21:54 +0200
Message-Id: <97d2eb704d0e644e11e02261e3facd2206930787.1618524877.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Wake the chip before configuring the mcu log level

Fixes: 1d8efc741df8 ("mt76: mt7921: introduce Runtime PM support")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/debugfs.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/debugfs.c b/drivers/net/wireless/mediatek/mt76/mt7921/debugfs.c
index 024524173115..48dc7daf975b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/debugfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/debugfs.c
@@ -9,10 +9,13 @@ mt7921_fw_debug_set(void *data, u64 val)
 {
 	struct mt7921_dev *dev = data;
 
-	dev->fw_debug = (u8)val;
+	mt7921_mutex_acquire(dev);
 
+	dev->fw_debug = (u8)val;
 	mt7921_mcu_fw_log_2_host(dev, dev->fw_debug);
 
+	mt7921_mutex_release(dev);
+
 	return 0;
 }
 
-- 
2.30.2

