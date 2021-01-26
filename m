Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5D0DC433E0
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Jan 2021 12:11:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E06A20637
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Jan 2021 12:11:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404982AbhAZMLP (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 26 Jan 2021 07:11:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:38906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404062AbhAZLOr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Jan 2021 06:14:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 27DAD23108;
        Tue, 26 Jan 2021 11:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611659647;
        bh=ZcIldbls1k+3Cum94TvuyMTcJRknOrkNe2eLWhGJ03k=;
        h=From:To:Cc:Subject:Date:From;
        b=QLBp/Ido6ZvX882ck39JcQE8B7XHDBl3UF78Zu4U2Mno9tpPalXOQKUruGAwDKcNE
         KZPoJ3qRcbU3/JhK4jGfDRq4o2VHLK40QweO3wTtuuJ2qzBcUW59TlPRrq4WVwQ9xY
         +0XWVW0qOQMjugWvphG2S5IpEsDKeVwOAhRu7C8g/6cW1t6NtbxNjp+u6z2zLQCqMc
         wXZ5s9Tms/zyDyD0IswPAuAhzwMwKW/Uqd5+eW3NOzj7XkQ5iDI1paJFHjq4WVZ1mU
         Hx+hbrguXU5ZLXKLlm2Ba+v4q10+MzXiXHP6EgRaV8W3mRdWZ/cMlfk869Zr+94eg9
         kiFgWaU1uWUBw==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, lorenzo.bianconi@redhat.com,
        sean.wang@mediatek.com
Subject: [PATCH v3 0/6] mt76: introduce mt76_connac common module
Date:   Tue, 26 Jan 2021 12:13:50 +0100
Message-Id: <cover.1611659413.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Introduce mt76_connac common module for code sharing between mt7615
and mt7921 drivers.

Changes since v2:
- fix typo in mt7615_mcu_wtbl_sta_add()

Changes since v1:
- rename mt76_vif struct of mt7615_vif in mt76

Lorenzo Bianconi (6):
  mt76: introduce mt76_vif data structure
  mt76: mt76_connac: create mcu library
  mt76: mt76_connac: move hw_scan and sched_scan routine in
    mt76_connac_mcu module
  mt76: mt76_connac: move WoW and suspend code in mt76_connac_mcu module
  mt76: mt76_connac: move pm data struct in mt76_connac.h
  mt76: mt76_connac: move pm utility routines in mt76_connac_lib module

 drivers/net/wireless/mediatek/mt76/Kconfig    |    4 +
 drivers/net/wireless/mediatek/mt76/Makefile   |    3 +
 drivers/net/wireless/mediatek/mt76/mt76.h     |    8 +
 .../net/wireless/mediatek/mt76/mt7615/Kconfig |    2 +-
 .../net/wireless/mediatek/mt76/mt7615/init.c  |   15 +-
 .../net/wireless/mediatek/mt76/mt7615/mac.c   |   91 +-
 .../net/wireless/mediatek/mt76/mt7615/main.c  |  159 +-
 .../net/wireless/mediatek/mt76/mt7615/mcu.c   | 1624 ++---------------
 .../net/wireless/mediatek/mt76/mt7615/mcu.h   |  682 +------
 .../wireless/mediatek/mt76/mt7615/mt7615.h    |   97 +-
 .../net/wireless/mediatek/mt76/mt7615/pci.c   |    9 +-
 .../wireless/mediatek/mt76/mt7615/pci_mac.c   |    2 +-
 .../net/wireless/mediatek/mt76/mt7615/sdio.c  |    5 +-
 .../net/wireless/mediatek/mt76/mt7615/usb.c   |    4 +-
 .../net/wireless/mediatek/mt76/mt76_connac.h  |   91 +
 .../wireless/mediatek/mt76/mt76_connac_mac.c  |  119 ++
 .../wireless/mediatek/mt76/mt76_connac_mcu.c  | 1490 +++++++++++++++
 .../wireless/mediatek/mt76/mt76_connac_mcu.h  |  954 ++++++++++
 18 files changed, 2930 insertions(+), 2429 deletions(-)
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76_connac.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h

-- 
2.29.2

