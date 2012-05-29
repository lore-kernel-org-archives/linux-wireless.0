Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:43893 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755783Ab2E2Wjz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 May 2012 18:39:55 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com
Cc: lf_driver_backport@lists.linux-foundation.org,
	linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 0/8] compat-wireless: misc patches to make it compile again
Date: Wed, 30 May 2012 00:39:34 +0200
Message-Id: <1338331182-29589-1-git-send-email-hauke@hauke-m.de> (sfid-20120530_004004_026156_EBF27FCB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series in combination with the series for compat makes 
compat-wireless compile again for me on all supported kernel versions.

Hauke Mehrtens (8):
  compat-wireless: make patches apply again
  compat-wireless: add usb driver lpm
  compat-wireless: deactivate wl1251 for kernel < 2.6.37
  compat-wireless: add linux/compat.h header
  compat-wireless: add asm/unaligned.h include to ath6kl
  compat-wireless: add bluetooth to pr_fmt patch
  compat-wireless: add bluetooth to sdio suspend remove patch
  compat-wireless: add include/net/bluetooth/{hci_mon.h,sco.h}

 config.mk                              |    6 +-
 patches/05-usb.patch                   |    4 +-
 patches/06-header-changes.patch        |   40 +++++
 patches/08-rename-config-options.patch |    8 +-
 patches/16-bluetooth.patch             |   72 +++++----
 patches/24-pcmcia.patch                |   28 ++--
 patches/29-sdio_no_suspend.patch       |   28 ++++
 patches/46-use_other_workqueue.patch   |    4 +-
 patches/53-pr_fmt.patch                |   14 ++
 patches/62-usb_driver_lpm.patch        |  276 ++++++++++++++++++++++++++++++++
 scripts/admin-update.sh                |    2 +-
 11 files changed, 424 insertions(+), 58 deletions(-)
 create mode 100644 patches/62-usb_driver_lpm.patch

-- 
1.7.9.5

