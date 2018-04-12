Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out-ams-01.qualcomm.com ([185.23.61.162]:25358 "EHLO
        alexa-out-ams-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752215AbeDLHwk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 12 Apr 2018 03:52:40 -0400
From: Maya Erez <merez@codeaurora.org>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Maya Erez <merez@codeaurora.org>, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com
Subject: [PATCH 00/10] wil6210 patches
Date: Thu, 12 Apr 2018 10:52:19 +0300
Message-Id: <1523519549-20278-1-git-send-email-merez@codeaurora.org> (sfid-20180412_095243_459778_91BC95DE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The following patches include multiple wil6210 fixes.

Ahmad Masri (1):
  wil6210: align to latest auto generated wmi.h

Alexei Avshalom Lazar (2):
  wil6210: disable tracing config option
  wil6210: set/get EDMG channel through debugfs

Dedy Lansky (4):
  wil6210: use country specific board file upon reg domain change
  wil6210: move WMI functionality out of wil_cfg80211_mgmt_tx
  wil6210: remove unused rx_reorder members
  wil6210: rate limit wil_rx_refill error

Lazar Alexei (1):
  wil6210: Initialize reply struct of the WMI commands

Lior David (2):
  wil6210: fix call to wil6210_disconnect during unload
  wil6210: change reply_size arg to u16 in wmi_call

 drivers/net/wireless/ath/wil6210/Kconfig      |   2 +-
 drivers/net/wireless/ath/wil6210/cfg80211.c   | 216 ++++++++++---
 drivers/net/wireless/ath/wil6210/debugfs.c    |   6 +-
 drivers/net/wireless/ath/wil6210/main.c       |  39 ++-
 drivers/net/wireless/ath/wil6210/netdev.c     |   8 +-
 drivers/net/wireless/ath/wil6210/rx_reorder.c |   7 +-
 drivers/net/wireless/ath/wil6210/txrx.c       |  12 +-
 drivers/net/wireless/ath/wil6210/wil6210.h    |  23 +-
 drivers/net/wireless/ath/wil6210/wmi.c        | 177 ++++++++---
 drivers/net/wireless/ath/wil6210/wmi.h        | 420 ++++++++++++++++++++++++--
 10 files changed, 769 insertions(+), 141 deletions(-)

-- 
1.9.1
