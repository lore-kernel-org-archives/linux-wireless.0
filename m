Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:55985 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932085AbaKPAjk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Nov 2014 19:39:40 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH v2 00/11] ath9k patches
Date: Sun, 16 Nov 2014 06:10:59 +0530
Message-Id: <1416098470-14122-1-git-send-email-sujith@msujith.org> (sfid-20141116_013946_393565_297D5389)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Fixes for -next. Some of the patches have been
posted earlier, this series addresses Felix's review
comments.

Sujith

Miaoqing Pan (1):
  ath9k: Use new QCA953x initvals

Sujith Manoharan (10):
  ath9k: Update QCA953x initvals
  ath9k: Fix LED configuration
  ath9k: Enable TSF2 for generic HW timers
  ath9k: Store the chip chainmask in HW capabilities
  ath9k: Fix thermometer programming
  ath9k: Clear offchannel state properly
  ath9k: Cancel pending offchannel operations
  ath9k: Handle failure to send NoA
  ath9k: Adjust tbtt delta properly
  ath9k: Move roc completion to the offchannel timer

 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c   |   9 +-
 drivers/net/wireless/ath/ath9k/ar9003_hw.c       |  51 ++-
 drivers/net/wireless/ath/ath9k/ar953x_initvals.h | 498 +++++++++++++++++++++--
 drivers/net/wireless/ath/ath9k/ath9k.h           |   2 +
 drivers/net/wireless/ath/ath9k/channel.c         |  17 +-
 drivers/net/wireless/ath/ath9k/gpio.c            |   9 +-
 drivers/net/wireless/ath/ath9k/hw.c              |  43 +-
 drivers/net/wireless/ath/ath9k/hw.h              |   4 +
 drivers/net/wireless/ath/ath9k/init.c            |   3 +
 drivers/net/wireless/ath/ath9k/main.c            |  58 ++-
 drivers/net/wireless/ath/ath9k/pci.c             |   4 +-
 drivers/net/wireless/ath/ath9k/reg.h             |   3 +
 12 files changed, 620 insertions(+), 81 deletions(-)

-- 
2.1.3

