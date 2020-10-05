Return-Path: <SRS0=MQGE=DM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86C41C4363A
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Oct 2020 11:36:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D2A9206A1
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Oct 2020 11:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601897800;
	bh=fgGs/g8R7FGxfEERGh9tPEu0YXx3kolUdYs8Lt0EScE=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=1MpQ6IyDltssExsQminaRdU8eeHisGrdBN4SfR/Z2AZWv2nk3ruHvmOwRukASbtjH
	 BzoJaDlwHfdG3qI0QVgQuWfFuGpX33SZclwGVC/1xp/ibelPQiti9DSjMZTlCt+mPs
	 AUqXYAhRHo4hzsUwG1AfK3KBh1Mtzh8/LtYbwUu0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725936AbgJELgj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 5 Oct 2020 07:36:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:41230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725891AbgJELgj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Oct 2020 07:36:39 -0400
Received: from lore-desk.redhat.com (unknown [176.207.245.61])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CFB5D2064C;
        Mon,  5 Oct 2020 11:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601897798;
        bh=fgGs/g8R7FGxfEERGh9tPEu0YXx3kolUdYs8Lt0EScE=;
        h=From:To:Cc:Subject:Date:From;
        b=lzszI3pIr0lU7lPH3KLW7NciCo2KLn6pH58NypQbxMgFpCNYacScDTIC+VSa5rgQK
         WSf//wsihd19H9lqwbsUaFC3Iq/9a/cKLCfdx4kBz5GcZWL/EflXyh5Mmletijudkq
         j+EtZnp5YiARUVIZL41vi/dSE+a+QIUziBkw8UPg=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, lorenzo.bianconi@redhat.com,
        sean.wang@mediatek.com
Subject: [PATCH] mt76: mt7663s: get rid of mt7663s_sta_add
Date:   Mon,  5 Oct 2020 13:36:31 +0200
Message-Id: <c8e79c5d55440ff131d58a05efa303cbd7234b57.1601897686.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Get rid of mt7663s_sta_add routine and rely on mt7615_mac_sta_add
since sched quota is already initialized in mt7663s_mcu_init_sched
routine

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7615/sdio.c  | 26 +------------------
 1 file changed, 1 insertion(+), 25 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/sdio.c b/drivers/net/wireless/mediatek/mt76/mt7615/sdio.c
index a3718c501eb8..347975eaba86 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/sdio.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/sdio.c
@@ -294,30 +294,6 @@ static int mt7663s_hw_init(struct mt7615_dev *dev, struct sdio_func *func)
 	return ret;
 }
 
-static int mt7663s_sta_add(struct mt76_dev *mdev, struct ieee80211_vif *vif,
-			   struct ieee80211_sta *sta)
-{
-	struct mt7615_dev *dev = container_of(mdev, struct mt7615_dev, mt76);
-	struct mt76_sdio *sdio = &mdev->sdio;
-	u32 pse, ple;
-	int err;
-
-	err = mt7615_mac_sta_add(mdev, vif, sta);
-	if (err < 0)
-		return err;
-
-	/* init sched data quota */
-	pse = mt76_get_field(dev, MT_PSE_PG_HIF0_GROUP, MT_HIF0_MIN_QUOTA);
-	ple = mt76_get_field(dev, MT_PLE_PG_HIF0_GROUP, MT_HIF0_MIN_QUOTA);
-
-	mutex_lock(&sdio->sched.lock);
-	sdio->sched.pse_data_quota = pse;
-	sdio->sched.ple_data_quota = ple;
-	mutex_unlock(&sdio->sched.lock);
-
-	return 0;
-}
-
 static int mt7663s_probe(struct sdio_func *func,
 			 const struct sdio_device_id *id)
 {
@@ -329,7 +305,7 @@ static int mt7663s_probe(struct sdio_func *func,
 		.tx_status_data = mt7663_usb_sdio_tx_status_data,
 		.rx_skb = mt7615_queue_rx_skb,
 		.sta_ps = mt7615_sta_ps,
-		.sta_add = mt7663s_sta_add,
+		.sta_add = mt7615_mac_sta_add,
 		.sta_remove = mt7615_mac_sta_remove,
 		.update_survey = mt7615_update_channel,
 	};
-- 
2.26.2

