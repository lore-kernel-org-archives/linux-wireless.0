Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40746 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751184AbeC0IoL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Mar 2018 04:44:11 -0400
From: Vasanthakumar Thiagarajan <vthiagar@codeaurora.org>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Vasanthakumar Thiagarajan <vthiagar@codeaurora.org>
Subject: [RFC 0/4] wireless: Per-sta NoAck and offload support
Date: Tue, 27 Mar 2018 14:12:47 +0530
Message-Id: <1522140171-10926-1-git-send-email-vthiagar@codeaurora.org> (sfid-20180327_104417_473651_4C187515)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Adds infrastructure for driver to offload NoAck functionality, driver
like ath10k could make use of it. Also extends the current ndev wide
NoAck policy to per-station, with sta level NoAck policy configuration
userspace could selectively turn off/on Noack based on various connection
parameters of the station.

Vasanthakumar Thiagarajan (4):
  mac80211: Add NoAck policy functionality offload infrastructure
  nl80211/mac80211: Extend NoAck policy command with peer MAC address
  mac80211: Apply per-peer NoAck tid bitmap configuration
  mac80211: Advertise per-peer NoAck policy support

 include/net/cfg80211.h       |  9 +++++++--
 include/net/mac80211.h       | 18 ++++++++++++++++++
 include/uapi/linux/nl80211.h | 12 +++++++++++-
 net/mac80211/cfg.c           | 45 +++++++++++++++++++++++++++++++++++++++++---
 net/mac80211/debugfs.c       |  1 +
 net/mac80211/driver-ops.h    | 22 ++++++++++++++++++++++
 net/mac80211/iface.c         |  4 ++++
 net/mac80211/main.c          |  8 ++++++++
 net/mac80211/sta_info.h      |  3 +++
 net/mac80211/trace.h         | 28 +++++++++++++++++++++++++++
 net/mac80211/tx.c            |  3 ++-
 net/mac80211/wme.c           | 35 +++++++++++++++++++++++++++++++++-
 net/wireless/nl80211.c       | 12 +++++++++++-
 net/wireless/rdev-ops.h      |  7 ++++---
 net/wireless/trace.h         | 11 +++++++----
 15 files changed, 202 insertions(+), 16 deletions(-)

-- 
1.9.1
