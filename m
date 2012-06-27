Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog128.obsmtp.com ([74.125.149.141]:52178 "EHLO
	na3sys009aog128.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754433Ab2F0PgP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jun 2012 11:36:15 -0400
Received: by lbol5 with SMTP id l5so1951755lbo.34
        for <linux-wireless@vger.kernel.org>; Wed, 27 Jun 2012 08:36:12 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, arik@wizery.com
Subject: [PATCH 0/8] wlcore/wl12xx/wl18xx: patches of the day
Date: Wed, 27 Jun 2012 18:35:54 +0300
Message-Id: <1340811362-30441-1-git-send-email-coelho@ti.com> (sfid-20120627_173618_950425_0EE4D806)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

A few more patches for wlcore and friends.  Some improvements and bug
fixes.  The most significant improvement is that now in wl12xx we
allow sched scan while connected and allow normal scans while sched
scanning.  The wl18xx firmware doesn't support this yet.

After this series, a newer firmware version is required.  We call it
fw-5 for wl127x and wl128x now.

Cheers,
Luca.


Arik Nemtsov (5):
  wlcore/wl12xx/wl18xx: check min FW version
  wlcore: don't stop tx queue via watermark if already stopped
  wlcore: remove recover cmd from testmode
  wlcore: avoid debug prints during intended FW recovery
  wlcore: always clear recovery flag during recovery_work

Luciano Coelho (1):
  wl12xx/wlcore: increase FW filename version

Victor Goldenshtein (1):
  wlcore: enable sched scan while connected

Yoni Divinsky (1):
  wlcore: add probe request templates for sched and one-shot scans

 drivers/net/wireless/ti/wl12xx/main.c     |   24 ++++++++++----
 drivers/net/wireless/ti/wl12xx/wl12xx.h   |   14 ++++++++
 drivers/net/wireless/ti/wl18xx/main.c     |    5 +++
 drivers/net/wireless/ti/wl18xx/wl18xx.h   |    7 ++++
 drivers/net/wireless/ti/wlcore/boot.c     |   51 +++++++++++++++++++++++++++++
 drivers/net/wireless/ti/wlcore/cmd.c      |   14 ++++++--
 drivers/net/wireless/ti/wlcore/cmd.h      |    6 ++--
 drivers/net/wireless/ti/wlcore/init.c     |   16 +++++++++
 drivers/net/wireless/ti/wlcore/main.c     |   15 +++++----
 drivers/net/wireless/ti/wlcore/scan.c     |    9 ++---
 drivers/net/wireless/ti/wlcore/sdio.c     |    6 ----
 drivers/net/wireless/ti/wlcore/spi.c      |    6 ----
 drivers/net/wireless/ti/wlcore/testmode.c |   13 +-------
 drivers/net/wireless/ti/wlcore/wlcore.h   |   21 ++++++++++++
 drivers/net/wireless/ti/wlcore/wlcore_i.h |    9 -----
 15 files changed, 161 insertions(+), 55 deletions(-)

-- 
1.7.10

