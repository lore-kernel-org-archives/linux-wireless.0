Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:16870 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422827AbbD2Lpp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Apr 2015 07:45:45 -0400
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
To: Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 0/7] wil6210 patches
Date: Wed, 29 Apr 2015 14:44:59 +0300
Message-Id: <1430307906-28393-1-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20150429_134550_272893_ABC3E394)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

- introduced debug trace facility (PMC) that extracts events
  reported by the hardware
- introduced real broadcast for secure link
- other are small fixes here and there

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
 drivers/net/wireless/ath/wil6210/pmc.c      | 374 ++++++++++++++++++++++++++++
 drivers/net/wireless/ath/wil6210/pmc.h      |  27 ++
 drivers/net/wireless/ath/wil6210/txrx.c     |  48 ++--
 drivers/net/wireless/ath/wil6210/txrx.h     |  24 +-
 drivers/net/wireless/ath/wil6210/wil6210.h  |  21 +-
 drivers/net/wireless/ath/wil6210/wmi.c      |  70 ++----
 drivers/net/wireless/ath/wil6210/wmi.h      |  40 ++-
 11 files changed, 705 insertions(+), 138 deletions(-)
 create mode 100644 drivers/net/wireless/ath/wil6210/pmc.c
 create mode 100644 drivers/net/wireless/ath/wil6210/pmc.h

-- 
2.1.0

