Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:61675 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752786AbZK0OHt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Nov 2009 09:07:49 -0500
Received: from esebh106.NOE.Nokia.com (esebh106.ntc.nokia.com [172.21.138.213])
	by mgw-mx09.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id nARE7n54025427
	for <linux-wireless@vger.kernel.org>; Fri, 27 Nov 2009 08:07:54 -0600
Received: from [127.0.1.1] (essapo-nirac2521.europe.nokia.com [10.162.252.1])
	by mgw-da01.ext.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id nARE7o9G019850
	for <linux-wireless@vger.kernel.org>; Fri, 27 Nov 2009 16:07:51 +0200
Subject: [RFC PATCH v1 0/4] mac80211 client U-APSD support
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kalle.valo@iki.fi>
Date: Fri, 27 Nov 2009 16:07:49 +0200
Message-ID: <20091127140700.2847.42426.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

here is my suggestion how to add U-APSD client support to mac80211. I
also included example driver implementation for wl1251.

Most probably I will drop patch 1 and fold patches 2 and 3, but I keep
them all in for now to make it easier to change things.

Please comment. Also I would like to get comments how U-APSD needs to
be implemented in different hardware.

---

Kalle Valo (4):
      cfg80211: add U-APSD support
      mac80211: add U-APSD support
      mac80211: add debugfs interface for U-APSD queue configuration
      wl1251: add U-APSD support


 drivers/net/wireless/wl12xx/wl1251_main.c |   12 ++++++--
 include/linux/ieee80211.h                 |    5 ++++
 include/linux/nl80211.h                   |    2 +
 include/net/cfg80211.h                    |    1 +
 include/net/mac80211.h                    |    6 ++++
 net/mac80211/cfg.c                        |    1 +
 net/mac80211/debugfs.c                    |   41 +++++++++++++++++++++++++++++
 net/mac80211/ieee80211_i.h                |    5 ++++
 net/mac80211/main.c                       |    1 +
 net/mac80211/mlme.c                       |   36 ++++++++++++++++++++++---
 net/mac80211/scan.c                       |   18 +++++++++++++
 net/mac80211/util.c                       |    2 +
 net/wireless/nl80211.c                    |    3 ++
 13 files changed, 125 insertions(+), 8 deletions(-)

