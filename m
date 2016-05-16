Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:63805 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754471AbcEPTYK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 May 2016 15:24:10 -0400
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Maya Erez <qca_merez@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
Subject: [PATCH 0/6] wil6210 patches
Date: Mon, 16 May 2016 22:23:29 +0300
Message-Id: <1463426615-15523-1-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20160516_212417_497432_C592B4DD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The below set of patches includes:
- Various wil6210 fixes for multi core environment
- Addition of pm_notify handling for early reject / approval of the suspend

Maya Erez (6):
  wil6210: fix race conditions between TX send and completion
  wil6210: guarantee safe access to rx descriptors shared memory
  wil6210: protect wil_vring_fini_tx in parallel to tx completions
  wil6210: fix dma mapping error cleanup in __wil_tx_vring_tso
  wil6210: add pm_notify handling
  wil6210: align wil log functions to wil_dbg_ratelimited implementation

 drivers/net/wireless/ath/wil6210/debug.c        | 46 ++++++++---------
 drivers/net/wireless/ath/wil6210/pcie_bus.c     | 68 ++++++++++++++++++++++++-
 drivers/net/wireless/ath/wil6210/pm.c           | 25 ++++++++-
 drivers/net/wireless/ath/wil6210/txrx.c         | 42 ++++++++++++++-
 drivers/net/wireless/ath/wil6210/wil6210.h      |  5 ++
 drivers/net/wireless/ath/wil6210/wil_platform.h |  4 +-
 6 files changed, 159 insertions(+), 31 deletions(-)

-- 
1.8.5.2

