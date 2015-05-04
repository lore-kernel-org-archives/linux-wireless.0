Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:32320 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943AbbEDWMB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 May 2015 18:12:01 -0400
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
To: Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH v3 0/7] wil6210 patches
Date: Tue,  5 May 2015 01:11:49 +0300
Message-Id: <1430777516-439-1-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20150505_001239_782974_5746A1B2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

- introduced debug trace facility (PMC) that extracts events
  reported by the hardware
- introduced real broadcast for secure link
- other are small fixes here and there

v2:

fix patch "wil6210: Add pmc debug mechanism memory management"
for 32-bit platforms

v3:

fix patch "wil6210: Add pmc debug mechanism memory management"
for pointers and dma_addr_t printing

Vladimir Kondratiev (7):
  wil6210: increase timeout for the "echo" command
  wil6210: update Rx descriptor fields
  wil6210: fix boot loader "ready" indication
  wil6210: fix for probe_resp IE's
  wil6210: Add pmc debug mechanism memory management
  wil6210: broadcast for secure link
  wil6210: support WSC for STA mode

 drivers/net/wireless/ath/wil6210/Makefile   |   1 +
 drivers/net/wireless/ath/wil6210/cfg80211.c | 117 ++++++---
 drivers/net/wireless/ath/wil6210/debugfs.c  | 107 +++++++-
 drivers/net/wireless/ath/wil6210/main.c     |  14 +-
 drivers/net/wireless/ath/wil6210/pmc.c      | 375 ++++++++++++++++++++++++++++
 drivers/net/wireless/ath/wil6210/pmc.h      |  27 ++
 drivers/net/wireless/ath/wil6210/txrx.c     |  48 ++--
 drivers/net/wireless/ath/wil6210/txrx.h     |  24 +-
 drivers/net/wireless/ath/wil6210/wil6210.h  |  21 +-
 drivers/net/wireless/ath/wil6210/wmi.c      |  70 ++----
 drivers/net/wireless/ath/wil6210/wmi.h      |  40 ++-
 11 files changed, 706 insertions(+), 138 deletions(-)
 create mode 100644 drivers/net/wireless/ath/wil6210/pmc.c
 create mode 100644 drivers/net/wireless/ath/wil6210/pmc.h

-- 
2.1.0

