Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:35554 "EHLO
        sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752173AbdHBVA5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 Aug 2017 17:00:57 -0400
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Maya Erez <qca_merez@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
Subject: [PATCH v2 0/9] wil6210 patches
Date: Thu,  3 Aug 2017 00:00:40 +0300
Message-Id: <1501707649-9665-1-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20170802_230101_701760_835E87B8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

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

 drivers/net/wireless/ath/wil6210/cfg80211.c | 42 ++++++++++++++++++++++++-----
 drivers/net/wireless/ath/wil6210/debugfs.c  | 36 ++++++++++++++++++++-----
 drivers/net/wireless/ath/wil6210/main.c     | 12 ++++++++-
 drivers/net/wireless/ath/wil6210/pcie_bus.c |  3 +++
 drivers/net/wireless/ath/wil6210/pm.c       | 27 ++++++++++++++++---
 drivers/net/wireless/ath/wil6210/txrx.c     |  6 ++---
 drivers/net/wireless/ath/wil6210/wil6210.h  | 15 +++++++++--
 drivers/net/wireless/ath/wil6210/wmi.c      | 14 +++++++---
 drivers/net/wireless/ath/wil6210/wmi.h      |  8 ++++--
 9 files changed, 135 insertions(+), 28 deletions(-)

-- 
1.9.1
