Return-Path: <SRS0=N25P=6A=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B318C2BB55
	for <linux-wireless@archiver.kernel.org>; Thu, 16 Apr 2020 14:33:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7AC24221F7
	for <linux-wireless@archiver.kernel.org>; Thu, 16 Apr 2020 14:33:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1587047588;
	bh=FhD3Ty+RbHgAW6Fo2GvLifEfqRIh6qjW4sRsLYZRC2M=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=i+PxK8nlkxuyoSThQ6ZJ6PMu+k2JhulKI1Ib3EdfrDqPQBdHDtyDtXgkkatSVd/z5
	 ttj4DUsBoV2BhE5+na9pXQDfJi8DSBoHUsScofiFM56Ttn4c02fWCIPDF4eVpc56eZ
	 v1/WHmcKGTAUgqZRJ80jguYNYCKvf3qFvWCN+ZRs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394377AbgDPOdE (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 16 Apr 2020 10:33:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:39368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394372AbgDPOc7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 16 Apr 2020 10:32:59 -0400
Received: from lore-desk.redhat.com (unknown [151.48.151.50])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D872521927;
        Thu, 16 Apr 2020 14:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587047578;
        bh=FhD3Ty+RbHgAW6Fo2GvLifEfqRIh6qjW4sRsLYZRC2M=;
        h=From:To:Cc:Subject:Date:From;
        b=H16abqjI20/S3QLQZCizj/fLdGv8pjxQb4iHBwpEebURa9POO87k0PDla2KljtsGZ
         TFKqViJN1sI/nvKO8LjonjfR/Fd/SlnKdIX1hTmGsAW9C5SWfZpmuqditVlTQUHyii
         vQ3D/nr6a3nOlER2RnlJ+7E1ODAOksO7TBHliMXM=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, lorenzo.bianconi@redhat.com,
        sean.wang@mediatek.com, linux-mediatek@lists.infradead.org
Subject: [PATCH v3 0/2] introduce usb support to mt7615 driver
Date:   Thu, 16 Apr 2020 16:32:49 +0200
Message-Id: <cover.1587047373.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.25.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Introduce support for mt7663u 802.11ac 2x2:2 chipset to mt7615 driver.
Create mt7615-common module as container for mmio and usb shared code

Changes since v2:
- rebased ontop of mt76 master branch
- fix license

Changes since v1:
- rebased ontop of mt76 master branch

Lorenzo Bianconi (2):
  mt76: mt7615: move core shared code in mt7615-common module
  mt76: mt7615: introduce mt7663u support

 drivers/net/wireless/mediatek/mt76/Makefile   |   2 +-
 drivers/net/wireless/mediatek/mt76/mt76.h     |   1 +
 .../net/wireless/mediatek/mt76/mt7615/Kconfig |  18 +-
 .../wireless/mediatek/mt76/mt7615/Makefile    |  10 +-
 .../wireless/mediatek/mt76/mt7615/debugfs.c   |   1 +
 .../net/wireless/mediatek/mt76/mt7615/dma.c   |  39 --
 .../wireless/mediatek/mt76/mt7615/eeprom.c    |   1 +
 .../net/wireless/mediatek/mt76/mt7615/init.c  | 194 +--------
 .../net/wireless/mediatek/mt76/mt7615/mac.c   | 249 ++++-------
 .../net/wireless/mediatek/mt76/mt7615/mac.h   |   5 +-
 .../net/wireless/mediatek/mt76/mt7615/main.c  |  66 +--
 .../net/wireless/mediatek/mt76/mt7615/mcu.c   |  18 +-
 .../net/wireless/mediatek/mt76/mt7615/mcu.h   |   5 +
 .../net/wireless/mediatek/mt76/mt7615/mmio.c  |  30 ++
 .../wireless/mediatek/mt76/mt7615/mt7615.h    |  22 +-
 .../wireless/mediatek/mt76/mt7615/pci_init.c  | 189 +++++++++
 .../wireless/mediatek/mt76/mt7615/pci_mac.c   | 184 ++++++++
 .../net/wireless/mediatek/mt76/mt7615/regs.h  |  26 ++
 .../net/wireless/mediatek/mt76/mt7615/usb.c   | 396 ++++++++++++++++++
 .../wireless/mediatek/mt76/mt7615/usb_init.c  | 144 +++++++
 .../wireless/mediatek/mt76/mt7615/usb_mcu.c   |  93 ++++
 21 files changed, 1259 insertions(+), 434 deletions(-)
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7615/pci_init.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7615/pci_mac.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7615/usb.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7615/usb_init.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7615/usb_mcu.c

-- 
2.25.2

