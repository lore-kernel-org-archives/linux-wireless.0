Return-Path: <SRS0=eg9r=U4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79150C4321A
	for <linux-wireless@archiver.kernel.org>; Sat, 29 Jun 2019 10:36:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3A651214DA
	for <linux-wireless@archiver.kernel.org>; Sat, 29 Jun 2019 10:36:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1561804580;
	bh=n9jQRPlsPyOigoSZHV/zewMVVKc8HOl8pEwM2cBdyMg=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=ODJiQFnl7Pd+ncmJLpHFPGAXb7f+BrEsWZvvUxD7gWY1eMuzIJRRfmlKVM31Ap13V
	 GaRlEF8Eh1hMLox2KjxCFRx7Xx0ceH7FgHgS+XPI7muoED+O96pKng7a4YJaWKC1lS
	 IZsYxq3ZBYb8h5VuxztZjExu+gBYd+eIvtyJe7Wg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726942AbfF2KgT (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 29 Jun 2019 06:36:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:42794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726839AbfF2KgT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 29 Jun 2019 06:36:19 -0400
Received: from lore-desk-wlan.lan (unknown [151.66.61.123])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 52CE82086D;
        Sat, 29 Jun 2019 10:36:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561804578;
        bh=n9jQRPlsPyOigoSZHV/zewMVVKc8HOl8pEwM2cBdyMg=;
        h=From:To:Cc:Subject:Date:From;
        b=rdcRc9sT+aZ87c8rZOd0FJPuk7wx67pZTEYTFMNs0Yn68O4ptxpSoOOpqYZU7obN5
         IQuE+jgz8bk7gwyoR7plW2OMsxi1oZaojZdW39052fWzsxKWPu/rvK638ns0xwWIeh
         a2QY6Z5xRlVSJSY1tj/X5+CfHgHNPerNe1gVnuZo=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     lorenzo.bianconi@redhat.com, linux-wireless@vger.kernel.org,
        ryder.lee@mediatek.com, royluo@google.com, yf.luo@mediatek.com
Subject: [PATCH 0/6] add hw dfs pattern detector support to mt7615 driver
Date:   Sat, 29 Jun 2019 12:36:05 +0200
Message-Id: <cover.1561804422.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Introduce radar pattern detection support to mt7615 driver.
Add Channel Switch Announcement support updating beacon template with
CSA IE received from mac80211.
Please note I have tested this series just through the radar pattern test
knob added to debugfs and not through I real radar signal generator.

Lorenzo Bianconi (6):
  mt76: mt7615: introduce mt7615_regd_notifier
  mt76: mt7615: add hw dfs pattern detector support
  mt76: mt7615: do not perform txcalibration before cac is complited
  mt76: mt7615: unlock dfs bands
  mt76: mt7615: add csa support
  mt76: mt7615: add radar pattern test knob to debugfs

 .../wireless/mediatek/mt76/mt7615/Makefile    |   3 +-
 .../wireless/mediatek/mt76/mt7615/debugfs.c   |  38 +++++
 .../net/wireless/mediatek/mt76/mt7615/dma.c   |   2 +-
 .../net/wireless/mediatek/mt76/mt7615/init.c  |  44 ++++--
 .../net/wireless/mediatek/mt76/mt7615/mac.c   |  88 +++++++++++
 .../net/wireless/mediatek/mt76/mt7615/main.c  |  19 +++
 .../net/wireless/mediatek/mt76/mt7615/mcu.c   | 147 ++++++++++++++++--
 .../net/wireless/mediatek/mt76/mt7615/mcu.h   |  24 +++
 .../wireless/mediatek/mt76/mt7615/mt7615.h    |  55 +++++++
 9 files changed, 392 insertions(+), 28 deletions(-)
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7615/debugfs.c

-- 
2.21.0

