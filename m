Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:37598 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759099AbbA3Ncl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jan 2015 08:32:41 -0500
Received: from [117.207.72.194] (port=10794 helo=sujith-pixel.qualcomm.com)
	by server72.web-hosting.com with esmtpsa (UNKNOWN:AES128-SHA256:128)
	(Exim 4.82)
	(envelope-from <sujith@msujith.org>)
	id 1YHBge-004FiR-3h
	for linux-wireless@vger.kernel.org; Fri, 30 Jan 2015 08:32:40 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 00/17] ath9k patches
Date: Fri, 30 Jan 2015 19:05:20 +0530
Message-Id: <1422624937-4810-1-git-send-email-sujith@msujith.org> (sfid-20150130_143244_234138_34291866)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

ath9k patches for -next.

Sujith Manoharan (17):
  ath9k: Remove ATH9K_HW_WOW_DEVICE_CAPABLE
  ath9k: Return early for error conditions
  ath9k: Remove redundant device_can_wakeup() check
  ath9k: Check early for multi-vif/STA conditions
  ath9k: Check multi-channel context for WOW
  ath9k: Fix wow init/deinit
  ath9k: Check WOW triggers properly
  ath9k: Remove unused BMISS processing
  ath9k: Remove ath9k_hw_wow_event_to_string
  ath9k: Add a debugfs file for WOW
  ath9k: Simplify user pattern configuration
  ath9k: Add a HW structure for WOW
  ath9k: Register max WOW patterns
  ath9k: Move WOW registers to reg_wow.h
  ath9k: Remove incorrect register macros
  ath9k: Cleanup reg_wow.h
  ath9k: Fix max pattern check

 drivers/net/wireless/ath/ath.h              |   1 +
 drivers/net/wireless/ath/ath9k/ar9003_wow.c |  38 ++---
 drivers/net/wireless/ath/ath9k/ath9k.h      |  13 +-
 drivers/net/wireless/ath/ath9k/debug.c      |  68 +++++++++
 drivers/net/wireless/ath/ath9k/hw.c         |  10 +-
 drivers/net/wireless/ath/ath9k/hw.h         |  34 ++---
 drivers/net/wireless/ath/ath9k/init.c       |   1 +
 drivers/net/wireless/ath/ath9k/main.c       |   9 --
 drivers/net/wireless/ath/ath9k/pci.c        |   5 +-
 drivers/net/wireless/ath/ath9k/reg.h        | 120 ----------------
 drivers/net/wireless/ath/ath9k/reg_wow.h    |  93 ++++++++++++
 drivers/net/wireless/ath/ath9k/wow.c        | 212 ++++++++++++----------------
 12 files changed, 301 insertions(+), 303 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath9k/reg_wow.h

-- 
2.2.2

