Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([198.47.19.11]:59241 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933587AbcHDMoa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Aug 2016 08:44:30 -0400
From: Maxim Altshul <maxim.altshul@ti.com>
To: <linux-wireless@vger.kernel.org>
CC: <johannes@sipsolutions.net>, <kvalo@codeaurora.org>,
	Maxim Altshul <maxim.altshul@ti.com>
Subject: [PATCH 0/2] get_expected_throughput interface update
Date: Thu, 4 Aug 2016 15:48:09 +0300
Message-ID: <20160804124809.7742-1-maxim.altshul@ti.com> (sfid-20160804_144459_457342_2CF31B58)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These two patches are two important patches (mainly 1/2)
that solve a regression issue that was found in wlcore
(where wl was found to be null in some cases)

Also, they make it easier for driver to get hw->priv when op is invoked. 


Maxim Altshul (2):
  mac80211/wlcore: Add ieee80211_hw variable to get_expected_throughput
  wlcore: Remove wl pointer from wl_sta structure

 drivers/net/wireless/ti/wlcore/main.c     | 6 +++---
 drivers/net/wireless/ti/wlcore/wlcore_i.h | 1 -
 include/net/mac80211.h                    | 3 ++-
 net/mac80211/driver-ops.h                 | 2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

-- 
2.9.0

