Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:48389 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755278Ab3LQSLt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Dec 2013 13:11:49 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 0/4] ath9k patches
Date: Tue, 17 Dec 2013 23:36:44 +0530
Message-Id: <1387303608-31356-1-git-send-email-sujith@msujith.org> (sfid-20131217_191152_114389_3A5C2D1C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

This series has a few RTC fixes. There are still two missing pieces:

* When a cold reset is performed, AR9100 requires the AHB/WMAC interface
  to be reset.
* AR955x requires an SoC RTC reset.

Both have to be done via the external_reset() platform interface.

Sujith Manoharan (4):
  ath9k: Remove ath9k_hw_gettsf32()
  ath9k: Add a delay between RTC reset/clear for AR9003
  ath9k: Fix RTC reset delay
  ath9k: Fix AR9330 external reset

 drivers/net/wireless/ath/ath9k/ar9003_mci.c |  2 +-
 drivers/net/wireless/ath/ath9k/hw.c         | 86 ++++++++++++++---------------
 drivers/net/wireless/ath/ath9k/hw.h         |  2 +-
 drivers/net/wireless/ath/ath9k/init.c       |  3 +-
 4 files changed, 45 insertions(+), 48 deletions(-)

-- 
1.8.5.1

