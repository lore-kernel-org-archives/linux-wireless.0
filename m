Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f41.google.com ([74.125.83.41]:44775 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753201AbaDVAKY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Apr 2014 20:10:24 -0400
Received: by mail-ee0-f41.google.com with SMTP id t10so4053227eei.0
        for <linux-wireless@vger.kernel.org>; Mon, 21 Apr 2014 17:10:23 -0700 (PDT)
From: Grazvydas Ignotas <notasas@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: Pavel Machek <pavel@ucw.cz>,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>,
	David Gnedt <david.gnedt@davizone.at>,
	Grazvydas Ignotas <notasas@gmail.com>
Subject: [PATCH 0/4] wl1251 IBSS fixes
Date: Tue, 22 Apr 2014 03:09:51 +0300
Message-Id: <1398125395-5579-1-git-send-email-notasas@gmail.com> (sfid-20140422_021028_148762_7669788F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

IBSS mode is currently advertised by wl1251 driver but is totally broken.
First there is a disconnect hack for monitor mode that was recently merged,
it abuses mac80211 and causes corruption in IBSS mode, so I think should be
reverted. Then there are several cases of station-only mac80211 functions
called carelessly, what is also fixed.

Grazvydas Ignotas (4):
  Revert "wl1251: enforce changed hw encryption support on monitor state change"
  wl1251: fix null data for IBSS
  wl1251: fix mixed up args for join
  wl1251: only call ieee80211_beacon_loss in managed mode

 drivers/net/wireless/ti/wl1251/event.c |    5 ++-
 drivers/net/wireless/ti/wl1251/main.c  |   68 ++++++++++++++++++--------------
 2 files changed, 42 insertions(+), 31 deletions(-)

-- 
1.7.9.5

