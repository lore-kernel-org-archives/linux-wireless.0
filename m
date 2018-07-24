Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out-ams-01.qualcomm.com ([185.23.61.162]:42741 "EHLO
        alexa-out-ams-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388390AbeGXIty (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Jul 2018 04:49:54 -0400
From: Maya Erez <merez@codeaurora.org>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Maya Erez <merez@codeaurora.org>, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com
Subject: [PATCH v2 00/19] wil6210 patches
Date: Tue, 24 Jul 2018 10:44:21 +0300
Message-Id: <1532418280-5849-1-git-send-email-merez@codeaurora.org> (sfid-20180724_094449_460976_59A41BED)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Changes from v1:
Removal of "wil6210: send L2UF on behalf of newly associated station"
patch. wil_indicate_layer2_update will be unified with ieee80211_send_layer2_update()
into a new cfg80211 function.

The following set of patches include:
- Various wil6210 fixes
- Support triple MSI configuration
- Support scan on AP interface
- Support Talyn specific FW and board files

Ahmad Masri (3):
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
 drivers/net/wireless/ath/wil6210/txrx.c         |  71 ++-
 drivers/net/wireless/ath/wil6210/txrx.h         |   7 +
 drivers/net/wireless/ath/wil6210/txrx_edma.c    |  48 +-
 drivers/net/wireless/ath/wil6210/txrx_edma.h    |   6 +
 drivers/net/wireless/ath/wil6210/wil6210.h      |  96 +++-
 drivers/net/wireless/ath/wil6210/wil_platform.h |   1 +
 drivers/net/wireless/ath/wil6210/wmi.c          | 221 ++++++++
 drivers/net/wireless/ath/wil6210/wmi.h          | 685 +++++++++++++++++++++++-
 16 files changed, 1660 insertions(+), 131 deletions(-)

-- 
1.9.1
