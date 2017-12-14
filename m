Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:17927 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753099AbdLNQxR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Dec 2017 11:53:17 -0500
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Maya Erez <qca_merez@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
Subject: [PATCH v2 0/9] wil6210 patches
Date: Thu, 14 Dec 2017 18:53:04 +0200
Message-Id: <1513270393-919-1-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20171214_175323_341319_66DC9904)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Changes from v1:
- Fix code review comments on "wil6210: support Scheduled scan"

The following patches include several wil6210 fixes.

Dedy Lansky (2):
  wil6210: support Scheduled scan
  wil6210: remove leftover "FIXME"s

Lazar Alexei (2):
  wil6210: support 40bit DMA addresses
  wil6210: add support for headroom configuration

Lior David (2):
  wil6210: configurable broadcast TX MCS
  wil6210: remove reference to preset_chandef

Maya Erez (3):
  wil6210: add platform capabilities bitmap
  wil6210: set platform features based on FW capabilities
  wil6210: prevent parallel suspend and dump collection

 drivers/net/wireless/ath/wil6210/cfg80211.c       |  68 +++++-
 drivers/net/wireless/ath/wil6210/debugfs.c        |   1 -
 drivers/net/wireless/ath/wil6210/interrupt.c      |   2 +-
 drivers/net/wireless/ath/wil6210/main.c           |  67 +++++-
 drivers/net/wireless/ath/wil6210/netdev.c         |   2 +-
 drivers/net/wireless/ath/wil6210/pcie_bus.c       |  36 +++-
 drivers/net/wireless/ath/wil6210/pm.c             |  17 ++
 drivers/net/wireless/ath/wil6210/pmc.c            |  11 +-
 drivers/net/wireless/ath/wil6210/txrx.c           | 101 ++++++++-
 drivers/net/wireless/ath/wil6210/wil6210.h        |  15 +-
 drivers/net/wireless/ath/wil6210/wil_crash_dump.c |  11 +
 drivers/net/wireless/ath/wil6210/wil_platform.h   |  15 +-
 drivers/net/wireless/ath/wil6210/wmi.c            | 241 +++++++++++++++++++++-
 drivers/net/wireless/ath/wil6210/wmi.h            | 100 +++++++--
 14 files changed, 621 insertions(+), 66 deletions(-)

-- 
1.9.1
