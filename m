Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53924 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932075AbeE3TLB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 May 2018 15:11:01 -0400
From: Tamizh chelvam <tamizhr@codeaurora.org>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Tamizh chelvam <tamizhr@codeaurora.org>
Subject: [RFCv3 0/4] cfg80211/mac80211: Add support to configure and monitor txrate threshold
Date: Thu, 31 May 2018 00:40:46 +0530
Message-Id: <1527707450-2985-1-git-send-email-tamizhr@codeaurora.org> (sfid-20180530_211105_696299_F04419B7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patchsets introduced new NL command and api to support
configuring txrate threshold for the connected stations and api to
notify userspace application upon crossing the configured txrate threshold.
This will be useful for the application which requires
station's current capability change information.

Tamizh chelvam (4):
  cfg80211: Add support to configure station specific txrate threshold
  mac80211: Add api to configure low and high txrate threshold
  cfg80211: Add support to notify station's txrate crossing event
  mac80211: Implement functionality to monitor txrate cross event for a
    station

Note:
  * This patch rebased on top of below patchset
    [RFCv3 0/7] cfg80211/mac80211: Add support to configure and monitor rssi threshold

v3:
  * splitted txrate patchsets as a different patchsets.

v2:
  * fixed kbuild warnings
  * updated commit log

 include/net/cfg80211.h       | 26 +++++++++++++++
 include/net/mac80211.h       |  5 +++
 include/uapi/linux/nl80211.h | 34 ++++++++++++++++++++
 net/mac80211/cfg.c           | 36 +++++++++++++++++++++
 net/mac80211/sta_info.h      | 17 ++++++++++
 net/mac80211/status.c        | 40 ++++++++++++++++++++++-
 net/wireless/nl80211.c       | 76 ++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/rdev-ops.h      | 17 ++++++++++
 net/wireless/trace.h         | 50 +++++++++++++++++++++++++++++
 9 files changed, 300 insertions(+), 1 deletion(-)

-- 
1.9.1
