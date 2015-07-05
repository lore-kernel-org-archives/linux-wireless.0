Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:6121 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753034AbbGEIqC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Jul 2015 04:46:02 -0400
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
To: Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 00/13] wil6210 patches
Date: Sun,  5 Jul 2015 10:24:27 +0300
Message-Id: <1436081080-27305-1-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20150705_104609_080173_15D763F2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Several new features introduced:
- TSO improves throughput on Tx side on systems with weak CPU
- ACS chooses best channel automatically when starting AP
- support for the new boot loader

Bug fixes:
- "wait for del_station to complete"
- "hold wil->mutex while managing vrings"

The rest are small fixes and improvements

Dedy Lansky (1):
  wil6210: treat "unhandled event" as warning instead of error

Vladimir Kondratiev (12):
  wil6210: support boot loader struct v0 & v1
  wil6210: ACS implementation using QCA vendor command
  wil6210: debugfs for channel survey
  wil6210: count drops in Rx block ack reorder
  wil6210: print "ulong" fields in hex format in the debugfs
  wil6210: use <> vs. "" for global include
  wil6210: wait for del_station to complete
  wil6210: hold wil->mutex while managing vrings
  wil6210: use wil_fw_error_recovery()
  wil6210: skip HW version check for chip debugging
  wil6210: TSO implementation
  wil6210: improve mgmt frame handling

 drivers/net/wireless/ath/wil6210/boot_loader.h  |  57 ++++
 drivers/net/wireless/ath/wil6210/cfg80211.c     | 389 ++++++++++++++++++++++++
 drivers/net/wireless/ath/wil6210/debugfs.c      |  64 +++-
 drivers/net/wireless/ath/wil6210/main.c         | 112 +++++--
 drivers/net/wireless/ath/wil6210/netdev.c       |   5 +-
 drivers/net/wireless/ath/wil6210/rx_reorder.c   |   2 +
 drivers/net/wireless/ath/wil6210/txrx.c         | 383 ++++++++++++++++++++++-
 drivers/net/wireless/ath/wil6210/txrx.h         |   8 +
 drivers/net/wireless/ath/wil6210/wil6210.h      |  18 +-
 drivers/net/wireless/ath/wil6210/wil_platform.c |   2 +-
 drivers/net/wireless/ath/wil6210/wmi.c          | 129 ++++++--
 drivers/net/wireless/ath/wil6210/wmi.h          |  38 ++-
 12 files changed, 1129 insertions(+), 78 deletions(-)
 create mode 100644 drivers/net/wireless/ath/wil6210/boot_loader.h

-- 
2.1.4

