Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:54355 "EHLO
        sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753656AbdKNNZs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Nov 2017 08:25:48 -0500
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Maya Erez <qca_merez@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
Subject: [PATCH v3 00/12] wil6210 patches
Date: Tue, 14 Nov 2017 15:25:32 +0200
Message-Id: <1510665944-30198-1-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20171114_142552_194577_5828BAA2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Changes from v2:
- Additional fixes to "wil6210: run-time PM when interface down"

Changes from v1:
- Fix static buffer allocation in "wil6210: update statistics for suspend"
- Fix kbuild bot error on "wil6210: run-time PM when interface down"

The following patches include:
- Bug fixes
- run-time PM when interface down

Dedy Lansky (1):
  wil6210: print human readable names of WMI commands and events

Hamad Kadmany (1):
  wil6210: abort properly in cfg suspend

Lazar Alexei (5):
  wil6210: run-time PM when interface down
  wil6210: get suspend reject reason and resume triggers from FW
  wil6210: fix PCIe bus mastering in case of interface down
  wil6210: remove suspend time statistics
  wil6210: update statistics for suspend

Lior David (5):
  wil6210: refresh FW capabilities during interface up
  wil6210: fix length check in __wmi_send
  wil6210: add block size checks during FW load
  wil6210: missing length check in wmi_set_ie
  wil6210: missing length check in wil_cfg80211_mgmt_tx

 drivers/net/wireless/ath/wil6210/cfg80211.c  |  17 +-
 drivers/net/wireless/ath/wil6210/debugfs.c   | 150 ++++++++++---
 drivers/net/wireless/ath/wil6210/ethtool.c   |  15 ++
 drivers/net/wireless/ath/wil6210/fw_inc.c    |  79 ++++---
 drivers/net/wireless/ath/wil6210/interrupt.c |  22 +-
 drivers/net/wireless/ath/wil6210/main.c      |  26 ++-
 drivers/net/wireless/ath/wil6210/netdev.c    |  18 +-
 drivers/net/wireless/ath/wil6210/pcie_bus.c  |  97 ++++++---
 drivers/net/wireless/ath/wil6210/pm.c        | 104 ++++++---
 drivers/net/wireless/ath/wil6210/wil6210.h   |  40 ++--
 drivers/net/wireless/ath/wil6210/wmi.c       | 304 ++++++++++++++++++++++++++-
 drivers/net/wireless/ath/wil6210/wmi.h       |  17 +-
 12 files changed, 724 insertions(+), 165 deletions(-)

-- 
1.9.1
