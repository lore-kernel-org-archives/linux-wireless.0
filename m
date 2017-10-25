Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:35612 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750876AbdJYNOM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 25 Oct 2017 09:14:12 -0400
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Maya Erez <qca_merez@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
Subject: [PATCH 00/12] wil6210 patches
Date: Wed, 25 Oct 2017 16:13:55 +0300
Message-Id: <1508937247-11890-1-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20171025_151416_546362_775CC7D1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

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
 drivers/net/wireless/ath/wil6210/debugfs.c   | 134 +++++++++---
 drivers/net/wireless/ath/wil6210/ethtool.c   |  15 ++
 drivers/net/wireless/ath/wil6210/fw_inc.c    |  79 ++++---
 drivers/net/wireless/ath/wil6210/interrupt.c |  22 +-
 drivers/net/wireless/ath/wil6210/main.c      |  26 ++-
 drivers/net/wireless/ath/wil6210/netdev.c    |  18 +-
 drivers/net/wireless/ath/wil6210/pcie_bus.c  |  87 +++++---
 drivers/net/wireless/ath/wil6210/pm.c        | 100 ++++++---
 drivers/net/wireless/ath/wil6210/wil6210.h   |  38 +++-
 drivers/net/wireless/ath/wil6210/wmi.c       | 304 ++++++++++++++++++++++++++-
 drivers/net/wireless/ath/wil6210/wmi.h       |  17 +-
 12 files changed, 706 insertions(+), 151 deletions(-)

-- 
1.9.1
