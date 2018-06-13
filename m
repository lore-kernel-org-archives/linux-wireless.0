Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47452 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933498AbeFMKqM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Jun 2018 06:46:12 -0400
From: Tamizh chelvam <tamizhr@codeaurora.org>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Tamizh chelvam <tamizhr@codeaurora.org>
Subject: [PATCH 0/7] cfg80211/mac80211: Add support to configure and monitor rssi threshold
Date: Wed, 13 Jun 2018 16:15:40 +0530
Message-Id: <1528886747-26342-1-git-send-email-tamizhr@codeaurora.org> (sfid-20180613_124617_763223_F378FBB2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patchsets introduced new NL command and api to support
configuring rssi for the connected stations and api to notify
userspace application upon crossing the configured threshold.
This will be useful for the application which requires
station's current capability change information.

Tamizh chelvam (7):
  wireless: Change single cqm_config to rssi config list
  cfg80211: Add new NL command to configure peer specific rssi
    threshold
  mac80211: Add api to support configuring station specific rssi
    threshold
  cfg80211: Add support to notify station's rssi level crossing
  mac80211: Implement functionality to monitor station's rssi cross
    event
  cfg80211: Accept multiple RSSI threholds for STA_MON command
  mac80211: Add api to configure low and high RSSI threshold

 include/net/cfg80211.h       |   42 ++++-
 include/net/mac80211.h       |    6 +
 include/uapi/linux/nl80211.h |   60 +++++++
 net/mac80211/cfg.c           |   75 +++++++++
 net/mac80211/rx.c            |   65 +++++++-
 net/mac80211/sta_info.h      |   22 +++
 net/wireless/core.c          |   29 +++-
 net/wireless/core.h          |    6 +-
 net/wireless/nl80211.c       |  377 ++++++++++++++++++++++++++++++++++++------
 net/wireless/rdev-ops.h      |   31 ++++
 net/wireless/trace.h         |   73 ++++++++
 11 files changed, 723 insertions(+), 63 deletions(-)

-- 
1.7.9.5
