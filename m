Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34210 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934063AbeBMJVd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Feb 2018 04:21:33 -0500
From: Tamizh chelvam <tamizhr@codeaurora.org>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Tamizh chelvam <tamizhr@codeaurora.org>
Subject: [PATCHv2 0/3] cfg80211/mac80211: cqm rssi config for AP mode
Date: Tue, 13 Feb 2018 14:50:55 +0530
Message-Id: <1518513656-22324-1-git-send-email-tamizhr@codeaurora.org> (sfid-20180213_102140_068579_2E4DC24D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tamizh chelvam <tamizhr@codeaurora.org>

Currently station mode has the support of rssi based cqm. This patchsets
extended the support for AP mode as well. Already netlink accepts mac
address in cqm notification event. We can use that to pass mac address of
the station to specify its rssi change event. This patchsets introduce
new api cfg80211_ap_sta_cqm_notify and multicast group to notify the event.

Pradeep Kumar Chitrapu (1):
  mac80211: enable setting cqm rssi c onfig for AP mode

Tamizh chelvam (2):
  cfg80211: enable setting cqm rssi config for AP mode
  mac80211: implement cqm rssi check using rx data signal

V2:
  * Removed changing existing ieee80211_cqm_rssi_notify api changes.
  * Introduced new ext feature bit and multicast group id to support this
    feature.

 include/net/cfg80211.h       |   15 ++++++++++
 include/net/mac80211.h       |    7 +++++
 include/uapi/linux/nl80211.h |    6 ++++
 net/mac80211/cfg.c           |   31 ++++++++++++-------
 net/mac80211/rx.c            |   46 +++++++++++++++++++++++++++-
 net/mac80211/sta_info.h      |    3 ++
 net/wireless/nl80211.c       |   68 +++++++++++++++++++++++++++++++++++-------
 7 files changed, 155 insertions(+), 21 deletions(-)

-- 
1.7.9.5
