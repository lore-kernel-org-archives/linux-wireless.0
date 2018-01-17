Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:32880 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752357AbeAQHec (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Jan 2018 02:34:32 -0500
From: tamizhr@codeaurora.org
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, tamizhr@qti.qualcomm.com,
        Tamizh chelvam <tamizhr@codeaurora.org>
Subject: [PATCH 0/4] cfg80211/mac80211: cqm rssi config for AP mode
Date: Wed, 17 Jan 2018 13:01:12 +0530
Message-Id: <1516174276-16789-1-git-send-email-tamizhr@codeaurora.org> (sfid-20180117_083446_596303_AE7E322F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tamizh chelvam <tamizhr@codeaurora.org>

Currently station mode has the support of rssi based cqm. This patchsets
extended the support for AP mode as well. Already netlink accepts mac
address in cqm notification event. We can use that to pass mac address of
the station to specify its rssi change event and bssid will be passed for
STA mode. This patchset changes cfg80211_cqm_rssi_notify and
ieee80211_cqm_rssi_notify apis to accepts mac address. RSSI config is
common for all the stations in bss.

Pradeep Kumar Chitrapu (3):
  wireless: allow send peer mac in rssi cqm notify
  cfg80211: enable setting cqm config for AP mode
  mac80211: enable setting cqm config for AP mode

Tamizh chelvam (1):
  mac80211: implement cqm using rx data signal

 drivers/net/wireless/intel/iwlwifi/mvm/rx.c      |  4 +--
 drivers/net/wireless/marvell/mwifiex/sta_event.c |  4 +--
 drivers/net/wireless/rndis_wlan.c                |  2 +-
 drivers/net/wireless/rsi/rsi_91x_mac80211.c      |  2 +-
 drivers/net/wireless/st/cw1200/sta.c             |  4 ++-
 drivers/net/wireless/ti/wl1251/event.c           |  4 +--
 drivers/net/wireless/ti/wlcore/event.c           |  5 +--
 include/net/cfg80211.h                           |  3 +-
 include/net/mac80211.h                           | 10 +++++-
 net/mac80211/cfg.c                               | 32 ++++++++++++------
 net/mac80211/mlme.c                              | 14 ++++----
 net/mac80211/rx.c                                | 43 +++++++++++++++++++++++-
 net/mac80211/sta_info.h                          |  3 ++
 net/mac80211/trace.h                             | 11 +++---
 net/wireless/nl80211.c                           | 11 +++---
 net/wireless/trace.h                             | 12 ++++---
 16 files changed, 121 insertions(+), 43 deletions(-)

-- 
1.9.1
