Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lpdvsmtp01.broadcom.com ([192.19.211.62]:60078 "EHLO
        relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751705AbdAMMr4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Jan 2017 07:47:56 -0500
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [RFC 0/5] cfg80211: support multiple scheduled scans
Date: Fri, 13 Jan 2017 12:47:39 +0000
Message-Id: <1484311664-4840-1-git-send-email-arend.vanspriel@broadcom.com> (sfid-20170113_134859_314820_1470F0A6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After sending out the initial RFC for multiple scheduled scan support [1]
here a series that deal with it all (I hope) so including events and the
driver function call apis.

It is applies to the master branch of the mac80211-next repository.

Arend van Spriel (5):
  nl80211: allow multiple active scheduled scan requests
  nl80211: include request id in scheduled scan event messages
  cfg80211: add request id parameter to .sched_scan_stop() signature
  cfg80211: add request id to cfg80211_sched_scan_results() api
  cfg80211: add request id in cfg80211_sched_scan_stopped{,_rtnl}() api

 drivers/net/wireless/ath/ath6kl/cfg80211.c         |   4 +-
 drivers/net/wireless/ath/ath6kl/wmi.c              |   2 +-
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |  10 +-
 drivers/net/wireless/marvell/mwifiex/cfg80211.c    |   8 +-
 drivers/net/wireless/marvell/mwifiex/main.c        |   2 +-
 drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c |   2 +-
 drivers/net/wireless/marvell/mwifiex/sta_event.c   |   2 +-
 drivers/net/wireless/marvell/mwifiex/sta_ioctl.c   |   2 +-
 include/net/cfg80211.h                             |  32 +++--
 include/uapi/linux/nl80211.h                       |  12 +-
 net/mac80211/cfg.c                                 |   3 +-
 net/mac80211/pm.c                                  |   2 +-
 net/mac80211/scan.c                                |   4 +-
 net/mac80211/util.c                                |   2 +-
 net/wireless/core.c                                |  31 +++--
 net/wireless/core.h                                |  11 +-
 net/wireless/nl80211.c                             |  62 +++++++---
 net/wireless/nl80211.h                             |   3 +-
 net/wireless/rdev-ops.h                            |   8 +-
 net/wireless/scan.c                                | 135 +++++++++++++++------
 net/wireless/trace.h                               |  54 ++++++---
 21 files changed, 271 insertions(+), 120 deletions(-)

--
1.9.1
