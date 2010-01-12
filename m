Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:44848 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753156Ab0ALInF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jan 2010 03:43:05 -0500
Subject: [PATCH PATCH v6 0/7] mac80211 client U-APSD support
To: linville@tuxdriver.com
From: Kalle Valo <kalle.valo@iki.fi>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	a.young.jason@gmail.com
Date: Tue, 12 Jan 2010 10:42:23 +0200
Message-ID: <20100112084059.27492.86738.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

here is my proposal how to add U-APSD client support to mac80211. I
also included example driver implementation for wl1251.

Patches should be ready now.

v6:
o store max SP length value in unconverted format and shift is just
  before use (suggested by Johannes)

v5:
o rename IEEE80211_HW_UAPSD to IEEE80211_HW_SUPPORTS_UAPSD
o U-APSD queue and max SP length configuration debugfs interface
  (requested by Jason)
o dynamic ps support for U-APSD
o by default enable U-APSD in all queues
o back to RFC state due to new code
o add a warning if both PS_NULLFUNC_STACK and U-APSD are enabled
o wl1251: set qos null data template
o more defines to ieee80211.h

v4:
o use IEEE80211_WMM_IE_STA_QOSINFO prefix in ieee80211.h (Jason Young)
o fix VI and BK qosinfo values in ieee80211.h (Jason Young)
o add IEEE80211_WMM_IE_AP_QOSINFO_UAPSD

v3:
o remove unnecessary debugfs interface, people can recompile mac80211
  in case they want to try enable more queues
o add max SP length defines to ieee80211.h
o removed unnecessary code comments

v2:
o remove cfg80211 changes
o rename IEEE80211_QOS_IE to IEEE80211_WMM_IE_STA in ieee80211.h

---

Kalle Valo (7):
      mac80211: add U-APSD client support
      mac80211: add debugfs interface for U-APSD queue configuration
      mac80211: create tx handler for dynamic ps
      mac80211: check uapsd state for dynamic power save
      ieee80211: add struct ieee80211_hdr_qos
      wl1251: create qos null data template
      wl1251: add U-APSD support


 drivers/net/wireless/wl12xx/wl1251_main.c |   37 +++++++++-
 include/linux/ieee80211.h                 |   28 ++++++++
 include/net/mac80211.h                    |    7 ++
 net/mac80211/cfg.c                        |    7 ++
 net/mac80211/debugfs.c                    |   94 ++++++++++++++++++++++++++
 net/mac80211/ieee80211_i.h                |   27 +++++++
 net/mac80211/main.c                       |    6 ++
 net/mac80211/mlme.c                       |   31 ++++++++
 net/mac80211/scan.c                       |   18 +++++
 net/mac80211/tx.c                         |  106 ++++++++++++++++++-----------
 net/mac80211/util.c                       |    2 +
 net/mac80211/work.c                       |   12 +++
 12 files changed, 326 insertions(+), 49 deletions(-)

