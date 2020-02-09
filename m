Return-Path: <SRS0=ZRRt=35=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 658CAC352A4
	for <linux-wireless@archiver.kernel.org>; Sun,  9 Feb 2020 14:15:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 34C8D2080C
	for <linux-wireless@archiver.kernel.org>; Sun,  9 Feb 2020 14:15:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1581257728;
	bh=ozCZ5IDcxCbHd4n50GpxOKbRUcjWGnwEjNRhKCdtR24=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=xK2bWPc3uGVmcCmfWwTMesVF7AalOok8rCDzomcq0D2NEZ7QjOf33x0x3RXcIpmQu
	 pEf97w7ZZJJlYMX52em1cn2AXX/sq5gV0j3doPBh4tSmzBHHiSHMlWBhenDSpAhNBM
	 5Ivk2otJfbXWcrl3JEUN9ZjHQhJoVe8br5yh6hT8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727786AbgBIOP1 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 9 Feb 2020 09:15:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:36674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727473AbgBIOP1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 9 Feb 2020 09:15:27 -0500
Received: from lore-desk-wlan.lan (unknown [151.48.137.85])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD7DF20733;
        Sun,  9 Feb 2020 14:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581257726;
        bh=ozCZ5IDcxCbHd4n50GpxOKbRUcjWGnwEjNRhKCdtR24=;
        h=From:To:Cc:Subject:Date:From;
        b=GK/4FPg53hFJbtIOKRLOlG9wjxpoeRNdUxUQ0lCZ9OiZdIA6AKHQKFZdaQq+x3vqU
         9P2nP1g0aVaPKVs7STpfA9Em3JT1MdtYhXZkocJGiq+7B51Kv8rDsV9bbZA/WEG5Zx
         rEy9eSQgwPu+WCBbat9lvQoy8Fj/JVoBGB+ivjTE=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     lorenzo.bianconi@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH] mt76: mt7615: rely on mt76_queues_read for mt7622
Date:   Sun,  9 Feb 2020 15:15:08 +0100
Message-Id: <4ac612059543771e116c0cc9b485d61b8c2f75e0.1581257677.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

As previous devices, mt7622 relies on multiple hw queues while for
mt7615 we have just on per band hw queue and the mcu demux the traffic
according to the packet AC. In order to dump all configured hw queues,
rely on mt76_queues_read for mt7622 in mt7615 debugfs

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/debugfs.c        | 2 +-
 drivers/net/wireless/mediatek/mt76/mt7615/debugfs.c | 8 ++++++--
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/debugfs.c b/drivers/net/wireless/mediatek/mt76/debugfs.c
index 2567c5d6945f..d2202acb8dc6 100644
--- a/drivers/net/wireless/mediatek/mt76/debugfs.c
+++ b/drivers/net/wireless/mediatek/mt76/debugfs.c
@@ -30,7 +30,7 @@ int mt76_queues_read(struct seq_file *s, void *data)
 	struct mt76_dev *dev = dev_get_drvdata(s->private);
 	int i;
 
-	for (i = 0; i < __MT_TXQ_MAX; i++) {
+	for (i = 0; i < ARRAY_SIZE(dev->q_tx); i++) {
 		struct mt76_sw_queue *q = &dev->q_tx[i];
 
 		if (!q->q)
diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/debugfs.c b/drivers/net/wireless/mediatek/mt76/mt7615/debugfs.c
index 7d8e53ac51ef..b4d0795154e3 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/debugfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/debugfs.c
@@ -264,8 +264,12 @@ int mt7615_init_debugfs(struct mt7615_dev *dev)
 	if (!dir)
 		return -ENOMEM;
 
-	debugfs_create_devm_seqfile(dev->mt76.dev, "queues", dir,
-				    mt7615_queues_read);
+	if (is_mt7615(&dev->mt76))
+		debugfs_create_devm_seqfile(dev->mt76.dev, "queues", dir,
+					    mt7615_queues_read);
+	else
+		debugfs_create_devm_seqfile(dev->mt76.dev, "queues", dir,
+					    mt76_queues_read);
 	debugfs_create_devm_seqfile(dev->mt76.dev, "acq", dir,
 				    mt7615_queues_acq);
 	debugfs_create_file("ampdu_stat", 0400, dir, dev, &fops_ampdu_stat);
-- 
2.24.1

