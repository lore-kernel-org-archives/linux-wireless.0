Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:24814 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbbJDHXn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Oct 2015 03:23:43 -0400
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
To: Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 00/10] wil6210 patches
Date: Sun,  4 Oct 2015 10:23:17 +0300
Message-Id: <1443943407-6663-1-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20151004_092348_216184_5570DE24)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

New features:
- BlockAckReq support
- firmware crashdump using devcoredump
- capture all frames with sniffer

The rest of patches are fixes

Hamad Kadmany (1):
  wil6210: Do no schedule firmware recovery during reset flow

Vladimir Kondratiev (8):
  wil6210: fix warning in system power management code
  wil6210: Add proper handling for invalid frames on Rx
  wil6210: log firmware crash information
  wil6210: treat broadcast bssid as "disconnect all"
  wil6210: support BAR (BlockAck Req)
  wil6210: capture all frames in sniffer mode
  wil6210: ratelimit Tx error message
  wil6210: dump firmware memory when firmware crashes

Vladimir Shulman (1):
  wil6210: pmc logger bug fix

 drivers/net/wireless/ath/wil6210/Kconfig          |   1 +
 drivers/net/wireless/ath/wil6210/Makefile         |   1 +
 drivers/net/wireless/ath/wil6210/debugfs.c        |   6 ++
 drivers/net/wireless/ath/wil6210/interrupt.c      |  10 +-
 drivers/net/wireless/ath/wil6210/main.c           |  14 ++-
 drivers/net/wireless/ath/wil6210/pcie_bus.c       |   2 +-
 drivers/net/wireless/ath/wil6210/pmc.c            |   2 +-
 drivers/net/wireless/ath/wil6210/rx_reorder.c     |  26 +++++
 drivers/net/wireless/ath/wil6210/txrx.c           |  62 +++++++++---
 drivers/net/wireless/ath/wil6210/txrx.h           |   7 ++
 drivers/net/wireless/ath/wil6210/wil6210.h        |  10 ++
 drivers/net/wireless/ath/wil6210/wil_crash_dump.c | 115 ++++++++++++++++++++++
 drivers/net/wireless/ath/wil6210/wmi.c            |   2 +-
 13 files changed, 237 insertions(+), 21 deletions(-)
 create mode 100644 drivers/net/wireless/ath/wil6210/wil_crash_dump.c

-- 
2.1.4

