Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mgw-da01.ext.nokia.com ([147.243.128.24]:26100 "EHLO
	mgw-da01.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757381Ab0KAMZ7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Nov 2010 08:25:59 -0400
Received: from localhost.localdomain (chilepepper.research.nokia.com [172.21.50.167])
	by mgw-da01.nokia.com (Switch-3.4.3/Switch-3.4.3) with ESMTP id oA1BqGcC020116
	for <linux-wireless@vger.kernel.org>; Mon, 1 Nov 2010 13:52:16 +0200
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linux-wireless@vger.kernel.org
Subject: [RFC 00/15] Implementation of periodic scan
Date: Mon,  1 Nov 2010 13:52:01 +0200
Message-Id: <1288612336-2830-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

This patcheset implements initial support for hardware offloaded periodic
scan support.  When this is used, the hardware is able to perform scans
automatically at certain intervals without waking up the host, which can
potentially save power.

The hardware can also automatically filter results and only report desired
results to the host.  Currently, this patchset supports only filtering on
SSIDs.  In the future, support for filtering on RSSI and SNR thresholds can
be added.  This set doesn't support variable intervals, and the intervals
need to be configure in the hw driver.

This functionality is based on the periodic scan feature supported by the
wl1271 firmware.

This is an initial implementation and I'd like to get some comments before
submitting the final version.

I've split the implementation in many small patches, just to keep it clear
and due to the zillions of times I've had to task switch while implementing
this.  I can merge some of them, if that makes things cleaner.

Cheers,
Luca.


Luciano Coelho (15):
  nl80211: add periodic scan commands
  cfg80211: add periodic scan request structure
  nl80211: alloc and free the periodic_req data
  cfg80211: add periodic scan start and stop ops
  nl80211: call periodic_start and periodic_stop
  mac80211: add support for HW periodic scan
  cfg80211: add periodic scan results handler
  nl80211: report periodic scan results
  cfg80211: add channel support to periodic scan
  nl80211: add channel support to the periodic scan
  mac80211: pass cfg80211 periodic scan request structure down to the
    driver
  cfg80211: add ssid support to periodic scan
  nl80211: add ssid filtering support to the periodic scan
  cfg80211: add ie support for periodic scans
  mac80211: create and pass the ies for each band in periodic scans

 include/linux/nl80211.h     |    8 ++
 include/net/cfg80211.h      |   44 +++++++
 include/net/mac80211.h      |   15 +++
 net/mac80211/cfg.c          |   26 ++++
 net/mac80211/driver-ops.h   |   27 ++++
 net/mac80211/driver-trace.h |   63 ++++++++++
 net/mac80211/ieee80211_i.h  |    8 ++
 net/mac80211/rx.c           |    4 +-
 net/mac80211/scan.c         |   82 +++++++++++++
 net/wireless/core.c         |    1 +
 net/wireless/core.h         |    3 +
 net/wireless/nl80211.c      |  278 +++++++++++++++++++++++++++++++++++++++++++
 net/wireless/nl80211.h      |    4 +
 net/wireless/scan.c         |   20 +++
 14 files changed, 582 insertions(+), 1 deletions(-)

