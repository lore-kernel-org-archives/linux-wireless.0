Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:45297 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756283Ab2EREqp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 May 2012 00:46:45 -0400
Received: by wibhn6 with SMTP id hn6so2490194wib.1
        for <linux-wireless@vger.kernel.org>; Thu, 17 May 2012 21:46:44 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 0/5] TKIP/GEM support for 18xx
Date: Fri, 18 May 2012 07:46:35 +0300
Message-Id: <1337316400-23875-1-git-send-email-arik@wizery.com> (sfid-20120518_064649_476430_6AF4AF8D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

TKIP extra padding is not required for 18xx cards. Turn this into a
quirk for 12xx cards only.
18xx cards must have their Tx spare-blocks updated before any vif can
transmit GEM or TKIP encrypted packets. When spare blocks are updated,
we must make sure no Tx frame reaches the FW. Otherwise our Tx block
accounting will be out of sync.
Introduce new internal Tx queue wake/stop APIs to allow us to safely
stop the queues for multiple reasons (similar to mac80211). Use the
new APIs to prevent all Tx during the change of spare blocks.

Arik Nemtsov (5):
  wlcore/wl12xx/wl18xx: introduce quirk to remove TKIP header space
  wlcore/wl12xx/wl18xx: handle spare blocks spacial cases per arch
  wlcore: add stop reason bitmap for waking/starting queues
  wlcore: stop queues on Tx flush
  wlcore/wl12xx/wl18xx: implement op_set_key per HW arch

 drivers/net/wireless/ti/wl12xx/main.c     |   27 ++++-
 drivers/net/wireless/ti/wl18xx/acx.c      |    4 +
 drivers/net/wireless/ti/wl18xx/main.c     |  101 ++++++++++++++++---
 drivers/net/wireless/ti/wl18xx/tx.c       |    3 +-
 drivers/net/wireless/ti/wl18xx/tx.h       |    3 +-
 drivers/net/wireless/ti/wl18xx/wl18xx.h   |    3 +
 drivers/net/wireless/ti/wlcore/cmd.c      |    5 +-
 drivers/net/wireless/ti/wlcore/debugfs.c  |    1 -
 drivers/net/wireless/ti/wlcore/hw_ops.h   |   21 ++++
 drivers/net/wireless/ti/wlcore/main.c     |   55 ++++++-----
 drivers/net/wireless/ti/wlcore/tx.c       |  152 ++++++++++++++++++++++++-----
 drivers/net/wireless/ti/wlcore/tx.h       |   23 ++++-
 drivers/net/wireless/ti/wlcore/wlcore.h   |   21 +++-
 drivers/net/wireless/ti/wlcore/wlcore_i.h |    3 -
 14 files changed, 343 insertions(+), 79 deletions(-)

-- 
1.7.9.5

