Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:26141 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339AbZLaNiS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Dec 2009 08:38:18 -0500
Subject: [RFC PATCH v5 0/7] mac80211 client U-APSD support
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kalle.valo@iki.fi>
Cc: johannes@sipsolutions.net, a.young.jason@gmail.com
Date: Thu, 31 Dec 2009 15:37:05 +0200
Message-ID: <20091231133626.29899.95683.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

here is my proposal how to add U-APSD client support to mac80211. I
also included example driver implementation for wl1251.

Please comment. Also I would like to get comments how U-APSD needs to
be implemented in different hardware.

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
 include/linux/ieee80211.h                 |   27 +++++++
 include/net/mac80211.h                    |    7 ++
 net/mac80211/cfg.c                        |    7 ++
 net/mac80211/debugfs.c                    |   94 ++++++++++++++++++++++++++
 net/mac80211/ieee80211_i.h                |   24 ++++++-
 net/mac80211/main.c                       |    6 ++
 net/mac80211/mlme.c                       |   31 ++++++++
 net/mac80211/scan.c                       |   18 +++++
 net/mac80211/tx.c                         |  106 ++++++++++++++++++-----------
 net/mac80211/util.c                       |    2 +
 net/mac80211/work.c                       |   11 ++-
 12 files changed, 321 insertions(+), 49 deletions(-)

