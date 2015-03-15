Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:6643 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752481AbbCOPGq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Mar 2015 11:06:46 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH 0/6] ath10k: thermal mitigation fixes
Date: Sun, 15 Mar 2015 20:36:19 +0530
Message-ID: <1426431985-16332-1-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20150315_160650_155857_F2BBD5F8)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here are few enhancements in thermal throttling that allows
user to control throttling state and quiet period. Also enables
throttling for station mode. These patches are rebased on latest TOT.

Rajkumar Manoharan (6):
  ath10k: add debugfs entry to configure quiet period
  ath10k: Fix interpretation of cooling device state
  ath10k: configure thermal throttle while powering up
  ath10k: do not restrict thermal throttling to ap mode
  ath10k: cache throttle state when device is down
  ath10k: move driver state check before setting throttle

 drivers/net/wireless/ath/ath10k/debug.c   |  47 ++++++++++++
 drivers/net/wireless/ath/ath10k/mac.c     |   1 +
 drivers/net/wireless/ath/ath10k/thermal.c | 120 ++++++++++++------------------
 drivers/net/wireless/ath/ath10k/thermal.h |  10 ++-
 4 files changed, 102 insertions(+), 76 deletions(-)

-- 
2.3.2

