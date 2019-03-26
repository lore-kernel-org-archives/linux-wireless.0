Return-Path: <SRS0=Lwp6=R5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE367C43381
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Mar 2019 14:28:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8807220857
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Mar 2019 14:28:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731770AbfCZO2S (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 26 Mar 2019 10:28:18 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:62979 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726111AbfCZO2S (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Mar 2019 10:28:18 -0400
X-UUID: 83f15606239e4179a4e38f24af20ba58-20190326
X-UUID: 83f15606239e4179a4e38f24af20ba58-20190326
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw02.mediatek.com
        (envelope-from <ryder.lee@mediatek.com>)
        (mhqrelay.mediatek.com ESMTP with TLS)
        with ESMTP id 589441082; Tue, 26 Mar 2019 22:28:13 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs03n1.mediatek.inc (172.21.101.181) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Tue, 26 Mar 2019 22:28:11 +0800
Received: from mtkslt306.mediatek.inc (10.21.14.136) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Tue, 26 Mar 2019 22:28:11 +0800
From:   Ryder Lee <ryder.lee@mediatek.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>
CC:     Roy Luo <royluo@google.com>, Sean Wang <sean.wang@mediatek.com>,
        Nelson Chang <nelson.chang@mediatek.com>,
        YF Luo <yf.luo@mediatek.com>, Kai Lin <kai.lin@mediatek.com>,
        Rorscha Yang <rorscha.yang@mediatek.com>,
        Kyle Lee <kyle.lee@mediatek.com>,
        Miller Shen <miller.shen@mediatek.com>,
        Haipin Liang <haipin.liang@mediatek.com>,
        <linux-wireless@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Ryder Lee <ryder.lee@mediatek.com>
Subject: [PATCH 0/4] Add support for MediaTek MT7615 wireless chipsets
Date:   Tue, 26 Mar 2019 22:28:06 +0800
Message-ID: <cover.1553607739.git.ryder.lee@mediatek.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset="y"
Content-Transfer-Encoding: 8bit
X-MTK:  N
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This adds support for MediaTek MT7615E 4x4 802.11ac PCIe-based chipsets.

In the legacy tx arch, we move and store the whole skb content to the
on-device memory when we send packets via high speed interface. (i.e. PCIe)

However, MT7615 and the following generation use a new tx arch called
“cut-through”, which only passes the physical address to the hardware,
and the packet engine will fetch the packets before transmission.

It saves on-chip memory for high throughput devices, and the token mechanism
is used to manage the release of skb under this arch.

Detailed hardware information for this chip could be found on 
https://wikidevi.com/wiki/MediaTek_MT7615

Ryder Lee (4):
  mt76: add mac80211 driver for MT7615 PCIe-based chipsets
  mt76: add unlikely() for dma_mapping_error() check
  mt76: use macro for sn and seq_ctrl conversion
  MAINTAINERS : update entry for mt76 wireless driver

 MAINTAINERS                                        |    2 +
 drivers/net/wireless/mediatek/mt76/Kconfig         |    1 +
 drivers/net/wireless/mediatek/mt76/Makefile        |    1 +
 drivers/net/wireless/mediatek/mt76/agg-rx.c        |    2 +-
 drivers/net/wireless/mediatek/mt76/dma.c           |    8 +-
 drivers/net/wireless/mediatek/mt76/mt7603/mac.c    |    2 +-
 drivers/net/wireless/mediatek/mt76/mt7603/main.c   |    2 +-
 drivers/net/wireless/mediatek/mt76/mt7615/Kconfig  |    7 +
 drivers/net/wireless/mediatek/mt76/mt7615/Makefile |    5 +
 drivers/net/wireless/mediatek/mt76/mt7615/dma.c    |  204 +++
 drivers/net/wireless/mediatek/mt76/mt7615/eeprom.c |   97 ++
 drivers/net/wireless/mediatek/mt76/mt7615/eeprom.h |   18 +
 drivers/net/wireless/mediatek/mt76/mt7615/init.c   |  220 +++
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c    |  760 +++++++++
 drivers/net/wireless/mediatek/mt76/mt7615/mac.h    |  300 ++++
 drivers/net/wireless/mediatek/mt76/mt7615/main.c   |  498 ++++++
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c    | 1656 ++++++++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.h    |  520 ++++++
 drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h |  195 +++
 drivers/net/wireless/mediatek/mt76/mt7615/pci.c    |  149 ++
 drivers/net/wireless/mediatek/mt76/mt7615/regs.h   |  196 +++
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c  |    2 +-
 22 files changed, 4837 insertions(+), 8 deletions(-)
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7615/Kconfig
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7615/Makefile
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7615/dma.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7615/eeprom.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7615/eeprom.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7615/init.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7615/mac.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7615/mac.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7615/main.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7615/mcu.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7615/pci.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7615/regs.h

-- 
1.9.1

