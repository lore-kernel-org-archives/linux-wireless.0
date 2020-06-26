Return-Path: <SRS0=B3tD=AH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 288E5C433E2
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Jun 2020 21:25:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 08BF52100A
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Jun 2020 21:25:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1593206743;
	bh=tuLy4ShzWJs5sATRkIvM4SMsEx6NlrCEvROfr7GG5zA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=cznU6mjFj/7hj1Ic03/Tn7czDIAk8trgM2aklh5jTbc7V7HStj9ayHeUE9YC2UDB+
	 mNwumxvcC1/JvLuKGr4Tn5NRi7TyixkU+U6wATLTVWwOyCeGTpUHOhfXcDb65WWnBd
	 ptLGoQICUfpTcv9EPFOxrwnYP4unNtfqB6mux8pg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726345AbgFZVZm (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 26 Jun 2020 17:25:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:33736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725793AbgFZVZl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Jun 2020 17:25:41 -0400
Received: from localhost.localdomain.com (unknown [151.48.138.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4A94120B1F;
        Fri, 26 Jun 2020 21:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593206741;
        bh=tuLy4ShzWJs5sATRkIvM4SMsEx6NlrCEvROfr7GG5zA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DWN/3TwxAZ6w6DqupEkMRvnpF8ozFPuAn7ukJ1OYdI0bsB2wGtGtFKHU0SfU4XVO9
         UyHaHN+lydu6jnatPKNbaaTr6FDXSGtDmR2o9wgNyP2qqm3V4J9tyuvzkG/2KmCfMH
         4pLlaKuHVM4l+8JMVJUs+D8ElcEidkb1IuXs75o0=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, lorenzo.bianconi@redhat.com,
        sean.wang@mediatek.com, ryder.lee@mediatek.com,
        linux-mediatek@lists.infradead.org
Subject: [PATCH 05/17] mt76: mt7615: wake device before accessing regmap in debugfs
Date:   Fri, 26 Jun 2020 23:25:05 +0200
Message-Id: <4ad493ebe2a26e709c50edf16d29a310f57d8fcf.1593204577.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1593204577.git.lorenzo@kernel.org>
References: <cover.1593204577.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Make sure the device is in full-power before reading regs in debugfs

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/debugfs.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/debugfs.c b/drivers/net/wireless/mediatek/mt76/mt7615/debugfs.c
index 8bb7c64db738..b4c196005ebf 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/debugfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/debugfs.c
@@ -167,9 +167,13 @@ mt7615_ampdu_stat_read(struct seq_file *file, void *data)
 {
 	struct mt7615_dev *dev = file->private;
 
+	mt7615_mutex_acquire(dev, &dev->mt76.mutex);
+
 	mt7615_ampdu_stat_read_phy(&dev->phy, file);
 	mt7615_ampdu_stat_read_phy(mt7615_ext_phy(dev), file);
 
+	mt7615_mutex_release(dev, &dev->mt76.mutex);
+
 	return 0;
 }
 
@@ -233,6 +237,8 @@ mt7615_queues_acq(struct seq_file *s, void *data)
 	struct mt7615_dev *dev = dev_get_drvdata(s->private);
 	int i;
 
+	mt7615_mutex_acquire(dev, &dev->mt76.mutex);
+
 	for (i = 0; i < 16; i++) {
 		int j, wmm_idx = i % MT7615_MAX_WMM_SETS;
 		int acs = i / MT7615_MAX_WMM_SETS;
@@ -253,6 +259,8 @@ mt7615_queues_acq(struct seq_file *s, void *data)
 		seq_printf(s, "AC%d%d: queued=%d\n", wmm_idx, acs, qlen);
 	}
 
+	mt7615_mutex_release(dev, &dev->mt76.mutex);
+
 	return 0;
 }
 
-- 
2.26.2

