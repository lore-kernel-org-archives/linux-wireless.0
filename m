Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out-ams-02.qualcomm.com ([185.23.61.163]:64021 "EHLO
        alexa-out-ams-02.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728509AbeHMPXJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Aug 2018 11:23:09 -0400
From: Alexei Avshalom Lazar <ailizaro@codeaurora.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Alexei Avshalom Lazar <ailizaro@codeaurora.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com
Subject: [PATCH 0/3] Add support for new channels on 60GHz band
Date: Mon, 13 Aug 2018 15:32:59 +0300
Message-Id: <1534163582-9983-1-git-send-email-ailizaro@codeaurora.org> (sfid-20180813_144123_504262_5BFFB51C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The following set of patches add support for new channels on
60GHz band and EDMG channels:
-Support new channels 5 and 6
-Support EDMG channels

Alexei Avshalom Lazar (3):
  cfg80211: Add support for 60GHz band channels 5 and 6
  nl80211: Add support for EDMG channels
  wil6210: Add EDMG channel support

 drivers/net/wireless/ath/wil6210/cfg80211.c  | 194 +++++++++++++++++++++++++--
 drivers/net/wireless/ath/wil6210/debugfs.c   |   2 +-
 drivers/net/wireless/ath/wil6210/main.c      |   3 +
 drivers/net/wireless/ath/wil6210/txrx_edma.c |   2 +
 drivers/net/wireless/ath/wil6210/txrx_edma.h |   6 +
 drivers/net/wireless/ath/wil6210/wil6210.h   |   6 +-
 drivers/net/wireless/ath/wil6210/wmi.c       |   5 +-
 drivers/net/wireless/ath/wil6210/wmi.h       |  43 +++++-
 include/net/cfg80211.h                       |  50 ++++++-
 include/uapi/linux/nl80211.h                 |  14 +-
 net/wireless/chan.c                          |  88 ++++++++++++
 net/wireless/nl80211.c                       |  33 +++++
 net/wireless/reg.c                           |   2 +-
 net/wireless/trace.h                         |   2 +-
 net/wireless/util.c                          |  48 ++++++-
 15 files changed, 468 insertions(+), 30 deletions(-)

-- 
1.9.1
