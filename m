Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:55134 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686AbZBWQhy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Feb 2009 11:37:54 -0500
From: Kalle Valo <kalle.valo@nokia.com>
Subject: [RFC PATCH v1 0/3] mac80211: beacon filtering
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>
Date: Mon, 23 Feb 2009 18:37:17 +0200
Message-ID: <20090223163626.20939.4879.stgit@tikku> (sfid-20090223_173758_195526_BE5D0319)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here's my suggestion how to implement beacon filtering in mac80211.
The basic idea is simple, the driver enables filtering is whenever
mac80211 enables power save. Driver calls ieee80211_beacon_loss()
whenever hardware informs about beacon loss.

I have tested this with stlc45xx and based on simple tests this seems
to work. For reference I'll send stlc45xx patch as a followup.

TODO: 

o API documentation
o test with different hardwares (without beacon filtering) to 
  avoid regressions

---

Kalle Valo (3):
      mac80211: add beacon filtering support
      mac80211: track beacons separately from the rx path activity
      mac80211: decrease execution of the associated timer


 include/net/mac80211.h     |    2 +
 net/mac80211/ieee80211_i.h |    4 ++
 net/mac80211/iface.c       |    3 +
 net/mac80211/mlme.c        |  114 ++++++++++++++++++++++++++++++++------------
 net/mac80211/rx.c          |    9 +++
 5 files changed, 99 insertions(+), 33 deletions(-)

