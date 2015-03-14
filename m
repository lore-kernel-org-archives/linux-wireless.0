Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:36609 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262AbbCNFyO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Mar 2015 01:54:14 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org
Subject: [PATCH v2 00/11] ath9k patches
Date: Sat, 14 Mar 2015 11:27:46 +0530
Message-Id: <1426312677-2064-1-git-send-email-sujith@msujith.org> (sfid-20150314_065420_170981_10A2BAB0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

AIC support, for -next.

v2 : Address warning reported by Kalle:
     ar9003_aic.c: In function 'ar9003_aic_cal_post_process':
     ar9003_aic.c:431:1: warning: the frame size of 1312 bytes is larger than 1024 bytes [-Wframe-larger-than=]

Sujith Manoharan (11):
  ath9k: Add initial structures for AIC
  ath9k: Register private AIC ops
  ath9k: Add register definitions for AIC
  ath9k: Handle MCI_STATE_AIC_CAL_SINGLE
  ath9k: Finish AIC calibration
  ath9k: Process the AIC calibration results
  ath9k: Disable AIC by default
  ath9k: Handle MCI_STATE_AIC_CAL_RESET
  ath9k: Handle MCI_STATE_AIC_START
  ath9k: Handle MCI_STATE_AIC_CAL
  ath9k: Start AIC calibration during MCI reset

 drivers/net/wireless/ath/ath9k/Makefile     |   3 +-
 drivers/net/wireless/ath/ath9k/ar9003_aic.c | 599 ++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/ar9003_aic.h |  61 +++
 drivers/net/wireless/ath/ath9k/ar9003_hw.c  |   1 +
 drivers/net/wireless/ath/ath9k/ar9003_mci.c |  20 +
 drivers/net/wireless/ath/ath9k/ar9003_phy.h |  25 --
 drivers/net/wireless/ath/ath9k/btcoex.h     |  12 +
 drivers/net/wireless/ath/ath9k/hw-ops.h     |   8 +
 drivers/net/wireless/ath/ath9k/hw.h         |   6 +
 drivers/net/wireless/ath/ath9k/reg_aic.h    | 168 ++++++++
 10 files changed, 877 insertions(+), 26 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath9k/ar9003_aic.c
 create mode 100644 drivers/net/wireless/ath/ath9k/ar9003_aic.h
 create mode 100644 drivers/net/wireless/ath/ath9k/reg_aic.h

-- 
2.3.1

