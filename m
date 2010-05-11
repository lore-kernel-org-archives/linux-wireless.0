Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:22663 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755734Ab0EKIii (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 May 2010 04:38:38 -0400
Received: from vs3002.wh2.ocn.ne.jp (125.206.180.165)
	by mail30f.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 5-0298397115
	for <linux-wireless@vger.kernel.org>; Tue, 11 May 2010 17:38:36 +0900 (JST)
Subject: [RFC PATCH 0/2] mac80211: antenna configuration
To: johannes@sipsolutions.net, linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: linux-wireless@vger.kernel.org, holgerschurig@gmail.com
Date: Tue, 11 May 2010 17:38:55 +0900
Message-ID: <20100511083121.28289.96180.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi!

this adds antenna configuration via nl80211. patches for iw will follow
shortly.

i have followed holger schurig's suggestion to use a bitmap for allowed
antennas. when multiple antennas are selected in the bitmap, the driver may use
diversity. i think that this allows for the most flexible, yet simple
configuration of antennas, and drivers can just reject configurations they
cannot support. i hope that this will also be generic enough for 802.11n with
multiple antennas - but for the moment i think the most important use case is
that we sometimes know that only one antenna is available and we want to
disable diversity and use only one fixed antenna. at least for ath5k this is
sometimes necessary to get good results with only one antenna.

please check it out and let me know what you think,
bruno

---

Bruno Randolf (2):
      mac80211: Add nl80211 antenna configuration
      ath5k: Add support for cfg80211 antenna setting


 drivers/net/wireless/ath/ath5k/base.c |   34 ++++++++++
 include/linux/nl80211.h               |   12 +++
 include/net/cfg80211.h                |    3 +
 include/net/mac80211.h                |    2 +
 net/mac80211/cfg.c                    |   16 +++++
 net/mac80211/driver-ops.h             |   21 ++++++
 net/wireless/nl80211.c                |  114 +++++++++++++++++++++++++++++++++
 7 files changed, 202 insertions(+), 0 deletions(-)

-- 
Signature
