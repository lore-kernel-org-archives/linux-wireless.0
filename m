Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:31223 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753301Ab1KVQW4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Nov 2011 11:22:56 -0500
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: Jouni Malinen <jouni@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	Balasubramanian senthilkumar <senthilb@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	Vivek Natarajan <nataraja@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: [PATCH 00/18] Add support for MCI BT coex
Date: Tue, 22 Nov 2011 21:52:27 +0530
Message-ID: <1321978965-21684-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20111122_172300_100450_233197FF)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

Add support for MCI BT-Coex for AR9462. with AR9462 we have
WLAN and BT coexists via MCI protocol(Message Coexistence Interface)
WLAN and BT exchanges GPM, SCHED messages and few other messages
for coexistence.

*thanks to Senthil Balasubramanian <senthilb@qca.qualcomm.com> 
for his technical support

*thanks to Wilson Tsao <wtsao@qca.qualcomm.com> who being the core 
author of MCI, for his valuable help and documents

*thanks a lot to Rajkumar Manoharan <rmanohar@qca.qualcomm.com> for
his suggestions, review comments, code cleanups, and modifications
in design.

bug fixes and few miscellaneous cleanups will be added then and there 

Mohammed Shafi Shajakhan (18):
  ath9k_hw: add definitions to support MCI h/w code
  ath9k_hw: add GPIO output MUX related macros
  ath9k_hw: Add MCI h/w specific structure
  ath9k_hw: initialize MCI parameters
  ath9k_hw: Add MCI h/w code and state machine
  ath9k: Add MCI interrupt to interrupt mask
  ath9k_hw: take care of enabling MCI interrupts
  ath9k_hw: check for asynchronous MCI interrupt pending
  ath9k_hw: check for MCI interrupt in get_isr
  ath9k: add MCI specific definitions and structures
  ath9k: Add functions to allocate/free buffers for MCI
  ath9k_hw: MCI related changes in chip management
  ath9k_hw: MCI related changes in set_reset_reg
  ath9k_hw: Add support for MCI WLAN calibration
  ath9k_hw: Add MCI related changes in chip reset
  ath9k: make ath_reset non-static
  ath9k: MCI state machine based on MCI interrupt
  ath9k: fix a typo

 drivers/net/wireless/ath/ath9k/Makefile       |    3 +-
 drivers/net/wireless/ath/ath9k/ar9003_calib.c |   43 +
 drivers/net/wireless/ath/ath9k/ar9003_mac.c   |   36 +-
 drivers/net/wireless/ath/ath9k/ar9003_mci.c   | 1464 +++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/ar9003_mci.h   |  102 ++
 drivers/net/wireless/ath/ath9k/ar9003_phy.h   |    3 +
 drivers/net/wireless/ath/ath9k/ath9k.h        |    2 +
 drivers/net/wireless/ath/ath9k/btcoex.c       |    2 +-
 drivers/net/wireless/ath/ath9k/btcoex.h       |   31 +
 drivers/net/wireless/ath/ath9k/hw.c           |  174 +++-
 drivers/net/wireless/ath/ath9k/hw.h           |  182 +++
 drivers/net/wireless/ath/ath9k/init.c         |   33 +
 drivers/net/wireless/ath/ath9k/mac.c          |   17 +-
 drivers/net/wireless/ath/ath9k/main.c         |   11 +-
 drivers/net/wireless/ath/ath9k/mci.c          |  419 +++++++
 drivers/net/wireless/ath/ath9k/mci.h          |   20 +
 drivers/net/wireless/ath/ath9k/reg.h          |  306 +++++-
 17 files changed, 2807 insertions(+), 41 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath9k/ar9003_mci.c
 create mode 100644 drivers/net/wireless/ath/ath9k/ar9003_mci.h

