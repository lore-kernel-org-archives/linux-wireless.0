Return-Path: <SRS0=I2fZ=XI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11C87C4CEC5
	for <linux-wireless@archiver.kernel.org>; Fri, 13 Sep 2019 07:06:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D521B2089F
	for <linux-wireless@archiver.kernel.org>; Fri, 13 Sep 2019 07:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1568358361;
	bh=sxAxmPtRHcJox6dCnGFUlgrOAVuLKEVEkwaza5AiIqo=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=i1HUTkOBU/1Ba9FblOtKziS53HhqFnzyLKuDMV9l2/4/f0nekzUb6rgfyIooNlTU1
	 iODOdqIaz7m3IauU7+SJsOZpv5CRKU+r2t7cMdwhJitrgvg5XUnLODZSKQXUXP9/c/
	 rHE5W1KPg3wIjhhzTkEGgcyVPhoxtdCQeAF+3lhE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727261AbfIMHGB (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 13 Sep 2019 03:06:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:49176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725446AbfIMHGB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Sep 2019 03:06:01 -0400
Received: from localhost.localdomain (unknown [151.66.2.116])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E1B720717;
        Fri, 13 Sep 2019 07:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568358360;
        bh=sxAxmPtRHcJox6dCnGFUlgrOAVuLKEVEkwaza5AiIqo=;
        h=From:To:Cc:Subject:Date:From;
        b=q5p5xAoeq7fJFjY5JsEaT+juVnbu5ap/McGMQeghAZalf6tCGJ0b1/ZAsiNQ6pwAC
         XWCA41/t8fc/yfJIXFX4E+36qVYLQCqGrn7Ax1d3X4xyQmvAm9UeTm7iPNqjFXeE0v
         eBvHfv03KVs6IcaZmk42gN7vt27sr3ku24SMhgiU=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     lorenzo.bianconi@redhat.com, linux-wireless@vger.kernel.org,
        ryder.lee@mediatek.com
Subject: [PATCH 0/5] improve debugfs info for mt7615/mt7603 drivers
Date:   Fri, 13 Sep 2019 09:05:49 +0200
Message-Id: <cover.1568358061.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Improve hw queue debugfs info for mt7615 driver
Add 802.11 aggr info for mt7615/mt7603 drivers

This series is based on 'mt76x02: tidy up mib counters'
https://patchwork.kernel.org/cover/11142613/

Lorenzo Bianconi (5):
  mt76: move queue debugfs entry to driver specific code
  mt76: mt7615: add queue entry in debugfs
  mt76: move aggr_stats array in mt76_dev
  mt76: mt7615: collect aggregation stats
  mt76: mt7603: collect aggregation stats

 drivers/net/wireless/mediatek/mt76/debugfs.c  |   5 +-
 drivers/net/wireless/mediatek/mt76/mt76.h     |   3 +
 .../wireless/mediatek/mt76/mt7603/debugfs.c   |  38 +++++++
 .../net/wireless/mediatek/mt76/mt7603/mac.c   |  18 ++++
 .../net/wireless/mediatek/mt76/mt7603/main.c  |   1 +
 .../wireless/mediatek/mt76/mt7603/mt7603.h    |   1 +
 .../net/wireless/mediatek/mt76/mt7603/regs.h  |   5 +
 .../wireless/mediatek/mt76/mt7615/debugfs.c   | 100 ++++++++++++++++++
 .../net/wireless/mediatek/mt76/mt7615/mac.c   |  18 ++++
 .../net/wireless/mediatek/mt76/mt7615/main.c  |   2 +
 .../wireless/mediatek/mt76/mt7615/mt7615.h    |   1 +
 .../net/wireless/mediatek/mt76/mt7615/regs.h  |  17 +++
 drivers/net/wireless/mediatek/mt76/mt76x02.h  |   2 -
 .../wireless/mediatek/mt76/mt76x02_debugfs.c  |   5 +-
 .../net/wireless/mediatek/mt76/mt76x02_mac.c  |   6 +-
 15 files changed, 213 insertions(+), 9 deletions(-)

-- 
2.21.0

