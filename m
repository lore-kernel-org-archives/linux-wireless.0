Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:52867 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751303Ab2K2W1f (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Nov 2012 17:27:35 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, mcgrof@qca.qualcomm.com,
	ath9k-devel@lists.ath9k.org, Larry.Finger@lwfinger.net,
	chunkeey@googlemail.com, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 0/3] wireless: use SIMPLE_DEV_PM_OPS
Date: Thu, 29 Nov 2012 23:27:14 +0100
Message-Id: <1354228037-1700-1-git-send-email-hauke@hauke-m.de> (sfid-20121129_232738_714276_41B2D363)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead of filling struct dev_pm_ops manually use SIMPLE_DEV_PM_OPS.
This will also make backport in compat-drivers more easily.

Hauke Mehrtens (3):
  ath9k: use SIMPLE_DEV_PM_OPS
  p54pci: use SIMPLE_DEV_PM_OPS
  rtlwifi: use SIMPLE_DEV_PM_OPS

 drivers/net/wireless/ath/ath9k/pci.c        |   15 ++++-----------
 drivers/net/wireless/p54/p54pci.c           |   13 +++----------
 drivers/net/wireless/rtlwifi/pci.c          |    2 ++
 drivers/net/wireless/rtlwifi/pci.h          |    2 ++
 drivers/net/wireless/rtlwifi/rtl8192ce/sw.c |    9 +--------
 drivers/net/wireless/rtlwifi/rtl8192de/sw.c |    9 +--------
 drivers/net/wireless/rtlwifi/rtl8192se/sw.c |    9 +--------
 drivers/net/wireless/rtlwifi/rtl8723ae/sw.c |    9 +--------
 8 files changed, 15 insertions(+), 53 deletions(-)

-- 
1.7.10.4

