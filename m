Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:41933 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687Ab1JJIMe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Oct 2011 04:12:34 -0400
Received: by eye27 with SMTP id 27so1109073eye.19
        for <linux-wireless@vger.kernel.org>; Mon, 10 Oct 2011 01:12:32 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 00/29] make the driver ready for multi-vif support
Date: Mon, 10 Oct 2011 10:12:48 +0200
Message-Id: <1318234397-21081-1-git-send-email-eliad@wizery.com> (sfid-20111010_101238_173341_E5FB3F12)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patchset finishes adding multiple vif support to the
wl12xx driver.

The driver still allows only a single vif, as the current
fw only supports a single vif.

This patchset doesn't break compatibility with the current fw.

Eliad Peller (29):
  wl12xx: refactor fw init into a new function
  wl12xx: move last_tx_hlid into wlvif
  wl12xx: unify STA and AP tx_queue mechanism
  wl12xx: move some functions from remove_interface() to stop()
  wl12xx: move bitrate_masks into wlvif
  wl12xx: add vifs list
  wl12xx: support multiple vifs in the tx path
  wl12xx: configure sleep_policy according to active roles
  wl12xx: make event handling support multirole
  wl12xx: move tx_security_seq into wlvif
  wl12xx: rearm rx streaming per vif
  wl12xx: make WL1271_FLAG_STA_ASSOCIATED flag per-vif
  wl12xx: make WL1271_FLAG_IBSS_JOINED flag per-vif
  wl12xx: make WL1271_FLAG_AP_STARTED flag per-vif
  wl12xx: make WL1271_FLAG_PSM flag per-vif
  wl12xx: make WL1271_FLAG_STA_STATE_SENT flag per-vif
  wl12xx: make WL1271_FLAG_RX_STREAMING_STARTED flag per-vif
  wl12xx: make WL1271_FLAG_IF_INITIALIZED per-vif
  wl12xx: make WL1271_FLAG_PSPOLL_FAILURE flag per-vif
  wl12xx: make WL1271_FLAG_CS_PROGRESS flag per-vif
  wl12xx: add band field to wlvif
  wl12xx: add channel field to wlvif
  wl12xx: add power_level field to wlvif
  wl12xx: make op_config configure all vifs
  wl12xx: replace all remaining wl->vif references
  wl12xx: call stop() on recovery
  wl12xx: use dynamic rate policies
  wl12xx: add elp wakeup/sleep calls to add_interface
  wl12xx: use round-robin policy for tx

 drivers/net/wireless/wl12xx/acx.c     |   11 +-
 drivers/net/wireless/wl12xx/acx.h     |    8 +-
 drivers/net/wireless/wl12xx/cmd.c     |   70 ++--
 drivers/net/wireless/wl12xx/cmd.h     |    8 +-
 drivers/net/wireless/wl12xx/debugfs.c |   23 +-
 drivers/net/wireless/wl12xx/event.c   |  137 ++++--
 drivers/net/wireless/wl12xx/init.c    |   48 ++-
 drivers/net/wireless/wl12xx/main.c    |  923 +++++++++++++++++++--------------
 drivers/net/wireless/wl12xx/ps.c      |   38 +-
 drivers/net/wireless/wl12xx/ps.h      |    5 +-
 drivers/net/wireless/wl12xx/rx.c      |   35 +-
 drivers/net/wireless/wl12xx/scan.c    |   29 +-
 drivers/net/wireless/wl12xx/tx.c      |  294 ++++++-----
 drivers/net/wireless/wl12xx/tx.h      |    8 +-
 drivers/net/wireless/wl12xx/wl12xx.h  |  117 +++--
 15 files changed, 1029 insertions(+), 725 deletions(-)

-- 
1.7.6.401.g6a319

