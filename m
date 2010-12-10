Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:25819 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755805Ab0LJPGA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Dec 2010 10:06:00 -0500
From: luciano.coelho@nokia.com
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [RFC v2 0/2] implementation of scheduled scan
Date: Fri, 10 Dec 2010 17:07:10 +0200
Message-Id: <1291993632-6921-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@nokia.com>

Hi,

So, here's my second RFC for the scheduled scan implementation (which we used
to call periodic scan earlier).  I have applied all Johannes's comments, except
for two things:

* I kept the return value in the sched_scan_stop chain, because, at least with
  wl12xx, the call can fail (due to OOM for instance).  I think it's cleaner
  this way.

* I have not implemented support for passing the scan interval from userspace
  yet.  I'll work on it next week and send it as a separate patch.

One of the main things you'll notice is that I merged the patches into two
patches instead of 15, which caused some people to whip me before.  :P

Please give me some comments, if you have the time (and bother).

Cheers,
Luca.

Luciano Coelho (2):
  cfg80211/nl80211: add support for scheduled scans
  mac80211: add support for HW scheduled scan

 include/linux/nl80211.h     |    9 ++
 include/net/cfg80211.h      |   48 ++++++++
 include/net/mac80211.h      |   40 +++++++
 net/mac80211/cfg.c          |   26 ++++
 net/mac80211/driver-ops.h   |   30 +++++
 net/mac80211/driver-trace.h |   63 ++++++++++
 net/mac80211/ieee80211_i.h  |    8 ++
 net/mac80211/rx.c           |    4 +-
 net/mac80211/scan.c         |   80 +++++++++++++
 net/wireless/core.c         |    6 +
 net/wireless/core.h         |    3 +
 net/wireless/nl80211.c      |  271 +++++++++++++++++++++++++++++++++++++++++++
 net/wireless/nl80211.h      |    6 +
 net/wireless/scan.c         |   18 +++
 14 files changed, 611 insertions(+), 1 deletions(-)

