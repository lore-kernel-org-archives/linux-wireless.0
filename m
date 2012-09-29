Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:58936 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757358Ab2I2S37 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Sep 2012 14:29:59 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, zajec5@gmail.com,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 0/2] bcma: initialize sprom earlier
Date: Sat, 29 Sep 2012 20:29:48 +0200
Message-Id: <1348943390-22411-1-git-send-email-hauke@hauke-m.de> (sfid-20120929_203053_256522_16CFF5A0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The chip common and the PCIe code are accessing the sprom struct which 
is not filled when these cores are initialized. Fix this by adding an 
early initialize and fill the sprom struct before accessing it in other 
code.

Hauke Mehrtens (2):
  bcma: just do the necessary things in early register on SoCs
  bcma: init sprom struct earlier

 drivers/bcma/driver_chipcommon.c            |   23 ++++++++++++++++-----
 drivers/bcma/driver_chipcommon_pmu.c        |    5 ++++-
 drivers/bcma/driver_mips.c                  |   26 +++++++++++++++++-------
 drivers/bcma/main.c                         |   29 +++++++++++++++++----------
 include/linux/bcma/bcma_driver_chipcommon.h |    3 +++
 include/linux/bcma/bcma_driver_mips.h       |    3 +++
 6 files changed, 65 insertions(+), 24 deletions(-)

-- 
1.7.9.5

