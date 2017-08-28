Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:41752 "EHLO
        alexa-out-lv-01.qualcomm.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751192AbdH1TSw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Aug 2017 15:18:52 -0400
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Maya Erez <qca_merez@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
Subject: [PATCH 0/7] wil6210 patches
Date: Mon, 28 Aug 2017 22:18:40 +0300
Message-Id: <1503947927-18877-1-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20170828_211857_123146_61540040)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The following patches include:
- Bug fixes
- Optional compilation of wil6210 debugfs

Dedy Lansky (2):
  wil6210: move pre-FW configuration to separate function
  wil6210: clear PAL_UNIT_ICR part of device reset

Gidon Studinski (1):
  wil6210: make debugfs compilation optional

Lazar Alexei (1):
  wil6210: align to latest auto generated wmi.h

Lior David (3):
  wil6210: ratelimit errors in TX/RX interrupts
  wil6210: increase connect timeout
  wil6210: ensure P2P device is stopped before removing interface

 drivers/net/wireless/ath/wil6210/Kconfig     |  12 +
 drivers/net/wireless/ath/wil6210/Makefile    |   2 +-
 drivers/net/wireless/ath/wil6210/cfg80211.c  |  59 +--
 drivers/net/wireless/ath/wil6210/interrupt.c |  14 +-
 drivers/net/wireless/ath/wil6210/main.c      |  42 +-
 drivers/net/wireless/ath/wil6210/wil6210.h   |   7 +
 drivers/net/wireless/ath/wil6210/wmi.h       | 714 ++++++++++++++++++---------
 7 files changed, 557 insertions(+), 293 deletions(-)

-- 
1.9.1
