Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48068 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S937766AbeE1NfE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 May 2018 09:35:04 -0400
From: Sriram R <srirrama@codeaurora.org>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Sriram R <srirrama@codeaurora.org>
Subject: [RFCv2 0/2] nl80211/mac80211 Add support for per-rate rx statistics
Date: Mon, 28 May 2018 19:04:37 +0530
Message-Id: <1527514479-6696-1-git-send-email-srirrama@codeaurora.org> (sfid-20180528_153606_306217_A06C48C0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patchset adds support for the collection and propagating of
per-rate, per-station rx statistics when subscribed by userspace applications.

These statistics can be useful in understanding the quality of 
communication with our peers and in evaluating how different peers
are communicating in different MCS/BW/NSS during different time periods and environment.

This patchset is based on the below implementation by Johannes, to publish the stats when
user space clients have subscribed and  dump and clear when a certain threshold 
of stats is reached.

http://thread.gmane.org/gmane.linux.kernel.wireless.general/133172

Few changes are made to the above implementation,
	1. Dynamic memory allocation of stats data structures
	2. Rate is encoded and used as key of hash table for scalablility.

Johannes Berg(1):
  nl80211: support per-rate/per-station statistics

Sriram R (1):
  mac80211: Add support for per-rate rx statistics

 include/net/cfg80211.h       |  51 +++++++++++
 include/uapi/linux/nl80211.h |  76 ++++++++++++++++
 net/mac80211/cfg.c           |  36 ++++++++
 net/mac80211/ieee80211_i.h   |   2 +
 net/mac80211/main.c          |   2 +
 net/mac80211/rx.c            |  10 +-
 net/mac80211/sta_info.c      | 212 +++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/sta_info.h      |  20 ++++
 net/wireless/core.c          |  18 ++++
 net/wireless/nl80211.c       | 175 ++++++++++++++++++++++++++++++++---
 net/wireless/nl80211.h       |  14 +++
 net/wireless/rdev-ops.h      |  10 ++
 net/wireless/trace.h         |  15 +++
 13 files changed, 626 insertions(+), 15 deletions(-)

-- 
2.7.4
