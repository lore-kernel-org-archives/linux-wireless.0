Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:50592 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753653Ab3CLNpb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Mar 2013 09:45:31 -0400
Received: from dlelxv30.itg.ti.com ([172.17.2.17])
	by devils.ext.ti.com (8.13.7/8.13.7) with ESMTP id r2CDjVR6003583
	for <linux-wireless@vger.kernel.org>; Tue, 12 Mar 2013 08:45:31 -0500
Received: from DLEE70.ent.ti.com (dlee70.ent.ti.com [157.170.170.113])
	by dlelxv30.itg.ti.com (8.13.8/8.13.8) with ESMTP id r2CDjVDq017296
	for <linux-wireless@vger.kernel.org>; Tue, 12 Mar 2013 08:45:31 -0500
From: Luciano Coelho <coelho@ti.com>
To: <linux-wireless@vger.kernel.org>
CC: <coelho@ti.com>
Subject: [PATCH 00/13] wlcore/wl18xx: some patches for 3.10
Date: Tue, 12 Mar 2013 15:44:11 +0200
Message-ID: <1363095864-24422-1-git-send-email-coelho@ti.com> (sfid-20130312_144548_649646_8744B694)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

These are some of the TI wireless drivers patches that are intended
for 3.10.

A bunch of fixes and small improvements here and there.

Please review.

--
Cheers,
Luca.


Arik Nemtsov (8):
  wlcore: fix link count in single-link-PSM optimization
  wlcore: don't risk using stale HLID during .sta_state callback
  wlcore: consolidate tx_seq handling on recovery
  wlcore: change warn on missing lock in wlcore_queue_xx funcs
  wlcore: free AP global links properly on recovery
  wlcore: AP-mode - recover security seq num for stations
  wlcore: correctly check state before regdomain conf
  wlcore: consider dummy packets when tx queues are empty

Eyal Shapira (1):
  wlcore: don't attempt to roam in case of p2p

Igal Chernobelsky (2):
  wlcore: enter elp in force ps mode in 5ms
  wlcore: set max num of Rx BA sessions per chip

Nadim Zubidat (1):
  wlcore: report rssi from roaming statistics

Victor Goldenshtein (1):
  wl18xx: print chip info during boot

 drivers/net/wireless/ti/wl12xx/main.c     |    1 +
 drivers/net/wireless/ti/wl12xx/wl12xx.h   |    2 +
 drivers/net/wireless/ti/wl18xx/main.c     |   25 ++++-
 drivers/net/wireless/ti/wl18xx/reg.h      |   29 ++++++
 drivers/net/wireless/ti/wl18xx/wl18xx.h   |    4 +-
 drivers/net/wireless/ti/wlcore/acx.c      |   29 ++++++
 drivers/net/wireless/ti/wlcore/acx.h      |   16 +++-
 drivers/net/wireless/ti/wlcore/cmd.c      |   32 +++++++
 drivers/net/wireless/ti/wlcore/debugfs.c  |    3 +-
 drivers/net/wireless/ti/wlcore/event.c    |    9 +-
 drivers/net/wireless/ti/wlcore/main.c     |  145 +++++++++++++++++++++--------
 drivers/net/wireless/ti/wlcore/ps.c       |    4 +-
 drivers/net/wireless/ti/wlcore/tx.c       |   39 +++-----
 drivers/net/wireless/ti/wlcore/wlcore.h   |    3 +
 drivers/net/wireless/ti/wlcore/wlcore_i.h |   28 ++++--
 15 files changed, 289 insertions(+), 80 deletions(-)

-- 
1.7.10.4

