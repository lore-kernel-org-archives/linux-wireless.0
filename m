Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:52198 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753135AbZCNROt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Mar 2009 13:14:49 -0400
From: Kalle Valo <kalle.valo@nokia.com>
Subject: [RFC PATCH v2 0/4] mac80211: beacon filtering
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>, Jouni Malinen <j@w1.fi>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Sat, 14 Mar 2009 19:14:24 +0200
Message-ID: <20090314171234.11126.21125.stgit@tikku> (sfid-20090314_181450_773691_61C57AD2)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here's my proposal how to implement beacon filtering in mac80211. The
basic idea is simple, the driver enables filtering whenever mac80211
enables power save and the driver calls ieee80211_beacon_loss()
whenever hardware informs about beacon loss.

I have tested this with stlc45xx and based on simple tests this seems
to work. For reference I earlier sent stlc45xx patch to this list.

v2:
o rebase to 2.6.29-rc7-wl
o rename ieee80211_rx_trigger() to ieee80211_sta_rx_notify()
o move check for sta mode in ieee80211_sta_rx_notify() to rx.c
o move unicast check from rx.c to ieee80211_sta_rx_notify()
o add comment for setting last_beacon in ieee80211_rx_mgmt_assoc_resp()
o rename IEEE80211_HW_BEACON_FILTERING to IEEE80211_HW_BEACON_FILTER
o send probe request from ieee80211_beacon_loss_work()
o API documentation
o enable beacon filtering only when power save is enabled
o disable power save (and hence beacon filtering) while scanning to make 
  it possible to have reliable scan results even when beacon filtering
  is enabled

TODO: 

o test with different hardware (without beacon filtering) to 
  avoid regressions

---

Kalle Valo (4):
      mac80211: add beacon filtering support
      mac80211: disable power save when scanning
      mac80211: track beacons separately from the rx path activity
      mac80211: decrease execution of the associated timer


 include/net/mac80211.h     |   30 +++++++++--
 net/mac80211/ieee80211_i.h |    5 ++
 net/mac80211/iface.c       |    3 +
 net/mac80211/mlme.c        |  124 +++++++++++++++++++++++++++++++++-----------
 net/mac80211/rx.c          |    9 +++
 net/mac80211/scan.c        |   54 ++++++++++++++++++-
 6 files changed, 185 insertions(+), 40 deletions(-)

