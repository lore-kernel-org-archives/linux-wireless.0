Return-Path: <SRS0=/Ln1=VP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6243C7618F
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Jul 2019 22:50:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 79A6C2173B
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Jul 2019 22:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1563490252;
	bh=7+E7GoF6Dwtfw+V7YyrBAVrViteIaF9bp1/dS6cJ68Q=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=1HHQsmww5Ft3QU5LuP4t78tOmWKTY8kMvAMOU4d4ccYmMbSgcR/3MrZtXPSsI8sn5
	 4SInYqBQ60rGco33JRnCwzLopaZKtICoVoeF2BP/S6irPMQ7k+XWxfS8SHjH2Z5zJv
	 VLL0jJdmv2xiYkes6KZw9zlOorH/OD+vikHnD5vo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391375AbfGRWuv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 18 Jul 2019 18:50:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:42364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727972AbfGRWuv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 Jul 2019 18:50:51 -0400
Received: from lore-desk-wlan.lan (unknown [151.66.36.246])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B4E012173B;
        Thu, 18 Jul 2019 22:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563490250;
        bh=7+E7GoF6Dwtfw+V7YyrBAVrViteIaF9bp1/dS6cJ68Q=;
        h=From:To:Cc:Subject:Date:From;
        b=SdZLulyB59o1iuq91drSgUuJTXtmlHh1x3HfoFlhLPUArTF7GOuMasu0zxNmg6ja2
         k6Dhnz+HSvLsAF2Mrxgu7LNNGDVFOB/GfEtO6Prr27OqZkbVMm38+CF2rz6Tip0c8f
         FeWUWyhfTMuKvRf+TO+7wXWNKjQvi4llnO5bIu6M=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     lorenzo.bianconi@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH] mt76: mt7603: fix watchdog rescheduling in mt7603_set_channel
Date:   Fri, 19 Jul 2019 00:50:42 +0200
Message-Id: <a266417a71907f663991142f5ce44becc09e6996.1563490117.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Convert MT7603_WATCHDOG_TIME in jiffies rescheduling watchdog delayed
work

Fixes: c8846e101502 ("mt76: add driver for MT7603E and MT7628/7688")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7603/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/main.c b/drivers/net/wireless/mediatek/mt76/mt7603/main.c
index d70f42dac923..88c869002311 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/main.c
@@ -173,7 +173,7 @@ mt7603_set_channel(struct mt7603_dev *dev, struct cfg80211_chan_def *def)
 	mt76_txq_schedule_all(&dev->mt76);
 
 	ieee80211_queue_delayed_work(mt76_hw(dev), &dev->mt76.mac_work,
-				     MT7603_WATCHDOG_TIME);
+				     msecs_to_jiffies(MT7603_WATCHDOG_TIME));
 
 	/* reset channel stats */
 	mt76_clear(dev, MT_MIB_CTL, MT_MIB_CTL_READ_CLR_DIS);
-- 
2.21.0

