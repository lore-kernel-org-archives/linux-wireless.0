Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([198.47.19.12]:49427 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750776AbcHRH3k (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Aug 2016 03:29:40 -0400
From: Maxim Altshul <maxim.altshul@ti.com>
To: <linux-wireless@vger.kernel.org>
CC: <kvalo@codeaurora.org>, <johannes@sipsolutions.net>,
	Maxim Altshul <maxim.altshul@ti.com>
Subject: [PATCH 0/3] IOP RX BA session issues
Date: Thu, 18 Aug 2016 10:36:24 +0300
Message-ID: <20160818073627.30972-1-maxim.altshul@ti.com> (sfid-20160818_092943_235565_9AFD6E6E)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some background: 

There exist some devices (latest mobile phones and some AP's e.g LG G4 H815, 
Samsung Galaxy S5 G900H) that tend to not respect a BA 
sessions maximum size (in Kbps). 

These devices won't respect the AMPDU size that was negotiated 
during associasion (even though they do respect the maximal number of packets).

This violation is characterized by a valid number of 
packets in a single AMPDU who all have the same size.
Even so, the total size will exceed the size negotiated during association.

Eventually, this will cause some undefined behavior, 
which in turn causes the hw to drop packets, causing the throughput to plummet.

The fix is separated to 3 patches:
wlcore patches (patches 2+3):
Add a functionality in which the firmware is able 
to notify the driver that the aggregation window size 
must be changed, and in turn the driver will notify mac80211.

mac80211 patch (patch 1) which will:
a. Make the subframe limitation to be held by each station, 
instead of being held only by hw.
b. Create an api for the driver to call which will remove all violating
BA sessions with a specific peer.

Reopening the BA sessions with a different size will limit the aggregation 
window size, which will in turn limit the maximum size in bytes of the whole aggregation.

I hope that the commit messages are clear enough, and if not then I will change them upon request.

Maxim Altshul (3):
  mac80211: RX BA support for sta max_rx_aggregation_subframes
  wlcore: Pass win_size taken from ieee80211_sta to FW
  wlcore: Add RX_BA_WIN_SIZE_CHANGE_EVENT event

 drivers/net/wireless/ti/wl18xx/event.c | 22 ++++++++++++++++++++++
 drivers/net/wireless/ti/wl18xx/event.h |  1 +
 drivers/net/wireless/ti/wl18xx/main.c  |  3 ++-
 drivers/net/wireless/ti/wlcore/acx.c   |  5 +++--
 drivers/net/wireless/ti/wlcore/acx.h   |  3 ++-
 drivers/net/wireless/ti/wlcore/main.c  |  6 ++++--
 include/net/mac80211.h                 | 22 ++++++++++++++++++++++
 net/mac80211/agg-rx.c                  | 31 +++++++++++++++++++++++++++----
 net/mac80211/ht.c                      | 18 ++++++++++++++++++
 net/mac80211/sta_info.c                |  3 +++
 10 files changed, 104 insertions(+), 10 deletions(-)

-- 
2.9.0
