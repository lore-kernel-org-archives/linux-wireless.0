Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:32134 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752553AbZLAMGe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2009 07:06:34 -0500
Received: from esebh105.NOE.Nokia.com (esebh105.ntc.nokia.com [172.21.138.211])
	by mgw-mx03.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id nB1C6OAQ010420
	for <linux-wireless@vger.kernel.org>; Tue, 1 Dec 2009 14:06:38 +0200
Received: from [127.0.1.1] (essapo-nirac253175.europe.nokia.com [10.162.253.175])
	by mgw-da02.ext.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id nB1C6WGk006739
	for <linux-wireless@vger.kernel.org>; Tue, 1 Dec 2009 14:06:33 +0200
Subject: [PATCH v3 0/2] mac80211 client U-APSD support
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kalle.valo@iki.fi>
Date: Tue, 01 Dec 2009 14:06:28 +0200
Message-ID: <20091201120508.4264.25010.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

here is my proposal how to add U-APSD client support to mac80211. I
also included example driver implementation for wl1251.

Please comment. Also I would like to get comments how U-APSD needs to
be implemented in different hardware.

v3:
o remove unnecessary debugfs interface, people can recompile mac80211
  in case they want to try enable more queues
o add max SP length defines to ieee80211.h
o removed unnecessary code comments

v2:
o remove cfg80211 changes
o rename IEEE80211_QOS_IE to IEEE80211_WMM_IE_STA in ieee80211.h


---

Kalle Valo (2):
      mac80211: add U-APSD client support
      wl1251: add U-APSD support


 drivers/net/wireless/wl12xx/wl1251_main.c |   12 +++++++--
 include/linux/ieee80211.h                 |   12 +++++++++
 include/net/mac80211.h                    |    6 ++++
 net/mac80211/cfg.c                        |    7 +++++
 net/mac80211/ieee80211_i.h                |    2 +
 net/mac80211/mlme.c                       |   39 +++++++++++++++++++++++++----
 net/mac80211/scan.c                       |   18 +++++++++++++
 net/mac80211/util.c                       |    2 +
 8 files changed, 90 insertions(+), 8 deletions(-)

