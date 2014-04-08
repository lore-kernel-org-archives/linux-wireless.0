Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:7538 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756126AbaDHIgo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Apr 2014 04:36:44 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 0/5] wil6210 patches
Date: Tue, 8 Apr 2014 11:36:14 +0300
Message-ID: <1396946179-11677-1-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140408_103649_016199_DABDF141)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Few more patches.
Patches 4 and 5 are significant:
- relaxed check for BACK start sequence
  it fixes connectivity problem caused by firmware's funny
  implementation of block ack
- Use larger Tx rings
  boosts throughput

Vladimir Kondratiev (5):
  wil6210: Convert to Kbuild
  wil6210: fix printouts for better readability
  wil6210: sync with the latest FW API
  wil6210: relaxed check for BACK start sequence
  wil6210: Use larger Tx rings

 drivers/net/wireless/ath/wil6210/Kbuild       | 18 ++++++++++
 drivers/net/wireless/ath/wil6210/Makefile     | 18 ----------
 drivers/net/wireless/ath/wil6210/interrupt.c  |  2 +-
 drivers/net/wireless/ath/wil6210/main.c       |  4 +--
 drivers/net/wireless/ath/wil6210/pcie_bus.c   |  2 --
 drivers/net/wireless/ath/wil6210/rx_reorder.c | 17 +++++++++
 drivers/net/wireless/ath/wil6210/wil6210.h    |  3 +-
 drivers/net/wireless/ath/wil6210/wmi.c        | 11 +++---
 drivers/net/wireless/ath/wil6210/wmi.h        | 50 +++++++++++++++++----------
 9 files changed, 77 insertions(+), 48 deletions(-)
 create mode 100644 drivers/net/wireless/ath/wil6210/Kbuild
 delete mode 100644 drivers/net/wireless/ath/wil6210/Makefile

-- 
1.8.3.2

