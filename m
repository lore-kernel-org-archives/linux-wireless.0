Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:54257 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751599Ab1EENA3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 May 2011 09:00:29 -0400
Received: by mail-ew0-f52.google.com with SMTP id 28so873869ewy.11
        for <linux-wireless@vger.kernel.org>; Thu, 05 May 2011 06:00:28 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, linville@tuxdriver.com
Subject: [PATCH 0/3] cfg80211/mac80211: implementation of scheduled scan
Date: Thu,  5 May 2011 16:00:16 +0300
Message-Id: <1304600420-24227-1-git-send-email-coelho@ti.com> (sfid-20110505_150043_084734_2F05A705)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Here's another version of my scheduled scan patches.  I think these are now
good enough.  I applied all comments by Johannes and added some improvements.
These are the main differences from RFCv2:

mac80211:
---------
* mac80211 checks if the driver has an op->sched_scan_start and sets
  the WIPHY_FLAG_SUPPORTS_SCHED_SCAN flag accordingly;
* fixed a typo;
* moved drv_sched_scan_results to api_sched_scan_results;
* removed SCAN_SCHED_SCANNING as a scan_attribute and moved it to
  a separate local boolean, so that it doesn't interfere with
  normal scan scenarios;
* there was on comment that the sched_scan was "eating" beacons for
  the whole time when it was scanning, but this doesn't apply anymore
  because of commit b23b025fe246f3acc2988eb6d400df34c27cb8ae changed
  the code so that beacons are passed up if they're on the operating
  channel (see ieee80211_scan_rx());
* fixed allocation failure bug when allocating sched_scan_ies;
* removed lock in ieee80211_sched_scan_results();
* don't return a value in sched_scan_stop;

cfg80211:
---------
* fixed documentation in nl80211 so that it's clear that if an empty
  SSID is passed (broadcast), we do broadcast probe_reqs and if no
  SSID is passed, we do a passive scan;
* removed max_sched_scan_ssids, now we use max_scan_ssids instead;
* added __cfg80211_stop_sched_scan() and call that from
  nl80211_stop_sched_scan(), wdev_cleanup_work() and
  NETDEV_GOING_DOWN;
* removed unnecessary dev_hold() in nl80211_start_sched_scan();
* added the NL80211_CMD_SCHED_SCAN_STOPPED event and an interface for
  the driver to stop the scan by itself;
* send a NL80211_CMD_SCHED_SCAN_STOPPED event instead of a
  NL80211_CMD_STOP_SCHED_SCAN when the scan is stopped by a
  NL80211_CMD_STOP_SCHED_SCAN command;
* don't return a value in sched_scan_stop;
* added a new patch to include the scan interval;
* a few minor cleanups.

There are still more things on my TODO list, but they're mostly improvements
and it will be much easier to add them step-by-step after this part is
included.  This version is already functional and ready to be used. ;)

Please review and let me know if there are still some problems for inclusion.

Cheers,
Luca.

Luciano Coelho (3):
  cfg80211/nl80211: add support for scheduled scans
  mac80211: add support for HW scheduled scan
  cfg80211/nl80211: add interval attribute for scheduled scans

 include/linux/nl80211.h     |   31 +++++
 include/net/cfg80211.h      |   59 ++++++++++
 include/net/mac80211.h      |   50 ++++++++
 net/mac80211/cfg.c          |   27 +++++
 net/mac80211/driver-ops.h   |   27 +++++
 net/mac80211/driver-trace.h |   81 +++++++++++++
 net/mac80211/ieee80211_i.h  |    9 ++
 net/mac80211/main.c         |    8 +-
 net/mac80211/rx.c           |    6 +-
 net/mac80211/scan.c         |   99 ++++++++++++++++
 net/wireless/core.c         |   12 ++-
 net/wireless/core.h         |    7 +
 net/wireless/nl80211.c      |  261 +++++++++++++++++++++++++++++++++++++++++++
 net/wireless/nl80211.h      |    4 +
 net/wireless/scan.c         |   62 ++++++++++
 15 files changed, 738 insertions(+), 5 deletions(-)

