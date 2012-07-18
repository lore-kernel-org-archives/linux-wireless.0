Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:59328 "EHLO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752018Ab2GRMNt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jul 2012 08:13:49 -0400
Received: by lbom4 with SMTP id m4so4558827lbo.16
        for <linux-wireless@vger.kernel.org>; Wed, 18 Jul 2012 05:13:45 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, arik@wizery.com
Subject: [PATCH 00/14] wlcore/wl12xx/wl18xx: more pathes for 3.6
Date: Wed, 18 Jul 2012 15:13:19 +0300
Message-Id: <1342613613-917-1-git-send-email-coelho@ti.com> (sfid-20120718_141355_372601_4D0ADB94)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

This is one more batch of patches intended for 3.6.  It contains a
some patches by Yair related to interfaces with userspace (PLT,
calibrator and wlconf) and a few bugfixes by Eyal, Eliad and Arik.
Also a couple of my own patches to fix some out-of-sync issues with
the firmware.

Please review.

Cheers,
Luca.

Arik Nemtsov (4):
  wl18xx: alloc conf.phy memory to ensure alignemnt
  wl18xx: fix bogus compile warning on cc config option
  wlcore: don't issue SLEEP_AUTH command during recovery
  wl18xx: enable MIMO rates when connected as a MIMO STA

Eliad Peller (1):
  wlcore: use basic rates for non-data packets

Eyal Shapira (1):
  wlcore: don't re-configure wakeup conditions if not needed

Igal Chernobelsky (1):
  wlcore: send EAPOLs using minimum basic rate for all roles

Luciano Coelho (2):
  wlcore: wait for command completion event when sending CMD_ROLE_STOP
  wlcore: increase command completion timeout

Yair Shapira (5):
  wl18xx: add support for ht_mode in conf.h
  wlcore: add plt_mode including new PLT_FEM_DETECT
  wl18xx: disable calibrator based fem detect
  wlcore/wl12xx: calibrator fem detect implementation
  wlcore: make usage of nla_put clearer

 drivers/net/wireless/ti/wl12xx/cmd.c      |   34 ++++++++-
 drivers/net/wireless/ti/wl12xx/main.c     |   23 ++++++
 drivers/net/wireless/ti/wl18xx/conf.h     |   21 +++++-
 drivers/net/wireless/ti/wl18xx/io.c       |    2 +-
 drivers/net/wireless/ti/wl18xx/main.c     |  117 +++++++++++++++++++++--------
 drivers/net/wireless/ti/wlcore/cmd.c      |   12 +++
 drivers/net/wireless/ti/wlcore/cmd.h      |    2 +-
 drivers/net/wireless/ti/wlcore/main.c     |   44 ++++++++++-
 drivers/net/wireless/ti/wlcore/testmode.c |   85 +++++++++++++++------
 drivers/net/wireless/ti/wlcore/tx.c       |   14 ++--
 drivers/net/wireless/ti/wlcore/wlcore.h   |    2 +
 drivers/net/wireless/ti/wlcore/wlcore_i.h |    8 +-
 12 files changed, 290 insertions(+), 74 deletions(-)

-- 
1.7.10.4

