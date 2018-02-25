Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:54098 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751619AbeBYHuC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 25 Feb 2018 02:50:02 -0500
From: Tamizh chelvam <tamizhr@codeaurora.org>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Tamizh chelvam <tamizhr@codeaurora.org>
Subject: [PATCHv4 0/3] cfg80211/mac80211: cqm rssi config for AP mode
Date: Sun, 25 Feb 2018 13:19:55 +0530
Message-Id: <1519544998-2621-1-git-send-email-tamizhr@codeaurora.org> (sfid-20180225_085010_082741_A62F0B4D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tamizh chelvam <tamizhr@codeaurora.org>

Currently station mode has the support of rssi based cqm. This patchsets
extended the support for AP mode as well. Already netlink accepts mac
address in cqm notification event. We can use that to pass mac address of
the station to specify its rssi change event. This patchsets introduce
new api cfg80211_ap_sta_cqm_notify and multicast group to notify the event.

Pradeep Kumar Chitrapu (1):
  mac80211: enable setting cqm rssi config for AP mode

Tamizh chelvam (2):
  cfg80211: enable setting cqm rssi config for AP mode
  mac80211: implement cqm rssi check using rx data signal

v4:
  * Fixed compilation warning of missing description for count_rx_signal
    and last_cqm_event_signal.

v3:
  * Added vif type check to avoid enable this feature for all mode.

V2:
  * Removed changing existing ieee80211_cqm_rssi_notify api changes.
  * Introduced new ext feature bit and multicast group id to support this
    feature.

 include/net/cfg80211.h       |   15 +++++++++
 include/net/mac80211.h       |    7 +++++
 include/uapi/linux/nl80211.h |    6 ++++
 net/mac80211/cfg.c           |   31 ++++++++++++------
 net/mac80211/rx.c            |   46 ++++++++++++++++++++++++++-
 net/mac80211/sta_info.h      |    9 ++++++
 net/wireless/nl80211.c       |   71 ++++++++++++++++++++++++++++++++++++------
 7 files changed, 164 insertions(+), 21 deletions(-)

-- 
1.7.9.5
