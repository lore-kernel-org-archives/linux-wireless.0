Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lpdvrndsmtp01.broadcom.com ([192.19.229.170]:39498 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751588AbdBOKh5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Feb 2017 05:37:57 -0500
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [RFC V3 0/5] cfg80211: support multiple scheduled scans
Date: Wed, 15 Feb 2017 10:37:24 +0000
Message-Id: <1487155049-1892-1-git-send-email-arend.vanspriel@broadcom.com> (sfid-20170215_113808_589900_84DB171F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Another review round for multiple scheduled scan support in nl80211.

The patches apply to master branch of mac80211-next repository.

changelog:
 V3:
  - addressed comments on "nl80211: allow multiple active scheduled scan requests"
  - reordered first two patches.

Arend van Spriel (5):
  nl80211: add request id in scheduled scan event messages
  nl80211: allow multiple active scheduled scan requests
  cfg80211: add request id parameter to .sched_scan_stop() signature
  cfg80211: add request id to cfg80211_sched_scan_results() api
  cfg80211: add request id in cfg80211_sched_scan_stopped{,_rtnl}() api

 drivers/net/wireless/ath/ath6kl/cfg80211.c         |   6 +-
 drivers/net/wireless/ath/ath6kl/wmi.c              |   2 +-
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |  12 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |   2 +-
 drivers/net/wireless/marvell/mwifiex/cfg80211.c    |  10 +-
 drivers/net/wireless/marvell/mwifiex/main.c        |   2 +-
 drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c |   2 +-
 drivers/net/wireless/marvell/mwifiex/sta_event.c   |   2 +-
 drivers/net/wireless/marvell/mwifiex/sta_ioctl.c   |   2 +-
 drivers/net/wireless/ti/wlcore/main.c              |   2 +-
 include/net/cfg80211.h                             |  34 +++--
 include/uapi/linux/nl80211.h                       |  12 +-
 net/mac80211/cfg.c                                 |   3 +-
 net/mac80211/pm.c                                  |   2 +-
 net/mac80211/scan.c                                |   4 +-
 net/mac80211/util.c                                |   2 +-
 net/wireless/core.c                                |  27 ++--
 net/wireless/core.h                                |  11 +-
 net/wireless/nl80211.c                             |  75 +++++++----
 net/wireless/nl80211.h                             |   3 +-
 net/wireless/rdev-ops.h                            |   8 +-
 net/wireless/scan.c                                | 141 +++++++++++++++------
 net/wireless/trace.h                               |  54 +++++---
 23 files changed, 286 insertions(+), 132 deletions(-)

-- 
1.9.1
