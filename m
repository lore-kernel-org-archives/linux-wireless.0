Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:35301 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754472Ab3IJItK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Sep 2013 04:49:10 -0400
Received: from epcpsbgr4.samsung.com
 (u144.gpu120.samsung.co.kr [203.254.230.144])
 by mailout4.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MSW00H6CJ55SIN0@mailout4.samsung.com> for
 linux-wireless@vger.kernel.org; Tue, 10 Sep 2013 17:49:08 +0900 (KST)
From: Jingoo Han <jg1.han@samsung.com>
To: "'John W. Linville'" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, 'Jingoo Han' <jg1.han@samsung.com>
Subject: [PATCH] wireless: use dev_get_platdata()
Date: Tue, 10 Sep 2013 17:49:08 +0900
Message-id: <005101ceae02$9cbb95f0$d632c1d0$%han@samsung.com> (sfid-20130910_104926_715185_0013B0D4)
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use the wrapper function for retrieving the platform data instead of
accessing dev->platform_data directly. This is a cosmetic change
to make the code simpler and enhance the readability.

---
 drivers/net/wireless/ath/ath5k/ahb.c                   |   15 ++++++---------
 drivers/net/wireless/ath/ath9k/ahb.c                   |    4 ++--
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c |    2 +-
 drivers/net/wireless/cw1200/cw1200_spi.c               |    4 ++--
 drivers/net/wireless/libertas/if_spi.c                 |    2 +-
 drivers/net/wireless/ti/wl1251/spi.c                   |    2 +-
 drivers/net/wireless/ti/wl12xx/main.c                  |    2 +-
 drivers/net/wireless/ti/wlcore/main.c                  |    2 +-
 drivers/net/wireless/ti/wlcore/spi.c                   |    2 +-
 9 files changed, 16 insertions(+), 19 deletions(-)

