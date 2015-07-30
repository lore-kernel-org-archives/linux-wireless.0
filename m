Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:36497 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753832AbbG3Kyl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2015 06:54:41 -0400
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
To: Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH v3 00/19] wil6210 patches
Date: Thu, 30 Jul 2015 13:51:48 +0300
Message-Id: <1438253527-3372-1-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20150730_125445_631884_32F47AAE)
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

V2: found bug in the commit for TSO - by mistake, reported was
NETIF_F_IP_CSUM and NETIF_F_IPV6_CSUM. Re-sending whole series
to avoid confusion

v3: re-sending whole patch series.
Dropped is ACS with vendor specific implementation
Also dropped is patch "hold wil->mutex while managing vrings",
logical issue found with this patch and it should be redesigned
Added couple of minor patches for the boot loader

Dedy Lansky (1):
  wil6210: treat "unhandled event" as warning instead of error

Vladimir Kondratiev (17):
  wil6210: support boot loader struct v0 & v1
  wil6210: count drops in Rx block ack reorder
  wil6210: print "ulong" fields in hex format in the debugfs
  wil6210: use <> vs. "" for global include
  wil6210: wait for del_station to complete
  wil6210: use wil_fw_error_recovery()
  wil6210: skip HW version check for chip debugging
  wil6210: TSO implementation
  wil6210: improve mgmt frame handling
  wil6210: sort IEs handling
  wil6210: unify wmi_set_ie() error handling
  wil6210: detailed statistics for Rx reorder drop
  wil6210: remove 3-MSI support
  wil6210: use inline functions for register access
  wil6210: system power management
  wil6210: report boot loader error
  wil6210: support future boot loaders

Vladimir Shulman (1):
  wil6210: allow to handle Rx on 2 cores

 drivers/net/wireless/ath/wil6210/Makefile       |   1 +
 drivers/net/wireless/ath/wil6210/boot_loader.h  |  61 ++++
 drivers/net/wireless/ath/wil6210/cfg80211.c     |  95 ++----
 drivers/net/wireless/ath/wil6210/debugfs.c      |  16 +-
 drivers/net/wireless/ath/wil6210/ethtool.c      |  14 +-
 drivers/net/wireless/ath/wil6210/fw.c           |  10 -
 drivers/net/wireless/ath/wil6210/fw_inc.c       |  16 +-
 drivers/net/wireless/ath/wil6210/interrupt.c    | 165 ++++------
 drivers/net/wireless/ath/wil6210/ioctl.c        |   4 +-
 drivers/net/wireless/ath/wil6210/main.c         | 198 +++++++-----
 drivers/net/wireless/ath/wil6210/netdev.c       |   5 +-
 drivers/net/wireless/ath/wil6210/pcie_bus.c     | 127 +++++---
 drivers/net/wireless/ath/wil6210/pm.c           |  98 ++++++
 drivers/net/wireless/ath/wil6210/rx_reorder.c   |   6 +
 drivers/net/wireless/ath/wil6210/txrx.c         | 383 +++++++++++++++++++++++-
 drivers/net/wireless/ath/wil6210/txrx.h         |   8 +
 drivers/net/wireless/ath/wil6210/wil6210.h      |  62 ++--
 drivers/net/wireless/ath/wil6210/wil_platform.c |   2 +-
 drivers/net/wireless/ath/wil6210/wmi.c          | 130 ++++++--
 19 files changed, 1011 insertions(+), 390 deletions(-)
 create mode 100644 drivers/net/wireless/ath/wil6210/boot_loader.h
 create mode 100644 drivers/net/wireless/ath/wil6210/pm.c

-- 
2.1.4

