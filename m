Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:51730 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339AbZCVT5c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Mar 2009 15:57:32 -0400
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH v4 0/5] mac80211: beacon filtering
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>, Jouni Malinen <j@w1.fi>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linux-wireless@vger.kernel.org
Date: Sun, 22 Mar 2009 21:56:59 +0200
Message-ID: <20090322195619.26460.48292.stgit@tikku> (sfid-20090322_205736_404068_42654ECD)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here's my proposal how to implement beacon filtering in mac80211. The
basic idea is simple, the driver enables filtering whenever mac80211
enables power save and the driver calls ieee80211_beacon_loss()
whenever hardware informs about beacon loss.

I have tested this with stlc45xx (with beacon filtering) and iwl3945
(without beacon filtering) and based on simple tests this seems to
work. For reference I'll send the stlc45xx patch as a followup.

v4:

o remove hw parameter from ieee80211_beacon_loss()
o don't call the patchset RFC anymore

v3:
o rebase to 2.6.29-rc8-wl
o add cfg80211_hold_bss() and cfg80211_unhold_bss() to avoid loosing
  the bss struct when beacon filter is enabled
o fix bug to use !IEEE80211_HW_PS_NULLFUNC_STACK both in
  ieee80211_scan_ps_enable() and ieee80211_scan_ps_disable(), also
  improve comments
o fix the indentation in ieee80211_associated(), not visible in patch
  anymore:

    mod_timer(&ifmgd->timer, jiffies +
    -				      IEEE80211_MONITORING_INTERVAL);
    +			  IEEE80211_MONITORING_INTERVAL);

o add vif parameter to void ieee80211_beacon_loss()
o more documentation about filtering, and especially about
  checksumming
o document why multicast check is needed in ieee80211_sta_rx_notify()
o beacon filter is only enabled when power save is enabled, take this
  into account in ieee80211_associated()

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

(none)

For the future:

o configuration for beacon filter (beacon misses * beacon interval
  should be constant?)
o don't run ieee80211_associated() in data idle period

---

Kalle Valo (5):
      mac80211: add beacon filtering support
      cfg80211: add feature to hold bss
      mac80211: disable power save when scanning
      mac80211: track beacons separately from the rx path activity
      mac80211: decrease execution of the associated timer


 Documentation/DocBook/mac80211.tmpl |    6 ++
 include/net/cfg80211.h              |   18 +++++
 include/net/mac80211.h              |   45 ++++++++++-
 net/mac80211/ieee80211_i.h          |    5 +
 net/mac80211/iface.c                |    3 +
 net/mac80211/mlme.c                 |  139 +++++++++++++++++++++++++++--------
 net/mac80211/rx.c                   |    9 ++
 net/mac80211/scan.c                 |   64 ++++++++++++++++
 net/wireless/core.h                 |    2 +
 net/wireless/scan.c                 |   27 +++++++
 10 files changed, 278 insertions(+), 40 deletions(-)

