Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:47089 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520AbbBOMC7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Feb 2015 07:02:59 -0500
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
To: Kalle Valo <kvalo@qca.qualcomm.com>
Subject: [PATCH 0/9] wil6210 patches
Date: Sun, 15 Feb 2015 14:02:29 +0200
Message-Id: <1424001758-29529-1-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20150215_130316_050168_799FF95D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Boot loader starts kind of new era in the driver/firmware
interaction. No more ability to boot operational firmware
from on card flash, the only way is to download from the
host.

Removed is support for the old hardware. It is not supported
any more by the new firmware. Removing it allow to compact
code a bit.

Also, after old hardware support is out, it is possible to benefit
from fixes in the new hardware. See
"enable fix for HW bug in 802.11->803.3 transform"

Boris fixed division by 0 observed on some platforms

Other are small improvements

Boris Sorochkin (1):
  wil6210: Fix division by zero in wil_vring_debugfs_show

Vladimir Kondratiev (7):
  wil6210: boot loader
  wil6210: remove support for old hardware
  wil6210: enable fix for HW bug in 802.11->803.3 transform
  wil6210: branch prediction hints
  wil6210: rename 'secure_pcp' to 'privacy'
  wil6210: track privacy connection attribute
  wil6210: Align Rx buffers on 4*n+2

Vladimir Shulman (1):
  wil6210: Change of threshold for tx vring idleness measurement

 drivers/net/wireless/ath/wil6210/cfg80211.c  |  32 +++---
 drivers/net/wireless/ath/wil6210/debugfs.c   |  26 +++--
 drivers/net/wireless/ath/wil6210/ethtool.c   |  34 +++---
 drivers/net/wireless/ath/wil6210/fw.c        |   3 +-
 drivers/net/wireless/ath/wil6210/fw_inc.c    |   4 +-
 drivers/net/wireless/ath/wil6210/interrupt.c |  70 ++++-------
 drivers/net/wireless/ath/wil6210/main.c      | 166 +++++++++++++++------------
 drivers/net/wireless/ath/wil6210/pcie_bus.c  |  22 +---
 drivers/net/wireless/ath/wil6210/txrx.c      | 128 ++++++++++-----------
 drivers/net/wireless/ath/wil6210/wil6210.h   |  34 ++++--
 drivers/net/wireless/ath/wil6210/wmi.c       |   9 +-
 11 files changed, 252 insertions(+), 276 deletions(-)

-- 
2.1.0

