Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:11352 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756624AbaDWIHI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Apr 2014 04:07:08 -0400
From: Seungwon Jeon <tgih.jun@samsung.com>
To: linux-mmc@vger.kernel.org, linux-wireless@vger.kernel.org
Cc: 'Chris Ball' <chris@printf.net>,
	'Ulf Hansson' <ulf.hansson@linaro.org>,
	'Jaehoon Chung' <jh80.chung@samsung.com>,
	'Jackey Shen' <jackey.shen@amd.com>,
	'Alim Akhtar' <alim.akhtar@samsung.com>,
	'Fariya Fatima' <fariyaf@gmail.com>,
	"'John W. Linville'" <linville@tuxdriver.com>
References: <1383653403-10049-1-git-send-email-ulf.hansson@linaro.org>
 <006701cf2a58$c628e050$527aa0f0$%jun@samsung.com>
In-reply-to: 
Subject: [PATCH 0/6] update selection of bus speed mode for eMMC
Date: Wed, 23 Apr 2014 17:07:06 +0900
Message-id: <000901cf5ecb$04a26f80$0de74e80$%jun@samsung.com> (sfid-20140423_100736_558395_0DEA9810)
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series contains the change for selection of bus speed mode.
Previous implementation is complicated and some sequence is duplicated.
And specially, HS400 mode eMMC5.0 is introduced this time.
This patch-set has been tested in Exynos SoC.

Note: 
	As RS9113 wireless driver has been introduced newly in Linux-3.15-rc1, we meet some dependency with this patch-set
         which has been in the works all the while.
	Thus, related modification is applied through " mmc: drop the speed mode of card's state" 
---
Changes in v6:
	(6/6) Included "mmc: core: add DT bindings for eMMC HS400 1.8/1.2V" into this patch-set
	
Changes in v5:
	(5/5) Added callback operation for HS400 target operation frequency
	       instead of specific timing identifier.
	(2/5) Removed using union declaration.

Changes in v4:
	(5/5)Reverting to HS mode is included in mmc_select_hs400() using __mmc_switch().

Changes in v3:
 	Removed the function to check DDR type(mmc_snoop_ddr).
 	Rebased with the latest branch.

Seungwon Jeon (6):
  mmc: drop the speed mode of card's state
  mmc: identify available device type to select
  mmc: step power class after final selection of bus mode
  mmc: rework selection of bus speed mode
  mmc: add support for HS400 mode of eMMC5.0
  mmc: add DT bindings for eMMC HS400 1.8/1.2V

 Documentation/devicetree/bindings/mmc/mmc.txt |    2 +
 drivers/mmc/core/bus.c                        |    9 +-
 drivers/mmc/core/core.c                       |    3 +-
 drivers/mmc/core/debugfs.c                    |    5 +-
 drivers/mmc/core/host.c                       |    4 +
 drivers/mmc/core/mmc.c                        |  666 +++++++++++++++----------
 drivers/mmc/core/sd.c                         |   16 +-
 drivers/mmc/core/sd.h                         |    1 -
 drivers/mmc/core/sdio.c                       |    8 +-
 drivers/net/wireless/rsi/rsi_91x_sdio.c       |    4 +-
 include/linux/mmc/card.h                      |   27 +-
 include/linux/mmc/host.h                      |   43 ++-
 include/linux/mmc/mmc.h                       |   23 +-
 13 files changed, 487 insertions(+), 324 deletions(-)

Thanks,
sw-j

