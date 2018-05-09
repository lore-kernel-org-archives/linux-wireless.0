Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out-ams-02.qualcomm.com ([185.23.61.163]:5085 "EHLO
        alexa-out-ams-02.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932215AbeEIKHK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 May 2018 06:07:10 -0400
From: Maya Erez <merez@codeaurora.org>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Maya Erez <merez@codeaurora.org>, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com
Subject: [PATCH v3 0/8] wil6210 patches
Date: Wed,  9 May 2018 13:06:51 +0300
Message-Id: <1525860419-6514-1-git-send-email-merez@codeaurora.org> (sfid-20180509_120714_244541_EAFB2859)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Changes from v2:
Removal of the following patches:
- wil6210: use country specific board file upon reg domain change
- wil6210: force EDMG channel through debugfs

Changes from v1:
Updated the commit text of "wil6210: force EDMG channel through debugfs"

The following patches include multiple wil6210 fixes.

Ahmad Masri (1):
  wil6210: align to latest auto generated wmi.h

Alexei Avshalom Lazar (2):
  wil6210: disable tracing config option
  wil6210: Initialize reply struct of the WMI commands

Dedy Lansky (3):
  wil6210: move WMI functionality out of wil_cfg80211_mgmt_tx
  wil6210: remove unused rx_reorder members
  wil6210: rate limit wil_rx_refill error

Lior David (2):
  wil6210: fix call to wil6210_disconnect during unload
  wil6210: change reply_size arg to u16 in wmi_call

 drivers/net/wireless/ath/wil6210/Kconfig      |   2 +-
 drivers/net/wireless/ath/wil6210/cfg80211.c   |  61 ++--
 drivers/net/wireless/ath/wil6210/debugfs.c    |   5 +-
 drivers/net/wireless/ath/wil6210/main.c       |   2 +
 drivers/net/wireless/ath/wil6210/netdev.c     |   8 +-
 drivers/net/wireless/ath/wil6210/rx_reorder.c |   7 +-
 drivers/net/wireless/ath/wil6210/txrx.c       |  12 +-
 drivers/net/wireless/ath/wil6210/wil6210.h    |  13 +-
 drivers/net/wireless/ath/wil6210/wmi.c        | 152 +++++++---
 drivers/net/wireless/ath/wil6210/wmi.h        | 387 ++++++++++++++++++++++++--
 10 files changed, 519 insertions(+), 130 deletions(-)

-- 
1.9.1
