Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:32235 "EHLO
        sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752546AbdGaQch (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 31 Jul 2017 12:32:37 -0400
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Maya Erez <qca_merez@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
Subject: [PATCH 00/10] wil6210 patches
Date: Mon, 31 Jul 2017 19:32:23 +0300
Message-Id: <1501518753-6339-1-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20170731_183243_406978_D4937CF4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The following patches incude:
- wil6210 bug fixes
- Addition of runtime PM support

Dedy Lansky (2):
  wil6210: support FW RSSI reporting
  wil6210: store FW RF calibration result

Gidon Studinski (1):
  wil6210: make debugfs compilation optional

Hamad Kadmany (3):
  wil6210: protect against invalid length of tx management frame
  wil6210: allow configuring scan timers
  wil6210: fix interface-up check

Lazar Alexei (1):
  wil6210: run-time PM when interface down

Maya Erez (3):
  wil6210: check no_fw_recovery in resume failure recovery
  wil6210: add statistics for suspend time
  wil6210: notify wiphy on wowlan support

 drivers/net/wireless/ath/wil6210/cfg80211.c |  42 ++++++++--
 drivers/net/wireless/ath/wil6210/debugfs.c  | 121 +++++++++++++++++++++++++---
 drivers/net/wireless/ath/wil6210/ethtool.c  |  15 ++++
 drivers/net/wireless/ath/wil6210/main.c     |  12 ++-
 drivers/net/wireless/ath/wil6210/netdev.c   |  18 ++++-
 drivers/net/wireless/ath/wil6210/pcie_bus.c |  38 +++++++++
 drivers/net/wireless/ath/wil6210/pm.c       |  90 ++++++++++++++++++++-
 drivers/net/wireless/ath/wil6210/txrx.c     |   6 +-
 drivers/net/wireless/ath/wil6210/wil6210.h  |  31 ++++++-
 drivers/net/wireless/ath/wil6210/wmi.c      |  14 +++-
 drivers/net/wireless/ath/wil6210/wmi.h      |   8 +-
 11 files changed, 358 insertions(+), 37 deletions(-)

-- 
1.9.1
