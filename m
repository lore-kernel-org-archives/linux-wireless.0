Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:32261 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752997AbZK3NYa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Nov 2009 08:24:30 -0500
Received: from vaebh106.NOE.Nokia.com (vaebh106.europe.nokia.com [10.160.244.32])
	by mgw-mx06.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id nAUDOPga023042
	for <linux-wireless@vger.kernel.org>; Mon, 30 Nov 2009 15:24:34 +0200
Received: from [127.0.1.1] (essapo-nirac25272.europe.nokia.com [10.162.252.72])
	by mgw-sa02.ext.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id nAUDOMDE000386
	for <linux-wireless@vger.kernel.org>; Mon, 30 Nov 2009 15:24:22 +0200
Subject: [PATCH v2 0/3] mac80211 client U-APSD support
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kalle.valo@iki.fi>
Date: Mon, 30 Nov 2009 15:24:20 +0200
Message-ID: <20091130132348.28896.95317.stgit@tikku>
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

v2:
o remove cfg80211 changes
o rename IEEE80211_QOS_IE to IEEE80211_WMM_IE_STA in ieee80211.h

---

Kalle Valo (3):
      mac80211: add U-APSD client support
      mac80211: add debugfs interface for U-APSD queue configuration
      wl1251: add U-APSD support


 drivers/net/wireless/wl12xx/wl1251_main.c |   12 ++++++--
 include/linux/ieee80211.h                 |    5 ++++
 include/net/mac80211.h                    |    6 ++++
 net/mac80211/cfg.c                        |    7 +++++
 net/mac80211/debugfs.c                    |   41 +++++++++++++++++++++++++++++
 net/mac80211/ieee80211_i.h                |    5 ++++
 net/mac80211/main.c                       |    1 +
 net/mac80211/mlme.c                       |   36 ++++++++++++++++++++++---
 net/mac80211/scan.c                       |   18 +++++++++++++
 net/mac80211/util.c                       |    2 +
 10 files changed, 125 insertions(+), 8 deletions(-)

