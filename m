Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52346 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757413AbeD0FaM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Apr 2018 01:30:12 -0400
From: Tamizh chelvam <tamizhr@codeaurora.org>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Tamizh chelvam <tamizhr@codeaurora.org>
Subject: [RFCv2 0/6] cfg80211/mac80211: Add support to configure and monitor rssi/txrate threshold
Date: Fri, 27 Apr 2018 11:00:30 +0530
Message-Id: <1524807036-28056-1-git-send-email-tamizhr@codeaurora.org> (sfid-20180427_073019_249984_02AD8715)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patchsets introduced new NL command and api to support
configuring rssi and txrate for the connected stations.
And implemented new api to notify the threshold cross event.
This will be useful/requires for the user application like steering
to monitor station's activity change.

Tamizh chelvam (6):
  cfg80211: Add support to configure station specific rssi threshold for
    AP mode
  mac80211: Add support to configure rssi threshold for AP mode
  mac80211: Implement functionality to monitor station's rssi threshold
    cross
  cfg80211: Add support to configure station specific txrate threshold
    for AP mode
  mac80211: Add support to configure txrate threshold for station
  mac80211: Implement functionality to monitor txrate cross event for
    station

v2:
  * fixed kbuild warnings
  * updated commit log

 include/net/cfg80211.h       |  69 ++++++-
 include/net/mac80211.h       |  12 ++
 include/uapi/linux/nl80211.h |  96 +++++++++
 net/mac80211/cfg.c           | 111 +++++++++++
 net/mac80211/rx.c            |  65 +++++-
 net/mac80211/sta_info.h      |  37 ++++
 net/mac80211/status.c        |  40 +++-
 net/wireless/core.c          |  26 ++-
 net/wireless/core.h          |   6 +-
 net/wireless/nl80211.c       | 462 ++++++++++++++++++++++++++++++++++++++-----
 net/wireless/rdev-ops.h      |  48 +++++
 net/wireless/trace.h         | 123 ++++++++++++
 12 files changed, 1030 insertions(+), 65 deletions(-)

-- 
1.9.1
