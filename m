Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:19559 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750827Ab0KEGw6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Nov 2010 02:52:58 -0400
Received: from vs3000.wh2.ocn.ne.jp (125.206.180.163)
	by mail30g.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 1-0228639975
	for <linux-wireless@vger.kernel.org>; Fri,  5 Nov 2010 15:52:56 +0900 (JST)
Subject: [PATCH v6 0/3] Antenna configuration API
To: johannes@sipsolutions.net, linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: nbd@openwrt.org, mcgrof@gmail.com, linux-wireless@vger.kernel.org
Date: Fri, 05 Nov 2010 15:53:06 +0900
Message-ID: <20101105064851.8122.57278.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm resending the Antenna API series with the one fix which was requested last
time. No we disallow antenna configuration if the wifi is running, to make life
easier for 802.11n devices, which might have to recalculate chainmasks and HT
settings based on the available antennas. I hope this makes it acceptable for
merging now.

bruno

---

Bruno Randolf (3):
      cfg80211: Add nl80211 antenna configuration
      mac80211: Add antenna configuration
      ath5k: Add support for antenna configuration


 drivers/net/wireless/ath/ath5k/base.c |   32 +++++++++++++++++++++
 include/linux/nl80211.h               |   25 +++++++++++++++++
 include/net/cfg80211.h                |    3 ++
 include/net/mac80211.h                |    2 +
 net/mac80211/cfg.c                    |   19 +++++++++++++
 net/mac80211/driver-ops.h             |   23 +++++++++++++++
 net/mac80211/driver-trace.h           |   50 +++++++++++++++++++++++++++++++++
 net/wireless/nl80211.c                |   31 ++++++++++++++++++++
 8 files changed, 184 insertions(+), 1 deletions(-)

-- 
Signature
