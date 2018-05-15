Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36774 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752044AbeEOFS1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 May 2018 01:18:27 -0400
From: Sriram R <srirrama@codeaurora.org>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Sriram R <srirrama@codeaurora.org>
Subject: [RFC 0/2] nl80211/mac80211 Add support for per-rate rx statistics
Date: Tue, 15 May 2018 10:47:59 +0530
Message-Id: <1526361481-7159-1-git-send-email-srirrama@codeaurora.org> (sfid-20180515_071835_449483_BBA9A04F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patchset adds support for the collection and propagating of
per-rate, per-station rx statistics when enabled by a userspace application.

These statistics can be useful in understanding the quality of 
communication with our peers and in evaluating how different peers
are communicating in different MCS/BW/NSS during different time periods and environment.

Sriram R (2):
  nl80211: Add support for collection of per rate rx statistics
  mac80211: Add support for per-rate rx statistics

 include/net/cfg80211.h       |  25 +++++++
 include/uapi/linux/nl80211.h |  50 +++++++++++++
 net/mac80211/cfg.c           |  47 ++++++++++++
 net/mac80211/rx.c            |  10 ++-
 net/mac80211/sta_info.c      | 165 +++++++++++++++++++++++++++++++++++++++++
 net/mac80211/sta_info.h      |  17 +++++
 net/wireless/nl80211.c       | 172 +++++++++++++++++++++++++++++++++++++++++++
 net/wireless/rdev-ops.h      |  30 ++++++++
 net/wireless/trace.h         |  26 +++++++
 9 files changed, 540 insertions(+), 2 deletions(-)

-- 
2.7.4
