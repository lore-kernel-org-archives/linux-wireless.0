Return-Path: <SRS0=c+XT=TL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EE42C04AB1
	for <linux-wireless@archiver.kernel.org>; Sat, 11 May 2019 10:18:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 54E14217F9
	for <linux-wireless@archiver.kernel.org>; Sat, 11 May 2019 10:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1557569898;
	bh=Alx1F3HGpHHzTKCJodExOcFJvKJAfKfF+ZyRTzzeNZM=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=1k7M6gHJzL9Y/8Eg0btaYm7nVZMtjIv6M0SamAOYk1NOQCogjIYJNp5GUWKZ4EObO
	 HnoMPtHVnG22NAvbCJ25hKlkGk1isiyCcxH89Qh56RUVz9RkuRqAWyP4q+8ap9v+Nn
	 kTpfeQTkRV5ZH0ON+8KR7VilrsaxO/EfBv8v3o8g=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728496AbfEKKSR (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 11 May 2019 06:18:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:36690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728477AbfEKKSR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 11 May 2019 06:18:17 -0400
Received: from localhost.localdomain (unknown [151.66.17.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D64532146F;
        Sat, 11 May 2019 10:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557569896;
        bh=Alx1F3HGpHHzTKCJodExOcFJvKJAfKfF+ZyRTzzeNZM=;
        h=From:To:Cc:Subject:Date:From;
        b=dQYRg5SqW2BhAUj5MerVsW2QiaRwuiQnTApLOgP0n/KBK9/8za6VapD1M3ZiUngmZ
         wDyqxnAX9npiiOmM+p8ougZvaBxgw9sC3lgTZ0V7U94d9BfFZ7II4SCLTXoWb1RvCn
         aJTrGkXbZ8BmckicWPPKcmqPWlGrwAE2SRBm9TdM=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     lorenzo.bianconi@redhat.com, linux-wireless@vger.kernel.org,
        sgruszka@redhat.com
Subject: [PATCH 0/4] run mt76x02_edcca_init atomically
Date:   Sat, 11 May 2019 12:17:50 +0200
Message-Id: <cover.1557567465.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Run mt76x02_edcca_init atomically in mt76_edcca_set since it is
concurrent with mt76x2_set_channel/mt76x2u_set_channel and
channel calibration

Lorenzo Bianconi (4):
  mt76: mt76x02: remove enable from mt76x02_edcca_init signature
  mt76: mt76x2u: remove mt76x02_edcca_init in mt76x2u_set_channel
  mt76: mt76x2: move mutex_lock inside mt76x2_set_channel
  mt76: mt76x02: run mt76x02_edcca_init atomically in mt76_edcca_set

 .../net/wireless/mediatek/mt76/mt76x0/main.c  |  2 +-
 drivers/net/wireless/mediatek/mt76/mt76x02.h  |  7 ++++++
 .../wireless/mediatek/mt76/mt76x02_debugfs.c  |  6 ++++-
 .../net/wireless/mediatek/mt76/mt76x02_dfs.c  |  2 +-
 .../net/wireless/mediatek/mt76/mt76x02_mac.c  |  6 ++---
 .../net/wireless/mediatek/mt76/mt76x02_mac.h  |  1 -
 .../wireless/mediatek/mt76/mt76x2/pci_main.c  | 16 +++++++------
 .../wireless/mediatek/mt76/mt76x2/pci_phy.c   | 15 ++++++++----
 .../wireless/mediatek/mt76/mt76x2/usb_main.c  | 23 ++++++++++---------
 .../wireless/mediatek/mt76/mt76x2/usb_phy.c   | 15 ++++++++----
 10 files changed, 58 insertions(+), 35 deletions(-)

-- 
2.20.1

