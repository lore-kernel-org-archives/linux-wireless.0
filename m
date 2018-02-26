Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out-ams-01.qualcomm.com ([185.23.61.162]:21756 "EHLO
        alexa-out-ams-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751367AbeBZSND (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Feb 2018 13:13:03 -0500
From: Maya Erez <merez@codeaurora.org>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Maya Erez <merez@codeaurora.org>, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com
Subject: [PATCH v2 0/8] wil6210 patches
Date: Mon, 26 Feb 2018 20:12:10 +0200
Message-Id: <1519668738-16912-1-git-send-email-merez@codeaurora.org> (sfid-20180226_191323_635193_E7F93AA9)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Changes from v1:
Rebase patches

Support for multiple virtual interfaces (MultiVIF)

This series of patches add MultiVIF support to the wil6210 driver.
It makes it possible to start multiple interfaces where each interface
is an independent WIFI entity such as station, AP and so on.

Each virtual interface (VIF) is mapped so a separate network interface
(such as wlan0, wlan1, …) so it can also be treated separately for
routing and other network operations.

MultiVIF requires support in the FW. The FW will report whether it
supports MultiVIF and the allowed concurrency combinations. The driver
will export this information to user space and enforce it so it will
only be possible to start a combination of VIFs supported by the FW.

Initially our FW only supports multiple access points (APs) so it is
possible for example to have a secure and guest network. The code was
only validated with this scenario and we will improve the support for
other concurrency combinations with future patches, as it becomes
available in the FW.

Lior David (8):
  wil6210: add wil6210_vif structure for per-VIF data
  wil6210: support concurrency record in FW file
  wil6210: infrastructure for multiple virtual interfaces
  wil6210: add support for adding and removing virtual interfaces
  wil6210: multiple VIFs support for start/stop AP
  wil6210: rename p2p_wdev_mutex to vif_mutex
  wil6210: multiple VIFs support for connections and data path
  wil6210: add debugfs 'mids' file

 drivers/net/wireless/ath/wil6210/cfg80211.c   | 741 ++++++++++++++++++--------
 drivers/net/wireless/ath/wil6210/debug.c      |   9 +-
 drivers/net/wireless/ath/wil6210/debugfs.c    | 117 +++-
 drivers/net/wireless/ath/wil6210/ethtool.c    |   4 +-
 drivers/net/wireless/ath/wil6210/fw.h         |  38 +-
 drivers/net/wireless/ath/wil6210/fw_inc.c     |  52 +-
 drivers/net/wireless/ath/wil6210/interrupt.c  |   8 +-
 drivers/net/wireless/ath/wil6210/main.c       | 331 +++++++-----
 drivers/net/wireless/ath/wil6210/netdev.c     | 382 ++++++++++---
 drivers/net/wireless/ath/wil6210/p2p.c        | 175 +++---
 drivers/net/wireless/ath/wil6210/pcie_bus.c   |  57 +-
 drivers/net/wireless/ath/wil6210/pm.c         | 132 +++--
 drivers/net/wireless/ath/wil6210/pmc.c        |   8 +-
 drivers/net/wireless/ath/wil6210/rx_reorder.c |  45 +-
 drivers/net/wireless/ath/wil6210/txrx.c       | 177 +++---
 drivers/net/wireless/ath/wil6210/txrx.h       |  22 +-
 drivers/net/wireless/ath/wil6210/wil6210.h    | 217 +++++---
 drivers/net/wireless/ath/wil6210/wmi.c        | 460 +++++++++++-----
 18 files changed, 2081 insertions(+), 894 deletions(-)

-- 
1.9.1
