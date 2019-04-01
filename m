Return-Path: <SRS0=CFp0=SD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7A53C43381
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Apr 2019 07:20:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C0EE620896
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Apr 2019 07:20:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731769AbfDAHUu (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 1 Apr 2019 03:20:50 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:51750 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725867AbfDAHUu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 1 Apr 2019 03:20:50 -0400
X-UUID: 66fbbed3ba35464bb9d5ea9c1f3cca8b-20190401
X-UUID: 66fbbed3ba35464bb9d5ea9c1f3cca8b-20190401
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw02.mediatek.com
        (envelope-from <ryder.lee@mediatek.com>)
        (mhqrelay.mediatek.com ESMTP with TLS)
        with ESMTP id 2121804820; Mon, 01 Apr 2019 15:20:33 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs03n2.mediatek.inc (172.21.101.182) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Mon, 1 Apr 2019 15:20:31 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Mon, 1 Apr 2019 15:20:31 +0800
Message-ID: <1554103231.10304.2.camel@mtkswgap22>
Subject: Re: [PATCH v2 0/4] Add support for MediaTek MT7615 wireless chipsets
From:   Ryder Lee <ryder.lee@mediatek.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>
CC:     Roy Luo <royluo@google.com>, Sean Wang <sean.wang@mediatek.com>,
        "Nelson Chang" <nelson.chang@mediatek.com>,
        YF Luo <yf.luo@mediatek.com>, Kai Lin <kai.lin@mediatek.com>,
        Rorscha Yang <rorscha.yang@mediatek.com>,
        Kyle Lee <kyle.lee@mediatek.com>,
        Miller Shen <miller.shen@mediatek.com>,
        "Haipin Liang" <haipin.liang@mediatek.com>,
        KL Huang <kl.huang@mediatek.com>,
        "YH chen" <yh.chen@mediatek.com>, <linux-wireless@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Date:   Mon, 1 Apr 2019 15:20:31 +0800
In-Reply-To: <cover.1554100584.git.ryder.lee@mediatek.com>
References: <cover.1554100584.git.ryder.lee@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
X-TM-SNTS-SMTP: 008856975790149C2B70DC33F4597E803D571252FBCA9AD94225A4F487C4CFA52000:8
X-MTK:  N
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, 2019-04-01 at 14:56 +0800, Ryder Lee wrote:
> This adds support for MediaTek MT7615E 4x4 802.11ac PCIe-based chipsets.
> 
> In the legacy tx arch, we move and store the whole skb content to the
> on-device memory when we send packets via high speed interface. (e.g. PCIe)
> 
> However, MT7615 and the following generation use a new tx arch called
> “cut-through”, which only passes the physical address to the hardware,
> and the packet engine will fetch the packets before transmission.
> 
> It saves on-chip memory for high throughput devices, and the token mechanism
> is used to manage the release of skb under this arch.
> 
> And there might be other (existing or future) chips that use the same driver
> (e.g. mt7622/mt7663...), this is a starting point to unify MTK wireless chipsets.
> 
> Detailed hardware information for this chip could be found on 
> https://wikidevi.com/wiki/MediaTek_MT7615
> 
> Ryder Lee (4):
>   mt76: add mac80211 driver for MT7615 PCIe-based chipsets
>   mt76: add unlikely() for dma_mapping_error() check
>   mt76: use macro for sn and seq_ctrl conversion
>   MAINTAINERS : update entry for mt76 wireless driver
> 
>  MAINTAINERS                                        |    2 +
>  drivers/net/wireless/mediatek/mt76/Kconfig         |    1 +
>  drivers/net/wireless/mediatek/mt76/Makefile        |    1 +
>  drivers/net/wireless/mediatek/mt76/agg-rx.c        |    2 +-
>  drivers/net/wireless/mediatek/mt76/dma.c           |    8 +-
>  drivers/net/wireless/mediatek/mt76/mt7603/mac.c    |    2 +-
>  drivers/net/wireless/mediatek/mt76/mt7603/main.c   |    2 +-
>  drivers/net/wireless/mediatek/mt76/mt7615/Kconfig  |    7 +
>  drivers/net/wireless/mediatek/mt76/mt7615/Makefile |    5 +
>  drivers/net/wireless/mediatek/mt76/mt7615/dma.c    |  205 +++
>  drivers/net/wireless/mediatek/mt76/mt7615/eeprom.c |   98 ++
>  drivers/net/wireless/mediatek/mt76/mt7615/eeprom.h |   18 +
>  drivers/net/wireless/mediatek/mt76/mt7615/init.c   |  229 +++
>  drivers/net/wireless/mediatek/mt76/mt7615/mac.c    |  774 +++++++++
>  drivers/net/wireless/mediatek/mt76/mt7615/mac.h    |  300 ++++
>  drivers/net/wireless/mediatek/mt76/mt7615/main.c   |  499 ++++++
>  drivers/net/wireless/mediatek/mt76/mt7615/mcu.c    | 1656 ++++++++++++++++++++
>  drivers/net/wireless/mediatek/mt76/mt7615/mcu.h    |  520 ++++++
>  drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h |  195 +++
>  drivers/net/wireless/mediatek/mt76/mt7615/pci.c    |  150 ++
>  drivers/net/wireless/mediatek/mt76/mt7615/regs.h   |  203 +++
>  drivers/net/wireless/mediatek/mt76/mt76x02_util.c  |    2 +-
>  22 files changed, 4871 insertions(+), 8 deletions(-)
>  create mode 100644 drivers/net/wireless/mediatek/mt76/mt7615/Kconfig
>  create mode 100644 drivers/net/wireless/mediatek/mt76/mt7615/Makefile
>  create mode 100644 drivers/net/wireless/mediatek/mt76/mt7615/dma.c
>  create mode 100644 drivers/net/wireless/mediatek/mt76/mt7615/eeprom.c
>  create mode 100644 drivers/net/wireless/mediatek/mt76/mt7615/eeprom.h
>  create mode 100644 drivers/net/wireless/mediatek/mt76/mt7615/init.c
>  create mode 100644 drivers/net/wireless/mediatek/mt76/mt7615/mac.c
>  create mode 100644 drivers/net/wireless/mediatek/mt76/mt7615/mac.h
>  create mode 100644 drivers/net/wireless/mediatek/mt76/mt7615/main.c
>  create mode 100644 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
>  create mode 100644 drivers/net/wireless/mediatek/mt76/mt7615/mcu.h
>  create mode 100644 drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h
>  create mode 100644 drivers/net/wireless/mediatek/mt76/mt7615/pci.c
>  create mode 100644 drivers/net/wireless/mediatek/mt76/mt7615/regs.h
> 

My bad. I fixed the compilation issue in V3.

Sorry for the inconvenience.
Ryder

