Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:56115 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754105Ab1EITXL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 May 2011 15:23:11 -0400
Received: by mail-ew0-f46.google.com with SMTP id 4so2038254ewy.5
        for <linux-wireless@vger.kernel.org>; Mon, 09 May 2011 12:23:09 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	eliad@wizery.com
Subject: [PATCH v2 0/3]  cfg80211/mac80211: implementation of scheduled scan
Date: Mon,  9 May 2011 22:22:55 +0300
Message-Id: <1304968978-14319-1-git-send-email-coelho@ti.com> (sfid-20110509_212314_249368_4DF8C873)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

Here is my new version of the sched_scan patches after applying the review
comments.

The changes from v1 are:

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
 net/wireless/scan.c         |   62 ++++++++++
 15 files changed, 727 insertions(+), 23 deletions(-)

