Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:45841 "EHLO
        sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751083AbdHCNZo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 3 Aug 2017 09:25:44 -0400
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Maya Erez <qca_merez@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
Subject: [PATCH v3 0/9] wil6210 patches
Date: Thu,  3 Aug 2017 16:25:30 +0300
Message-Id: <1501766739-31996-1-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20170803_152547_971592_81057E94)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Changes from v2:
- Remove debugfs.c compilation if CONFIG_DEBUG_FS is not defined

Changes from v1:
- Removal of runtime PM patch, pending a fix to system suspend flow

Dedy Lansky (2):
  wil6210: support FW RSSI reporting
  wil6210: store FW RF calibration result

Gidon Studinski (1):
  wil6210: make debugfs compilation optional

Hamad Kadmany (3):
  wil6210: protect against invalid length of tx management frame
  wil6210: allow configuring scan timers
  wil6210: fix interface-up check

Maya Erez (3):
  wil6210: check no_fw_recovery in resume failure recovery
  wil6210: add statistics for suspend time
  wil6210: notify wiphy on wowlan support

 drivers/net/wireless/ath/wil6210/Makefile   |  2 +-
 drivers/net/wireless/ath/wil6210/cfg80211.c | 42 ++++++++++++++++++++++++-----
 drivers/net/wireless/ath/wil6210/debugfs.c  | 28 ++++++++++++++-----
 drivers/net/wireless/ath/wil6210/main.c     | 12 ++++++++-
 drivers/net/wireless/ath/wil6210/pcie_bus.c |  3 +++
 drivers/net/wireless/ath/wil6210/pm.c       | 27 ++++++++++++++++---
 drivers/net/wireless/ath/wil6210/txrx.c     |  6 ++---
 drivers/net/wireless/ath/wil6210/wil6210.h  | 21 +++++++++++++--
 drivers/net/wireless/ath/wil6210/wmi.c      | 14 +++++++---
 drivers/net/wireless/ath/wil6210/wmi.h      |  8 ++++--
 10 files changed, 134 insertions(+), 29 deletions(-)

-- 
1.9.1
