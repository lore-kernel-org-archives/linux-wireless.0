Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:35127 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754033Ab2KZQF4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2012 11:05:56 -0500
Received: by mail-we0-f174.google.com with SMTP id d7so3507268wer.19
        for <linux-wireless@vger.kernel.org>; Mon, 26 Nov 2012 08:05:55 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 00/11] wlcore fixes for 3.8 (part1)
Date: Mon, 26 Nov 2012 18:05:39 +0200
Message-Id: <1353945950-3899-1-git-send-email-arik@wizery.com> (sfid-20121126_170600_820665_59DDDF6F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Various fixes for wlcore, to be applied on top of
Eliad's 18xx API update series.

There are more patches pending - the splitting into smaller
series is meant to ease review.

Arik Nemtsov (2):
  wlcore: use new set bandwidth command to adjusting channel BW
  wlcore/wl18xx/wl12xx: separate channel count between chips

Eliad Peller (7):
  wlcore: configure dwell times according to scan type
  wlcore: don't stop fwlog if dbgpins are used
  wlcore/wl18xx: allow TX BA on all TIDs
  wlcore: use sta_state-based ROCs for AP mode
  wlcore: mask out CCK rates when starting GO
  wlcore: move ps change handling to .bss_info_changed()
  wlcore: don't allow access to FW mem when chip is off

Luciano Coelho (1):
  wlcore: gather information about firmware stability

Yair Shapira (1):
  wlcore/wl18xx/wl12xx: add recovery settings to conf

 drivers/net/wireless/ti/wl12xx/main.c     |   11 +-
 drivers/net/wireless/ti/wl12xx/scan.c     |    7 +-
 drivers/net/wireless/ti/wl18xx/acx.c      |   31 ++++++
 drivers/net/wireless/ti/wl18xx/acx.h      |   14 +++
 drivers/net/wireless/ti/wl18xx/main.c     |   49 ++++++++-
 drivers/net/wireless/ti/wl18xx/scan.c     |    6 +-
 drivers/net/wireless/ti/wl18xx/scan.h     |    7 --
 drivers/net/wireless/ti/wlcore/cmd.c      |    3 +
 drivers/net/wireless/ti/wlcore/conf.h     |   30 +++---
 drivers/net/wireless/ti/wlcore/debugfs.c  |    5 +-
 drivers/net/wireless/ti/wlcore/hw_ops.h   |    8 ++
 drivers/net/wireless/ti/wlcore/main.c     |  162 ++++++++++++++++++++---------
 drivers/net/wireless/ti/wlcore/scan.c     |   57 ++++++----
 drivers/net/wireless/ti/wlcore/scan.h     |    9 +-
 drivers/net/wireless/ti/wlcore/wlcore.h   |    7 ++
 drivers/net/wireless/ti/wlcore/wlcore_i.h |    6 ++
 16 files changed, 308 insertions(+), 104 deletions(-)

-- 
1.7.9.5

