Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:37855 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756695Ab1EKP7I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 May 2011 11:59:08 -0400
Received: by mail-ww0-f48.google.com with SMTP id 18so623493wwi.17
        for <linux-wireless@vger.kernel.org>; Wed, 11 May 2011 08:59:07 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	eliad@wizery.com
Subject: [PATCH v3 0/3] cfg80211/mac80211: implementation of scheduled scan
Date: Wed, 11 May 2011 17:09:34 +0300
Message-Id: <1305122977-6740-1-git-send-email-coelho@ti.com> (sfid-20110511_175943_000519_8DA8B8AC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I found a race condition in my previous patches when scan results where queued
and we got a stop request before processing them.  I have now fixed this by
checking whether we're scanning before sending results and by not queuing new
scan results after we have stopped.

Two new changes from v2:

* make sure we still have sched_scan_req when trying to send scan results;
* don't queue scan results events if the scheduled scan is not running;

And the previous changes, from v1 were:

* fixed @ssid description in cfg80211_sched_scan_request();
* cleaned the 'out_free' inside an else block;
* use a trace event class for sched_scan_start/_stop and hw_scan;
* a couple of patches sent separately with more common trace classes;
* removed the FIF_BCN_PRBRESP_PROMISC flag on sched_scanning;
* moved conditions a bit around in ieee80211_rx_h_passive_scan(), so the
  IEEE80211_RX_IN_SCAN flag is not needed in sched_scan;
* sent a separate patch not to drop skb->len < 24 frames in scans;
* fixed freeing the ies array when the sched_scan_start driver callback fails;


Cheers,
Luca.

Luciano Coelho (3):
  cfg80211/nl80211: add support for scheduled scans
  mac80211: add support for HW scheduled scan
  cfg80211/nl80211: add interval attribute for scheduled scans

 include/linux/nl80211.h     |   32 ++++++
 include/net/cfg80211.h      |   59 ++++++++++
 include/net/mac80211.h      |   50 ++++++++
 net/mac80211/cfg.c          |   27 +++++
 net/mac80211/driver-ops.h   |   29 +++++-
 net/mac80211/driver-trace.h |   88 ++++++++++++---
 net/mac80211/ieee80211_i.h  |    9 ++
 net/mac80211/main.c         |    6 +-
 net/mac80211/rx.c           |    6 +-
 net/mac80211/scan.c         |   99 ++++++++++++++++
 net/wireless/core.c         |   12 ++-
 net/wireless/core.h         |    7 +
 net/wireless/nl80211.c      |  260 +++++++++++++++++++++++++++++++++++++++++++
 net/wireless/nl80211.h      |    4 +
 net/wireless/scan.c         |   70 ++++++++++++
 15 files changed, 735 insertions(+), 23 deletions(-)

