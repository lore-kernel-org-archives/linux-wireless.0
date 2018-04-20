Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:35852 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752725AbeDTGya (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 20 Apr 2018 02:54:30 -0400
From: Tamizh chelvam <tamizhr@codeaurora.org>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Tamizh chelvam <tamizhr@codeaurora.org>
Subject: [RFC 0/6] cfg80211/mac80211: enable rssi/txrate threshold config for AP mode
Date: Fri, 20 Apr 2018 12:22:45 +0530
Message-Id: <1524207171-3325-1-git-send-email-tamizhr@codeaurora.org> (sfid-20180420_085434_896613_B7C60A1C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patchsets introduced new NL command and api to support
configuring rssi and txrate for the connected stations.
And implemented new api to notify the threshold cross event.
This will be useful/requires for the user application like steering
to monitor station's activity change.

Tamizh chelvam (6):
  cfg80211: enable setting rssi threshold config for AP mode
  mac80211: enable setting rssi threshold config for AP mode
  mac80211: implement station's rssi check using rx data signal
  cfg80211: Add support to config station tx rate threshold
  mac80211: Add support to configure txrate threshold for station
  mac80211: Implement cqm txrate range check for a station

 include/net/cfg80211.h       |  68 ++++++-
 include/net/mac80211.h       |  12 ++
 include/uapi/linux/nl80211.h |  95 +++++++++
 net/mac80211/cfg.c           | 111 +++++++++++
 net/mac80211/rx.c            |  65 +++++-
 net/mac80211/sta_info.h      |  32 +++
 net/mac80211/status.c        |  40 +++-
 net/wireless/core.c          |  26 ++-
 net/wireless/core.h          |   6 +-
 net/wireless/nl80211.c       | 462 ++++++++++++++++++++++++++++++++++++++-----
 net/wireless/rdev-ops.h      |  48 +++++
 net/wireless/trace.h         | 123 ++++++++++++
 12 files changed, 1023 insertions(+), 65 deletions(-)

-- 
1.9.1
