Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:15294 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754659AbdAKQNy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Jan 2017 11:13:54 -0500
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Maya Erez <qca_merez@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
Subject: [PATCH 00/12] wil6210 patches
Date: Wed, 11 Jan 2017 18:12:36 +0200
Message-Id: <1484151168-894-1-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20170111_171431_536463_D8BB5543)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The following set of patches include various wil6210 fixes

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

 drivers/net/wireless/ath/wil6210/Makefile         |   1 +
 drivers/net/wireless/ath/wil6210/cfg80211.c       | 170 ++++++++++++++++------
 drivers/net/wireless/ath/wil6210/debugfs.c        |  10 +-
 drivers/net/wireless/ath/wil6210/ethtool.c        |   8 +-
 drivers/net/wireless/ath/wil6210/fw.c             |   5 +-
 drivers/net/wireless/ath/wil6210/fw_inc.c         |  19 +++
 drivers/net/wireless/ath/wil6210/interrupt.c      |  28 ++--
 drivers/net/wireless/ath/wil6210/main.c           |  69 ++++-----
 drivers/net/wireless/ath/wil6210/netdev.c         |  15 +-
 drivers/net/wireless/ath/wil6210/p2p.c            |  34 ++---
 drivers/net/wireless/ath/wil6210/pcie_bus.c       |  73 +++++++---
 drivers/net/wireless/ath/wil6210/pm.c             |  15 +-
 drivers/net/wireless/ath/wil6210/pmc.c            |  77 +++++-----
 drivers/net/wireless/ath/wil6210/rx_reorder.c     |   6 +-
 drivers/net/wireless/ath/wil6210/sysfs.c          | 126 ++++++++++++++++
 drivers/net/wireless/ath/wil6210/txrx.c           |  69 +++++----
 drivers/net/wireless/ath/wil6210/wil6210.h        |  31 +++-
 drivers/net/wireless/ath/wil6210/wil_crash_dump.c |  16 +-
 drivers/net/wireless/ath/wil6210/wmi.c            | 123 +++++++++++-----
 drivers/net/wireless/ath/wil6210/wmi.h            |  65 ++++++++-
 20 files changed, 674 insertions(+), 286 deletions(-)
 create mode 100644 drivers/net/wireless/ath/wil6210/sysfs.c

-- 
1.9.1
