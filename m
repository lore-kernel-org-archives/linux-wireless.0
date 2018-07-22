Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out-ams-02.qualcomm.com ([185.23.61.163]:39653 "EHLO
        alexa-out-ams-02.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727837AbeGVIqF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 22 Jul 2018 04:46:05 -0400
From: Maya Erez <merez@codeaurora.org>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Maya Erez <merez@codeaurora.org>, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com
Subject: [PATCH 00/20] wil6210 patches
Date: Sun, 22 Jul 2018 10:47:25 +0300
Message-Id: <1532245665-15249-1-git-send-email-merez@codeaurora.org> (sfid-20180722_095021_521515_4F46542A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The following set of patches include:
- Various wil6210 fixes
- Support triple MSI configuration
- Support scan on AP interface
- Support Talyn specific FW and board files

Ahmad Masri (4):
  wil6210: send L2UF on behalf of newly associated station
  wil6210: allow scan on AP interface
  wil6210: align to latest auto generated wmi.h
  wil6210: off channel transmit management frames in AP mode

Alexei Avshalom Lazar (3):
  wil6210: add 3-MSI support
  wil6210: fix min() compilation errors
  wil6210: set default 3-MSI

Dedy Lansky (6):
  wil6210: Rx multicast packets duplicate detection
  wil6210: drop Rx packets with L2 error indication from HW
  wil6210: add TX latency statistics
  wil6210: fix temperature debugfs
  wil6210: align to latest auto generated wmi.h
  wil6210: add support for link statistics

Hamad Kadmany (1):
  wil6210: increase firmware ready timeout

Maya Erez (6):
  wil6210: fix RX checksum report to network stack
  wil6210: support Talyn specific FW file
  wil6210: support max aggregation window size 64
  wil6210: support Talyn specific board file
  wil6210: prevent FW download if HW is configured for secured boot
  wil6210: fix eDMA RX chaining

 drivers/net/wireless/ath/wil6210/cfg80211.c     |  50 +-
 drivers/net/wireless/ath/wil6210/debugfs.c      | 371 ++++++++++++-
 drivers/net/wireless/ath/wil6210/fw.c           |   3 +
 drivers/net/wireless/ath/wil6210/fw_inc.c       |   2 +-
 drivers/net/wireless/ath/wil6210/interrupt.c    |  64 ++-
 drivers/net/wireless/ath/wil6210/main.c         |  65 ++-
 drivers/net/wireless/ath/wil6210/pcie_bus.c     |  70 ++-
 drivers/net/wireless/ath/wil6210/rx_reorder.c   |  31 +-
 drivers/net/wireless/ath/wil6210/txrx.c         | 119 +++-
 drivers/net/wireless/ath/wil6210/txrx.h         |   7 +
 drivers/net/wireless/ath/wil6210/txrx_edma.c    |  48 +-
 drivers/net/wireless/ath/wil6210/txrx_edma.h    |   6 +
 drivers/net/wireless/ath/wil6210/wil6210.h      |  98 +++-
 drivers/net/wireless/ath/wil6210/wil_platform.h |   1 +
 drivers/net/wireless/ath/wil6210/wmi.c          | 223 ++++++++
 drivers/net/wireless/ath/wil6210/wmi.h          | 685 +++++++++++++++++++++++-
 16 files changed, 1712 insertions(+), 131 deletions(-)

-- 
1.9.1
