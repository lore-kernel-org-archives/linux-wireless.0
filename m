Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:36751 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216Ab3LRE20 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Dec 2013 23:28:26 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH v2 00/10] ath9k patches
Date: Wed, 18 Dec 2013 09:53:17 +0530
Message-Id: <1387340607-20045-1-git-send-email-sujith@msujith.org> (sfid-20131218_052850_937466_FD61CF03)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Various HW fixes and pending patches, rebased over current
HEAD + Felix's patches.

There's one stable fix which was posted earlier:
https://patchwork.kernel.org/patch/3351331/

Sujith

Sujith Manoharan (10):
  ath9k: Cleanup spectral scan code
  ath9k: Cleanup ath9k.h
  ath9k: Remove unneeded ref. count initialization
  ath9k: Initialize "switchcomspdt" eeprom field explicitly
  ath9k: Update BaseExtension_1 eeprom structure
  ath9k: Fix regulatory compliance
  ath9k: Remove ath9k_hw_gettsf32()
  ath9k: Add a delay between RTC reset/clear for AR9003
  ath9k: Fix RTC reset delay
  ath9k: Use a subroutine for the AR9330 reset WAR

 drivers/net/wireless/ath/ath9k/Makefile        |   4 +-
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |  52 ++-
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.h |  14 +-
 drivers/net/wireless/ath/ath9k/ar9003_mci.c    |   2 +-
 drivers/net/wireless/ath/ath9k/ar9003_phy.h    |   4 +-
 drivers/net/wireless/ath/ath9k/ath9k.h         | 358 ++++------------
 drivers/net/wireless/ath/ath9k/debug.c         | 311 +-------------
 drivers/net/wireless/ath/ath9k/debug.h         |   2 -
 drivers/net/wireless/ath/ath9k/hw.c            |  90 ++--
 drivers/net/wireless/ath/ath9k/hw.h            |   1 -
 drivers/net/wireless/ath/ath9k/init.c          |   4 +-
 drivers/net/wireless/ath/ath9k/recv.c          | 181 ---------
 drivers/net/wireless/ath/ath9k/spectral.c      | 543 +++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/spectral.h      | 212 ++++++++++
 14 files changed, 948 insertions(+), 830 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath9k/spectral.c
 create mode 100644 drivers/net/wireless/ath/ath9k/spectral.h

-- 
1.8.5.1

