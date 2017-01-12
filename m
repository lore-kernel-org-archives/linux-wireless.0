Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:57758 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751510AbdALNPO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 12 Jan 2017 08:15:14 -0500
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Maya Erez <qca_merez@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
Subject: [PATCH v2 00/13] wil6210 patches
Date: Thu, 12 Jan 2017 15:05:52 +0200
Message-Id: <1484226365-10433-1-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20170112_141631_856514_32B59ADD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The following set of patches include various wil6210 fixes
Changes from V1:
- Fix copyright year to 2017
- Add a patch to convert symbolic permissions to octal permissions to fix checkpatch
  errors and align to latest kernel preference
- Fix "set dma mask to reflect device capability" commit text


Dedy Lansky (2):
  wil6210: add disable_ap_sme module parameter
  wil6210: support new WMI-only FW capability

Hamad Kadmany (2):
  wil6210: protect against false interrupt during reset sequence
  wil6210: set dma mask to reflect device capability

Lazar Alexei (2):
  wil6210: support loading dedicated image for sparrow-plus devices
  wil6210: remove __func__ from debug printouts

Lior David (6):
  wil6210: add sysfs file for FTM calibration
  wil6210: missing reinit_completion in wmi_call
  wil6210: fix for broadcast workaround in PBSS
  wil6210: align to latest auto generated wmi.h
  wil6210: report association ID (AID) per station in debugfs
  wil6210: option to override A-BFT length in start AP/PCP

Maya Erez (1):
  wil6210: convert symbolic permissions to octal permissions

 drivers/net/wireless/ath/wil6210/Makefile         |   1 +
 drivers/net/wireless/ath/wil6210/cfg80211.c       | 172 ++++++++++++++++------
 drivers/net/wireless/ath/wil6210/debugfs.c        | 136 ++++++++---------
 drivers/net/wireless/ath/wil6210/ethtool.c        |  10 +-
 drivers/net/wireless/ath/wil6210/fw.c             |   7 +-
 drivers/net/wireless/ath/wil6210/fw_inc.c         |  21 ++-
 drivers/net/wireless/ath/wil6210/interrupt.c      |  30 ++--
 drivers/net/wireless/ath/wil6210/main.c           |  87 +++++------
 drivers/net/wireless/ath/wil6210/netdev.c         |  17 ++-
 drivers/net/wireless/ath/wil6210/p2p.c            |  36 ++---
 drivers/net/wireless/ath/wil6210/pcie_bus.c       |  77 +++++++---
 drivers/net/wireless/ath/wil6210/pm.c             |  17 +--
 drivers/net/wireless/ath/wil6210/pmc.c            |  79 +++++-----
 drivers/net/wireless/ath/wil6210/rx_reorder.c     |   8 +-
 drivers/net/wireless/ath/wil6210/sysfs.c          | 126 ++++++++++++++++
 drivers/net/wireless/ath/wil6210/txrx.c           |  75 +++++-----
 drivers/net/wireless/ath/wil6210/wil6210.h        |  33 ++++-
 drivers/net/wireless/ath/wil6210/wil_crash_dump.c |  18 +--
 drivers/net/wireless/ath/wil6210/wmi.c            | 131 ++++++++++------
 drivers/net/wireless/ath/wil6210/wmi.h            |  67 ++++++++-
 20 files changed, 768 insertions(+), 380 deletions(-)
 create mode 100644 drivers/net/wireless/ath/wil6210/sysfs.c

-- 
1.9.1
