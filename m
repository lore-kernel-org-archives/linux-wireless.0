Return-Path: <SRS0=OuuR=2T=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92BD8C2D0C6
	for <linux-wireless@archiver.kernel.org>; Sun, 29 Dec 2019 10:03:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5E2FA208C4
	for <linux-wireless@archiver.kernel.org>; Sun, 29 Dec 2019 10:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1577613785;
	bh=aKEj2TqOAY8kpgEClAm1BK4XfP0D5pY/KiZcn8u6hQQ=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=vpefjUjyHY5HMwPMAbUsPa+jTJGaopKuaJco1dM10kku95cGBvFBkoWSqcx4/fPaT
	 +YRbZPu8yWDVo5PDS/xp+pcZx4PJWJMFuhSYBKJjHsy4mo28sxbuFpG9Z4av11hhSD
	 5FbGfjCHKPzv8MuvkTtSxj1lpA6P8oQUHHcfVA+8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726400AbfL2KC6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 29 Dec 2019 05:02:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:47500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726371AbfL2KC5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 29 Dec 2019 05:02:57 -0500
Received: from localhost.localdomain.homenet.telecomitalia.it (host151-113-dynamic.27-79-r.retail.telecomitalia.it [79.27.113.151])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 378C3207E0;
        Sun, 29 Dec 2019 10:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577613777;
        bh=aKEj2TqOAY8kpgEClAm1BK4XfP0D5pY/KiZcn8u6hQQ=;
        h=From:To:Cc:Subject:Date:From;
        b=wWrh6UmFv/Of2bvDnfMTIpfkUR7cS0V1FFlF5OnSQ9kaxsyC052qnVF8U93DqlP95
         li9Q+YMfw61hkpxT/4T2yVtqkrl84VwRathuhB2KaSjyuYKIXM3fhnO0dzuL54CwY6
         jU4tDjyCVp+fZhuzxfxiHkd0/0XQgFKE/K24nZWw=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     lorenzo.bianconi@redhat.com, linux-wireless@vger.kernel.org,
        ryder.lee@mediatek.com
Subject: [PATCH 0/4] Introduce tracing support to mt7615 driver
Date:   Sun, 29 Dec 2019 11:03:04 +0100
Message-Id: <cover.1577613505.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Add tracing support to mt7615 and mt7603 drivers.
Move some tracing common code in mt76 module.

Lorenzo Bianconi (4):
  mt76: move dev_irq tracepoint in mt76 module
  mt76: move mac_txdone tracepoint in mt76 module
  mt76: mt7615: add tracing support
  mt76: mt76x2: get rid of leftover target

 .../net/wireless/mediatek/mt76/mt7603/core.c  |  3 +
 .../net/wireless/mediatek/mt76/mt7603/mac.c   |  3 +
 .../wireless/mediatek/mt76/mt7615/Makefile    |  4 +-
 .../net/wireless/mediatek/mt76/mt7615/mac.c   | 10 +++-
 .../mediatek/mt76/mt7615/mt7615_trace.h       | 56 +++++++++++++++++++
 .../net/wireless/mediatek/mt76/mt7615/pci.c   |  3 +
 .../net/wireless/mediatek/mt76/mt7615/trace.c | 12 ++++
 .../net/wireless/mediatek/mt76/mt76x02_mac.c  |  3 +-
 .../net/wireless/mediatek/mt76/mt76x02_mmio.c |  4 +-
 .../wireless/mediatek/mt76/mt76x02_trace.h    | 46 ---------------
 .../wireless/mediatek/mt76/mt76x2/Makefile    |  2 -
 drivers/net/wireless/mediatek/mt76/trace.c    |  3 +
 drivers/net/wireless/mediatek/mt76/trace.h    | 54 +++++++++++++++++-
 13 files changed, 148 insertions(+), 55 deletions(-)
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7615/mt7615_trace.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7615/trace.c

-- 
2.21.0

