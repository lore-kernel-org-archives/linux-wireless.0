Return-Path: <SRS0=HTPg=VH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16F82C73C6E
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Jul 2019 05:05:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EE25520861
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Jul 2019 05:05:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726125AbfGJFEf (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 10 Jul 2019 01:04:35 -0400
Received: from smtprelay0012.hostedemail.com ([216.40.44.12]:43575 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725791AbfGJFEf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Jul 2019 01:04:35 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay07.hostedemail.com (Postfix) with ESMTP id 2D69B181D3403;
        Wed, 10 Jul 2019 05:04:33 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: help91_a3a1c1ec484c
X-Filterd-Recvd-Size: 2833
Received: from joe-laptop.perches.com (cpe-23-242-196-136.socal.res.rr.com [23.242.196.136])
        (Authenticated sender: joe@perches.com)
        by omf06.hostedemail.com (Postfix) with ESMTPA;
        Wed, 10 Jul 2019 05:04:30 +0000 (UTC)
From:   Joe Perches <joe@perches.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Patrick Venture <venture@google.com>,
        Nancy Yuen <yuenn@google.com>,
        Benjamin Fair <benjaminfair@google.com>,
        Andrew Jeffery <andrew@aj.id.au>, openbmc@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-aspeed@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org, netdev@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-wireless@vger.kernel.org, linux-media@vger.kernel.org
Cc:     dri-devel@lists.freedesktop.org, linux-iio@vger.kernel.org,
        linux-mmc@vger.kernel.org, devel@driverdev.osuosl.org,
        alsa-devel@alsa-project.org
Subject: [PATCH 00/12] treewide: Fix GENMASK misuses
Date:   Tue,  9 Jul 2019 22:04:13 -0700
Message-Id: <cover.1562734889.git.joe@perches.com>
X-Mailer: git-send-email 2.15.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

These GENMASK uses are inverted argument order and the
actual masks produced are incorrect.  Fix them.

Add checkpatch tests to help avoid more misuses too.

Joe Perches (12):
  checkpatch: Add GENMASK tests
  clocksource/drivers/npcm: Fix misuse of GENMASK macro
  drm: aspeed_gfx: Fix misuse of GENMASK macro
  iio: adc: max9611: Fix misuse of GENMASK macro
  irqchip/gic-v3-its: Fix misuse of GENMASK macro
  mmc: meson-mx-sdio: Fix misuse of GENMASK macro
  net: ethernet: mediatek: Fix misuses of GENMASK macro
  net: stmmac: Fix misuses of GENMASK macro
  rtw88: Fix misuse of GENMASK macro
  phy: amlogic: G12A: Fix misuse of GENMASK macro
  staging: media: cedrus: Fix misuse of GENMASK macro
  ASoC: wcd9335: Fix misuse of GENMASK macro

 drivers/clocksource/timer-npcm7xx.c               |  2 +-
 drivers/gpu/drm/aspeed/aspeed_gfx.h               |  2 +-
 drivers/iio/adc/max9611.c                         |  2 +-
 drivers/irqchip/irq-gic-v3-its.c                  |  2 +-
 drivers/mmc/host/meson-mx-sdio.c                  |  2 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.h       |  2 +-
 drivers/net/ethernet/mediatek/mtk_sgmii.c         |  2 +-
 drivers/net/ethernet/stmicro/stmmac/descs.h       |  2 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c |  4 ++--
 drivers/net/wireless/realtek/rtw88/rtw8822b.c     |  2 +-
 drivers/phy/amlogic/phy-meson-g12a-usb2.c         |  2 +-
 drivers/staging/media/sunxi/cedrus/cedrus_regs.h  |  2 +-
 scripts/checkpatch.pl                             | 15 +++++++++++++++
 sound/soc/codecs/wcd-clsh-v2.c                    |  2 +-
 14 files changed, 29 insertions(+), 14 deletions(-)

-- 
2.15.0

