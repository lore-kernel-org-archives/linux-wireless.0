Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:49050 "EHLO
        alexa-out-lv-02.qualcomm.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751600AbdHCTI3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 3 Aug 2017 15:08:29 -0400
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Maya Erez <qca_merez@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
Subject: [PATCH v4 00/10] wil6210 patches
Date: Thu,  3 Aug 2017 22:08:12 +0300
Message-Id: <1501787302-22885-1-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20170803_210832_776020_31BBBB12)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Changes from v3:
- Split of "wil6210: make debugfs compilation optional" patch to 2 logical patches

Changes from v2:
- Remove debugfs.c compilation if CONFIG_DEBUG_FS is not defined

Changes from v1:
- Removal of runtime PM patch, pending a fix to system suspend flow

Dedy Lansky (2):
  wil6210: support FW RSSI reporting
  wil6210: store FW RF calibration result

Gidon Studinski (2):
  wil6210: move vring_idle_trsh definition to wil6210_priv
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
 drivers/net/wireless/ath/wil6210/debugfs.c  | 27 ++++++++++++++-----
 drivers/net/wireless/ath/wil6210/main.c     | 12 ++++++++-
 drivers/net/wireless/ath/wil6210/pcie_bus.c |  3 +++
 drivers/net/wireless/ath/wil6210/pm.c       | 27 ++++++++++++++++---
 drivers/net/wireless/ath/wil6210/txrx.c     |  6 ++---
 drivers/net/wireless/ath/wil6210/wil6210.h  | 21 +++++++++++++--
 drivers/net/wireless/ath/wil6210/wmi.c      | 14 +++++++---
 drivers/net/wireless/ath/wil6210/wmi.h      |  8 ++++--
 10 files changed, 133 insertions(+), 29 deletions(-)

-- 
1.9.1
